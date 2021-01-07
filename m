Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF282ED18F
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbhAGOQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:16:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbhAGOQN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:16:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A0202311E;
        Thu,  7 Jan 2021 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028932;
        bh=0V+4DFvlLmzMohPpnYRiyo4mRYE2Si0uI32gqF/94Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhpY+En5Z95yl1/P78Ek19Y2M6Yl4nj/ETjSzIgUtaGQb0/WFnqfDkuX75+esp6iX
         hP5fRz7FOyovbcG1EmVqvwlPUPCfQiBGQMCoZ+I4bIEWfPCR1u51rao3R4PH1MrTyq
         QK/VShnqP43NmTF20OHeHS7mDxGDwz65D2/I6QHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alberto Aguirre <albaguirre@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 02/19] ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk
Date:   Thu,  7 Jan 2021 15:16:27 +0100
Message-Id: <20210107140827.695221610@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -324,6 +324,7 @@ static int set_sync_ep_implicit_fb_quirk
 	struct usb_host_interface *alts;
 	struct usb_interface *iface;
 	unsigned int ep;
+	unsigned int ifnum;
 
 	/* Implicit feedback sync EPs consumers are always playback EPs */
 	if (subs->direction != SNDRV_PCM_STREAM_PLAYBACK)
@@ -334,34 +335,19 @@ static int set_sync_ep_implicit_fb_quirk
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
+		ifnum = 2;
+		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x1397, 0x0002):
 		ep = 0x81;
-		iface = usb_ifnum_to_if(dev, 1);
-
-		if (!iface || iface->num_altsetting == 0)
-			return -EINVAL;
-
-		alts = &iface->altsetting[1];
-		goto add_sync_ep;
+		ifnum = 1;
+		goto add_sync_ep_from_ifnum;
 	}
+
 	if (attr == USB_ENDPOINT_SYNC_ASYNC &&
 	    altsd->bInterfaceClass == USB_CLASS_VENDOR_SPEC &&
 	    altsd->bInterfaceProtocol == 2 &&
@@ -376,6 +362,14 @@ static int set_sync_ep_implicit_fb_quirk
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


