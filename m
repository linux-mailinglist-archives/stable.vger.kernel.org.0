Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1D72ED2B3
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbhAGOgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:36:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729287AbhAGOcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:32:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D2F1233E2;
        Thu,  7 Jan 2021 14:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029881;
        bh=bmG8cDKhmZ3Yu1LN9m5aZPQoMKQO1lvaFBzrdJo7uPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUStcHLvizQdQRmZBW7jEXG1zVZj7xop7qWfPgJuW9BbzB1rqfyeMZjs/o3nd6MwE
         i8u2P9CU72MyBJY9m7yitrlDsEG6Oxfx154Peffdc4/UeP6G1No/uPOn0lC0TBAQq/
         b91T9Ogl+JoShTuPvgQlLAoTwX6Rl7/H8oaVMnMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alberto Aguirre <albaguirre@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 04/29] ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk
Date:   Thu,  7 Jan 2021 15:31:19 +0100
Message-Id: <20210107143053.539114711@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
References: <20210107143052.973437064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alberto Aguirre <albaguirre@gmail.com>

commit 103e9625647ad74d201e26fb74afcd8479142a37 upstream

Signed-off-by: Alberto Aguirre <albaguirre@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |   52 ++++++++++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 32 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -324,6 +324,7 @@ static int set_sync_ep_implicit_fb_quirk
 	struct usb_host_interface *alts;
 	struct usb_interface *iface;
 	unsigned int ep;
+	unsigned int ifnum;
 
 	/* Implicit feedback sync EPs consumers are always playback EPs */
 	if (subs->direction != SNDRV_PCM_STREAM_PLAYBACK)
@@ -334,44 +335,23 @@ static int set_sync_ep_implicit_fb_quirk
 	case USB_ID(0x0763, 0x2031): /* M-Audio Fast Track C600 */
 	case USB_ID(0x22f0, 0x0006): /* Allen&Heath Qu-16 */
 		ep = 0x81;
-		iface = usb_ifnum_to_if(dev, 3);
-
-		if (!iface || iface->num_altsetting == 0)
-			return -EINVAL;
-
-		alts = &iface->altsetting[1];
-		goto add_sync_ep;
-		break;
+		ifnum = 3;
+		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x0763, 0x2080): /* M-Audio FastTrack Ultra */
 	case USB_ID(0x0763, 0x2081):
 		ep = 0x81;
-		iface = usb_ifnum_to_if(dev, 2);
-
-		if (!iface || iface->num_altsetting == 0)
-			return -EINVAL;
-
-		alts = &iface->altsetting[1];
-		goto add_sync_ep;
-	case USB_ID(0x2466, 0x8003):
+		ifnum = 2;
+		goto add_sync_ep_from_ifnum;
+	case USB_ID(0x2466, 0x8003): /* Fractal Audio Axe-Fx II */
 		ep = 0x86;
-		iface = usb_ifnum_to_if(dev, 2);
-
-		if (!iface || iface->num_altsetting == 0)
-			return -EINVAL;
-
-		alts = &iface->altsetting[1];
-		goto add_sync_ep;
-	case USB_ID(0x1397, 0x0002):
+		ifnum = 2;
+		goto add_sync_ep_from_ifnum;
+	case USB_ID(0x1397, 0x0002): /* Behringer UFX1204 */
 		ep = 0x81;
-		iface = usb_ifnum_to_if(dev, 1);
-
-		if (!iface || iface->num_altsetting == 0)
-			return -EINVAL;
-
-		alts = &iface->altsetting[1];
-		goto add_sync_ep;
-
+		ifnum = 1;
+		goto add_sync_ep_from_ifnum;
 	}
+
 	if (attr == USB_ENDPOINT_SYNC_ASYNC &&
 	    altsd->bInterfaceClass == USB_CLASS_VENDOR_SPEC &&
 	    altsd->bInterfaceProtocol == 2 &&
@@ -386,6 +366,14 @@ static int set_sync_ep_implicit_fb_quirk
 	/* No quirk */
 	return 0;
 
+add_sync_ep_from_ifnum:
+	iface = usb_ifnum_to_if(dev, ifnum);
+
+	if (!iface || iface->num_altsetting == 0)
+		return -EINVAL;
+
+	alts = &iface->altsetting[1];
+
 add_sync_ep:
 	subs->sync_endpoint = snd_usb_add_endpoint(subs->stream->chip,
 						   alts, ep, !subs->direction,


