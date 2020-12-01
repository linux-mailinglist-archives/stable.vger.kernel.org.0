Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B571B2C9A36
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387652AbgLAI4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387623AbgLAI4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:56:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF8432220B;
        Tue,  1 Dec 2020 08:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812954;
        bh=HpT54RHx9FS9Hv91WRVKiRblez5KYbBRdSNwdKR7CNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8zKyR27RzN4VNiqH98sjYB5UiPAMh6UiyJCSch9H3kFWwqEVsQZG7Rt9bXtk7WUd
         EgwFPxpZwMlZ7+Zqwa1xEEc5QL04zYD0DEaKp3iUsx0v9+luWvX3e0Zs33G0kM2euX
         kJ+PkYY0fGDlKeuZoeWQvC04mtOMVZf6PiaFTHPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 09/42] ALSA: hda/hdmi: Use single mutex unlock in error paths
Date:   Tue,  1 Dec 2020 09:53:07 +0100
Message-Id: <20201201084642.627849756@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084642.194933793@linuxfoundation.org>
References: <20201201084642.194933793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit f69548ffafcc4942022f16f2f192b24143de1dba upstream

Instead of calling mutex_unlock() at each error path multiple times,
take the standard goto-and-a-single-unlock approach.  This will
simplify the code and make easier to find the unbalanced mutex locks.

No functional changes, but only the code readability improvement as a
preliminary work for further changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |   67 ++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -307,13 +307,13 @@ static int hdmi_eld_ctl_info(struct snd_
 	if (!per_pin) {
 		/* no pin is bound to the pcm */
 		uinfo->count = 0;
-		mutex_unlock(&spec->pcm_lock);
-		return 0;
+		goto unlock;
 	}
 	eld = &per_pin->sink_eld;
 	uinfo->count = eld->eld_valid ? eld->eld_size : 0;
-	mutex_unlock(&spec->pcm_lock);
 
+ unlock:
+	mutex_unlock(&spec->pcm_lock);
 	return 0;
 }
 
