Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196723F9AA2
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 16:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238436AbhH0OIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 10:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238426AbhH0OIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 10:08:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDC1060F25;
        Fri, 27 Aug 2021 14:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630073282;
        bh=nxMK3xG24Fmylmic6zPyfBbsumDpW/r7PhNtGfNIdiY=;
        h=Subject:To:From:Date:From;
        b=huZRbKPy6ugL51FC2c4FDii2farqhUHok8vYTgFrdUXS/z6WR/BSAwNkXs/XIOVAU
         95OMNtUofGb2Av0VluR676AgcOvoIOAKbHq4V499odxmB7L3ahhcLxAWhW3KWpQrtE
         WsZricJza69OfeN/LzChmBZ5UAFGQprM//W58Wbc=
Subject: patch "usb: gadget: u_audio: fix race condition on endpoint stop" added to usb-linus
To:     jbrunet@baylibre.com, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 27 Aug 2021 16:07:48 +0200
Message-ID: <16300732684485@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: u_audio: fix race condition on endpoint stop

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 068fdad20454f815e61e6f6eb9f051a8b3120e88 Mon Sep 17 00:00:00 2001
From: Jerome Brunet <jbrunet@baylibre.com>
Date: Fri, 27 Aug 2021 11:29:27 +0200
Subject: usb: gadget: u_audio: fix race condition on endpoint stop

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
---
 drivers/usb/gadget/function/u_audio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
-- 
2.32.0


