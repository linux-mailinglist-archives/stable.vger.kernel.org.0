Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697F88DAA9
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbfHNRLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbfHNRLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:11:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76E5320665;
        Wed, 14 Aug 2019 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802690;
        bh=0tXrQaeo0vYzQgzrG/JWcReo/TyRtrYjY6f/JgbqLGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMsaV5kLHk/Adfw0xS0tOFcWN8QOHrNfI9AoZzSgjbZK6jfYN5nHiQzC0Ama06fVN
         CpHjvjmgAVSQPRjKQnXNloE59C6ryZaHySKZIwgzLmbqsfW6CAehwR0DE/QQwq8cfa
         +dLzA0YtA/PHhCIOHFAIvztVF31acOqtMQH3jpz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 80/91] ALSA: hda - Workaround for crackled sound on AMD controller (1022:1457)
Date:   Wed, 14 Aug 2019 19:01:43 +0200
Message-Id: <20190814165753.312582703@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c02f77d32d2c45cfb1b2bb99eabd8a78f5ecc7db upstream.

A long-time problem on the recent AMD chip (X370, X470, B450, etc with
PCI ID 1022:1457) with Realtek codecs is the crackled or distorted
sound for capture streams, as well as occasional playback hiccups.
After lengthy debugging sessions, the workarounds we've found are like
the following:

- Set up the proper driver caps for this controller, similar as the
  other AMD controller.

- Correct the DMA position reporting with the fixed FIFO size, which
  is similar like as workaround used for VIA chip set.

- Even after the position correction, PulseAudio still shows
  mysterious stalls of playback streams when a capture is triggered in
  timer-scheduled mode.  Since we have no clear way to eliminate the
  stall, pass the BATCH PCM flag for PA to suppress the tsched mode as
  a temporary workaround.

This patch implements the workarounds.  For the driver caps, it
defines a new preset, AXZ_DCAPS_PRESET_AMD_SB.  It enables the FIFO-
corrected position reporting (corresponding to the new position_fix=6)
and enforces the SNDRV_PCM_INFO_BATCH flag.

Note that the current implementation is merely a workaround.
Hopefully we'll find a better alternative in future, especially about
removing the BATCH flag hack again.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=195303
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_controller.c |    7 ++++
 sound/pci/hda/hda_controller.h |    2 -
 sound/pci/hda/hda_intel.c      |   63 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 70 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -624,6 +624,13 @@ static int azx_pcm_open(struct snd_pcm_s
 				     20,
 				     178000000);
 
+	/* by some reason, the playback stream stalls on PulseAudio with
+	 * tsched=1 when a capture stream triggers.  Until we figure out the
+	 * real cause, disable tsched mode by telling the PCM info flag.
+	 */
+	if (chip->driver_caps & AZX_DCAPS_AMD_WORKAROUND)
+		runtime->hw.info |= SNDRV_PCM_INFO_BATCH;
+
 	if (chip->align_buffer_size)
 		/* constrain buffer sizes to be multiple of 128
 		   bytes. This is more efficient in terms of memory
--- a/sound/pci/hda/hda_controller.h
+++ b/sound/pci/hda/hda_controller.h
@@ -40,7 +40,7 @@
 /* 14 unused */
 #define AZX_DCAPS_CTX_WORKAROUND (1 << 15)	/* X-Fi workaround */
 #define AZX_DCAPS_POSFIX_LPIB	(1 << 16)	/* Use LPIB as default */
-/* 17 unused */
+#define AZX_DCAPS_AMD_WORKAROUND (1 << 17)	/* AMD-specific workaround */
 #define AZX_DCAPS_NO_64BIT	(1 << 18)	/* No 64bit address */
 #define AZX_DCAPS_SYNC_WRITE	(1 << 19)	/* sync each cmd write */
 #define AZX_DCAPS_OLD_SSYNC	(1 << 20)	/* Old SSYNC reg for ICH */
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -78,6 +78,7 @@ enum {
 	POS_FIX_VIACOMBO,
 	POS_FIX_COMBO,
 	POS_FIX_SKL,
+	POS_FIX_FIFO,
 };
 
 /* Defines for ATI HD Audio support in SB450 south bridge */
@@ -149,7 +150,7 @@ module_param_array(model, charp, NULL, 0
 MODULE_PARM_DESC(model, "Use the given board model.");
 module_param_array(position_fix, int, NULL, 0444);
 MODULE_PARM_DESC(position_fix, "DMA pointer read method."
-		 "(-1 = system default, 0 = auto, 1 = LPIB, 2 = POSBUF, 3 = VIACOMBO, 4 = COMBO, 5 = SKL+).");
+		 "(-1 = system default, 0 = auto, 1 = LPIB, 2 = POSBUF, 3 = VIACOMBO, 4 = COMBO, 5 = SKL+, 6 = FIFO).");
 module_param_array(bdl_pos_adj, int, NULL, 0644);
 MODULE_PARM_DESC(bdl_pos_adj, "BDL position adjustment offset.");
 module_param_array(probe_mask, int, NULL, 0444);
