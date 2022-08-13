Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D111D591B20
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239649AbiHMOrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 10:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239471AbiHMOrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 10:47:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBE3AE61
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 07:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D04160E75
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 14:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594F1C433D6;
        Sat, 13 Aug 2022 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660402049;
        bh=hfV9yPRcctSgd9/P+YcAfnM5uKYGcmwhns8kEoGgsok=;
        h=Subject:To:Cc:From:Date:From;
        b=u20m6ATbozTdi6heoCA3mdhBsFX0m9wCE7M118MTJWCifoA+HZ9sLuqgTWxzMDj0p
         uZjp76ypmBQ8DZMV6p5friRRwC6vUtgUE8xO5uPTPEgQTqcGPti1RjS06LgvJJyAHb
         xwytsRU4Y2e7R/v22sfDe2BUCoxIxH/TF2YaAzD4=
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: fix high speed multiplier setting" failed to apply to 5.4-stable tree
To:     m.grzeschik@pengutronix.de, gregkh@linuxfoundation.org,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 16:47:27 +0200
Message-ID: <16604020478850@kroah.com>
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

From 8affe37c525d800a2628c4ecfaed13b77dc5634a Mon Sep 17 00:00:00 2001
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
Date: Mon, 4 Jul 2022 16:18:12 +0200
Subject: [PATCH] usb: dwc3: gadget: fix high speed multiplier setting

For High-Speed Transfers the prepare_one_trb function is calculating the
multiplier setting for the trb based on the length parameter of the trb
currently prepared. This assumption is wrong. For trbs with a sg list,
the length of the actual request has to be taken instead.

Fixes: 40d829fb2ec6 ("usb: dwc3: gadget: Correct ISOC DATA PIDs for short packets")
Cc: stable <stable@kernel.org>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220704141812.1532306-3-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index dcd8fc209ccd..4366c45c28cf 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1265,10 +1265,10 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 				unsigned int mult = 2;
 				unsigned int maxp = usb_endpoint_maxp(ep->desc);
 
-				if (trb_length <= (2 * maxp))
+				if (req->request.length <= (2 * maxp))
 					mult--;
 
-				if (trb_length <= maxp)
+				if (req->request.length <= maxp)
 					mult--;
 
 				trb->size |= DWC3_TRB_SIZE_PCM1(mult);

