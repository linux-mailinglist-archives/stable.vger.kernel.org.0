Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A778B3C2F67
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhGJCbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234531AbhGJC3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23576613E6;
        Sat, 10 Jul 2021 02:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884001;
        bh=Kj3F6WY2nm737P62wP754f/Pzo/O6ynzSq8DoMe4IJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3clzOtgORvhEvkoCuZfXmTYjzevqS9MUScuUMRDKIV/Bt6MqTQnuGxOiKt+1Xd5g
         fe7v8tdm2PaPLnD+c9iaZwZS8QFIUyfluFR9vl8Z+/SxOC+JK0CnBoOhhtgEUPHkOA
         /PEb382B1wndcQe7ydoI/MGC2Mf/jVqd3oConbIFeHRj1frVR65CvI4mNxSciIeORC
         B+xDtUBpWTKtDFJof3I+St30OgED/EKru4Afm7iyz5zijWO85XljjAJOHxf1y62nSq
         xrTtlm5HNpVK7gYY2ADBqY7RHhSW6aMcn0tdwhMCOfH4GBybPnUgAbS2+D/TdLFJJP
         nlIfGa4XIJNMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Geoffrey D. Bennett" <g@b4.vu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 76/93] ALSA: usb-audio: scarlett2: Fix data_mutex lock
Date:   Fri,  9 Jul 2021 22:24:10 -0400
Message-Id: <20210710022428.3169839-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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
index e605ec5a91ba..38b3a0352b24 100644
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

