Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A02103F38
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732127AbfKTPlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:41:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52978 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731819AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5X-0004cx-Ds; Wed, 20 Nov 2019 15:40:15 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004Ni-Fc; Wed, 20 Nov 2019 15:40:13 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Petr Vorel" <pvorel@suse.cz>,
        "Thadeu Lima de Souza Cascardo" <cascardo@canonical.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Wed, 20 Nov 2019 15:38:27 +0000
Message-ID: <lsq.1574264230.686973857@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 77/83] alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit f18ddc13af981ce3c7b7f26925f099e7c6929aba upstream.

ENOTSUPP is not supposed to be returned to userspace. This was found on an
OpenPower machine, where the RTC does not support set_alarm.

On that system, a clock_nanosleep(CLOCK_REALTIME_ALARM, ...) results in
"524 Unknown error 524"

Replace it with EOPNOTSUPP which results in the expected "95 Operation not
supported" error.

Fixes: 1c6b39ad3f01 (alarmtimers: Return -ENOTSUPP if no RTC device is present)
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190903171802.28314-1-cascardo@canonical.com
[ pvorel: backport for v3.16, changes also in alarm_timer_{del,set}(), which
were removed in f2c45807d3992fe0f173f34af9c347d907c31686 in v4.13-rc1 ]
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/alarmtimer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -533,7 +533,7 @@ static int alarm_timer_create(struct k_i
 	struct alarm_base *base;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
@@ -576,7 +576,7 @@ static void alarm_timer_get(struct k_iti
 static int alarm_timer_del(struct k_itimer *timr)
 {
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
 		return TIMER_RETRY;
@@ -600,7 +600,7 @@ static int alarm_timer_set(struct k_itim
 	ktime_t exp;
 
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (flags & ~TIMER_ABSTIME)
 		return -EINVAL;
@@ -761,7 +761,7 @@ static int alarm_timer_nsleep(const cloc
 	struct restart_block *restart;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (flags & ~TIMER_ABSTIME)
 		return -EINVAL;

