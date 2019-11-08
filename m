Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A42F5043
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 16:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfKHPym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 10:54:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:39836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726095AbfKHPyl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 10:54:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 45265AD26;
        Fri,  8 Nov 2019 15:54:40 +0000 (UTC)
From:   Petr Vorel <pvorel@suse.cz>
To:     stable@vger.kernel.org
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Petr Vorel <pvorel@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH v3.16] alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP
Date:   Fri,  8 Nov 2019 16:54:11 +0100
Message-Id: <20191108155411.13306-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

ENOTSUPP is not supposed to be returned to userspace. This was found on an
OpenPower machine, where the RTC does not support set_alarm.

On that system, a clock_nanosleep(CLOCK_REALTIME_ALARM, ...) results in
"524 Unknown error 524"

Replace it with EOPNOTSUPP which results in the expected "95 Operation not
supported" error.

Fixes: 1c6b39ad3f01 (alarmtimers: Return -ENOTSUPP if no RTC device is present)
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ pvorel: backport for v3.16, changes also in alarm_timer_{del,set}(), which
were removed in f2c45807d3992fe0f173f34af9c347d907c31686 in v4.13-rc1 ]
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Cc: stable@vger.kernel.org # v3.16
Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Link: https://lkml.kernel.org/r/20190903171802.28314-1-cascardo@canonical.com
---
 kernel/time/alarmtimer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 8c65c236f26a..c3fc69986850 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -533,7 +533,7 @@ static int alarm_timer_create(struct k_itimer *new_timer)
 	struct alarm_base *base;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
@@ -576,7 +576,7 @@ static void alarm_timer_get(struct k_itimer *timr,
 static int alarm_timer_del(struct k_itimer *timr)
 {
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
 		return TIMER_RETRY;
@@ -600,7 +600,7 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 	ktime_t exp;
 
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (flags & ~TIMER_ABSTIME)
 		return -EINVAL;
@@ -761,7 +761,7 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 	struct restart_block *restart;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (flags & ~TIMER_ABSTIME)
 		return -EINVAL;
