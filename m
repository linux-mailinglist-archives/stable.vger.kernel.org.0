Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06032240357
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 10:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgHJIYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 04:24:18 -0400
Received: from marcansoft.com ([212.63.210.85]:55682 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgHJIYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 04:24:18 -0400
X-Greylist: delayed 12642 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Aug 2020 04:24:16 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 0878141A78;
        Mon, 10 Aug 2020 08:24:13 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     alsa-devel@alsa-project.org
Cc:     Takashi Iwai <tiwai@suse.de>, Hector Martin <marcan@marcan.st>,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109
Date:   Mon, 10 Aug 2020 17:24:00 +0900
Message-Id: <20200810082400.225858-1-marcan@marcan.st>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 sound/usb/card.h   | 1 +
 sound/usb/pcm.c    | 6 ++++++
 sound/usb/quirks.c | 3 +++
 sound/usb/stream.c | 1 +
 4 files changed, 11 insertions(+)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index de43267b9c8a..5351d7183b1b 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -137,6 +137,7 @@ struct snd_usb_substream {
 	unsigned int tx_length_quirk:1;	/* add length specifier to transfers */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
 	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
+	unsigned int stream_offset_adj;	/* Bytes to drop from beginning of stream (for non-compliant devices) */
 
 	unsigned int running: 1;	/* running status */
 
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 415bfec49a01..5600751803cf 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1420,6 +1420,12 @@ static void retire_capture_urb(struct snd_usb_substream *subs,
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
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index c551141f337e..abf99b814a0f 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1495,6 +1495,9 @@ void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 	case USB_ID(0x2b73, 0x000a): /* Pioneer DJ DJM-900NXS2 */
 		pioneer_djm_set_format_quirk(subs);
 		break;
+	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
+		subs->stream_offset_adj = 2;
+		break;
 	}
 }
 
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 4d1e6579e54d..ca76ba5b5c0b 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -94,6 +94,7 @@ static void snd_usb_init_substream(struct snd_usb_stream *as,
 	subs->tx_length_quirk = as->chip->tx_length_quirk;
 	subs->speed = snd_usb_get_speed(subs->dev);
 	subs->pkt_offset_adj = 0;
+	subs->stream_offset_adj = 0;
 
 	snd_usb_set_pcm_ops(as->pcm, stream);
 
-- 
2.27.0