@@ -325,6 +325,7 @@ static int hdmi_eld_ctl_get(struct snd_k
 	struct hdmi_spec_per_pin *per_pin;
 	struct hdmi_eld *eld;
 	int pcm_idx;
+	int err = 0;
 
 	pcm_idx = kcontrol->private_value;
 	mutex_lock(&spec->pcm_lock);
@@ -333,16 +334,15 @@ static int hdmi_eld_ctl_get(struct snd_k
 		/* no pin is bound to the pcm */
 		memset(ucontrol->value.bytes.data, 0,
 		       ARRAY_SIZE(ucontrol->value.bytes.data));
-		mutex_unlock(&spec->pcm_lock);
-		return 0;
+		goto unlock;
 	}
-	eld = &per_pin->sink_eld;
 
+	eld = &per_pin->sink_eld;
 	if (eld->eld_size > ARRAY_SIZE(ucontrol->value.bytes.data) ||
 	    eld->eld_size > ELD_MAX_SIZE) {
-		mutex_unlock(&spec->pcm_lock);
 		snd_BUG();
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock;
 	}
 
 	memset(ucontrol->value.bytes.data, 0,
@@ -350,9 +350,10 @@ static int hdmi_eld_ctl_get(struct snd_k
 	if (eld->eld_valid)
 		memcpy(ucontrol->value.bytes.data, eld->eld_buffer,
 		       eld->eld_size);
-	mutex_unlock(&spec->pcm_lock);
 
-	return 0;
+ unlock:
+	mutex_unlock(&spec->pcm_lock);
+	return err;
 }
 
 static struct snd_kcontrol_new eld_bytes_ctl = {
@@ -1114,8 +1115,8 @@ static int hdmi_pcm_open(struct hda_pcm_
 	pin_idx = hinfo_to_pin_index(codec, hinfo);
 	if (!spec->dyn_pcm_assign) {
 		if (snd_BUG_ON(pin_idx < 0)) {
-			mutex_unlock(&spec->pcm_lock);
-			return -EINVAL;
+			err = -EINVAL;
+			goto unlock;
 		}
 	} else {
 		/* no pin is assigned to the PCM
@@ -1123,16 +1124,13 @@ static int hdmi_pcm_open(struct hda_pcm_
 		 */
 		if (pin_idx < 0) {
 			err = hdmi_pcm_open_no_pin(hinfo, codec, substream);
-			mutex_unlock(&spec->pcm_lock);
-			return err;
+			goto unlock;
 		}
 	}
 
 	err = hdmi_choose_cvt(codec, pin_idx, &cvt_idx);
-	if (err < 0) {
-		mutex_unlock(&spec->pcm_lock);
-		return err;
-	}
+	if (err < 0)
+		goto unlock;
 
 	per_cvt = get_cvt(spec, cvt_idx);
 	/* Claim converter */
@@ -1168,12 +1166,11 @@ static int hdmi_pcm_open(struct hda_pcm_
 			per_cvt->assigned = 0;
 			hinfo->nid = 0;
 			snd_hda_spdif_ctls_unassign(codec, pcm_idx);
-			mutex_unlock(&spec->pcm_lock);
-			return -ENODEV;
+			err = -ENODEV;
+			goto unlock;
 		}
 	}
 
-	mutex_unlock(&spec->pcm_lock);
 	/* Store the updated parameters */
 	runtime->hw.channels_min = hinfo->channels_min;
 	runtime->hw.channels_max = hinfo->channels_max;
@@ -1182,7 +1179,9 @@ static int hdmi_pcm_open(struct hda_pcm_
 
 	snd_pcm_hw_constraint_step(substream->runtime, 0,
 				   SNDRV_PCM_HW_PARAM_CHANNELS, 2);
-	return 0;
+ unlock:
+	mutex_unlock(&spec->pcm_lock);
+	return err;
 }
 
 /*
@@ -1726,7 +1725,7 @@ static int generic_hdmi_playback_pcm_pre
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	bool non_pcm;
 	int pinctl;
-	int err;
+	int err = 0;
 
 	mutex_lock(&spec->pcm_lock);
 	pin_idx = hinfo_to_pin_index(codec, hinfo);
@@ -1738,13 +1737,12 @@ static int generic_hdmi_playback_pcm_pre
 		pin_cvt_fixup(codec, NULL, cvt_nid);
 		snd_hda_codec_setup_stream(codec, cvt_nid,
 					stream_tag, 0, format);
-		mutex_unlock(&spec->pcm_lock);
-		return 0;
+		goto unlock;
 	}
 
 	if (snd_BUG_ON(pin_idx < 0)) {
-		mutex_unlock(&spec->pcm_lock);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock;
 	}
 	per_pin = get_pin(spec, pin_idx);
 	pin_nid = per_pin->pin_nid;
@@ -1781,6 +1779,7 @@ static int generic_hdmi_playback_pcm_pre
 
 	err = spec->ops.setup_stream(codec, cvt_nid, pin_nid,
 				 stream_tag, format);
+ unlock:
 	mutex_unlock(&spec->pcm_lock);
 	return err;
 }
@@ -1802,6 +1801,7 @@ static int hdmi_pcm_close(struct hda_pcm
 	struct hdmi_spec_per_cvt *per_cvt;
 	struct hdmi_spec_per_pin *per_pin;
 	int pinctl;
+	int err = 0;
 
 	if (hinfo->nid) {
 		pcm_idx = hinfo_to_pcm_index(codec, hinfo);
@@ -1820,14 +1820,12 @@ static int hdmi_pcm_close(struct hda_pcm
 		snd_hda_spdif_ctls_unassign(codec, pcm_idx);
 		clear_bit(pcm_idx, &spec->pcm_in_use);
 		pin_idx = hinfo_to_pin_index(codec, hinfo);
-		if (spec->dyn_pcm_assign && pin_idx < 0) {
-			mutex_unlock(&spec->pcm_lock);
-			return 0;
-		}
+		if (spec->dyn_pcm_assign && pin_idx < 0)
+			goto unlock;
 
 		if (snd_BUG_ON(pin_idx < 0)) {
-			mutex_unlock(&spec->pcm_lock);
-			return -EINVAL;
+			err = -EINVAL;
+			goto unlock;
 		}
 		per_pin = get_pin(spec, pin_idx);
 
@@ -1846,10 +1844,11 @@ static int hdmi_pcm_close(struct hda_pcm
 		per_pin->setup = false;
 		per_pin->channels = 0;
 		mutex_unlock(&per_pin->lock);
+	unlock:
 		mutex_unlock(&spec->pcm_lock);
 	}
 
-	return 0;
+	return err;
 }
 
 static const struct hda_pcm_ops generic_ops = {


