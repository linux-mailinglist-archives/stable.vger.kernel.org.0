Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C3F45BCD4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245281AbhKXMcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:32:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344258AbhKXMam (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:30:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C156112F;
        Wed, 24 Nov 2021 12:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756350;
        bh=7K2kOOr+Fr3Bv20Qi4jQYSFXYz8Q5AC5QsgcbvB2AYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/ryfVKz+QOY2Mn5bSti80Ls1uIf59bvHxzuCr0KYY1iuDgEKZJOWaeWgopiHaz7E
         3/cYUyP07uIozFre37ve2m7/BuE6styxd/EYLMOwN8wuIS21OcUvVgb6Lu0oFUgsXQ
         evuomUJGV4QYoBOqg+kvqEIQq+3avOxuJaTb1J/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9988f17cf72a1045a189@syzkaller.appspotmail.com,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 055/251] ALSA: mixer: oss: Fix racy access to slots
Date:   Wed, 24 Nov 2021 12:54:57 +0100
Message-Id: <20211124115712.158516332@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 411cef6adfb38a5bb6bd9af3941b28198e7fb680 upstream.

The OSS mixer can reassign the mapping slots dynamically via proc
file.  Although the addition and deletion of those slots are protected
by mixer->reg_mutex, the access to slots aren't, hence this may cause
UAF when the slots in use are deleted concurrently.

This patch applies the mixer->reg_mutex in all appropriate code paths
(i.e. the ioctl functions) that may access slots.

Reported-by: syzbot+9988f17cf72a1045a189@syzkaller.appspotmail.com
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/00000000000036adc005ceca9175@google.com
Link: https://lore.kernel.org/r/20211020164846.922-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/oss/mixer_oss.c |   43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -145,11 +145,13 @@ static int snd_mixer_oss_devmask(struct
 
 	if (mixer == NULL)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	for (chn = 0; chn < 31; chn++) {
 		pslot = &mixer->slots[chn];
 		if (pslot->put_volume || pslot->put_recsrc)
 			result |= 1 << chn;
 	}
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 
@@ -161,11 +163,13 @@ static int snd_mixer_oss_stereodevs(stru
 
 	if (mixer == NULL)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	for (chn = 0; chn < 31; chn++) {
 		pslot = &mixer->slots[chn];
 		if (pslot->put_volume && pslot->stereo)
 			result |= 1 << chn;
 	}
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 
@@ -176,6 +180,7 @@ static int snd_mixer_oss_recmask(struct
 
 	if (mixer == NULL)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	if (mixer->put_recsrc && mixer->get_recsrc) {	/* exclusive */
 		result = mixer->mask_recsrc;
 	} else {
@@ -187,6 +192,7 @@ static int snd_mixer_oss_recmask(struct
 				result |= 1 << chn;
 		}
 	}
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 
@@ -197,11 +203,12 @@ static int snd_mixer_oss_get_recsrc(stru
 
 	if (mixer == NULL)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	if (mixer->put_recsrc && mixer->get_recsrc) {	/* exclusive */
-		int err;
 		unsigned int index;
-		if ((err = mixer->get_recsrc(fmixer, &index)) < 0)
-			return err;
+		result = mixer->get_recsrc(fmixer, &index);
+		if (result < 0)
+			goto unlock;
 		result = 1 << index;
 	} else {
 		struct snd_mixer_oss_slot *pslot;
@@ -216,7 +223,10 @@ static int snd_mixer_oss_get_recsrc(stru
 			}
 		}
 	}
-	return mixer->oss_recsrc = result;
+	mixer->oss_recsrc = result;
+ unlock:
+	mutex_unlock(&mixer->reg_mutex);
+	return result;
 }
 
 static int snd_mixer_oss_set_recsrc(struct snd_mixer_oss_file *fmixer, int recsrc)
@@ -229,6 +239,7 @@ static int snd_mixer_oss_set_recsrc(stru
 
 	if (mixer == NULL)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	if (mixer->get_recsrc && mixer->put_recsrc) {	/* exclusive input */
 		if (recsrc & ~mixer->oss_recsrc)
 			recsrc &= ~mixer->oss_recsrc;
@@ -254,6 +265,7 @@ static int snd_mixer_oss_set_recsrc(stru
 			}
 		}
 	}
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 
@@ -265,6 +277,7 @@ static int snd_mixer_oss_get_volume(stru
 
 	if (mixer == NULL || slot > 30)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	pslot = &mixer->slots[slot];
 	left = pslot->volume[0];
 	right = pslot->volume[1];
@@ -272,15 +285,21 @@ static int snd_mixer_oss_get_volume(stru
 		result = pslot->get_volume(fmixer, pslot, &left, &right);
 	if (!pslot->stereo)
 		right = left;
-	if (snd_BUG_ON(left < 0 || left > 100))
-		return -EIO;
-	if (snd_BUG_ON(right < 0 || right > 100))
-		return -EIO;
+	if (snd_BUG_ON(left < 0 || left > 100)) {
+		result = -EIO;
+		goto unlock;
+	}
+	if (snd_BUG_ON(right < 0 || right > 100)) {
+		result = -EIO;
+		goto unlock;
+	}
 	if (result >= 0) {
 		pslot->volume[0] = left;
 		pslot->volume[1] = right;
 	 	result = (left & 0xff) | ((right & 0xff) << 8);
 	}
+ unlock:
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 
@@ -293,6 +312,7 @@ static int snd_mixer_oss_set_volume(stru
 
 	if (mixer == NULL || slot > 30)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	pslot = &mixer->slots[slot];
 	if (left > 100)
 		left = 100;
@@ -303,10 +323,13 @@ static int snd_mixer_oss_set_volume(stru
 	if (pslot->put_volume)
 		result = pslot->put_volume(fmixer, pslot, left, right);
 	if (result < 0)
-		return result;
+		goto unlock;
 	pslot->volume[0] = left;
 	pslot->volume[1] = right;
- 	return (left & 0xff) | ((right & 0xff) << 8);
+	result = (left & 0xff) | ((right & 0xff) << 8);
+ unlock:
+	mutex_lock(&mixer->reg_mutex);
+	return result;
 }
 
 static int snd_mixer_oss_ioctl1(struct snd_mixer_oss_file *fmixer, unsigned int cmd, unsigned long arg)


