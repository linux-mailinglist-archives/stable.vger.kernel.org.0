Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96F1F503C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 16:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfKHPxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 10:53:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:38540 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbfKHPxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 10:53:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 883CCB1C2
        for <stable@vger.kernel.org>; Fri,  8 Nov 2019 15:53:22 +0000 (UTC)
From:   Petr Vorel <pvorel@suse.cz>
To:     stable@vger.kernel.org
Cc:     Petr Vorel <pvorel@suse.cz>
Subject: [PATCH] Fix backport of f18ddc13af981ce3c7b7f26925f099e7c6929aba
Date:   Fri,  8 Nov 2019 16:53:16 +0100
Message-Id: <20191108155316.13109-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

for v4.4 and v4.9 stable branches

Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
Hi,

Patch for stable-queue.git of previously sent 2 patches, if needed.

Kind regards,
Petr

 ...armtimer-use-eopnotsupp-instead-of-enotsupp.patch | 20 +++++++++++++++++++-
 ...armtimer-use-eopnotsupp-instead-of-enotsupp.patch | 20 +++++++++++++++++++-
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/releases/4.4.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch b/releases/4.4.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
index 6e1622d11..64864792b 100644
--- a/releases/4.4.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
+++ b/releases/4.4.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
@@ -38,7 +38,25 @@ Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
  
  	if (!capable(CAP_WAKE_ALARM))
  		return -EPERM;
-@@ -759,7 +759,7 @@ static int alarm_timer_nsleep(const cloc
+@@ -573,7 +573,7 @@ static void alarm_timer_get(struct k_itimer *timr,
+ static int alarm_timer_del(struct k_itimer *timr)
+ {
+ 	if (!rtcdev)
+-		return -ENOTSUPP;
++		return -EOPNOTSUPP;
+ 
+ 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
+ 		return TIMER_RETRY;
+@@ -597,7 +597,7 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
+ 	ktime_t exp;
+ 
+ 	if (!rtcdev)
+-		return -ENOTSUPP;
++		return -EOPNOTSUPP;
+ 
+ 	if (flags & ~TIMER_ABSTIME)
+ 		return -EINVAL;
+@@ -759,7 +759,7 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
  	struct restart_block *restart;
  
  	if (!alarmtimer_get_rtcdev())
diff --git a/releases/4.9.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch b/releases/4.9.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
index 1c783e622..f6af42535 100644
--- a/releases/4.9.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
+++ b/releases/4.9.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
@@ -38,7 +38,25 @@ Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
  
  	if (!capable(CAP_WAKE_ALARM))
  		return -EPERM;
-@@ -772,7 +772,7 @@ static int alarm_timer_nsleep(const cloc
+@@ -586,7 +586,7 @@ static void alarm_timer_get(struct k_itimer *timr,
+ static int alarm_timer_del(struct k_itimer *timr)
+ {
+ 	if (!rtcdev)
+-		return -ENOTSUPP;
++		return -EOPNOTSUPP;
+ 
+ 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
+ 		return TIMER_RETRY;
+@@ -610,7 +610,7 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
+ 	ktime_t exp;
+ 
+ 	if (!rtcdev)
+-		return -ENOTSUPP;
++		return -EOPNOTSUPP;
+ 
+ 	if (flags & ~TIMER_ABSTIME)
+ 		return -EINVAL;
+@@ -772,7 +772,7 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
  	struct restart_block *restart;
  
  	if (!alarmtimer_get_rtcdev())
-- 
2.16.4

