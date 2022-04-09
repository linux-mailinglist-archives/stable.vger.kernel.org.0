Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28C24FA93B
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 17:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiDIPUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 11:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiDIPUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 11:20:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF198AE67
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 08:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A82F060A5A
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 15:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE5AC385A4;
        Sat,  9 Apr 2022 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649517513;
        bh=KB8WhoufbzScKCv74LM4rGDo887W+VVMTmT6mBGpqpM=;
        h=Subject:To:From:Date:From;
        b=WkpzuX0Q3pLskyvOE5BhkvyMae3Ytv8xOIyL1+mQsMQPl+om8zwEuRlvmWzkgvaGh
         yl7TJkGhaWk8vu3grCAZw6wQr2NzKCdu30MqWKsiAE1ZfWct7gkY0sAr7j2uBEWwI2
         03Y9qoQGrF1R6sXWuaWtpnG0yOoQEHQXjqBHASSY=
Subject: patch "usb: cdns3: Fix issue for clear halt endpoint" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 09 Apr 2022 17:18:20 +0200
Message-ID: <164951750087124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


This is a note to let you know that I've just added the patch titled

    usb: cdns3: Fix issue for clear halt endpoint

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b3fa25de31fb7e9afebe9599b8ff32eda13d7c94 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Tue, 29 Mar 2022 10:46:05 +0200
Subject: usb: cdns3: Fix issue for clear halt endpoint

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
---
 drivers/usb/cdns3/cdns3-gadget.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

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
-- 
2.35.1


