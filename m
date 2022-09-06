Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BA95AECA9
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241330AbiIFOOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241435AbiIFONC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:13:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF8D1D30F;
        Tue,  6 Sep 2022 06:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25ADF60F89;
        Tue,  6 Sep 2022 13:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32880C433D6;
        Tue,  6 Sep 2022 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472056;
        bh=UzlkVzbW/FBS9IjBbS65LIgBC1gJ99a04EZ6jP5G9+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2MId8KNppZr3lcAAlUE8y+ArwC0s8xB1cSPAxQQzxekkQTtL1vCjbVNSZRms9dsH
         CZ/R7VRrbL9d6ucWG2r4ATyGIu1g1/eZ9+HbJnfeEU2/J1hF1CQb4wQ/HaKEbHhZEw
         jfVY9rplU1BKxxnh3WR240zaHwpOiIXQWZoW5gFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        stable <stable@kernel.org>
Subject: [PATCH 5.19 131/155] usb: xhci-mtk: relax TT periodic bandwidth allocation
Date:   Tue,  6 Sep 2022 15:31:19 +0200
Message-Id: <20220906132834.998809553@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 8b13ea05117ffad4727b0971ed09122d5c91c4dc upstream.

Currently uses the worst case byte budgets on FS/LS bus bandwidth,
for example, for an isochronos IN endpoint with 192 bytes budget, it
will consume the whole 5 uframes(188 * 5) while the actual FS bus
budget should be just 192 bytes. It cause that many usb audio headsets
with 3 interfaces (audio input, audio output, and HID) cannot be
configured.
To improve it, changes to use "approximate" best case budget for FS/LS
bandwidth management. For the same endpoint from the above example,
the approximate best case budget is now reduced to (188 * 2) bytes.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220819080556.32215-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -425,7 +425,6 @@ static int check_fs_bus_bw(struct mu3h_s
 
 static int check_sch_tt(struct mu3h_sch_ep_info *sch_ep, u32 offset)
 {
-	u32 extra_cs_count;
 	u32 start_ss, last_ss;
 	u32 start_cs, last_cs;
 
@@ -461,18 +460,12 @@ static int check_sch_tt(struct mu3h_sch_
 		if (last_cs > 7)
 			return -ESCH_CS_OVERFLOW;
 
-		if (sch_ep->ep_type == ISOC_IN_EP)
-			extra_cs_count = (last_cs == 7) ? 1 : 2;
-		else /*  ep_type : INTR IN / INTR OUT */
-			extra_cs_count = 1;
-
-		cs_count += extra_cs_count;
 		if (cs_count > 7)
 			cs_count = 7; /* HW limit */
 
 		sch_ep->cs_count = cs_count;
-		/* one for ss, the other for idle */
-		sch_ep->num_budget_microframes = cs_count + 2;
+		/* ss, idle are ignored */
+		sch_ep->num_budget_microframes = cs_count;
 
 		/*
 		 * if interval=1, maxp >752, num_budge_micoframe is larger


