Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FE83C3075
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhGJCfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235267AbhGJCel (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A9FE613E6;
        Sat, 10 Jul 2021 02:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884305;
        bh=KxUnYA1ZCm/A5kJwNZswFMsaVBGtm4UAUpU4v/+eQwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhNx7eYqpb2j8Em2KF24O0tQoawXiOkZANCdqMuVixZCoi321uGeqdwYaoFlA6ZpH
         8UcXeolOTkJlnRjcp/aMwg542yqThCLY+Rrwg0x95Zq2D5gMpQmqTpRYDaVXlUbESi
         M1K4RzK9qaywn8ukogBO7yQkpeWYWAgdvZaFAfZXluQpxu4GdFNowCbLhLwOT2Ym2w
         OLSNWHLyS70wL3VTHSDkYiSUZSUeIitok95b9qQE8MzATgPAC0ajfS7S0dD4QIsGD1
         X1y6PzI3NU2MZvvomYrksPWNBJA/yy5gy8QsBRr0iKulPJ0fK5q6xrK+Kpn5L8FjyG
         R27uNQcnj8r5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Geoffrey D. Bennett" <g@b4.vu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 50/63] ALSA: usb-audio: scarlett2: Fix data_mutex lock
Date:   Fri,  9 Jul 2021 22:26:56 -0400
Message-Id: <20210710022709.3170675-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit 9b5ddea9ce5a68d7d2bedcb69901ac2a86c96c7b ]

The private->vol_updated flag was being checked outside of the
mutex_lock/unlock() of private->data_mutex leading to the volume data
being fetched twice from the device unnecessarily or old volume data
being returned.

Update scarlett2_*_ctl_get() and include the private->vol_updated flag
check inside the critical region.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://lore.kernel.org/r/20210620164643.GA9216@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index a1f1ff72be4f..60545eeef28f 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1028,11 +1028,10 @@ static int scarlett2_master_volume_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_mixer_data *private = mixer->private_data;
 
-	if (private->vol_updated) {
-		mutex_lock(&private->data_mutex);
+	mutex_lock(&private->data_mutex);
+	if (private->vol_updated)
 		scarlett2_update_volumes(mixer);
-		mutex_unlock(&private->data_mutex);
-	}
+	mutex_unlock(&private->data_mutex);
 
 	ucontrol->value.integer.value[0] = private->master_vol;
 	return 0;
@@ -1046,11 +1045,10 @@ static int scarlett2_volume_ctl_get(struct snd_kcontrol *kctl,
 	struct scarlett2_mixer_data *private = mixer->private_data;
 	int index = elem->control;
 
-	if (private->vol_updated) {
-		mutex_lock(&private->data_mutex);
+	mutex_lock(&private->data_mutex);
+	if (private->vol_updated)
 		scarlett2_update_volumes(mixer);
-		mutex_unlock(&private->data_mutex);
-	}
+	mutex_unlock(&private->data_mutex);
 
 	ucontrol->value.integer.value[0] = private->vol[index];
 	return 0;
@@ -1314,11 +1312,10 @@ static int scarlett2_button_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_mixer_data *private = mixer->private_data;
 
-	if (private->vol_updated) {
-		mutex_lock(&private->data_mutex);
+	mutex_lock(&private->data_mutex);
+	if (private->vol_updated)
 		scarlett2_update_volumes(mixer);
-		mutex_unlock(&private->data_mutex);
-	}
+	mutex_unlock(&private->data_mutex);
 
 	ucontrol->value.enumerated.item[0] = private->buttons[elem->control];
 	return 0;
-- 
2.30.2

