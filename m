Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C007246C79
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgHQQRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731125AbgHQQQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:16:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E0DA20772;
        Mon, 17 Aug 2020 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680999;
        bh=hPo0V38jnWsNMAydRHO7trBV7uIaBeU/p2KnrRXXULM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Riw4kPNPOvsGcmm2o9+1wsu432u85ZjJu/RcgmLZAgq8wG1igxiCoJ9XGzzC8rv7u
         XgLQ3iAcNJcQkO0p0RwX+9lXLSTt1vCmhXcjut49hFg3e4VOcQ/im4Ve3zheaRjfiW
         OaztLVXfmSECOexCEK9PKgjaqF9bB3oXdIrg1urE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 143/168] ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109
Date:   Mon, 17 Aug 2020 17:17:54 +0200
Message-Id: <20200817143740.824601407@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
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
@@ -129,6 +129,7 @@ struct snd_usb_substream {
 	unsigned int tx_length_quirk:1;	/* add length specifier to transfers */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
 	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
+	unsigned int stream_offset_adj;	/* Bytes to drop from beginning of stream (for non-compliant devices) */
 
 	unsigned int running: 1;	/* running status */
 
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1387,6 +1387,12 @@ static void retire_capture_urb(struct sn
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
@@ -1166,6 +1166,9 @@ void snd_usb_set_format_quirk(struct snd
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
@@ -99,6 +99,7 @@ static void snd_usb_init_substream(struc
 	subs->tx_length_quirk = as->chip->tx_length_quirk;
 	subs->speed = snd_usb_get_speed(subs->dev);
 	subs->pkt_offset_adj = 0;
+	subs->stream_offset_adj = 0;
 
 	snd_usb_set_pcm_ops(as->pcm, stream);
 


