Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92CB8EF007
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388665AbfKDWZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730627AbfKDVvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:51:52 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C6832053B;
        Mon,  4 Nov 2019 21:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904310;
        bh=9O/v+1/bywBKN63pqCoNkkXzmZ9XNOTcftS8wLfD++I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmG1uNYGQdxUkDQAhWvjTIg1Kvl6e/Uoknw/2ZqCyba8l/Ijlh6rRI1IPl66IbhPQ
         TyV4NOjsDYqIUDQi4ZK3hc21q4/9CNKPcam+l2cgkD7PXPSeRy2YNCFQDNbr08nSXX
         aJKQ8ODMWCVKj6EtmeZp4Xo1cweRz0FQyYeNI27g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 60/62] ALSA: timer: Limit max instances per timer
Date:   Mon,  4 Nov 2019 22:45:22 +0100
Message-Id: <20191104212000.057001996@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9b7d869ee5a77ed4a462372bb89af622e705bfb8 ]

Currently we allow unlimited number of timer instances, and it may
bring the system hogging way too much CPU when too many timer
instances are opened and processed concurrently.  This may end up with
a soft-lockup report as triggered by syzkaller, especially when
hrtimer backend is deployed.

Since such insane number of instances aren't demanded by the normal
use case of ALSA sequencer and it merely  opens a risk only for abuse,
this patch introduces the upper limit for the number of instances per
timer backend.  As default, it's set to 1000, but for the fine-grained
timer like hrtimer, it's set to 100.

Reported-by: syzbot
Tested-by: Jérôme Glisse <jglisse@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/timer.h |  2 ++
 sound/core/hrtimer.c  |  1 +
 sound/core/timer.c    | 67 ++++++++++++++++++++++++++++++++++---------
 3 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/include/sound/timer.h b/include/sound/timer.h
index c4d76ff056c6e..7ae226ab69908 100644
--- a/include/sound/timer.h
+++ b/include/sound/timer.h
@@ -90,6 +90,8 @@ struct snd_timer {
 	struct list_head ack_list_head;
 	struct list_head sack_list_head; /* slow ack list head */
 	struct tasklet_struct task_queue;
+	int max_instances;	/* upper limit of timer instances */
+	int num_instances;	/* current number of timer instances */
 };
 
 struct snd_timer_instance {
diff --git a/sound/core/hrtimer.c b/sound/core/hrtimer.c
index e2f27022b363c..d7dddb75e7bb8 100644
--- a/sound/core/hrtimer.c
+++ b/sound/core/hrtimer.c
@@ -159,6 +159,7 @@ static int __init snd_hrtimer_init(void)
 	timer->hw = hrtimer_hw;
 	timer->hw.resolution = resolution;
 	timer->hw.ticks = NANO_SEC / resolution;
+	timer->max_instances = 100; /* lower the limit */
 
 	err = snd_timer_global_register(timer);
 	if (err < 0) {
diff --git a/sound/core/timer.c b/sound/core/timer.c
index cfcc6718aafce..95c5838747754 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -179,7 +179,7 @@ static void snd_timer_request(struct snd_timer_id *tid)
  *
  * call this with register_mutex down.
  */
-static void snd_timer_check_slave(struct snd_timer_instance *slave)
+static int snd_timer_check_slave(struct snd_timer_instance *slave)
 {
 	struct snd_timer *timer;
 	struct snd_timer_instance *master;
@@ -189,16 +189,21 @@ static void snd_timer_check_slave(struct snd_timer_instance *slave)
 		list_for_each_entry(master, &timer->open_list_head, open_list) {
 			if (slave->slave_class == master->slave_class &&
 			    slave->slave_id == master->slave_id) {
+				if (master->timer->num_instances >=
+				    master->timer->max_instances)
+					return -EBUSY;
 				list_move_tail(&slave->open_list,
 					       &master->slave_list_head);
+				master->timer->num_instances++;
 				spin_lock_irq(&slave_active_lock);
 				slave->master = master;
 				slave->timer = master->timer;
 				spin_unlock_irq(&slave_active_lock);
-				return;
+				return 0;
 			}
 		}
 	}
+	return 0;
 }
 
 /*
@@ -207,7 +212,7 @@ static void snd_timer_check_slave(struct snd_timer_instance *slave)
  *
  * call this with register_mutex down.
  */
-static void snd_timer_check_master(struct snd_timer_instance *master)
+static int snd_timer_check_master(struct snd_timer_instance *master)
 {
 	struct snd_timer_instance *slave, *tmp;
 
@@ -215,7 +220,11 @@ static void snd_timer_check_master(struct snd_timer_instance *master)
 	list_for_each_entry_safe(slave, tmp, &snd_timer_slave_list, open_list) {
 		if (slave->slave_class == master->slave_class &&
 		    slave->slave_id == master->slave_id) {
+			if (master->timer->num_instances >=
+			    master->timer->max_instances)
+				return -EBUSY;
 			list_move_tail(&slave->open_list, &master->slave_list_head);
+			master->timer->num_instances++;
 			spin_lock_irq(&slave_active_lock);
 			spin_lock(&master->timer->lock);
 			slave->master = master;
@@ -227,8 +236,11 @@ static void snd_timer_check_master(struct snd_timer_instance *master)
 			spin_unlock_irq(&slave_active_lock);
 		}
 	}
+	return 0;
 }
 
+static int snd_timer_close_locked(struct snd_timer_instance *timeri);
+
 /*
  * open a timer instance
  * when opening a master, the slave id must be here given.
@@ -239,6 +251,7 @@ int snd_timer_open(struct snd_timer_instance **ti,
 {
 	struct snd_timer *timer;
 	struct snd_timer_instance *timeri = NULL;
+	int err;
 
 	if (tid->dev_class == SNDRV_TIMER_CLASS_SLAVE) {
 		/* open a slave instance */
@@ -258,10 +271,14 @@ int snd_timer_open(struct snd_timer_instance **ti,
 		timeri->slave_id = tid->device;
 		timeri->flags |= SNDRV_TIMER_IFLG_SLAVE;
 		list_add_tail(&timeri->open_list, &snd_timer_slave_list);
-		snd_timer_check_slave(timeri);
+		err = snd_timer_check_slave(timeri);
+		if (err < 0) {
+			snd_timer_close_locked(timeri);
+			timeri = NULL;
+		}
 		mutex_unlock(&register_mutex);
 		*ti = timeri;
-		return 0;
+		return err;
 	}
 
 	/* open a master instance */
@@ -287,6 +304,10 @@ int snd_timer_open(struct snd_timer_instance **ti,
 			return -EBUSY;
 		}
 	}
