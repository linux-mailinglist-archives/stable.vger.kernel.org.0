Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8D5CA4F6
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388067AbfJCQ3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390547AbfJCQ3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:29:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94C1C2054F;
        Thu,  3 Oct 2019 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120182;
        bh=BMdLIydfr0XqiBTIBaO/y9dLc3t97LMQFjAyQ1K7uX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doquGy6lREyYAZdlsycJYl/mGB7MbHZvsbzHDvgYBXhPEDbLLGyTV/iJloSRGBbzf
         JH4Qk/svt9/gMIYCaJHUWQl54dHhO/3Zwne1kgf8gKVQxwzjjGZFnrgLpdSJTsuFOw
         9pHH3rnZBMSTIxvXar8d6++Le8GV65/fHadkAFlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 128/313] posix-cpu-timers: Sanitize bogus WARNONS
Date:   Thu,  3 Oct 2019 17:51:46 +0200
Message-Id: <20191003154545.510746818@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



