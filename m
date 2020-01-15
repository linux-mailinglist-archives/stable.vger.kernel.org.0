Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6684C13BD51
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 11:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbgAOKYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 05:24:10 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46714 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729539AbgAOKYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 05:24:10 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1irfqI-0000rf-Dv; Wed, 15 Jan 2020 11:24:06 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id F37D81C0864;
        Wed, 15 Jan 2020 11:24:05 +0100 (CET)
Date:   Wed, 15 Jan 2020 10:24:05 -0000
From:   "tip-bot2 for Stephen Boyd" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/core] alarmtimer: Unregister wakeup source when module get fails
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200109155910.907-2-swboyd@chromium.org>
References: <20200109155910.907-2-swboyd@chromium.org>
MIME-Version: 1.0
Message-ID: <157908384579.396.18418981905772146869.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/core branch of tip:

Commit-ID:     6b6d188aae79a630957aefd88ff5c42af6553ee3
Gitweb:        https://git.kernel.org/tip/6b6d188aae79a630957aefd88ff5c42af6553ee3
Author:        Stephen Boyd <swboyd@chromium.org>
AuthorDate:    Thu, 09 Jan 2020 07:59:07 -08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 15 Jan 2020 11:16:54 +01:00

alarmtimer: Unregister wakeup source when module get fails

The alarmtimer_rtc_add_device() function creates a wakeup source and then
tries to grab a module reference. If that fails the function returns early
with an error code, but fails to remove the wakeup source.

Cleanup this exit path so there is no dangling wakeup source, which is
named 'alarmtime' left allocated which will conflict with another RTC
device that may be registered later.

Fixes: 51218298a25e ("alarmtimer: Ensure RTC module is not unloaded")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200109155910.907-2-swboyd@chromium.org
---
 kernel/time/alarmtimer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index b51b36e..9dc7a09 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -91,6 +91,7 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 	unsigned long flags;
 	struct rtc_device *rtc = to_rtc_device(dev);
 	struct wakeup_source *__ws;
+	int ret = 0;
 
 	if (rtcdev)
 		return -EBUSY;
@@ -105,8 +106,8 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 	spin_lock_irqsave(&rtcdev_lock, flags);
 	if (!rtcdev) {
 		if (!try_module_get(rtc->owner)) {
-			spin_unlock_irqrestore(&rtcdev_lock, flags);
-			return -1;
+			ret = -1;
+			goto unlock;
 		}
 
 		rtcdev = rtc;
@@ -115,11 +116,12 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 		ws = __ws;
 		__ws = NULL;
 	}
+unlock:
 	spin_unlock_irqrestore(&rtcdev_lock, flags);
 
 	wakeup_source_unregister(__ws);
 
-	return 0;
+	return ret;
 }
 
 static inline void alarmtimer_rtc_timer_init(void)
