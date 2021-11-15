Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7653345271E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244353AbhKPCQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:16:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237138AbhKORrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CC35632A3;
        Mon, 15 Nov 2021 17:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997400;
        bh=eN137RGl3cvcxNk/R6nNdsoJzwWnc+3Y5seUkbBr64g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxafrK1B6hNWuIQJIgBRUoNlyaWGTQy8l3mwwDiKkx59eKuORocRpb7nGe6YqONmA
         XTXHmtxXWUVlsTwBS97oRBKmG605Lf3wfVPXrTcfwb74aWxlwyH0wSIDV0RJBPc53q
         pV2A8rF1PYQ61wm9ZPa1gYuv44+8avLuajrSahd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9988f17cf72a1045a189@syzkaller.appspotmail.com,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 134/575] ALSA: mixer: oss: Fix racy access to slots
Date:   Mon, 15 Nov 2021 17:57:39 +0100
Message-Id: <20211115165348.340105959@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
@@ -130,11 +130,13 @@ static int snd_mixer_oss_devmask(struct
 
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
 
@@ -146,11 +148,13 @@ static int snd_mixer_oss_stereodevs(stru
 
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
 
@@ -161,6 +165,7 @@ static int snd_mixer_oss_recmask(struct
 
 	if (mixer == NULL)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	if (mixer->put_recsrc && mixer->get_recsrc) {	/* exclusive */
 		result = mixer->mask_recsrc;
 	} else {
@@ -172,6 +177,7 @@ static int snd_mixer_oss_recmask(struct
 				result |= 1 << chn;
 		}
 	}
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 
@@ -182,11 +188,12 @@ static int snd_mixer_oss_get_recsrc(stru
 
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
@@ -201,7 +208,10 @@ static int snd_mixer_oss_get_recsrc(stru
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
@@ -214,6 +224,7 @@ static int snd_mixer_oss_set_recsrc(stru
 
 	if (mixer == NULL)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	if (mixer->get_recsrc && mixer->put_recsrc) {	/* exclusive input */
 		if (recsrc & ~mixer->oss_recsrc)
 			recsrc &= ~mixer->oss_recsrc;
@@ -239,6 +250,7 @@ static int snd_mixer_oss_set_recsrc(stru
 			}
 		}
 	}
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 
@@ -250,6 +262,7 @@ static int snd_mixer_oss_get_volume(stru
 
 	if (mixer == NULL || slot > 30)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	pslot = &mixer->slots[slot];
 	left = pslot->volume[0];
 	right = pslot->volume[1];
@@ -257,15 +270,21 @@ static int snd_mixer_oss_get_volume(stru
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
 
@@ -278,6 +297,7 @@ static int snd_mixer_oss_set_volume(stru
 
 	if (mixer == NULL || slot > 30)
 		return -EIO;
+	mutex_lock(&mixer->reg_mutex);
 	pslot = &mixer->slots[slot];
 	if (left > 100)
 		left = 100;
@@ -288,10 +308,13 @@ static int snd_mixer_oss_set_volume(stru
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


