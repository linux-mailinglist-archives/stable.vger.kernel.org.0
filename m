Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C5EBA5AE
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388605AbfIVSn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388371AbfIVSn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:43:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8040A208C0;
        Sun, 22 Sep 2019 18:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177836;
        bh=K/Ynl8ZURJU4AyzZONs+0nrqygS1OaSrdmCK3xxot6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXu1/isq990SKY8R+dMsBQTRKAkn5cw1C7zbrpBFRCBcRt0K0bKv/cZbzzvl16MLp
         bLtgBxqJb49zVkdo4Z7v3FFr47VQIH0DhaZ/DwTEYU3U8dACTfNmuJ+hxtKh1ITcRO
         zQ4g3i5VTvM6sf1NH+mWaOx3dCWFxDH0jZ1071VY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 004/203] ALSA: hda/hdmi - Don't report spurious jack state changes
Date:   Sun, 22 Sep 2019 14:40:30 -0400
Message-Id: <20190922184350.30563-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 551626ec0ad28dc43cae3094c35be7088cc625ab ]

The HDMI jack handling reports the state change always via
snd_jack_report() whenever hdmi_present_sense() is called, even if the
state itself doesn't change from the previous time.  This is mostly
harmless but still a bit confusing to user-space.

This patch reduces such spurious jack state changes and reports only
when the state really changed.  Also, as a minor optimization, avoid
overwriting the pin ELD data when the state is identical.

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index bea7b09610809..c380596b2e84c 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1421,7 +1421,7 @@ static void hdmi_pcm_reset_pin(struct hdmi_spec *spec,
 /* update per_pin ELD from the given new ELD;
  * setup info frame and notification accordingly
  */
-static void update_eld(struct hda_codec *codec,
+static bool update_eld(struct hda_codec *codec,
 		       struct hdmi_spec_per_pin *per_pin,
 		       struct hdmi_eld *eld)
 {
@@ -1452,18 +1452,22 @@ static void update_eld(struct hda_codec *codec,
 		snd_hdmi_show_eld(codec, &eld->info);
 
 	eld_changed = (pin_eld->eld_valid != eld->eld_valid);
-	if (eld->eld_valid && pin_eld->eld_valid)
+	eld_changed |= (pin_eld->monitor_present != eld->monitor_present);
+	if (!eld_changed && eld->eld_valid && pin_eld->eld_valid)
 		if (pin_eld->eld_size != eld->eld_size ||
 		    memcmp(pin_eld->eld_buffer, eld->eld_buffer,
 			   eld->eld_size) != 0)
 			eld_changed = true;
 
-	pin_eld->monitor_present = eld->monitor_present;
-	pin_eld->eld_valid = eld->eld_valid;
-	pin_eld->eld_size = eld->eld_size;
-	if (eld->eld_valid)
-		memcpy(pin_eld->eld_buffer, eld->eld_buffer, eld->eld_size);
-	pin_eld->info = eld->info;
+	if (eld_changed) {
+		pin_eld->monitor_present = eld->monitor_present;
+		pin_eld->eld_valid = eld->eld_valid;
+		pin_eld->eld_size = eld->eld_size;
+		if (eld->eld_valid)
+			memcpy(pin_eld->eld_buffer, eld->eld_buffer,
+			       eld->eld_size);
+		pin_eld->info = eld->info;
+	}
 
 	/*
 	 * Re-setup pin and infoframe. This is needed e.g. when
@@ -1481,6 +1485,7 @@ static void update_eld(struct hda_codec *codec,
 			       SNDRV_CTL_EVENT_MASK_VALUE |
 			       SNDRV_CTL_EVENT_MASK_INFO,
 			       &get_hdmi_pcm(spec, pcm_idx)->eld_ctl->id);
+	return eld_changed;
 }
 
 /* update ELD and jack state via HD-audio verbs */
@@ -1582,6 +1587,7 @@ static void sync_eld_via_acomp(struct hda_codec *codec,
 	struct hdmi_spec *spec = codec->spec;
 	struct hdmi_eld *eld = &spec->temp_eld;
 	struct snd_jack *jack = NULL;
+	bool changed;
 	int size;
 
 	mutex_lock(&per_pin->lock);
@@ -1608,15 +1614,13 @@ static void sync_eld_via_acomp(struct hda_codec *codec,
 	 * disconnected event. Jack must be fetched before update_eld()
 	 */
 	jack = pin_idx_to_jack(codec, per_pin);
-	update_eld(codec, per_pin, eld);
+	changed = update_eld(codec, per_pin, eld);
 	if (jack == NULL)
 		jack = pin_idx_to_jack(codec, per_pin);
-	if (jack == NULL)
-		goto unlock;
-	snd_jack_report(jack,
-			(eld->monitor_present && eld->eld_valid) ?
+	if (changed && jack)
+		snd_jack_report(jack,
+				(eld->monitor_present && eld->eld_valid) ?
 				SND_JACK_AVOUT : 0);
- unlock:
 	mutex_unlock(&per_pin->lock);
 }
 
-- 
2.20.1

