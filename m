Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B2911B69A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbfLKQBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731411AbfLKPNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1574E24656;
        Wed, 11 Dec 2019 15:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077204;
        bh=Ur/viyuBEyZ5mqbdrZIIH5xEqPh/48fUizwmkULdx4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaFJuEPcATQr3gajjFdK81T2jXtUe/ZD+k2Z0IwMHQDaLbRTYTcOIpv3XfDTykEj9
         q3tfUDXjFbnIByX5sz9X2/QF743gd5dQOYV26PUqffvcC4DbAJUOGhoept9HbpIyaU
         i0IinKA4rMKJ6ba8TsLurhL1+H60LdBzwR2d1QhA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julia Cartwright <julia@ni.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Tim Sander <tim@krieglstein.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 086/134] watchdog: prevent deferral of watchdogd wakeup on RT
Date:   Wed, 11 Dec 2019 10:11:02 -0500
Message-Id: <20191211151150.19073-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julia Cartwright <julia@ni.com>

[ Upstream commit a19f89335f4bda3d77d991c96583e3e51856acbb ]

When PREEMPT_RT is enabled, all hrtimer expiry functions are
deferred for execution into the context of ksoftirqd unless otherwise
annotated.

Deferring the expiry of the hrtimer used by the watchdog core, however,
is a waste, as the callback does nothing but queue a kthread work item
and wakeup watchdogd.

It's worst then that, too: the deferral through ksoftirqd also means
that for correct behavior a user must adjust the scheduling parameters
of both watchdogd _and_ ksoftirqd, which is unnecessary and has other
side effects (like causing unrelated expiry functions to execute at
potentially elevated priority).

Instead, mark the hrtimer used by the watchdog core as being _HARD to
allow it's execution directly from hardirq context.  The work done in
this expiry function is well-bounded and minimal.

A user still must adjust the scheduling parameters of the watchdogd
to be correct w.r.t. their application needs.

Link: https://lkml.kernel.org/r/0e02d8327aeca344096c246713033887bc490dd7.1538089180.git.julia@ni.com
Cc: Guenter Roeck <linux@roeck-us.net>
Reported-and-tested-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Reported-by: Tim Sander <tim@krieglstein.org>
Signed-off-by: Julia Cartwright <julia@ni.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
[bigeasy: use only HRTIMER_MODE_REL_HARD]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20191105144506.clyadjbvnn7b7b2m@linutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index dbd2ad4c92948..d3acc0a7256ca 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -158,7 +158,8 @@ static inline void watchdog_update_worker(struct watchdog_device *wdd)
 		ktime_t t = watchdog_next_keepalive(wdd);
 
 		if (t > 0)
-			hrtimer_start(&wd_data->timer, t, HRTIMER_MODE_REL);
+			hrtimer_start(&wd_data->timer, t,
+				      HRTIMER_MODE_REL_HARD);
 	} else {
 		hrtimer_cancel(&wd_data->timer);
 	}
@@ -177,7 +178,7 @@ static int __watchdog_ping(struct watchdog_device *wdd)
 	if (ktime_after(earliest_keepalive, now)) {
 		hrtimer_start(&wd_data->timer,
 			      ktime_sub(earliest_keepalive, now),
-			      HRTIMER_MODE_REL);
+			      HRTIMER_MODE_REL_HARD);
 		return 0;
 	}
 
@@ -971,7 +972,7 @@ static int watchdog_cdev_register(struct watchdog_device *wdd, dev_t devno)
 		return -ENODEV;
 
 	kthread_init_work(&wd_data->work, watchdog_ping_work);
-	hrtimer_init(&wd_data->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_init(&wd_data->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_HARD);
 	wd_data->timer.function = watchdog_timer_expired;
 
 	if (wdd->id == 0) {
@@ -1019,7 +1020,8 @@ static int watchdog_cdev_register(struct watchdog_device *wdd, dev_t devno)
 		__module_get(wdd->ops->owner);
 		kref_get(&wd_data->kref);
 		if (handle_boot_enabled)
-			hrtimer_start(&wd_data->timer, 0, HRTIMER_MODE_REL);
+			hrtimer_start(&wd_data->timer, 0,
+				      HRTIMER_MODE_REL_HARD);
 		else
 			pr_info("watchdog%d running and kernel based pre-userspace handler disabled\n",
 				wdd->id);
-- 
2.20.1

