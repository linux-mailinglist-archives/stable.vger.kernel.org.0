Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC83715783E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgBJNGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:06:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729562AbgBJMjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:55 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98FA724683;
        Mon, 10 Feb 2020 12:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338394;
        bh=lyAX0sD/dayzt5f8IDmRl9esyCecVngBi44p1H7HHDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upETm/qd7ARVujdBqXdj3OCVocBTG9vBMzlrREuHSk1iO0c+bOhw5JQEqMc8IQkS9
         LX9A/x1yWk6vuXGzCb162z0IwPbRvzQOBLK5D+yGazp2x7+AvX8zR7yAit4XmriBrI
         +5FnShcvljOkKJhqTCxYtoJ3RCDO/Lwwc+SykWZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikhil Mahale <nmahale@nvidia.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Martin Regner <martin@larkos.de>
Subject: [PATCH 5.5 071/367] ALSA: hda - Fix DP-MST support for NVIDIA codecs
Date:   Mon, 10 Feb 2020 04:29:44 -0800
Message-Id: <20200210122430.706919763@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikhil Mahale <nmahale@nvidia.com>

commit c7e661a1c2ae98a4754db6a85fc686b4a89322ad upstream.

If dyn_pcm_assign is set, different jack objects are being created
for pcm and pins.

If dyn_pcm_assign is set, generic_hdmi_build_jack() calls into
add_hdmi_jack_kctl() to create and track separate jack object for
pcm. Like sync_eld_via_acomp(), hdmi_present_sense_via_verbs() also
need to report status change of the pcm jack.

Rename pin_idx_to_jack() to pin_idx_to_pcm_jack(). Update
hdmi_present_sense_via_verbs() to report plug state of pcm jack
object. Unlike sync_eld_via_acomp(), for !acomp drivers the pcm
jack's plug state must be consistent with plug state
of pin's jack.

Fixes: 5398e94fb753 ("ALSA: hda - Add DP-MST support for NVIDIA codecs")
Reported-and-tested-by: Martin Regner <martin@larkos.de>
Signed-off-by: Nikhil Mahale <nmahale@nvidia.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200204102746.1356-1-nmahale@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |   94 ++++++++++++++++++++++++++++++---------------
 1 file changed, 63 insertions(+), 31 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1547,6 +1547,34 @@ static bool update_eld(struct hda_codec
 	return eld_changed;
 }
 
+static struct snd_jack *pin_idx_to_pcm_jack(struct hda_codec *codec,
+					    struct hdmi_spec_per_pin *per_pin)
+{
+	struct hdmi_spec *spec = codec->spec;
+	struct snd_jack *jack = NULL;
+	struct hda_jack_tbl *jack_tbl;
+
+	/* if !dyn_pcm_assign, get jack from hda_jack_tbl
+	 * in !dyn_pcm_assign case, spec->pcm_rec[].jack is not
+	 * NULL even after snd_hda_jack_tbl_clear() is called to
+	 * free snd_jack. This may cause access invalid memory
+	 * when calling snd_jack_report
+	 */
+	if (per_pin->pcm_idx >= 0 && spec->dyn_pcm_assign) {
+		jack = spec->pcm_rec[per_pin->pcm_idx].jack;
+	} else if (!spec->dyn_pcm_assign) {
+		/*
+		 * jack tbl doesn't support DP MST
+		 * DP MST will use dyn_pcm_assign,
+		 * so DP MST will never come here
+		 */
+		jack_tbl = snd_hda_jack_tbl_get_mst(codec, per_pin->pin_nid,
+						    per_pin->dev_id);
+		if (jack_tbl)
+			jack = jack_tbl->jack;
+	}
+	return jack;
+}
 /* update ELD and jack state via HD-audio verbs */
 static bool hdmi_present_sense_via_verbs(struct hdmi_spec_per_pin *per_pin,
 					 int repoll)
@@ -1568,6 +1596,7 @@ static bool hdmi_present_sense_via_verbs
 	int present;
 	bool ret;
 	bool do_repoll = false;
+	struct snd_jack *pcm_jack = NULL;
 
 	present = snd_hda_jack_pin_sense(codec, pin_nid, dev_id);
 
