Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17F9516537
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 18:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349142AbiEAQ3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 12:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbiEAQ3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 12:29:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AF9BCA6
        for <stable@vger.kernel.org>; Sun,  1 May 2022 09:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CB8E60DD9
        for <stable@vger.kernel.org>; Sun,  1 May 2022 16:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D23C385AA;
        Sun,  1 May 2022 16:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651422350;
        bh=XUJyCWhbtqy3DYsUlWyBPzFmziM/1H9WybQceI/3ZSw=;
        h=Subject:To:Cc:From:Date:From;
        b=hPCnd3BqDb8rsQWLviokuxQUARCKB9/IX0F7Hbcp5uZ+oZrOH5zcwvqEEzzj8UgJE
         I5GCLpSkGCyQCqfgCgfB4npFVnYEbCT9lNocp1pNuUUl/hlZ7F2QVxAqxVLhjVMaHV
         Qm6KTcgorAB6UITnAzeJzyBsLdAJJ1O89HBjl1dQ=
Subject: FAILED: patch "[PATCH] usb: cdns3: Fix issue for clear halt endpoint" failed to apply to 5.4-stable tree
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 01 May 2022 18:25:44 +0200
Message-ID: <165142234419551@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b3fa25de31fb7e9afebe9599b8ff32eda13d7c94 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Tue, 29 Mar 2022 10:46:05 +0200
Subject: [PATCH] usb: cdns3: Fix issue for clear halt endpoint

Path fixes bug which occurs during resetting endpoint in
__cdns3_gadget_ep_clear_halt function. During resetting endpoint
controller will change HW/DMA owned TRB. It set Abort flag in
trb->control and will change trb->length field. If driver want
to use the aborted trb it must update the changed field in
TRB.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20220329084605.4022-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index f9af7ebe003d..d6d515d598dc 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2684,6 +2684,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 	struct usb_request *request;
 	struct cdns3_request *priv_req;
 	struct cdns3_trb *trb = NULL;
+	struct cdns3_trb trb_tmp;
 	int ret;
 	int val;
 
@@ -2693,8 +2694,10 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 	if (request) {
 		priv_req = to_cdns3_request(request);
 		trb = priv_req->trb;
-		if (trb)
+		if (trb) {
+			trb_tmp = *trb;
 			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
+		}
 	}
 
 	writel(EP_CMD_CSTALL | EP_CMD_EPRST, &priv_dev->regs->ep_cmd);
@@ -2709,7 +2712,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 
 	if (request) {
 		if (trb)
-			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
+			*trb = trb_tmp;
 
 		cdns3_rearm_transfer(priv_ep, 1);
 	}

