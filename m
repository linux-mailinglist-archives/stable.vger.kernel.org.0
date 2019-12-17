Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E1012207E
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfLQAzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:55:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35328 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727056AbfLQAvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003Mm-1T; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0005c0-5C; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Iwai" <tiwai@suse.de>
Date:   Tue, 17 Dec 2019 00:47:22 +0000
Message-ID: <lsq.1576543535.26422639@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 108/136] ALSA: timer: Simplify error path in
 snd_timer_open()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 41672c0c24a62699d20aab53b98d843b16483053 upstream.

Just a minor refactoring to use the standard goto for error paths in
snd_timer_open() instead of open code.  The first mutex_lock() is
moved to the beginning of the function to make the code clearer.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.16 as dependency of commit a39331867335
 "ALSA: timer: Fix mutex deadlock at releasing card"]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/timer.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -255,19 +255,20 @@ int snd_timer_open(struct snd_timer_inst
 	struct snd_timer_instance *timeri = NULL;
 	int err;
 
+	mutex_lock(&register_mutex);
 	if (tid->dev_class == SNDRV_TIMER_CLASS_SLAVE) {
 		/* open a slave instance */
 		if (tid->dev_sclass <= SNDRV_TIMER_SCLASS_NONE ||
 		    tid->dev_sclass > SNDRV_TIMER_SCLASS_OSS_SEQUENCER) {
 			pr_debug("ALSA: timer: invalid slave class %i\n",
 				 tid->dev_sclass);
-			return -EINVAL;
+			err = -EINVAL;
+			goto unlock;
 		}
-		mutex_lock(&register_mutex);
 		timeri = snd_timer_instance_new(owner, NULL);
 		if (!timeri) {
-			mutex_unlock(&register_mutex);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto unlock;
 		}
 		timeri->slave_class = tid->dev_sclass;
 		timeri->slave_id = tid->device;
@@ -278,13 +279,10 @@ int snd_timer_open(struct snd_timer_inst
 			snd_timer_close_locked(timeri);
 			timeri = NULL;
 		}
-		mutex_unlock(&register_mutex);
-		*ti = timeri;
-		return err;
+		goto unlock;
 	}
 
 	/* open a master instance */
-	mutex_lock(&register_mutex);
 	timer = snd_timer_find(tid);
 #ifdef CONFIG_MODULES
 	if (!timer) {
@@ -295,25 +293,26 @@ int snd_timer_open(struct snd_timer_inst
 	}
 #endif
 	if (!timer) {
-		mutex_unlock(&register_mutex);
-		return -ENODEV;
+		err = -ENODEV;
+		goto unlock;
 	}
 	if (!list_empty(&timer->open_list_head)) {
 		timeri = list_entry(timer->open_list_head.next,
 				    struct snd_timer_instance, open_list);
 		if (timeri->flags & SNDRV_TIMER_IFLG_EXCLUSIVE) {
-			mutex_unlock(&register_mutex);
-			return -EBUSY;
+			err = -EBUSY;
+			timeri = NULL;
+			goto unlock;
 		}
 	}
 	if (timer->num_instances >= timer->max_instances) {
-		mutex_unlock(&register_mutex);
-		return -EBUSY;
+		err = -EBUSY;
+		goto unlock;
 	}
 	timeri = snd_timer_instance_new(owner, timer);
 	if (!timeri) {
-		mutex_unlock(&register_mutex);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto unlock;
 	}
 	/* take a card refcount for safe disconnection */
 	if (timer->card)
@@ -322,16 +321,16 @@ int snd_timer_open(struct snd_timer_inst
 	timeri->slave_id = slave_id;
 
 	if (list_empty(&timer->open_list_head) && timer->hw.open) {
-		int err = timer->hw.open(timer);
+		err = timer->hw.open(timer);
 		if (err) {
 			kfree(timeri->owner);
 			kfree(timeri);
+			timeri = NULL;
 
 			if (timer->card)
 				put_device(&timer->card->card_dev);
 			module_put(timer->module);
-			mutex_unlock(&register_mutex);
-			return err;
+			goto unlock;
 		}
 	}
 
@@ -342,6 +341,8 @@ int snd_timer_open(struct snd_timer_inst
 		snd_timer_close_locked(timeri);
 		timeri = NULL;
 	}
+
+ unlock:
 	mutex_unlock(&register_mutex);
 	*ti = timeri;
 	return err;