@@ -1595,10 +1624,19 @@ static bool hdmi_present_sense_via_verbs
 			do_repoll = true;
 	}
 
-	if (do_repoll)
+	if (do_repoll) {
 		schedule_delayed_work(&per_pin->work, msecs_to_jiffies(300));
-	else
+	} else {
+		/*
+		 * pcm_idx >=0 before update_eld() means it is in monitor
+		 * disconnected event. Jack must be fetched before
+		 * update_eld().
+		 */
+		pcm_jack = pin_idx_to_pcm_jack(codec, per_pin);
 		update_eld(codec, per_pin, eld);
+		if (!pcm_jack)
+			pcm_jack = pin_idx_to_pcm_jack(codec, per_pin);
+	}
 
 	ret = !repoll || !eld->monitor_present || eld->eld_valid;
 
@@ -1607,38 +1645,32 @@ static bool hdmi_present_sense_via_verbs
 		jack->block_report = !ret;
 		jack->pin_sense = (eld->monitor_present && eld->eld_valid) ?
 			AC_PINSENSE_PRESENCE : 0;
-	}
-	mutex_unlock(&per_pin->lock);
-	return ret;
-}
 
-static struct snd_jack *pin_idx_to_jack(struct hda_codec *codec,
-				 struct hdmi_spec_per_pin *per_pin)
-{
-	struct hdmi_spec *spec = codec->spec;
-	struct snd_jack *jack = NULL;
-	struct hda_jack_tbl *jack_tbl;
+		if (spec->dyn_pcm_assign && pcm_jack && !do_repoll) {
+			int state = 0;
+
+			if (jack->pin_sense & AC_PINSENSE_PRESENCE)
+				state = SND_JACK_AVOUT;
+			snd_jack_report(pcm_jack, state);
+		}
 
-	/* if !dyn_pcm_assign, get jack from hda_jack_tbl
-	 * in !dyn_pcm_assign case, spec->pcm_rec[].jack is not
-	 * NULL even after snd_hda_jack_tbl_clear() is called to
-	 * free snd_jack. This may cause access invalid memory
-	 * when calling snd_jack_report
-	 */
-	if (per_pin->pcm_idx >= 0 && spec->dyn_pcm_assign)
-		jack = spec->pcm_rec[per_pin->pcm_idx].jack;
-	else if (!spec->dyn_pcm_assign) {
 		/*
-		 * jack tbl doesn't support DP MST
-		 * DP MST will use dyn_pcm_assign,
-		 * so DP MST will never come here
+		 * snd_hda_jack_pin_sense() call at the beginning of this
+		 * function, updates jack->pins_sense and clears
+		 * jack->jack_dirty, therefore snd_hda_jack_report_sync() will
+		 * not override the jack->pin_sense.
+		 *
+		 * snd_hda_jack_report_sync() is superfluous for dyn_pcm_assign
+		 * case. The jack->pin_sense update was already performed, and
+		 * hda_jack->jack is NULL for dyn_pcm_assign.
+		 *
+		 * Don't call snd_hda_jack_report_sync() for
+		 * dyn_pcm_assign.
 		 */
-		jack_tbl = snd_hda_jack_tbl_get_mst(codec, per_pin->pin_nid,
-						    per_pin->dev_id);
-		if (jack_tbl)
-			jack = jack_tbl->jack;
+		ret = ret && !spec->dyn_pcm_assign;
 	}
-	return jack;
+	mutex_unlock(&per_pin->lock);
+	return ret;
 }
 
 /* update ELD and jack state via audio component */
@@ -1674,10 +1706,10 @@ static void sync_eld_via_acomp(struct hd
 	/* pcm_idx >=0 before update_eld() means it is in monitor
 	 * disconnected event. Jack must be fetched before update_eld()
 	 */
-	jack = pin_idx_to_jack(codec, per_pin);
+	jack = pin_idx_to_pcm_jack(codec, per_pin);
 	changed = update_eld(codec, per_pin, eld);
 	if (jack == NULL)
-		jack = pin_idx_to_jack(codec, per_pin);
+		jack = pin_idx_to_pcm_jack(codec, per_pin);
 	if (changed && jack)
 		snd_jack_report(jack,
 				(eld->monitor_present && eld->eld_valid) ?


