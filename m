Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E6038E9CE
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhEXOvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233652AbhEXOtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:49:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97D48613FE;
        Mon, 24 May 2021 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867647;
        bh=J/bY1BDA2WepYFUzY74lWoOzigSPgpgyi+ZouIRDfug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSS/RU1qiAGhUo7Ex4Emsy/YlPtrndyipXQ1yRQzPmo6XogKavME9bUKSHnqPghQR
         NYNIWvJnEa0Ldj0nOMuBtAzY2SMnBknZud0QO0RV+UJtmtFqLr2XWQwrSzpPaZxMEq
         9l+1VR3b5zsNDka1GHVzcNzQBJWduZJw+zhO0y6Cp646jz4/h+VNSNB7M2VlhsjzUW
         GgZFnF/Ps2VId/EzrDIy2ToPviM/ebv8yW4crt92M5uiMa2n2GGGRcZf0KOzCaEsep
         6d4X1i1EwDUmSI/M2UYM8R+3VjqTItHR4IEU75qystJa+6gryTj+j8e8mqAtaZNWpK
         IdP9iM/JO0Ihw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 51/63] ALSA: dice: disable double_pcm_frames mode for M-Audio Profire 610, 2626 and Avid M-Box 3 Pro
Date:   Mon, 24 May 2021 10:46:08 -0400
Message-Id: <20210524144620.2497249-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 9f079c1bdc9087842dc5ac9d81b1d7f2578e81ce ]

ALSA dice driver detects jumbo payload at high sampling transfer frequency
for below models:

 * Avid M-Box 3 Pro
 * M-Audio Profire 610
 * M-Audio Profire 2626

Although many DICE-based devices have a quirk at high sampling transfer
frequency to multiplex double number of PCM frames into data block than
the number in IEC 61883-1/6, the above devices are just compliant to
IEC 61883-1/6.

This commit disables the mode of double_pcm_frames for the models.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210518012510.37126-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/dice/dice-pcm.c    |  4 ++--
 sound/firewire/dice/dice-stream.c |  2 +-
 sound/firewire/dice/dice.c        | 24 ++++++++++++++++++++++++
 sound/firewire/dice/dice.h        |  3 ++-
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/sound/firewire/dice/dice-pcm.c b/sound/firewire/dice/dice-pcm.c
index af8a90ee40f3..a69ca1111b03 100644
--- a/sound/firewire/dice/dice-pcm.c
+++ b/sound/firewire/dice/dice-pcm.c
@@ -218,7 +218,7 @@ static int pcm_open(struct snd_pcm_substream *substream)
 
 		if (frames_per_period > 0) {
 			// For double_pcm_frame quirk.
-			if (rate > 96000) {
+			if (rate > 96000 && !dice->disable_double_pcm_frames) {
 				frames_per_period *= 2;
 				frames_per_buffer *= 2;
 			}
@@ -273,7 +273,7 @@ static int pcm_hw_params(struct snd_pcm_substream *substream,
 
 		mutex_lock(&dice->mutex);
 		// For double_pcm_frame quirk.
-		if (rate > 96000) {
+		if (rate > 96000 && !dice->disable_double_pcm_frames) {
 			events_per_period /= 2;
 			events_per_buffer /= 2;
 		}
diff --git a/sound/firewire/dice/dice-stream.c b/sound/firewire/dice/dice-stream.c
index 1a14c083e8ce..c4dfe76500c2 100644
--- a/sound/firewire/dice/dice-stream.c
+++ b/sound/firewire/dice/dice-stream.c
@@ -181,7 +181,7 @@ static int keep_resources(struct snd_dice *dice, struct amdtp_stream *stream,
 	// as 'Dual Wire'.
 	// For this quirk, blocking mode is required and PCM buffer size should
 	// be aligned to SYT_INTERVAL.
-	double_pcm_frames = rate > 96000;
+	double_pcm_frames = (rate > 96000 && !dice->disable_double_pcm_frames);
 	if (double_pcm_frames) {
 		rate /= 2;
 		pcm_chs *= 2;
diff --git a/sound/firewire/dice/dice.c b/sound/firewire/dice/dice.c
index 107a81691f0e..239d164b0eea 100644
--- a/sound/firewire/dice/dice.c
+++ b/sound/firewire/dice/dice.c
@@ -21,6 +21,7 @@ MODULE_LICENSE("GPL v2");
 #define OUI_SSL			0x0050c2	// Actually ID reserved by IEEE.
 #define OUI_PRESONUS		0x000a92
 #define OUI_HARMAN		0x000fd7
+#define OUI_AVID		0x00a07e
 
 #define DICE_CATEGORY_ID	0x04
 #define WEISS_CATEGORY_ID	0x00
@@ -222,6 +223,14 @@ static int dice_probe(struct fw_unit *unit,
 				(snd_dice_detect_formats_t)entry->driver_data;
 	}
 
+	// Below models are compliant to IEC 61883-1/6 and have no quirk at high sampling transfer
+	// frequency.
+	// * Avid M-Box 3 Pro
+	// * M-Audio Profire 610
+	// * M-Audio Profire 2626
+	if (entry->vendor_id == OUI_MAUDIO || entry->vendor_id == OUI_AVID)
+		dice->disable_double_pcm_frames = true;
+
 	spin_lock_init(&dice->lock);
 	mutex_init(&dice->mutex);
 	init_completion(&dice->clock_accepted);
@@ -278,7 +287,22 @@ static void dice_bus_reset(struct fw_unit *unit)
 
 #define DICE_INTERFACE	0x000001
 
+#define DICE_DEV_ENTRY_TYPICAL(vendor, model, data) \
+	{ \
+		.match_flags	= IEEE1394_MATCH_VENDOR_ID | \
+				  IEEE1394_MATCH_MODEL_ID | \
+				  IEEE1394_MATCH_SPECIFIER_ID | \
+				  IEEE1394_MATCH_VERSION, \
+		.vendor_id	= (vendor), \
+		.model_id	= (model), \
+		.specifier_id	= (vendor), \
+		.version	= DICE_INTERFACE, \
+		.driver_data = (kernel_ulong_t)(data), \
+	}
+
 static const struct ieee1394_device_id dice_id_table[] = {
+	// Avid M-Box 3 Pro. To match in probe function.
+	DICE_DEV_ENTRY_TYPICAL(OUI_AVID, 0x000004, snd_dice_detect_extension_formats),
 	/* M-Audio Profire 2626 has a different value in version field. */
 	{
 		.match_flags	= IEEE1394_MATCH_VENDOR_ID |
diff --git a/sound/firewire/dice/dice.h b/sound/firewire/dice/dice.h
index adc6f7c84460..3c967d1b3605 100644
--- a/sound/firewire/dice/dice.h
+++ b/sound/firewire/dice/dice.h
@@ -109,7 +109,8 @@ struct snd_dice {
 	struct fw_iso_resources rx_resources[MAX_STREAMS];
 	struct amdtp_stream tx_stream[MAX_STREAMS];
 	struct amdtp_stream rx_stream[MAX_STREAMS];
-	bool global_enabled;
+	bool global_enabled:1;
+	bool disable_double_pcm_frames:1;
 	struct completion clock_accepted;
 	unsigned int substreams_counter;
 
-- 
2.30.2

