Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5710DCA61A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392094AbfJCQjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392415AbfJCQjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:39:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6362C222CF;
        Thu,  3 Oct 2019 16:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120793;
        bh=K/Ynl8ZURJU4AyzZONs+0nrqygS1OaSrdmCK3xxot6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dn5P4JID9LJiOHazHdHJ9T8NIsX1pSlYwAu25Mn0WI3/sMhjem3wzsJ9m1C+xKmlV
         SqV1n37tC7EBIzA5n+rD6VKL86cI3V4mZXeNSeedHdE+a5QpbUDLd+3RmQkqnNMJR1
         wAAsrZrjOpYuoxMx4RK3afCvlRWY695rjK9yO03I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 041/344] ALSA: hda/hdmi - Dont report spurious jack state changes
Date:   Thu,  3 Oct 2019 17:50:06 +0200
Message-Id: <20191003154544.160924676@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



