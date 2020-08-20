Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A8824B4F0
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbgHTKOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731206AbgHTKOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:14:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F26720738;
        Thu, 20 Aug 2020 10:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918482;
        bh=Vnlfd91f9jY6V0NUMDifoozT8NMnDbS+d6M8OKwcTcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyVHFbs1Cc55RPjuRT4OkkSuol2glquX/E21C1DQwS0L5nOFAJJMk7jS5KoMWOQDP
         MA/o3vmfL2lEl4IewunEhnKxl2EolpnK9lmnexPaLx0pEF9molgPfkETn7bfFJhoJz
         TZUkJ9A3in+fbhYpRs9ok7+bkgGwtYpnnpV7gwhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 156/228] ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109
Date:   Thu, 20 Aug 2020 11:22:11 +0200
Message-Id: <20200820091615.374078967@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

commit 1b7ecc241a67ad6b584e071bd791a54e0cd5f097 upstream.

Further investigation of the L-R swap problem on the MS2109 reveals that
the problem isn't that the channels are swapped, but rather that they
are swapped and also out of phase by one sample. In other words, the
issue is actually that the very first frame that comes from the hardware
is a half-frame containing only the right channel, and after that
everything becomes offset.

So introduce a new quirk field to drop the very first 2 bytes that come
in after the format is configured and a capture stream starts. This puts
the channels in phase and in the correct order.

Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20200810082400.225858-1-marcan@marcan.st
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.h   |    1 +
 sound/usb/pcm.c    |    6 ++++++
 sound/usb/quirks.c |    3 +++
 sound/usb/stream.c |    1 +
 4 files changed, 11 insertions(+)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -126,6 +126,7 @@ struct snd_usb_substream {
 	unsigned int tx_length_quirk:1;	/* add length specifier to transfers */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
 	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
+	unsigned int stream_offset_adj;	/* Bytes to drop from beginning of stream (for non-compliant devices) */
 
 	unsigned int running: 1;	/* running status */
 
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1313,6 +1313,12 @@ static void retire_capture_urb(struct sn
 			// continue;
 		}
 		bytes = urb->iso_frame_desc[i].actual_length;
+		if (subs->stream_offset_adj > 0) {
+			unsigned int adj = min(subs->stream_offset_adj, bytes);
+			cp += adj;
+			bytes -= adj;
+			subs->stream_offset_adj -= adj;
+		}
 		frames = bytes / stride;
 		if (!subs->txfr_quirk)
 			bytes = frames * stride;
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1120,6 +1120,9 @@ void snd_usb_set_format_quirk(struct snd
 	case USB_ID(0x041e, 0x3f19): /* E-Mu 0204 USB */
 		set_format_emu_quirk(subs, fmt);
 		break;
+	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
+		subs->stream_offset_adj = 2;
+		break;
 	}
 }
 
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -95,6 +95,7 @@ static void snd_usb_init_substream(struc
 	subs->tx_length_quirk = as->chip->tx_length_quirk;
 	subs->speed = snd_usb_get_speed(subs->dev);
 	subs->pkt_offset_adj = 0;
+	subs->stream_offset_adj = 0;
 
 	snd_usb_set_pcm_ops(as->pcm, stream);
 


