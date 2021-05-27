Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EC93938F6
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 01:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236519AbhE0XLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 19:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236520AbhE0XLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 19:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 163EA613DA;
        Thu, 27 May 2021 23:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622157009;
        bh=xpdZ+SiiNryn3YuBZ/mBu3nABFN8h7x8bjyBdxYNuLE=;
        h=Date:From:To:Subject:From;
        b=HtnZMv0teZ35G7KTD8xE5hxuU1q8DvkD6nuruNys1qwvgohilQMzvj4Vf4q5AJyyF
         F4/ic1XJQr2In+M9wlgBLFSXRbDZCVVYfZl7VXYpRS5j23AfvN9ZRDdmlT+4Q0iujg
         9FwigbG3u6tED0hQr4gnTepSZBFUE3hLo4VzdzZU=
Date:   Thu, 27 May 2021 16:10:08 -0700
From:   akpm@linux-foundation.org
To:     bp@suse.de, davidchao@google.com, jenhaochen@google.com,
        jkosina@suse.cz, josh@joshtriplett.org, liumartin@google.com,
        mhocko@suse.cz, mingo@redhat.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, pmladek@suse.com,
        rostedt@goodmis.org, stable@vger.kernel.org, tglx@linutronix.de,
        tj@kernel.org, vbabka@suse.cz
Subject:  [to-be-updated]
 =?US-ASCII?Q?kthread-fix-kthread=5Fmod=5Fdelayed=5Fwork-vs-kthread=5Fcan?=
 =?US-ASCII?Q?cel=5Fdelayed=5Fwork=5Fsync-race.patch?= removed from -mm
 tree
Message-ID: <20210527231008.wCN_GY_xR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kthread: fix kthread_mod_delayed_work vs kthread_cancel_delayed_work_sync race
has been removed from the -mm tree.  Its filename was
     kthread-fix-kthread_mod_delayed_work-vs-kthread_cancel_delayed_work_sync-race.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Martin Liu <liumartin@google.com>
Subject: kthread: fix kthread_mod_delayed_work vs kthread_cancel_delayed_work_sync race

We encountered a system hang issue while doing the tests.  The callstack
is as following

	schedule+0x80/0x100
	schedule_timeout+0x48/0x138
	wait_for_common+0xa4/0x134
	wait_for_completion+0x1c/0x2c
	kthread_flush_work+0x114/0x1cc
	kthread_cancel_work_sync.llvm.16514401384283632983+0xe8/0x144
	kthread_cancel_delayed_work_sync+0x18/0x2c
	xxxx_pm_notify+0xb0/0xd8
	blocking_notifier_call_chain_robust+0x80/0x194
	pm_notifier_call_chain_robust+0x28/0x4c
	suspend_prepare+0x40/0x260
	enter_state+0x80/0x3f4
	pm_suspend+0x60/0xdc
	state_store+0x108/0x144
	kobj_attr_store+0x38/0x88
	sysfs_kf_write+0x64/0xc0
	kernfs_fop_write_iter+0x108/0x1d0
	vfs_write+0x2f4/0x368
	ksys_write+0x7c/0xec

When we started investigating, we found race between
kthread_mod_delayed_work vs kthread_cancel_delayed_work_sync.  The race's
result could be simply reproduced as a kthread_mod_delayed_work with a
following kthread_flush_work call.

Thing is we release kthread_mod_delayed_work kspin_lock in
__kthread_cancel_work so it opens a race window for
kthread_cancel_delayed_work_sync to change the canceling count used to
prevent dwork from being requeued before calling kthread_flush_work. 
However, we don't check the canceling count after returning from
__kthread_cancel_work and then insert the dwork to the worker.  It results
the following kthread_flush_work inserts flush work to dwork's tail which
is at worker's dealyed_work_list.  Therefore, flush work will never get
moved to the worker's work_list to be executed.  Finally,
kthread_cancel_delayed_work_sync will NOT be able to get completed and
wait forever.  The code sequence diagram is as following

Thread A                Thread B
kthread_mod_delayed_work
  spin_lock
   __kthread_cancel_work
    canceling = 1
    spin_unlock
                        kthread_cancel_delayed_work_sync
                          spin_lock
                            kthread_cancel_work
                          canceling = 2
                          spin_unlock
    del_timer_sync
    spin_lock
    canceling = 1 // canceling count gets update in ThreadB before
  queue_delayed_work // dwork is put into the woker's dealyed_work_list
                        without checking the canceling count
 spin_unlock
                          kthread_flush_work
                            spin_lock
                            Insert flush work // at the tail of the
			                         dwork which is at
						 the worker's
						 dealyed_work_list
                            spin_unlock
                            wait_for_completion // Thread B stuck here as
			                           flush work will never
						   get executed

The canceling count could change in __kthread_cancel_work as the spinlock
get released and regained in between, let's check the count again before
we queue the delayed work to avoid the race.

Link: https://lkml.kernel.org/r/20210513065458.941403-1-liumartin@google.com
Fixes: 37be45d49dec2 ("kthread: allow to cancel kthread work")
Signed-off-by: Martin Liu <liumartin@google.com>
Tested-by: David Chao <davidchao@google.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <jenhaochen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/kthread.c~kthread-fix-kthread_mod_delayed_work-vs-kthread_cancel_delayed_work_sync-race
+++ a/kernel/kthread.c
@@ -1181,6 +1181,19 @@ bool kthread_mod_delayed_work(struct kth
 		goto out;
 
 	ret = __kthread_cancel_work(work, true, &flags);
+
+	/*
+	 * Canceling could run in parallel from kthread_cancel_delayed_work_sync
+	 * and change work's canceling count as the spinlock is released and regain
+	 * in __kthread_cancel_work so we need to check the count again. Otherwise,
+	 * we might incorrectly queue the dwork and further cause
+	 * cancel_delayed_work_sync thread waiting for flush dwork endlessly.
+	 */
+	if (work->canceling) {
+		ret = false;
+		goto out;
+	}
+
 fast_queue:
 	__kthread_queue_delayed_work(worker, dwork, delay);
 out:
_

Patches currently in -mm which might be from liumartin@google.com are


