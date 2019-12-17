Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88558122098
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLQAvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35070 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726931AbfLQAvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003MU-KT; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0005cC-9F; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Iwai" <tiwai@suse.de>
Date:   Tue, 17 Dec 2019 00:47:24 +0000
Message-ID: <lsq.1576543535.963027911@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 110/136] ALSA: timer: Fix mutex deadlock at releasing
 card
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

commit a39331867335d4a94b6165e306265c9e24aca073 upstream.

When a card is disconnected while in use, the system waits until all
opened files are closed then releases the card.  This is done via
put_device() of the card device in each device release code.

The recently reported mutex deadlock bug happens in this code path;
snd_timer_close() for the timer device deals with the global
register_mutex and it calls put_device() there.  When this timer
device is the last one, the card gets freed and it eventually calls
snd_timer_free(), which has again the protection with the global
register_mutex -- boom.

Basically put_device() call itself is race-free, so a relative simple
workaround is to move this put_device() call out of the mutex.  For
achieving that, in this patch, snd_timer_close_locked() got a new
argument to store the card device pointer in return, and each caller
invokes put_device() with the returned object after the mutex unlock.

Reported-and-tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/timer.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -241,7 +241,8 @@ static int snd_timer_check_master(struct
 	return 0;
 }
 
-static int snd_timer_close_locked(struct snd_timer_instance *timeri);
+static int snd_timer_close_locked(struct snd_timer_instance *timeri,
+				  struct device **card_devp_to_put);
 
 /*
  * open a timer instance
@@ -253,6 +254,7 @@ int snd_timer_open(struct snd_timer_inst
 {
 	struct snd_timer *timer;
 	struct snd_timer_instance *timeri = NULL;
+	struct device *card_dev_to_put = NULL;
 	int err;
 
 	mutex_lock(&register_mutex);
@@ -276,7 +278,7 @@ int snd_timer_open(struct snd_timer_inst
 		list_add_tail(&timeri->open_list, &snd_timer_slave_list);
 		err = snd_timer_check_slave(timeri);
 		if (err < 0) {
-			snd_timer_close_locked(timeri);
+			snd_timer_close_locked(timeri, &card_dev_to_put);
 			timeri = NULL;
 		}
 		goto unlock;
@@ -328,7 +330,7 @@ int snd_timer_open(struct snd_timer_inst
 			timeri = NULL;
 
 			if (timer->card)
-				put_device(&timer->card->card_dev);
+				card_dev_to_put = &timer->card->card_dev;
 			module_put(timer->module);
 			goto unlock;
 		}
@@ -338,12 +340,15 @@ int snd_timer_open(struct snd_timer_inst
 	timer->num_instances++;
 	err = snd_timer_check_master(timeri);
 	if (err < 0) {
-		snd_timer_close_locked(timeri);
+		snd_timer_close_locked(timeri, &card_dev_to_put);
 		timeri = NULL;
 	}
 
  unlock:
 	mutex_unlock(&register_mutex);
+	/* put_device() is called after unlock for avoiding deadlock */
+	if (card_dev_to_put)
+		put_device(card_dev_to_put);
 	*ti = timeri;
 	return err;
 }
@@ -352,7 +357,8 @@ int snd_timer_open(struct snd_timer_inst
  * close a timer instance
  * call this with register_mutex down.
  */
-static int snd_timer_close_locked(struct snd_timer_instance *timeri)
+static int snd_timer_close_locked(struct snd_timer_instance *timeri,
+				  struct device **card_devp_to_put)
 {
 	struct snd_timer *timer = NULL;
 	struct snd_timer_instance *slave, *tmp;
@@ -404,7 +410,7 @@ static int snd_timer_close_locked(struct
 			timer->hw.close(timer);
 		/* release a card refcount for safe disconnection */
 		if (timer->card)
-			put_device(&timer->card->card_dev);
+			*card_devp_to_put = &timer->card->card_dev;
 		module_put(timer->module);
 	}
 
@@ -416,14 +422,18 @@ static int snd_timer_close_locked(struct
  */
 int snd_timer_close(struct snd_timer_instance *timeri)
 {
+	struct device *card_dev_to_put = NULL;
 	int err;
 
 	if (snd_BUG_ON(!timeri))
 		return -ENXIO;
 
 	mutex_lock(&register_mutex);
-	err = snd_timer_close_locked(timeri);
+	err = snd_timer_close_locked(timeri, &card_dev_to_put);
 	mutex_unlock(&register_mutex);
+	/* put_device() is called after unlock for avoiding deadlock */
+	if (card_dev_to_put)
+		put_device(card_dev_to_put);
 	return err;
 }
 

