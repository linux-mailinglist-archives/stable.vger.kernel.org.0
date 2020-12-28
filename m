Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75852E4093
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437967AbgL1Oxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:53:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501946AbgL1OSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3949D20731;
        Mon, 28 Dec 2020 14:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165058;
        bh=3kG5J9OMHZZUaPTYvMqT9RrDcyM43wQeuf2AI8E2A5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ziuD7YT7Lo2h3uHd0HmGaZjQmjgyQgV+7UX4MLy4a1zjYyDJ56olqF3BMoqziIdLN
         /6TNOIYnTdi73fmYBV0fkWAymEl3ClwRu8w56KnrpoR/Y2UeG5N7sxdQC3rU5jKpV4
         Fgem7O/i5D2SxeMZqcfPPkjK/KDryUONojaMNSwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 395/717] ALSA: hda/hdmi: fix silent stream for first playback to DP
Date:   Mon, 28 Dec 2020 13:46:33 +0100
Message-Id: <20201228125039.922956192@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit b1a5039759cb7bfcb2157f28604dbda0bca58598 ]

A problem exists in enabling silent stream when connection type is
DisplayPort. Silent stream programming is completed when a new DP
receiver is connected, but infoframe transmission does not actually
start until PCM is opened for the first time. This can result in audible
gap of multiple seconds. This only affects the first PCM open.

Fix the issue by properly assigning a converter to the silent stream,
and modifying the required stream ID programming sequence.

This change only affects Intel display audio codecs.

