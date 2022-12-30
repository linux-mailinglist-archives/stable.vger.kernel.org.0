Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB8D6583F2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiL1Qxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbiL1Qwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:52:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4347E78
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:47:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F66B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982A3C433D2;
        Wed, 28 Dec 2022 16:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246063;
        bh=YW6u3L6So3wCrj7EDvMlhpSljBwSghYO9/+jzmkNEJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIXqRgRAGRqvdDMLvf0cGUwqUp6eWVQtjD3BY/o7fkOvixc3pFtoAxhW9g+Li7xc+
         X9W4uTb/DiR5b7RwBFkoDQ+XTADxgjuwb9yQ3A4elFMD/buQsht7y/6t2b/0uH08F2
         9muaJf6JxpJnw/xtzOxidUNCrzpLBOO1Z51DOTlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1006/1073] ALSA: hda/hdmi: Use only dynamic PCM device allocation
Date:   Wed, 28 Dec 2022 15:43:14 +0100
Message-Id: <20221228144355.475699471@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit ef6f5494faf6a37c74990689a3bb3cee76d2544c ]

Per discussion on the alsa-devel mailing list [1], the legacy PIN to PCM
device mapping is obsolete nowadays. The maximum number of the simultaneously
usable PCM devices is equal to the HDMI codec converters.

Remove the extra PCM devices (beyond the detected converters) and force
the use of the dynamic PCM device allocation. The legacy code is removed.

I believe that all HDMI codecs have the jack sensing feature. Move the check
to the codec probe function and print a warning, if a codec without this
feature is detected.

[1] https://lore.kernel.org/alsa-devel/2f37e0b2-1e82-8c0b-2bbd-1e5038d6ecc6@perex.cz/

