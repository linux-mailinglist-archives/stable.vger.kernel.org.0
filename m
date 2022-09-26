Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02E15EA0C2
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbiIZKld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiIZKj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:39:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FE53E77B;
        Mon, 26 Sep 2022 03:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0578FB80924;
        Mon, 26 Sep 2022 10:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FCCC433C1;
        Mon, 26 Sep 2022 10:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187820;
        bh=/KzNBC/1o7m8B9RSy27+tliksvw2eqi39Mn6M3WBaDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNr4jX+L5UVJf9zNzuXTdlHyTUUGBIoZ7RHb3Acba3IhtAIf7UsjCK727A/sacNSk
         X8/Dk4ptiq/E+1bs2cGoqsQc3/KNmzC8zIqC6beVrbZBaxqRy6FAeeos1agyTE3Uua
         +HaDEEzYEuxotOLHN4YMjPQuLKu7Pv+dY58DBjzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/120] usb: xhci-mtk: add a function to (un)load bandwidth info
Date:   Mon, 26 Sep 2022 12:11:11 +0200
Message-Id: <20220926100752.083339049@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
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

[ Upstream commit 338af695fffb12a9407c376ce0cebce896c15050 ]

Extract a function to load/unload bandwidth info, and remove
a dummy check of TT offset.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/6fbc000756a4a4a7efbce651b785fee7561becb6.1615170625.git.chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 548011957d1d ("usb: xhci-mtk: relax TT periodic bandwidth allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 37 ++++++++++++++-------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index b1da3cb077c9..9a9685f74940 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -375,7 +375,6 @@ static void update_bus_bw(struct mu3h_sch_bw_info *sch_bw,
 					sch_ep->bw_budget_table[j];
 		}
 	}
-	sch_ep->allocated = used;
 }
 
 static int check_fs_bus_bw(struct mu3h_sch_ep_info *sch_ep, int offset)
@@ -509,6 +508,19 @@ static void update_sch_tt(struct usb_device *udev,
 		list_del(&sch_ep->tt_endpoint);
 }
 
+static int load_ep_bw(struct usb_device *udev, struct mu3h_sch_bw_info *sch_bw,
+		      struct mu3h_sch_ep_info *sch_ep, bool loaded)
+{
+	if (sch_ep->sch_tt)
+		update_sch_tt(udev, sch_ep, loaded);
+
+	/* update bus bandwidth info */
+	update_bus_bw(sch_bw, sch_ep, loaded);
+	sch_ep->allocated = loaded;
+
+	return 0;
+}
+
 static u32 get_esit_boundary(struct mu3h_sch_ep_info *sch_ep)
 {
 	u32 boundary = sch_ep->esit;
@@ -535,7 +547,6 @@ static int check_sch_bw(struct usb_device *udev,
 	u32 esit_boundary;
 	u32 min_num_budget;
 	u32 min_cs_count;
-	bool tt_offset_ok = false;
 	int ret;
 
 	/*
@@ -552,8 +563,6 @@ static int check_sch_bw(struct usb_device *udev,
 			ret = check_sch_tt(udev, sch_ep, offset);
 			if (ret)
 				continue;
-			else
-				tt_offset_ok = true;
 		}
 
 		if ((offset + sch_ep->num_budget_microframes) > esit_boundary)
@@ -585,29 +594,15 @@ static int check_sch_bw(struct usb_device *udev,
 	sch_ep->cs_count = min_cs_count;
 	sch_ep->num_budget_microframes = min_num_budget;
 
-	if (sch_ep->sch_tt) {
-		/* all offset for tt is not ok*/
-		if (!tt_offset_ok)
-			return -ERANGE;
-
-		update_sch_tt(udev, sch_ep, 1);
-	}
-
-	/* update bus bandwidth info */
-	update_bus_bw(sch_bw, sch_ep, 1);
-
-	return 0;
+	return load_ep_bw(udev, sch_bw, sch_ep, true);
 }
 
 static void destroy_sch_ep(struct usb_device *udev,
 	struct mu3h_sch_bw_info *sch_bw, struct mu3h_sch_ep_info *sch_ep)
 {
 	/* only release ep bw check passed by check_sch_bw() */
-	if (sch_ep->allocated) {
-		update_bus_bw(sch_bw, sch_ep, 0);
-		if (sch_ep->sch_tt)
-			update_sch_tt(udev, sch_ep, 0);
-	}
+	if (sch_ep->allocated)
+		load_ep_bw(udev, sch_bw, sch_ep, false);
 
 	if (sch_ep->sch_tt)
 		drop_tt(udev);
-- 
2.35.1