BugLink: https://github.com/thesofproject/linux/issues/2468
Fixes: 951894cf30f4 ("ALSA: hda/hdmi: Add Intel silent stream support")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20201210174445.3134104-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 98 +++++++++++++++++++++++++++++++++-----
 1 file changed, 86 insertions(+), 12 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index b0068f8ca46dd..2ddc27db8c012 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -78,6 +78,7 @@ struct hdmi_spec_per_pin {
 	int pcm_idx; /* which pcm is attached. -1 means no pcm is attached */
 	int repoll_count;
 	bool setup; /* the stream has been set up by prepare callback */
+	bool silent_stream;
 	int channels; /* current number of channels */
 	bool non_pcm;
 	bool chmap_set;		/* channel-map override by ALSA API? */
@@ -979,6 +980,13 @@ static int hdmi_choose_cvt(struct hda_codec *codec,
 	else
 		per_pin = get_pin(spec, pin_idx);
 
+	if (per_pin && per_pin->silent_stream) {
+		cvt_idx = cvt_nid_to_cvt_index(codec, per_pin->cvt_nid);
+		if (cvt_id)
+			*cvt_id = cvt_idx;
+		return 0;
+	}
+
 	/* Dynamically assign converter to stream */
 	for (cvt_idx = 0; cvt_idx < spec->num_cvts; cvt_idx++) {
 		per_cvt = get_cvt(spec, cvt_idx);
@@ -1642,30 +1650,95 @@ static void hdmi_present_sense_via_verbs(struct hdmi_spec_per_pin *per_pin,
 	snd_hda_power_down_pm(codec);
 }
 
+#define I915_SILENT_RATE		48000
+#define I915_SILENT_CHANNELS		2
+#define I915_SILENT_FORMAT		SNDRV_PCM_FORMAT_S16_LE
+#define I915_SILENT_FORMAT_BITS	16
+#define I915_SILENT_FMT_MASK		0xf
+
 static void silent_stream_enable(struct hda_codec *codec,
-				struct hdmi_spec_per_pin *per_pin)
+				 struct hdmi_spec_per_pin *per_pin)
 {
-	unsigned int newval, oldval;
-
-	codec_dbg(codec, "hdmi: enabling silent stream for NID %d\n",
-			per_pin->pin_nid);
+	struct hdmi_spec *spec = codec->spec;
+	struct hdmi_spec_per_cvt *per_cvt;
+	int cvt_idx, pin_idx, err;
+	unsigned int format;
 
 	mutex_lock(&per_pin->lock);
 
-	if (!per_pin->channels)
-		per_pin->channels = 2;
+	if (per_pin->setup) {
+		codec_dbg(codec, "hdmi: PCM already open, no silent stream\n");
+		goto unlock_out;
+	}
 
-	oldval = snd_hda_codec_read(codec, per_pin->pin_nid, 0,
-			AC_VERB_GET_CONV, 0);
-	newval = (oldval & 0xF0) | 0xF;
-	snd_hda_codec_write(codec, per_pin->pin_nid, 0,
-			AC_VERB_SET_CHANNEL_STREAMID, newval);
+	pin_idx = pin_id_to_pin_index(codec, per_pin->pin_nid, per_pin->dev_id);
+	err = hdmi_choose_cvt(codec, pin_idx, &cvt_idx);
+	if (err) {
+		codec_err(codec, "hdmi: no free converter to enable silent mode\n");
+		goto unlock_out;
+	}
+
+	per_cvt = get_cvt(spec, cvt_idx);
+	per_cvt->assigned = 1;
+	per_pin->cvt_nid = per_cvt->cvt_nid;
+	per_pin->silent_stream = true;
 
+	codec_dbg(codec, "hdmi: enabling silent stream pin-NID=0x%x cvt-NID=0x%x\n",
+		  per_pin->pin_nid, per_cvt->cvt_nid);
+
+	snd_hda_set_dev_select(codec, per_pin->pin_nid, per_pin->dev_id);
+	snd_hda_codec_write_cache(codec, per_pin->pin_nid, 0,
+				  AC_VERB_SET_CONNECT_SEL,
+				  per_pin->mux_idx);
+
+	/* configure unused pins to choose other converters */
+	pin_cvt_fixup(codec, per_pin, 0);
+
+	snd_hdac_sync_audio_rate(&codec->core, per_pin->pin_nid,
+				 per_pin->dev_id, I915_SILENT_RATE);
+
+	/* trigger silent stream generation in hw */
+	format = snd_hdac_calc_stream_format(I915_SILENT_RATE, I915_SILENT_CHANNELS,
+					     I915_SILENT_FORMAT, I915_SILENT_FORMAT_BITS, 0);
+	snd_hda_codec_setup_stream(codec, per_pin->cvt_nid,
+				   I915_SILENT_FMT_MASK, I915_SILENT_FMT_MASK, format);
+	usleep_range(100, 200);
+	snd_hda_codec_setup_stream(codec, per_pin->cvt_nid, I915_SILENT_FMT_MASK, 0, format);
+
+	per_pin->channels = I915_SILENT_CHANNELS;
 	hdmi_setup_audio_infoframe(codec, per_pin, per_pin->non_pcm);
 
+ unlock_out:
 	mutex_unlock(&per_pin->lock);
 }
 
+static void silent_stream_disable(struct hda_codec *codec,
+				  struct hdmi_spec_per_pin *per_pin)
+{
+	struct hdmi_spec *spec = codec->spec;
+	struct hdmi_spec_per_cvt *per_cvt;
+	int cvt_idx;
+
+	mutex_lock(&per_pin->lock);
+	if (!per_pin->silent_stream)
+		goto unlock_out;
+
+	codec_dbg(codec, "HDMI: disable silent stream on pin-NID=0x%x cvt-NID=0x%x\n",
+		  per_pin->pin_nid, per_pin->cvt_nid);
+
+	cvt_idx = cvt_nid_to_cvt_index(codec, per_pin->cvt_nid);
+	if (cvt_idx >= 0 && cvt_idx < spec->num_cvts) {
+		per_cvt = get_cvt(spec, cvt_idx);
+		per_cvt->assigned = 0;
+	}
+
+	per_pin->cvt_nid = 0;
+	per_pin->silent_stream = false;
+
+ unlock_out:
+	mutex_unlock(&spec->pcm_lock);
+}
+
 /* update ELD and jack state via audio component */
 static void sync_eld_via_acomp(struct hda_codec *codec,
 			       struct hdmi_spec_per_pin *per_pin)
@@ -1701,6 +1774,7 @@ static void sync_eld_via_acomp(struct hda_codec *codec,
 				pm_ret);
 			silent_stream_enable(codec, per_pin);
 		} else if (monitor_prev && !monitor_next) {
+			silent_stream_disable(codec, per_pin);
 			pm_ret = snd_hda_power_down_pm(codec);
 			if (pm_ret < 0)
 				codec_err(codec,
-- 
2.27.0



