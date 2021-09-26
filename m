Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB10341889E
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhIZMcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhIZMcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:32:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 273CC60F48;
        Sun, 26 Sep 2021 12:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632659430;
        bh=ZUX/goSIRDp3rPePZA59I3TmXkuZ0thwWYR6s24sNi8=;
        h=Subject:To:Cc:From:Date:From;
        b=AvsCwytzWX+1jbytr5jUjLdU18OcHf9CiJxhu/klRDp3NVMkju8Ou9tTgv2/Ypnby
         WjazyZjzKvwq4OU/vvQrPtvq846HnhKZtuOAgaNVRyTKdLbznRp17EPiN1qOM00y++
         GcJjxE0gta7J9dcq9yeQEFtHAq4+u0gEZFd6YTVM=
Subject: FAILED: patch "[PATCH] usb: gadget: u_audio: EP-OUT bInterval in fback frequency" failed to apply to 5.10-stable tree
To:     pavel.hofman@ivitera.com, gregkh@linuxfoundation.org,
        henrik.enquist@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Sep 2021 14:30:28 +0200
Message-ID: <1632659428195147@kroah.com>
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

From f5dfd98a80ff8d50cf4ae2820857d7f5a46cbab9 Mon Sep 17 00:00:00 2001
From: Pavel Hofman <pavel.hofman@ivitera.com>
Date: Mon, 6 Sep 2021 15:08:22 +0200
Subject: [PATCH] usb: gadget: u_audio: EP-OUT bInterval in fback frequency

The patch increases the bitshift in feedback frequency
calculation with EP-OUT bInterval value.

Tests have revealed that Win10 and OSX UAC2 drivers require
the feedback frequency to be based on the actual packet
interval instead of on the USB2 microframe. Otherwise they
ignore the feedback value. Linux snd-usb-audio driver
detects the applied bitshift automatically.

Tested-by: Henrik Enquist <henrik.enquist@gmail.com>
Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210906130822.12256-1-pavel.hofman@ivitera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 32ef22857083..ad16163b5ff8 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -96,11 +96,13 @@ static const struct snd_pcm_hardware uac_pcm_hardware = {
 };
 
 static void u_audio_set_fback_frequency(enum usb_device_speed speed,
+					struct usb_ep *out_ep,
 					unsigned long long freq,
 					unsigned int pitch,
 					void *buf)
 {
 	u32 ff = 0;
+	const struct usb_endpoint_descriptor *ep_desc;
 
 	/*
 	 * Because the pitch base is 1000000, the final divider here
@@ -128,8 +130,13 @@ static void u_audio_set_fback_frequency(enum usb_device_speed speed,
 		 * byte fromat (that is Q16.16)
 		 *
 		 * ff = (freq << 16) / 8000
+		 *
+		 * Win10 and OSX UAC2 drivers require number of samples per packet
+		 * in order to honor the feedback value.
+		 * Linux snd-usb-audio detects the applied bit-shift automatically.
 		 */
-		freq <<= 4;
+		ep_desc = out_ep->desc;
+		freq <<= 4 + (ep_desc->bInterval - 1);
 	}
 
 	ff = DIV_ROUND_CLOSEST_ULL((freq * pitch), 1953125);
@@ -267,7 +274,7 @@ static void u_audio_iso_fback_complete(struct usb_ep *ep,
 		pr_debug("%s: iso_complete status(%d) %d/%d\n",
 			__func__, status, req->actual, req->length);
 
-	u_audio_set_fback_frequency(audio_dev->gadget->speed,
+	u_audio_set_fback_frequency(audio_dev->gadget->speed, audio_dev->out_ep,
 				    params->c_srate, prm->pitch,
 				    req->buf);
 
@@ -526,7 +533,7 @@ int u_audio_start_capture(struct g_audio *audio_dev)
 	 * be meauserd at start of playback
 	 */
 	prm->pitch = 1000000;
-	u_audio_set_fback_frequency(audio_dev->gadget->speed,
+	u_audio_set_fback_frequency(audio_dev->gadget->speed, ep,
 				    params->c_srate, prm->pitch,
 				    req_fback->buf);
 