Cc: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220922084017.25925-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: ee0b089d6600 ("ALSA: hda/hdmi: fix stream-id config keep-alive for rt suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h   |   1 -
 sound/pci/hda/patch_hdmi.c  | 153 +++++++-----------------------------
 sound/soc/codecs/hda.c      |   3 -
 sound/soc/codecs/hdac_hda.c |   3 -
 4 files changed, 28 insertions(+), 132 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 6d3c82c4b6ac..684e6131737e 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -258,7 +258,6 @@ struct hda_codec {
 	unsigned int link_down_at_suspend:1; /* link down at runtime suspend */
 	unsigned int relaxed_resume:1;	/* don't resume forcibly for jack */
 	unsigned int forced_resume:1; /* forced resume for jack */
-	unsigned int mst_no_extra_pcms:1; /* no backup PCMs for DP-MST */
 
 #ifdef CONFIG_PM
 	unsigned long power_on_acct;
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index da5276e7eab1..36df152b63ba 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -167,8 +167,6 @@ struct hdmi_spec {
 	struct hdmi_ops ops;
 
 	bool dyn_pin_out;
-	bool dyn_pcm_assign;
-	bool dyn_pcm_no_legacy;
 	/* hdmi interrupt trigger control flag for Nvidia codec */
 	bool hdmi_intr_trig_ctrl;
 	bool nv_dp_workaround; /* workaround DP audio infoframe for Nvidia */
@@ -1187,9 +1185,7 @@ static void pin_cvt_fixup(struct hda_codec *codec,
 		spec->ops.pin_cvt_fixup(codec, per_pin, cvt_nid);
 }
 
-/* called in hdmi_pcm_open when no pin is assigned to the PCM
- * in dyn_pcm_assign mode.
- */
+/* called in hdmi_pcm_open when no pin is assigned to the PCM */
 static int hdmi_pcm_open_no_pin(struct hda_pcm_stream *hinfo,
 			 struct hda_codec *codec,
 			 struct snd_pcm_substream *substream)
@@ -1257,19 +1253,12 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 
 	mutex_lock(&spec->pcm_lock);
 	pin_idx = hinfo_to_pin_index(codec, hinfo);
-	if (!spec->dyn_pcm_assign) {
-		if (snd_BUG_ON(pin_idx < 0)) {
-			err = -EINVAL;
-			goto unlock;
-		}
-	} else {
-		/* no pin is assigned to the PCM
-		 * PA need pcm open successfully when probe
-		 */
-		if (pin_idx < 0) {
-			err = hdmi_pcm_open_no_pin(hinfo, codec, substream);
-			goto unlock;
-		}
+	/* no pin is assigned to the PCM
+	 * PA need pcm open successfully when probe
+	 */
+	if (pin_idx < 0) {
+		err = hdmi_pcm_open_no_pin(hinfo, codec, substream);
+		goto unlock;
 	}
 
 	err = hdmi_choose_cvt(codec, pin_idx, &cvt_idx, false);
@@ -1374,43 +1363,6 @@ static int hdmi_find_pcm_slot(struct hdmi_spec *spec,
 {
 	int i;
 
-	/* on the new machines, try to assign the pcm slot dynamically,
-	 * not use the preferred fixed map (legacy way) anymore.
-	 */
-	if (spec->dyn_pcm_no_legacy)
-		goto last_try;
-
-	/*
-	 * generic_hdmi_build_pcms() may allocate extra PCMs on some
-	 * platforms (with maximum of 'num_nids + dev_num - 1')
-	 *
-	 * The per_pin of pin_nid_idx=n and dev_id=m prefers to get pcm-n
-	 * if m==0. This guarantees that dynamic pcm assignments are compatible
-	 * with the legacy static per_pin-pcm assignment that existed in the
-	 * days before DP-MST.
-	 *
-	 * Intel DP-MST prefers this legacy behavior for compatibility, too.
-	 *
-	 * per_pin of m!=0 prefers to get pcm=(num_nids + (m - 1)).
-	 */
-
-	if (per_pin->dev_id == 0 || spec->intel_hsw_fixup) {
-		if (!test_bit(per_pin->pin_nid_idx, &spec->pcm_bitmap))
-			return per_pin->pin_nid_idx;
-	} else {
-		i = spec->num_nids + (per_pin->dev_id - 1);
-		if (i < spec->pcm_used && !(test_bit(i, &spec->pcm_bitmap)))
-			return i;
-	}
-
-	/* have a second try; check the area over num_nids */
-	for (i = spec->num_nids; i < spec->pcm_used; i++) {
-		if (!test_bit(i, &spec->pcm_bitmap))
-			return i;
-	}
-
- last_try:
-	/* the last try; check the empty slots in pins */
 	for (i = 0; i < spec->pcm_used; i++) {
 		if (!test_bit(i, &spec->pcm_bitmap))
 			return i;
@@ -1573,14 +1525,12 @@ static void update_eld(struct hda_codec *codec,
 	 */
 	pcm_jack = pin_idx_to_pcm_jack(codec, per_pin);
 
-	if (spec->dyn_pcm_assign) {
-		if (eld->eld_valid) {
-			hdmi_attach_hda_pcm(spec, per_pin);
-			hdmi_pcm_setup_pin(spec, per_pin);
-		} else {
-			hdmi_pcm_reset_pin(spec, per_pin);
-			hdmi_detach_hda_pcm(spec, per_pin);
-		}
+	if (eld->eld_valid) {
+		hdmi_attach_hda_pcm(spec, per_pin);
+		hdmi_pcm_setup_pin(spec, per_pin);
+	} else {
+		hdmi_pcm_reset_pin(spec, per_pin);
+		hdmi_detach_hda_pcm(spec, per_pin);
 	}
 	/* if pcm_idx == -1, it means this is in monitor connection event
 	 * we can get the correct pcm_idx now.
@@ -1943,7 +1893,7 @@ static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 		 * structures based on worst case.
 		 */
 		dev_num = spec->dev_num;
-	} else if (spec->dyn_pcm_assign && codec->dp_mst) {
+	} else if (codec->dp_mst) {
 		dev_num = snd_hda_get_num_devices(codec, pin_nid) + 1;
 		/*
 		 * spec->dev_num is the maxinum number of device entries
@@ -1968,13 +1918,8 @@ static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 		if (!per_pin)
 			return -ENOMEM;
 
-		if (spec->dyn_pcm_assign) {
-			per_pin->pcm = NULL;
-			per_pin->pcm_idx = -1;
-		} else {
-			per_pin->pcm = get_hdmi_pcm(spec, pin_idx);
-			per_pin->pcm_idx = pin_idx;
-		}
+		per_pin->pcm = NULL;
+		per_pin->pcm_idx = -1;
 		per_pin->pin_nid = pin_nid;
 		per_pin->pin_nid_idx = spec->num_nids;
 		per_pin->dev_id = i;
@@ -1983,6 +1928,8 @@ static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 		err = hdmi_read_pin_conn(codec, pin_idx);
 		if (err < 0)
 			return err;
+		if (!is_jack_detectable(codec, pin_nid))
+			codec_warn(codec, "HDMI: pin NID 0x%x - jack not detectable\n", pin_nid);
 		spec->num_pins++;
 	}
 	spec->num_nids++;
@@ -2130,10 +2077,9 @@ static int generic_hdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 
 	mutex_lock(&spec->pcm_lock);
 	pin_idx = hinfo_to_pin_index(codec, hinfo);
-	if (spec->dyn_pcm_assign && pin_idx < 0) {
-		/* when dyn_pcm_assign and pcm is not bound to a pin
-		 * skip pin setup and return 0 to make audio playback
-		 * be ongoing
+	if (pin_idx < 0) {
+		/* when pcm is not bound to a pin skip pin setup and return 0
+		 * to make audio playback be ongoing
 		 */
 		pin_cvt_fixup(codec, NULL, cvt_nid);
 		snd_hda_codec_setup_stream(codec, cvt_nid,
@@ -2236,7 +2182,7 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
 		snd_hda_spdif_ctls_unassign(codec, pcm_idx);
 		clear_bit(pcm_idx, &spec->pcm_in_use);
 		pin_idx = hinfo_to_pin_index(codec, hinfo);
-		if (spec->dyn_pcm_assign && pin_idx < 0)
+		if (pin_idx < 0)
 			goto unlock;
 
 		if (snd_BUG_ON(pin_idx < 0)) {
@@ -2334,21 +2280,8 @@ static int generic_hdmi_build_pcms(struct hda_codec *codec)
 	struct hdmi_spec *spec = codec->spec;
 	int idx, pcm_num;
 
-	/*
-	 * for non-mst mode, pcm number is the same as before
-	 * for DP MST mode without extra PCM, pcm number is same
-	 * for DP MST mode with extra PCMs, pcm number is
-	 *  (nid number + dev_num - 1)
-	 * dev_num is the device entry number in a pin
-	 */
-
-	if (spec->dyn_pcm_no_legacy && codec->mst_no_extra_pcms)
-		pcm_num = spec->num_cvts;
-	else if (codec->mst_no_extra_pcms)
-		pcm_num = spec->num_nids;
-	else
-		pcm_num = spec->num_nids + spec->dev_num - 1;
-
+	/* limit the PCM devices to the codec converters */
+	pcm_num = spec->num_cvts;
 	codec_dbg(codec, "hdmi: pcm_num set to %d\n", pcm_num);
 
 	for (idx = 0; idx < pcm_num; idx++) {
@@ -2387,17 +2320,12 @@ static int generic_hdmi_build_jack(struct hda_codec *codec, int pcm_idx)
 {
 	char hdmi_str[32] = "HDMI/DP";
 	struct hdmi_spec *spec = codec->spec;
-	struct hdmi_spec_per_pin *per_pin = get_pin(spec, pcm_idx);
 	struct snd_jack *jack;
 	int pcmdev = get_pcm_rec(spec, pcm_idx)->device;
 	int err;
 
 	if (pcmdev > 0)
 		sprintf(hdmi_str + strlen(hdmi_str), ",pcm=%d", pcmdev);
-	if (!spec->dyn_pcm_assign &&
-	    !is_jack_detectable(codec, per_pin->pin_nid))
-		strncat(hdmi_str, " Phantom",
-			sizeof(hdmi_str) - strlen(hdmi_str) - 1);
 
 	err = snd_jack_new(codec->card, hdmi_str, SND_JACK_AVOUT, &jack,
 			   true, false);
@@ -2430,18 +2358,9 @@ static int generic_hdmi_build_controls(struct hda_codec *codec)
 		/* create the spdif for each pcm
 		 * pin will be bound when monitor is connected
 		 */
-		if (spec->dyn_pcm_assign)
-			err = snd_hda_create_dig_out_ctls(codec,
+		err = snd_hda_create_dig_out_ctls(codec,
 					  0, spec->cvt_nids[0],
 					  HDA_PCM_TYPE_HDMI);
-		else {
-			struct hdmi_spec_per_pin *per_pin =
-				get_pin(spec, pcm_idx);
-			err = snd_hda_create_dig_out_ctls(codec,
-						  per_pin->pin_nid,
-						  per_pin->mux_nids[0],
-						  HDA_PCM_TYPE_HDMI);
-		}
 		if (err < 0)
 			return err;
 		snd_hda_spdif_ctls_unassign(codec, pcm_idx);
@@ -2561,11 +2480,7 @@ static void generic_hdmi_free(struct hda_codec *codec)
 	for (pcm_idx = 0; pcm_idx < spec->pcm_used; pcm_idx++) {
 		if (spec->pcm_rec[pcm_idx].jack == NULL)
 			continue;
-		if (spec->dyn_pcm_assign)
-			snd_device_free(codec->card,
-					spec->pcm_rec[pcm_idx].jack);
-		else
-			spec->pcm_rec[pcm_idx].jack = NULL;
+		snd_device_free(codec->card, spec->pcm_rec[pcm_idx].jack);
 	}
 
 	generic_spec_free(codec);
@@ -3063,7 +2978,6 @@ static int intel_hsw_common_init(struct hda_codec *codec, hda_nid_t vendor_nid,
 		return err;
 	spec = codec->spec;
 	codec->dp_mst = true;
-	spec->dyn_pcm_assign = true;
 	spec->vendor_nid = vendor_nid;
 	spec->port_map = port_map;
 	spec->port_num = port_num;
@@ -3127,17 +3041,9 @@ static int patch_i915_tgl_hdmi(struct hda_codec *codec)
 	 * the index indicate the port number.
 	 */
 	static const int map[] = {0x4, 0x6, 0x8, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf};
-	int ret;
-
-	ret = intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 4,
-				    enable_silent_stream);
-	if (!ret) {
-		struct hdmi_spec *spec = codec->spec;
 
-		spec->dyn_pcm_no_legacy = true;
-	}
-
-	return ret;
+	return intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map), 4,
+				     enable_silent_stream);
 }
 
 static int patch_i915_adlp_hdmi(struct hda_codec *codec)
@@ -3777,7 +3683,6 @@ static int patch_nvhdmi(struct hda_codec *codec)
 	codec->dp_mst = true;
 
 	spec = codec->spec;
-	spec->dyn_pcm_assign = true;
 
 	err = hdmi_parse_codec(codec);
 	if (err < 0) {
@@ -4057,10 +3962,8 @@ static int patch_tegra234_hdmi(struct hda_codec *codec)
 		return err;
 
 	codec->dp_mst = true;
-	codec->mst_no_extra_pcms = true;
 	spec = codec->spec;
 	spec->dyn_pin_out = true;
-	spec->dyn_pcm_assign = true;
 	spec->hdmi_intr_trig_ctrl = true;
 
 	return tegra_hdmi_init(codec);
diff --git a/sound/soc/codecs/hda.c b/sound/soc/codecs/hda.c
index ad20a3dff9b7..61e8e9be6b8d 100644
--- a/sound/soc/codecs/hda.c
+++ b/sound/soc/codecs/hda.c
@@ -224,9 +224,6 @@ static int hda_codec_probe(struct snd_soc_component *component)
 		goto err;
 	}
 
-	/* configure codec for 1:1 PCM:DAI mapping */
-	codec->mst_no_extra_pcms = 1;
-
 	ret = snd_hda_codec_parse_pcms(codec);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to map pcms to dai %d\n", ret);
diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 8debcee59224..7876bdd558a7 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -461,9 +461,6 @@ static int hdac_hda_codec_probe(struct snd_soc_component *component)
 		dev_dbg(&hdev->dev, "no patch file found\n");
 	}
 
-	/* configure codec for 1:1 PCM:DAI mapping */
-	hcodec->mst_no_extra_pcms = 1;
-
 	ret = snd_hda_codec_parse_pcms(hcodec);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to map pcms to dai %d\n", ret);
-- 
2.35.1



