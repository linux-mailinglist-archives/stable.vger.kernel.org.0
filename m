Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E875EA16B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbiIZKuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236891AbiIZKtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:49:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79F15809C;
        Mon, 26 Sep 2022 03:26:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D5F0B80682;
        Mon, 26 Sep 2022 10:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D58C433C1;
        Mon, 26 Sep 2022 10:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188014;
        bh=ElTOm2klxt85X0JKP/M2Yk+rb6HfPWLLC4D5yGfyYP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubqf16e2yJlpn2ODYSnCxPGztFI/0oyWRbAnvKeXn2+s7AWBNEO5+OfxCiUkdtFZi
         Gp4UWv9/+CWx17tD/Ylz3KZxs25wZKgCwTMdCPFhvj2z3f2L6ivdtc9HPjLyRV3gLt
         j5LicJuvGsbkEJ/1GsRsvbCBl1cMq8BGBZe5p5cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/141] usb: xhci-mtk: get the microframe boundary for ESIT
Date:   Mon, 26 Sep 2022 12:10:39 +0200
Message-Id: <20220926100755.070920337@linuxfoundation.org>
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

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 7c986fbc16ae6b2f914a3ebf06a3a4a8d9bb0b7c ]

Tune the boundary for FS/LS ESIT due to CS:
For ISOC out-ep, the controller starts transfer data after
the first SS; for others, the data is already transferred
before the last CS.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/49e5a269a47984f3126a70c3fb471b0c2874b8c2.1615170625.git.chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 548011957d1d ("usb: xhci-mtk: relax TT periodic bandwidth allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index 8950d1f10a7f..450fa22b7dc7 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -513,22 +513,35 @@ static void update_sch_tt(struct usb_device *udev,
 		list_del(&sch_ep->tt_endpoint);
 }
 
+static u32 get_esit_boundary(struct mu3h_sch_ep_info *sch_ep)
+{
+	u32 boundary = sch_ep->esit;
+
+	if (sch_ep->sch_tt) { /* LS/FS with TT */
+		/* tune for CS */
+		if (sch_ep->ep_type != ISOC_OUT_EP)
+			boundary++;
+		else if (boundary > 1) /* normally esit >= 8 for FS/LS */
+			boundary--;
+	}
+
+	return boundary;
+}
+
 static int check_sch_bw(struct usb_device *udev,
 	struct mu3h_sch_bw_info *sch_bw, struct mu3h_sch_ep_info *sch_ep)
 {
 	u32 offset;
-	u32 esit;
 	u32 min_bw;
 	u32 min_index;
 	u32 worst_bw;
 	u32 bw_boundary;
+	u32 esit_boundary;
 	u32 min_num_budget;
 	u32 min_cs_count;
 	bool tt_offset_ok = false;
 	int ret;
 
-	esit = sch_ep->esit;
-
 	/*
 	 * Search through all possible schedule microframes.
 	 * and find a microframe where its worst bandwidth is minimum.
@@ -537,7 +550,8 @@ static int check_sch_bw(struct usb_device *udev,
 	min_index = 0;
 	min_cs_count = sch_ep->cs_count;
 	min_num_budget = sch_ep->num_budget_microframes;
-	for (offset = 0; offset < esit; offset++) {
+	esit_boundary = get_esit_boundary(sch_ep);
+	for (offset = 0; offset < sch_ep->esit; offset++) {
 		if (is_fs_or_ls(udev->speed)) {
 			ret = check_sch_tt(udev, sch_ep, offset);
 			if (ret)
@@ -546,7 +560,7 @@ static int check_sch_bw(struct usb_device *udev,
 				tt_offset_ok = true;
 		}
 
-		if ((offset + sch_ep->num_budget_microframes) > sch_ep->esit)
+		if ((offset + sch_ep->num_budget_microframes) > esit_boundary)
 			break;
 
 		worst_bw = get_max_bw(sch_bw, sch_ep, offset);
-- 
2.35.1



