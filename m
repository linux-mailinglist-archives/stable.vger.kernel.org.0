Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4D85EA173
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbiIZKvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236978AbiIZKuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:50:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A563D58520;
        Mon, 26 Sep 2022 03:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D5EA601D2;
        Mon, 26 Sep 2022 10:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3139AC433C1;
        Mon, 26 Sep 2022 10:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188032;
        bh=NEZTy+BKfXvX5oTntyTl1H1SF2mGN6DXR21RV/cXAjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEcnxuTPBVU7Loc1h24J/Oq5/uIdsF5NhifOjONPWlvDLk8/vv1klX+M8ZwgyvEuL
         4K7qg5mNKCDl1OQzHgQij3jaHbFtLXD8NFmNK0s4safff7r92YDk3j9vx/tXEn6unz
         bd3MKdFYg1vp/Q6afK3Ngd3naMUULpMRofJCtSYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ikjoon Jang <ikjn@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/141] usb: xhci-mtk: relax TT periodic bandwidth allocation
Date:   Mon, 26 Sep 2022 12:10:45 +0200
Message-Id: <20220926100755.270440341@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ikjoon Jang <ikjn@chromium.org>

[ Upstream commit 548011957d1d72e0b662300c8b32b81d593b796e ]

Currently xhci-mtk needs software-managed bandwidth allocation for
periodic endpoints, it allocates the microframe index for the first
start-split packet for each endpoint. As this index allocation logic
should avoid the conflicts with other full/low-speed periodic endpoints,
it uses the worst case byte budgets on high-speed bus bandwidth
For example, for an isochronos IN endpoint with 192 bytes budget,
it will consume the whole 4 u-frames(188 * 4) while the actual
full-speed bus budget should be just 192bytes.

This patch changes the low/full-speed bandwidth allocation logic
to use "approximate" best case budget for lower speed bandwidth
management. For the same endpoint from the above example, the
approximate best case budget is now reduced to (188 * 2) bytes.

Without this patch, many usb audio headsets with 3 interfaces
(audio input, audio output, and HID) cannot be configured
on xhci-mtk.

Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
Link: https://lore.kernel.org/r/20210805133937.1.Ia8174b875bc926c12ce427a5a1415dea31cc35ae@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index f048af9c5335..4a7b200674ea 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -408,16 +408,17 @@ static int check_fs_bus_bw(struct mu3h_sch_ep_info *sch_ep, int offset)
 	u32 num_esit, tmp;
 	int base;
 	int i, j;
+	u8 uframes = DIV_ROUND_UP(sch_ep->maxpkt, FS_PAYLOAD_MAX);
 
 	num_esit = XHCI_MTK_MAX_ESIT / sch_ep->esit;
+
+	if (sch_ep->ep_type == INT_IN_EP || sch_ep->ep_type == ISOC_IN_EP)
+		offset++;
+
 	for (i = 0; i < num_esit; i++) {
 		base = offset + i * sch_ep->esit;
 
-		/*
-		 * Compared with hs bus, no matter what ep type,
-		 * the hub will always delay one uframe to send data
-		 */
-		for (j = 0; j < sch_ep->cs_count; j++) {
+		for (j = 0; j < uframes; j++) {
 			tmp = tt->fs_bus_bw[base + j] + sch_ep->bw_cost_per_microframe;
 			if (tmp > FS_PAYLOAD_MAX)
 				return -ESCH_BW_OVERFLOW;
@@ -494,6 +495,8 @@ static void update_sch_tt(struct usb_device *udev,
 	u32 base, num_esit;
 	int bw_updated;
 	int i, j;
+	int offset = sch_ep->offset;
+	u8 uframes = DIV_ROUND_UP(sch_ep->maxpkt, FS_PAYLOAD_MAX);
 
 	num_esit = XHCI_MTK_MAX_ESIT / sch_ep->esit;
 
@@ -502,10 +505,13 @@ static void update_sch_tt(struct usb_device *udev,
 	else
 		bw_updated = -sch_ep->bw_cost_per_microframe;
 
+	if (sch_ep->ep_type == INT_IN_EP || sch_ep->ep_type == ISOC_IN_EP)
+		offset++;
+
 	for (i = 0; i < num_esit; i++) {
-		base = sch_ep->offset + i * sch_ep->esit;
+		base = offset + i * sch_ep->esit;
 
-		for (j = 0; j < sch_ep->cs_count; j++)
+		for (j = 0; j < uframes; j++)
 			tt->fs_bus_bw[base + j] += bw_updated;
 	}
 
-- 
2.35.1