@@ -350,6 +351,11 @@ enum {
 #define AZX_DCAPS_PRESET_ATI_HDMI_NS \
 	(AZX_DCAPS_PRESET_ATI_HDMI | AZX_DCAPS_SNOOP_OFF)
 
+/* quirks for AMD SB */
+#define AZX_DCAPS_PRESET_AMD_SB \
+	(AZX_DCAPS_NO_TCSEL | AZX_DCAPS_SYNC_WRITE | AZX_DCAPS_AMD_WORKAROUND |\
+	 AZX_DCAPS_SNOOP_TYPE(ATI) | AZX_DCAPS_PM_RUNTIME)
+
 /* quirks for Nvidia */
 #define AZX_DCAPS_PRESET_NVIDIA \
 	(AZX_DCAPS_NO_MSI | AZX_DCAPS_CORBRP_SELF_CLEAR |\
@@ -920,6 +926,49 @@ static unsigned int azx_via_get_position
 	return bound_pos + mod_dma_pos;
 }
 
+#define AMD_FIFO_SIZE	32
+
+/* get the current DMA position with FIFO size correction */
+static unsigned int azx_get_pos_fifo(struct azx *chip, struct azx_dev *azx_dev)
+{
+	struct snd_pcm_substream *substream = azx_dev->core.substream;
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	unsigned int pos, delay;
+
+	pos = snd_hdac_stream_get_pos_lpib(azx_stream(azx_dev));
+	if (!runtime)
+		return pos;
+
+	runtime->delay = AMD_FIFO_SIZE;
+	delay = frames_to_bytes(runtime, AMD_FIFO_SIZE);
+	if (azx_dev->insufficient) {
+		if (pos < delay) {
+			delay = pos;
+			runtime->delay = bytes_to_frames(runtime, pos);
+		} else {
+			azx_dev->insufficient = 0;
+		}
+	}
+
+	/* correct the DMA position for capture stream */
+	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+		if (pos < delay)
+			pos += azx_dev->core.bufsize;
+		pos -= delay;
+	}
+
+	return pos;
+}
+
+static int azx_get_delay_from_fifo(struct azx *chip, struct azx_dev *azx_dev,
+				   unsigned int pos)
+{
+	struct snd_pcm_substream *substream = azx_dev->core.substream;
+
+	/* just read back the calculated value in the above */
+	return substream->runtime->delay;
+}
+
 static unsigned int azx_skl_get_dpib_pos(struct azx *chip,
 					 struct azx_dev *azx_dev)
 {
@@ -1528,6 +1577,7 @@ static int check_position_fix(struct azx
 	case POS_FIX_VIACOMBO:
 	case POS_FIX_COMBO:
 	case POS_FIX_SKL:
+	case POS_FIX_FIFO:
 		return fix;
 	}
 
@@ -1544,6 +1594,10 @@ static int check_position_fix(struct azx
 		dev_dbg(chip->card->dev, "Using VIACOMBO position fix\n");
 		return POS_FIX_VIACOMBO;
 	}
+	if (chip->driver_caps & AZX_DCAPS_AMD_WORKAROUND) {
+		dev_dbg(chip->card->dev, "Using FIFO position fix\n");
+		return POS_FIX_FIFO;
+	}
 	if (chip->driver_caps & AZX_DCAPS_POSFIX_LPIB) {
 		dev_dbg(chip->card->dev, "Using LPIB position fix\n");
 		return POS_FIX_LPIB;
@@ -1564,6 +1618,7 @@ static void assign_position_fix(struct a
 		[POS_FIX_VIACOMBO] = azx_via_get_position,
 		[POS_FIX_COMBO] = azx_get_pos_lpib,
 		[POS_FIX_SKL] = azx_get_pos_skl,
+		[POS_FIX_FIFO] = azx_get_pos_fifo,
 	};
 
 	chip->get_position[0] = chip->get_position[1] = callbacks[fix];
@@ -1578,6 +1633,9 @@ static void assign_position_fix(struct a
 			azx_get_delay_from_lpib;
 	}
 
+	if (fix == POS_FIX_FIFO)
+		chip->get_delay[0] = chip->get_delay[1] =
+			azx_get_delay_from_fifo;
 }
 
 /*
@@ -2594,6 +2652,9 @@ static const struct pci_device_id azx_id
 	/* AMD Hudson */
 	{ PCI_DEVICE(0x1022, 0x780d),
 	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_ATI_SB },
+	/* AMD, X370 & co */
+	{ PCI_DEVICE(0x1022, 0x1457),
+	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_AMD_SB },
 	/* AMD Stoney */
 	{ PCI_DEVICE(0x1022, 0x157a),
 	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_ATI_SB |


