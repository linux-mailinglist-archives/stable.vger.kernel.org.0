Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FE75EA172
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236639AbiIZKvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236963AbiIZKt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:49:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEB658534;
        Mon, 26 Sep 2022 03:27:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F1C609FB;
        Mon, 26 Sep 2022 10:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21316C433C1;
        Mon, 26 Sep 2022 10:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188029;
        bh=of9VwGUQy7seUFPvbgc+yE2g04nZYjEtNLp4P4EMGvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTBl+ed9GI42cQSwqsxbs5+PoTy5LaZG/myErfp6tSuyrFvW2lFQpXeOPRTO1O09D
         ovZAip7aPJHSCXa3WuHMbLdNhFzaEbhxPzmxHJD6uOkKLX4/ieto4+XjjbeRerPKU/
         TpLmgVUkJH63bl6jYQTSklBdFdhg2FRmqgmbRJQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>,
        Ikjoon Jang <ikjn@chromium.org>
Subject: [PATCH 5.10 018/141] usb: xhci-mtk: allow multiple Start-Split in a microframe
Date:   Mon, 26 Sep 2022 12:10:44 +0200
Message-Id: <20220926100755.227918903@linuxfoundation.org>
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

[ Upstream commit d3997fce189fc4423169c51a81ba5ca01144d886 ]

This patch is used to relax bandwidth schedule by allowing multiple
Start-Split in the same microframe.

Reviewed-and-Tested-by: Ikjoon Jang <ikjn@chromium.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1623995165-25759-1-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 548011957d1d ("usb: xhci-mtk: relax TT periodic bandwidth allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 18 ------------------
 drivers/usb/host/xhci-mtk.h     |  2 --
 2 files changed, 20 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index a6ec75bf2def..f048af9c5335 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -430,11 +430,9 @@ static int check_fs_bus_bw(struct mu3h_sch_ep_info *sch_ep, int offset)
 static int check_sch_tt(struct usb_device *udev,
 	struct mu3h_sch_ep_info *sch_ep, u32 offset)
 {
-	struct mu3h_sch_tt *tt = sch_ep->sch_tt;
 	u32 extra_cs_count;
 	u32 start_ss, last_ss;
 	u32 start_cs, last_cs;
-	int i;
 
 	start_ss = offset % 8;
 
@@ -448,10 +446,6 @@ static int check_sch_tt(struct usb_device *udev,
 		if (!(start_ss == 7 || last_ss < 6))
 			return -ESCH_SS_Y6;
 
-		for (i = 0; i < sch_ep->cs_count; i++)
-			if (test_bit(offset + i, tt->ss_bit_map))
-				return -ESCH_SS_OVERLAP;
-
 	} else {
 		u32 cs_count = DIV_ROUND_UP(sch_ep->maxpkt, FS_PAYLOAD_MAX);
 
@@ -478,9 +472,6 @@ static int check_sch_tt(struct usb_device *udev,
 		if (cs_count > 7)
 			cs_count = 7; /* HW limit */
 
-		if (test_bit(offset, tt->ss_bit_map))
-			return -ESCH_SS_OVERLAP;
-
 		sch_ep->cs_count = cs_count;
 		/* one for ss, the other for idle */
 		sch_ep->num_budget_microframes = cs_count + 2;
@@ -502,11 +493,9 @@ static void update_sch_tt(struct usb_device *udev,
 	struct mu3h_sch_tt *tt = sch_ep->sch_tt;
 	u32 base, num_esit;
 	int bw_updated;
-	int bits;
 	int i, j;
 
 	num_esit = XHCI_MTK_MAX_ESIT / sch_ep->esit;
-	bits = (sch_ep->ep_type == ISOC_OUT_EP) ? sch_ep->cs_count : 1;
 
 	if (used)
 		bw_updated = sch_ep->bw_cost_per_microframe;
@@ -516,13 +505,6 @@ static void update_sch_tt(struct usb_device *udev,
 	for (i = 0; i < num_esit; i++) {
 		base = sch_ep->offset + i * sch_ep->esit;
 
-		for (j = 0; j < bits; j++) {
-			if (used)
-				set_bit(base + j, tt->ss_bit_map);
-			else
-				clear_bit(base + j, tt->ss_bit_map);
-		}
-
 		for (j = 0; j < sch_ep->cs_count; j++)
 			tt->fs_bus_bw[base + j] += bw_updated;
 	}
diff --git a/drivers/usb/host/xhci-mtk.h b/drivers/usb/host/xhci-mtk.h
index 2fc0568ba054..3e2c607b5d64 100644
--- a/drivers/usb/host/xhci-mtk.h
+++ b/drivers/usb/host/xhci-mtk.h
@@ -20,14 +20,12 @@
 #define XHCI_MTK_MAX_ESIT	64
 
 /**
- * @ss_bit_map: used to avoid start split microframes overlay
  * @fs_bus_bw: array to keep track of bandwidth already used for FS
  * @ep_list: Endpoints using this TT
  * @usb_tt: usb TT related
  * @tt_port: TT port number
  */
 struct mu3h_sch_tt {
-	DECLARE_BITMAP(ss_bit_map, XHCI_MTK_MAX_ESIT);
 	u32 fs_bus_bw[XHCI_MTK_MAX_ESIT];
 	struct list_head ep_list;
 	struct usb_tt *usb_tt;
-- 
2.35.1



