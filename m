Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA02A44F336
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhKMNKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:10:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231555AbhKMNKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 08:10:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB0CA60F46;
        Sat, 13 Nov 2021 13:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636808867;
        bh=yDf128NDVlIa+Ejbv3C1VjglodUKaq7xVbIsOF3aI8U=;
        h=Subject:To:Cc:From:Date:From;
        b=h93jvjWqk8I0rgTAbbs1XJjs5fi7A/AKDCUUxzVQPp1i4KJ6nUIofLLaLB6nqj4cv
         cZmJ2wqIQlwFZUOMUcFVZIhZ47n1x9YQ5OzWoHFrPe7IZuR89dU9cBAAbPvGQzSrzN
         sj03RPLqTRoAN/W1a7iUTc58DXU9YP1kUjuJIOX8=
Subject: FAILED: patch "[PATCH] ALSA: mixer: oss: Fix racy access to slots" failed to apply to 4.19-stable tree
To:     tiwai@suse.de, perex@perex.cz, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 14:07:36 +0100
Message-ID: <163680885624242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 411cef6adfb38a5bb6bd9af3941b28198e7fb680 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 20 Oct 2021 18:48:46 +0200
Subject: [PATCH] ALSA: mixer: oss: Fix racy access to slots

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

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 6a5abdd4271b..d5ddc154a735 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -130,11 +130,13 @@ static int snd_mixer_oss_devmask(struct snd_mixer_oss_file *fmixer)
 
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
 
@@ -146,11 +148,13 @@ static int snd_mixer_oss_stereodevs(struct snd_mixer_oss_file *fmixer)
 
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
 
@@ -161,6 +165,7 @@ static int snd_mixer_oss_recmask(struct snd_mixer_oss_file *fmixer)
 
 	if (mixer == NULL)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	if (mixer->put_recsrc && mixer->get_recsrc) {	/* exclusive */
 		result = mixer->mask_recsrc;
 	} else {
@@ -172,6 +177,7 @@ static int snd_mixer_oss_recmask(struct snd_mixer_oss_file *fmixer)
 				result |= 1 << chn;
 		}
 	}
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 
@@ -182,12 +188,12 @@ static int snd_mixer_oss_get_recsrc(struct snd_mixer_oss_file *fmixer)
 
 	if (mixer == NULL)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	if (mixer->put_recsrc && mixer->get_recsrc) {	/* exclusive */
-		int err;
 		unsigned int index;
-		err = mixer->get_recsrc(fmixer, &index);
-		if (err < 0)
-			return err;
+		result = mixer->get_recsrc(fmixer, &index);
+		if (result < 0)
+			goto unlock;
 		result = 1 << index;
 	} else {
 		struct snd_mixer_oss_slot *pslot;
@@ -202,7 +208,10 @@ static int snd_mixer_oss_get_recsrc(struct snd_mixer_oss_file *fmixer)
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
@@ -215,6 +224,7 @@ static int snd_mixer_oss_set_recsrc(struct snd_mixer_oss_file *fmixer, int recsr
 
 	if (mixer == NULL)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	if (mixer->get_recsrc && mixer->put_recsrc) {	/* exclusive input */
 		if (recsrc & ~mixer->oss_recsrc)
 			recsrc &= ~mixer->oss_recsrc;
@@ -240,6 +250,7 @@ static int snd_mixer_oss_set_recsrc(struct snd_mixer_oss_file *fmixer, int recsr
 			}
 		}
 	}
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 
@@ -251,6 +262,7 @@ static int snd_mixer_oss_get_volume(struct snd_mixer_oss_file *fmixer, int slot)
 
 	if (mixer == NULL || slot > 30)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	pslot = &mixer->slots[slot];
 	left = pslot->volume[0];
 	right = pslot->volume[1];
@@ -258,15 +270,21 @@ static int snd_mixer_oss_get_volume(struct snd_mixer_oss_file *fmixer, int slot)
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
 
@@ -279,6 +297,7 @@ static int snd_mixer_oss_set_volume(struct snd_mixer_oss_file *fmixer,
 
 	if (mixer == NULL || slot > 30)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	pslot = &mixer->slots[slot];
 	if (left > 100)
 		left = 100;
@@ -289,10 +308,13 @@ static int snd_mixer_oss_set_volume(struct snd_mixer_oss_file *fmixer,
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

