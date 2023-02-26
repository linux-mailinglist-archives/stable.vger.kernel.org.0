Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EA06A31EF
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjBZPKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjBZPKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:10:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C42B24105;
        Sun, 26 Feb 2023 07:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB099B8068F;
        Sun, 26 Feb 2023 14:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F463C433EF;
        Sun, 26 Feb 2023 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422947;
        bh=VYstTmlkaqrzYzeHNhh9gQybj9/njulm8D0PiKE12hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bw1uiC9CAOdw68BBMlJXmoTXTyB3thjdG9ATp50Q1esMnO2uQfMmVfgngmVePZyJh
         Dv4hFh7SAoYL9US1HVc/fgWPBV9UrzuMJkWRrTYjHwAKD/uKVKV4ZkkzBen4MkapJu
         HP0DBcpOZXWQ/XkhOjfhjsixBHTq875ZKxhbJM9rpCwRRdQphcbGeCIEvZnyiNzimw
         Wkpm1bJltL9QQX6GkcYsj40SMFvpW0JWv5THZ76vhfMpiQeERVGkqgqBy8YImVRtN7
         krdUgsLGfZU/KVGA8BBnjFWIdydILd58tDAaDfTG/fhSRNh9UvwUvf819aoKncterx
         k3j5hMXk2Dtcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org
Subject: [PATCH AUTOSEL 5.15 08/36] timers: Prevent union confusion from unexpected restart_syscall()
Date:   Sun, 26 Feb 2023 09:48:16 -0500
Message-Id: <20230226144845.827893-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144845.827893-1-sashal@kernel.org>
References: <20230226144845.827893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit 9f76d59173d9d146e96c66886b671c1915a5c5e5 ]

The nanosleep syscalls use the restart_block mechanism, with a quirk:
The `type` and `rmtp`/`compat_rmtp` fields are set up unconditionally on
syscall entry, while the rest of the restart_block is only set up in the
unlikely case that the syscall is actually interrupted by a signal (or
pseudo-signal) that doesn't have a signal handler.

If the restart_block was set up by a previous syscall (futex(...,
FUTEX_WAIT, ...) or poll()) and hasn't been invalidated somehow since then,
this will clobber some of the union fields used by futex_wait_restart() and
do_restart_poll().

If userspace afterwards wrongly calls the restart_syscall syscall,
futex_wait_restart()/do_restart_poll() will read struct fields that have
been clobbered.

This doesn't actually lead to anything particularly interesting because
none of the union fields contain trusted kernel data, and
futex(..., FUTEX_WAIT, ...) and poll() aren't syscalls where it makes much
sense to apply seccomp filters to their arguments.

So the current consequences are just of the "if userspace does bad stuff,
it can damage itself, and that's not a problem" flavor.

But still, it seems like a hazard for future developers, so invalidate the
restart_block when partly setting it up in the nanosleep syscalls.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230105134403.754986-1-jannh@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c      | 2 ++
 kernel/time/posix-stubs.c  | 2 ++
 kernel/time/posix-timers.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 23af5eca11b14..97409581e9dac 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2126,6 +2126,7 @@ SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	return hrtimer_nanosleep(timespec64_to_ktime(tu), HRTIMER_MODE_REL,
@@ -2147,6 +2148,7 @@ SYSCALL_DEFINE2(nanosleep_time32, struct old_timespec32 __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 	return hrtimer_nanosleep(timespec64_to_ktime(tu), HRTIMER_MODE_REL,
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index fcb3b21d8bdcd..3783d07d60ba0 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -146,6 +146,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	texp = timespec64_to_ktime(t);
@@ -239,6 +240,7 @@ SYSCALL_DEFINE4(clock_nanosleep_time32, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 	texp = timespec64_to_ktime(t);
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 5dead89308b74..0c8a87a11b39d 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1270,6 +1270,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 
@@ -1297,6 +1298,7 @@ SYSCALL_DEFINE4(clock_nanosleep_time32, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 
-- 
2.39.0

