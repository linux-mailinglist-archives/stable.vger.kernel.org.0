Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A121B6822
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgDWXMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:12:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50150 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728523AbgDWXGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvb-0004nA-3f; Fri, 24 Apr 2020 00:06:43 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvW-00E6wM-7H; Fri, 24 Apr 2020 00:06:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alberto Aguirre" <albaguirre@gmail.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date:   Fri, 24 Apr 2020 00:06:48 +0100
Message-ID: <lsq.1587683028.680292235@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 181/245] ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alberto Aguirre <albaguirre@gmail.com>

commit 103e9625647ad74d201e26fb74afcd8479142a37 upstream.

Signed-off-by: Alberto Aguirre <albaguirre@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/pcm.c | 52 +++++++++++++++++++------------------------------
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
@@ -333,44 +334,23 @@ static int set_sync_ep_implicit_fb_quirk
 	case USB_ID(0x0763, 0x2030): /* M-Audio Fast Track C400 */
 	case USB_ID(0x0763, 0x2031): /* M-Audio Fast Track C600 */
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
@@ -385,6 +365,14 @@ static int set_sync_ep_implicit_fb_quirk
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

