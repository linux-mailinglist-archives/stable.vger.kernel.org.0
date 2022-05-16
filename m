Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990E6528FF5
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbiEPUKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236369AbiEPUB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A284C47564;
        Mon, 16 May 2022 12:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E20D60A50;
        Mon, 16 May 2022 19:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F78FC34100;
        Mon, 16 May 2022 19:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731006;
        bh=AfvNImvSajbT2lRm2lCrt5R+aKpmDHKgaIumFgk1JSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stgbeMvYNaGxLAmkaPWNKaoLUH41aAaDVCQE1LnRT9kWbfbofbAQKAAXfwUqOCLAm
         cwuzDrABGqbAN1a6etVTwVuZJ17WeWISjrA2wo3UgkbcavaVcMd/TDcdy0c7ahF/Rx
         HLOLL9clkVxsMtSE+iTguKBQCc+BLAwmJ7CQ0LIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.17 073/114] usb: xhci-mtk: fix fs isocs transfer error
Date:   Mon, 16 May 2022 21:36:47 +0200
Message-Id: <20220516193627.587019284@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit c237566b78ad8c72bc0431c5d6171db8d12e6f94 upstream.

Due to the scheduler allocates the optimal bandwidth for FS ISOC endpoints,
this may be not enough actually and causes data transfer error, so come up
with an estimate that is no less than the worst case bandwidth used for
any one mframe, but may be an over-estimate.

Fixes: 451d3912586a ("usb: xhci-mtk: update fs bus bandwidth by bw_budget_table")
Cc: stable@vger.kernel.org
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20220512064931.31670-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -465,7 +465,7 @@ static int check_fs_bus_bw(struct mu3h_s
 		 */
 		for (j = 0; j < sch_ep->num_budget_microframes; j++) {
 			k = XHCI_MTK_BW_INDEX(base + j);
-			tmp = tt->fs_bus_bw[k] + sch_ep->bw_budget_table[j];
+			tmp = tt->fs_bus_bw[k] + sch_ep->bw_cost_per_microframe;
 			if (tmp > FS_PAYLOAD_MAX)
 				return -ESCH_BW_OVERFLOW;
 		}
@@ -539,19 +539,17 @@ static int check_sch_tt(struct mu3h_sch_
 static void update_sch_tt(struct mu3h_sch_ep_info *sch_ep, bool used)
 {
 	struct mu3h_sch_tt *tt = sch_ep->sch_tt;
+	int bw_updated;
 	u32 base;
-	int i, j, k;
+	int i, j;
+
+	bw_updated = sch_ep->bw_cost_per_microframe * (used ? 1 : -1);
 
 	for (i = 0; i < sch_ep->num_esit; i++) {
 		base = sch_ep->offset + i * sch_ep->esit;
 
-		for (j = 0; j < sch_ep->num_budget_microframes; j++) {
-			k = XHCI_MTK_BW_INDEX(base + j);
-			if (used)
-				tt->fs_bus_bw[k] += sch_ep->bw_budget_table[j];
-			else
-				tt->fs_bus_bw[k] -= sch_ep->bw_budget_table[j];
-		}
+		for (j = 0; j < sch_ep->num_budget_microframes; j++)
+			tt->fs_bus_bw[XHCI_MTK_BW_INDEX(base + j)] += bw_updated;
 	}
 
 	if (used)


