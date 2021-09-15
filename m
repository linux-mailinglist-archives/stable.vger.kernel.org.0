Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A82540C9E2
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 18:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhIOQR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 12:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhIOQR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 12:17:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F41BC061574;
        Wed, 15 Sep 2021 09:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=G27UyJsrbVf8KCKuRCpUnOXbTvnevOaVQgdb3XtruZU=; t=1631722568; x=1632932168; 
        b=F5n/cFfOzaCNU6dOxZWyo1MP0YHU4n17FoZmW/m1an/UxDWNeADfVw9spcomH+OVMWQgkgBMWeO
        xd1OBVZIL6hXKlq6IFkGUs32mN8UhIGC4jIbosmLojbrSnDiZrr0IDdbT6L20wIRbUKZ7Y2PSrgVh
        NN7Ct8tctbOwAFRlbdzOVEWq0QLw9UHQDpCEXi97MxDUBCiiIfbrLmZxlVylXT8qH7iXpmkeeqbqV
        vRiek87mrQ3hax8+Jjd/89EAfj9JcsZPytFtRexvrt1JpR6bWAAmKmQXp6xt7e8g3vjWWsF9cocwJ
        WTnr0Bnh4Oi4tog4fC81euqbt//Rv1srhvIg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mQXZs-007Nae-RW;
        Wed, 15 Sep 2021 18:16:04 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-leds@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: [PATCH] leds: trigger: use RCU to protect the led_cdevs list
Date:   Wed, 15 Sep 2021 18:16:01 +0200
Message-Id: <20210915181601.99a68f5718be.I1a28b342d2d52cdeeeb81ecd6020c25cbf1dbfc0@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

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

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/leds/led-triggers.c | 41 +++++++++++++++++++------------------
 include/linux/leds.h        |  2 +-
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 4e7b78a84149..072491d3e17b 100644
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
index a0b730be40ad..ba4861ec73d3 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -360,7 +360,7 @@ struct led_trigger {
 	struct led_hw_trigger_type *trigger_type;
 
 	/* LEDs under control by this trigger (for simple triggers) */
-	rwlock_t	  leddev_list_lock;
+	spinlock_t	  leddev_list_lock;
 	struct list_head  led_cdevs;
 
 	/* Link to next registered trigger */
-- 
2.31.1

