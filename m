Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6A86A31BD
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjBZPDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjBZPDb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:03:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BD31A678;
        Sun, 26 Feb 2023 06:54:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25AFCB80C70;
        Sun, 26 Feb 2023 14:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B498C433D2;
        Sun, 26 Feb 2023 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423146;
        bh=/uR/HjHqUksQ6GlEGj0xtSRI2ndYRlvOIAERmpSe3eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZMb4aB7Lnoxvt4MM/I6seTF+t/57fPswekvED+CnVkcEVTdgjuc1Tk40lxYBoOrW
         2VqsF7qje2ost+ji3WoF0nKJ5v1y7hm9Vvb6RQdJq+NcpqQs4g6Ddtw6cCxj7GtlRt
         ehH64QxO+jj6pzg28ZjrwYMQhMelATXGcWlJI63CrEIjNwn0xwJ5MIjGny4W7imDC9
         WBWr2DMcZn48VpcasDKYEcGywJo+id1ipJOd34l+A6X1Eq3oK/ttSV7K0QKlO5lczh
         rosu/6FqUg5n4pcSiuANho5zF5kz/90sJ8U8jXw21m/1AGrB7CVHLocMAj2BTZ7oWv
         icCXNoDp7W+8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org
Subject: [PATCH AUTOSEL 4.19 04/13] timers: Prevent union confusion from unexpected restart_syscall()
Date:   Sun, 26 Feb 2023 09:52:06 -0500
Message-Id: <20230226145217.829485-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145217.829485-1-sashal@kernel.org>
References: <20230226145217.829485-1-sashal@kernel.org>
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
index 32ee24f5142ab..8512f06f0ebef 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1838,6 +1838,7 @@ SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	return hrtimer_nanosleep(&tu, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
@@ -1858,6 +1859,7 @@ COMPAT_SYSCALL_DEFINE2(nanosleep, struct compat_timespec __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 	return hrtimer_nanosleep(&tu, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index 2c6847d5d69ba..362c159fb3f88 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -144,6 +144,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	return hrtimer_nanosleep(&t, flags & TIMER_ABSTIME ?
@@ -230,6 +231,7 @@ COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 	return hrtimer_nanosleep(&t, flags & TIMER_ABSTIME ?
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 48758108e055c..1234868b3b03e 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1225,6 +1225,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 
@@ -1252,6 +1253,7 @@ COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 
-- 
2.39.0

