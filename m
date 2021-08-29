Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4583FA9A3
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 09:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhH2HBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 03:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhH2HBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 03:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 837C860524;
        Sun, 29 Aug 2021 07:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630220410;
        bh=Jw0yH7FBk664kUHHggD18IrDhIyEuW1PK1TAJdbHCqM=;
        h=Subject:To:Cc:From:Date:From;
        b=YK2rYon/ExMtL0oDMnmhJi9rxMwnsX5sizLNlcq99qcquvyNaDtkOk8M8b+KTaX9P
         r5Cg3DZLI3MX7v4pnpQokgdCTGCpPLdVimL/TFmbiT6wNY6yyD1AjnH1nTubN+bNML
         9qibp4y01uWHGIm32Ghd8WWUBMXptEiVk738sHOA=
Subject: FAILED: patch "[PATCH] usb: gadget: u_audio: fix race condition on endpoint stop" failed to apply to 5.10-stable tree
To:     jbrunet@baylibre.com, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Aug 2021 08:59:56 +0200
Message-ID: <163022039622793@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 068fdad20454f815e61e6f6eb9f051a8b3120e88 Mon Sep 17 00:00:00 2001
From: Jerome Brunet <jbrunet@baylibre.com>
Date: Fri, 27 Aug 2021 11:29:27 +0200
Subject: [PATCH] usb: gadget: u_audio: fix race condition on endpoint stop

If the endpoint completion callback is call right after the ep_enabled flag
is cleared and before usb_ep_dequeue() is call, we could do a double free
on the request and the associated buffer.

Fix this by clearing ep_enabled after all the endpoint requests have been
dequeued.

Fixes: 7de8681be2cd ("usb: gadget: u_audio: Free requests only after callback")
Cc: stable <stable@vger.kernel.org>
Reported-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20210827092927.366482-1-jbrunet@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 63d9340f008e..9e5c950612d0 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -394,8 +394,6 @@ static inline void free_ep(struct uac_rtd_params *prm, struct usb_ep *ep)
 	if (!prm->ep_enabled)
 		return;
 
-	prm->ep_enabled = false;
-
 	audio_dev = uac->audio_dev;
 	params = &audio_dev->params;
 
@@ -413,6 +411,8 @@ static inline void free_ep(struct uac_rtd_params *prm, struct usb_ep *ep)
 		}
 	}
 
+	prm->ep_enabled = false;
+
 	if (usb_ep_disable(ep))
 		dev_err(uac->card->dev, "%s:%d Error!\n", __func__, __LINE__);
 }
@@ -424,8 +424,6 @@ static inline void free_ep_fback(struct uac_rtd_params *prm, struct usb_ep *ep)
 	if (!prm->fb_ep_enabled)
 		return;
 
-	prm->fb_ep_enabled = false;
-
 	if (prm->req_fback) {
 		if (usb_ep_dequeue(ep, prm->req_fback)) {
 			kfree(prm->req_fback->buf);
@@ -434,6 +432,8 @@ static inline void free_ep_fback(struct uac_rtd_params *prm, struct usb_ep *ep)
 		prm->req_fback = NULL;
 	}
 
+	prm->fb_ep_enabled = false;
+
 	if (usb_ep_disable(ep))
 		dev_err(uac->card->dev, "%s:%d Error!\n", __func__, __LINE__);
 }