+	if (timer->num_instances >= timer->max_instances) {
+		mutex_unlock(&register_mutex);
+		return -EBUSY;
+	}
 	timeri = snd_timer_instance_new(owner, timer);
 	if (!timeri) {
 		mutex_unlock(&register_mutex);
@@ -313,25 +334,27 @@ int snd_timer_open(struct snd_timer_instance **ti,
 	}
 
 	list_add_tail(&timeri->open_list, &timer->open_list_head);
-	snd_timer_check_master(timeri);
+	timer->num_instances++;
+	err = snd_timer_check_master(timeri);
+	if (err < 0) {
+		snd_timer_close_locked(timeri);
+		timeri = NULL;
+	}
 	mutex_unlock(&register_mutex);
 	*ti = timeri;
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(snd_timer_open);
 
 /*
  * close a timer instance
+ * call this with register_mutex down.
  */
-int snd_timer_close(struct snd_timer_instance *timeri)
+static int snd_timer_close_locked(struct snd_timer_instance *timeri)
 {
 	struct snd_timer *timer = NULL;
 	struct snd_timer_instance *slave, *tmp;
 
-	if (snd_BUG_ON(!timeri))
-		return -ENXIO;
-
-	mutex_lock(&register_mutex);
 	list_del(&timeri->open_list);
 
 	/* force to stop the timer */
@@ -339,6 +362,7 @@ int snd_timer_close(struct snd_timer_instance *timeri)
 
 	timer = timeri->timer;
 	if (timer) {
+		timer->num_instances--;
 		/* wait, until the active callback is finished */
 		spin_lock_irq(&timer->lock);
 		while (timeri->flags & SNDRV_TIMER_IFLG_CALLBACK) {
@@ -354,6 +378,7 @@ int snd_timer_close(struct snd_timer_instance *timeri)
 		list_for_each_entry_safe(slave, tmp, &timeri->slave_list_head,
 					 open_list) {
 			list_move_tail(&slave->open_list, &snd_timer_slave_list);
+			timer->num_instances--;
 			slave->master = NULL;
 			slave->timer = NULL;
 			list_del_init(&slave->ack_list);
@@ -381,9 +406,24 @@ int snd_timer_close(struct snd_timer_instance *timeri)
 		module_put(timer->module);
 	}
 
-	mutex_unlock(&register_mutex);
 	return 0;
 }
+
+/*
+ * close a timer instance
+ */
+int snd_timer_close(struct snd_timer_instance *timeri)
+{
+	int err;
+
+	if (snd_BUG_ON(!timeri))
+		return -ENXIO;
+
+	mutex_lock(&register_mutex);
+	err = snd_timer_close_locked(timeri);
+	mutex_unlock(&register_mutex);
+	return err;
+}
 EXPORT_SYMBOL(snd_timer_close);
 
 unsigned long snd_timer_resolution(struct snd_timer_instance *timeri)
@@ -854,6 +894,7 @@ int snd_timer_new(struct snd_card *card, char *id, struct snd_timer_id *tid,
 	spin_lock_init(&timer->lock);
 	tasklet_init(&timer->task_queue, snd_timer_tasklet,
 		     (unsigned long)timer);
+	timer->max_instances = 1000; /* default limit per timer */
 	if (card != NULL) {
 		timer->module = card->module;
 		err = snd_device_new(card, SNDRV_DEV_TIMER, timer, &ops);
-- 
2.20.1



