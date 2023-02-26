Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAA06A3116
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjBZO4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjBZOzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:55:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12F313D58;
        Sun, 26 Feb 2023 06:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8662360C50;
        Sun, 26 Feb 2023 14:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46332C4339C;
        Sun, 26 Feb 2023 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423035;
        bh=T8EyDmS3c8KWcIlZlLCyElCSMUibYnr7czwvsQskVAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1BaznLC3uy//XuedGqaHLwOKqg5txWwgQlq3RPpRdjcfrQQt7fPRDSuU5/cRDPgj
         CuGadKBoGD+JIML4ZruNrbhC6zN53VyySQQC3iH0XOhlPWPq7m42Q4D9xWHHetYlJD
         UftATxyMXiNh4kKgCvCH9vt7PZDzs05COkb51RLdMGDi7FQK0mrcA4NJjqGlHni0rp
         EfwYZykTBp3YFGnBwAv5TpH7BatEGJq/bsgplWRcWEY2pj/565GwRR12Nz5qJDNUde
         6fE3UuCwmy/+/1A2kS225F/l+b8X9gT0GoDustIHFtGxDqj+us4zXvo0rha4gWSO74
         saEB/oBv23CWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org
Subject: [PATCH AUTOSEL 5.10 08/27] timers: Prevent union confusion from unexpected restart_syscall()
Date:   Sun, 26 Feb 2023 09:49:55 -0500
Message-Id: <20230226145014.828855-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145014.828855-1-sashal@kernel.org>
References: <20230226145014.828855-1-sashal@kernel.org>
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
index 544ce87ba38a7..70deb2f01e97a 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2024,6 +2024,7 @@ SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	return hrtimer_nanosleep(timespec64_to_ktime(tu), HRTIMER_MODE_REL,
@@ -2045,6 +2046,7 @@ SYSCALL_DEFINE2(nanosleep_time32, struct old_timespec32 __user *, rqtp,
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
index b624788023d8f..724ca7eb1a6e8 100644
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

