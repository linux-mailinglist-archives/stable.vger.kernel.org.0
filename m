Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81AE1BAB1B
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438959AbfIVTep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390522AbfIVSrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 798F621479;
        Sun, 22 Sep 2019 18:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178025;
        bh=BMdLIydfr0XqiBTIBaO/y9dLc3t97LMQFjAyQ1K7uX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdVgccMqhKpIDoF0W9+k7YNtIZf96eFjwYFmGkJVagskpsZ1ztepNMEbASFgUvBSa
         pKGeyW3k5oyf9TiQ8vgC0UeXIYfr/juLoy5DK/wftHXV1GRZ54sUrpY+6iPw5zRoU1
         4Fv3G5KbOTC1kZV8xfcwRBDSjTlKOPyITdS8NFAg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 109/203] posix-cpu-timers: Sanitize bogus WARNONS
Date:   Sun, 22 Sep 2019 14:42:15 -0400
Message-Id: <20190922184350.30563-109-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 692117c1f7a6770ed41dd8f277cd9fed1dfb16f1 ]

Warning when p == NULL and then proceeding and dereferencing p does not
make any sense as the kernel will crash with a NULL pointer dereference
right away.

Bailing out when p == NULL and returning an error code does not cure the
underlying problem which caused p to be NULL. Though it might allow to
do proper debugging.

Same applies to the clock id check in set_process_cpu_timer().

Clean them up and make them return without trying to do further damage.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lkml.kernel.org/r/20190819143801.846497772@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-cpu-timers.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 0a426f4e31251..5bbad147a90cf 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -375,7 +375,8 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 	struct sighand_struct *sighand;
 	struct task_struct *p = timer->it.cpu.task;
 
-	WARN_ON_ONCE(p == NULL);
+	if (WARN_ON_ONCE(!p))
+		return -EINVAL;
 
 	/*
 	 * Protect against sighand release/switch in exit/exec and process/
@@ -580,7 +581,8 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int timer_flags,
 	u64 old_expires, new_expires, old_incr, val;
 	int ret;
 
-	WARN_ON_ONCE(p == NULL);
+	if (WARN_ON_ONCE(!p))
+		return -EINVAL;
 
 	/*
 	 * Use the to_ktime conversion because that clamps the maximum
@@ -715,10 +717,11 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int timer_flags,
 
 static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec64 *itp)
 {
-	u64 now;
 	struct task_struct *p = timer->it.cpu.task;
+	u64 now;
 
-	WARN_ON_ONCE(p == NULL);
+	if (WARN_ON_ONCE(!p))
+		return;
 
 	/*
 	 * Easy part: convert the reload time.
@@ -1000,12 +1003,13 @@ static void check_process_timers(struct task_struct *tsk,
  */
 static void posix_cpu_timer_rearm(struct k_itimer *timer)
 {
+	struct task_struct *p = timer->it.cpu.task;
 	struct sighand_struct *sighand;
 	unsigned long flags;
-	struct task_struct *p = timer->it.cpu.task;
 	u64 now;
 
-	WARN_ON_ONCE(p == NULL);
+	if (WARN_ON_ONCE(!p))
+		return;
 
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
@@ -1202,7 +1206,9 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 	u64 now;
 	int ret;
 
-	WARN_ON_ONCE(clock_idx == CPUCLOCK_SCHED);
+	if (WARN_ON_ONCE(clock_idx >= CPUCLOCK_SCHED))
+		return;
+
 	ret = cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval && ret != -EINVAL) {
-- 
2.20.1

