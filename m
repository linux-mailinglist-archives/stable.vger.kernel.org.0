Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F6044A134
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbhKIBIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:08:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239365AbhKIBGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:06:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11DC261A35;
        Tue,  9 Nov 2021 01:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419763;
        bh=zSOUPnA9u5KD4ziO3B+5rsvYl7bkkjKW7GH8wgdaNUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgqhO2rBkvoINEA4wyeXaChroJxay6x4EO5YeHhBlljn3GVWw1CSODzkKTHlb/Gi1
         AkOq1/CTK0ZCRbhCfJpxOhcf5AXwl3fS48qSQ6TdbA1bI92kJ83rgRF1MQ957CzEd4
         0nPSY9L+tWu5M8iVic22DWRnOLOX2eKfNZJRtHNDIIBdU6gJ3agOriUE3iDy2gnWTg
         nxAovNHbFeySnjwIK5yetinjJlbpo+XAZQr/wVR7EbG8+WCXfaB8fBiQJg7I7QMdau
         fr8LOmUJOZbPNJb9hndxjQmX2kImi/SX81AkAaVsl9ef4ei9Mauc1pq0wPoU3WRtil
         Ij8nnjSvUM4Pw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 029/138] leds: trigger: use RCU to protect the led_cdevs list
Date:   Mon,  8 Nov 2021 12:44:55 -0500
Message-Id: <20211108174644.1187889-29-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2a5a8fa8b23144d14567d6f8293dd6fbeecee393 ]

Even with the previous commit 27af8e2c90fb
("leds: trigger: fix potential deadlock with libata")
to this file, we still get lockdep unhappy, and Boqun
explained the report here:
https://lore.kernel.org/r/YNA+d1X4UkoQ7g8a@boqun-archlinux

Effectively, this means that the read_lock_irqsave() isn't
enough here because another CPU might be trying to do a
write lock, and thus block the readers.

This is all pretty messy, but it doesn't seem right that
the LEDs framework imposes some locking requirements on
users, in particular we'd have to make the spinlock in the
iwlwifi driver always disable IRQs, even if we don't need
that for any other reason, just to avoid this deadlock.

Since writes to the led_cdevs list are rare (and are done
by userspace), just switch the list to RCU. This costs a
synchronize_rcu() at removal time so we can ensure things
are correct, but that seems like a small price to pay for
getting lock-free iterations and no deadlocks (nor any
locking requirements imposed on users.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-triggers.c | 41 +++++++++++++++++++------------------
 include/linux/leds.h        |  2 +-
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 4e7b78a84149b..072491d3e17b0 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -157,7 +157,6 @@ EXPORT_SYMBOL_GPL(led_trigger_read);
 /* Caller must ensure led_cdev->trigger_lock held */
 int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 {
-	unsigned long flags;
 	char *event = NULL;
 	char *envp[2];
 	const char *name;
@@ -171,10 +170,13 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 
 	/* Remove any existing trigger */
 	if (led_cdev->trigger) {
-		write_lock_irqsave(&led_cdev->trigger->leddev_list_lock, flags);
-		list_del(&led_cdev->trig_list);
-		write_unlock_irqrestore(&led_cdev->trigger->leddev_list_lock,
-			flags);
+		spin_lock(&led_cdev->trigger->leddev_list_lock);
+		list_del_rcu(&led_cdev->trig_list);
+		spin_unlock(&led_cdev->trigger->leddev_list_lock);
+
+		/* ensure it's no longer visible on the led_cdevs list */
+		synchronize_rcu();
+
 		cancel_work_sync(&led_cdev->set_brightness_work);
 		led_stop_software_blink(led_cdev);
 		if (led_cdev->trigger->deactivate)
@@ -186,9 +188,9 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 		led_set_brightness(led_cdev, LED_OFF);
 	}
 	if (trig) {
-		write_lock_irqsave(&trig->leddev_list_lock, flags);
-		list_add_tail(&led_cdev->trig_list, &trig->led_cdevs);
-		write_unlock_irqrestore(&trig->leddev_list_lock, flags);
+		spin_lock(&trig->leddev_list_lock);
+		list_add_tail_rcu(&led_cdev->trig_list, &trig->led_cdevs);
+		spin_unlock(&trig->leddev_list_lock);
 		led_cdev->trigger = trig;
 
 		if (trig->activate)
@@ -223,9 +225,10 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 		trig->deactivate(led_cdev);
 err_activate:
 
-	write_lock_irqsave(&led_cdev->trigger->leddev_list_lock, flags);
-	list_del(&led_cdev->trig_list);
-	write_unlock_irqrestore(&led_cdev->trigger->leddev_list_lock, flags);
+	spin_lock(&led_cdev->trigger->leddev_list_lock);
+	list_del_rcu(&led_cdev->trig_list);
+	spin_unlock(&led_cdev->trigger->leddev_list_lock);
+	synchronize_rcu();
 	led_cdev->trigger = NULL;
 	led_cdev->trigger_data = NULL;
 	led_set_brightness(led_cdev, LED_OFF);
@@ -285,7 +288,7 @@ int led_trigger_register(struct led_trigger *trig)
 	struct led_classdev *led_cdev;
 	struct led_trigger *_trig;
 
-	rwlock_init(&trig->leddev_list_lock);
+	spin_lock_init(&trig->leddev_list_lock);
 	INIT_LIST_HEAD(&trig->led_cdevs);
 
 	down_write(&triggers_list_lock);
@@ -378,15 +381,14 @@ void led_trigger_event(struct led_trigger *trig,
 			enum led_brightness brightness)
 {
 	struct led_classdev *led_cdev;
-	unsigned long flags;
 
 	if (!trig)
 		return;
 
-	read_lock_irqsave(&trig->leddev_list_lock, flags);
-	list_for_each_entry(led_cdev, &trig->led_cdevs, trig_list)
+	rcu_read_lock();
+	list_for_each_entry_rcu(led_cdev, &trig->led_cdevs, trig_list)
 		led_set_brightness(led_cdev, brightness);
-	read_unlock_irqrestore(&trig->leddev_list_lock, flags);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(led_trigger_event);
 
@@ -397,20 +399,19 @@ static void led_trigger_blink_setup(struct led_trigger *trig,
 			     int invert)
 {
 	struct led_classdev *led_cdev;
-	unsigned long flags;
 
 	if (!trig)
 		return;
 
-	read_lock_irqsave(&trig->leddev_list_lock, flags);
-	list_for_each_entry(led_cdev, &trig->led_cdevs, trig_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(led_cdev, &trig->led_cdevs, trig_list) {
 		if (oneshot)
 			led_blink_set_oneshot(led_cdev, delay_on, delay_off,
 					      invert);
 		else
 			led_blink_set(led_cdev, delay_on, delay_off);
 	}
-	read_unlock_irqrestore(&trig->leddev_list_lock, flags);
+	rcu_read_unlock();
 }
 
 void led_trigger_blink(struct led_trigger *trig,
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 329fd914cf243..fa59326b0ad9f 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -354,7 +354,7 @@ struct led_trigger {
 	struct led_hw_trigger_type *trigger_type;
 
 	/* LEDs under control by this trigger (for simple triggers) */
-	rwlock_t	  leddev_list_lock;
+	spinlock_t	  leddev_list_lock;
 	struct list_head  led_cdevs;
 
 	/* Link to next registered trigger */
-- 
2.33.0

