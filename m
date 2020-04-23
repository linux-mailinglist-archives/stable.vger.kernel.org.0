Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933891B690F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgDWXUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48678 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728229AbgDWXGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:34 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvM-0004c0-1C; Fri, 24 Apr 2020 00:06:28 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6jB-Dg; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dmitry Vyukov" <dvyukov@google.com>,
        "Will Deacon" <will@kernel.org>,
        "Christian Brauner" <christian.brauner@ubuntu.com>,
        "Andrea Parri" <parri.andrea@gmail.com>,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        "Marco Elver" <elver@google.com>
Date:   Fri, 24 Apr 2020 00:04:50 +0100
Message-ID: <lsq.1587683028.124448678@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 063/245] taskstats: fix data-race
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 0b8d616fb5a8ffa307b1d3af37f55c15dae14f28 upstream.

When assiging and testing taskstats in taskstats_exit() there's a race
when setting up and reading sig->stats when a thread-group with more
than one thread exits:

write to 0xffff8881157bbe10 of 8 bytes by task 7951 on cpu 0:
 taskstats_tgid_alloc kernel/taskstats.c:567 [inline]
 taskstats_exit+0x6b7/0x717 kernel/taskstats.c:596
 do_exit+0x2c2/0x18e0 kernel/exit.c:864
 do_group_exit+0xb4/0x1c0 kernel/exit.c:983
 get_signal+0x2a2/0x1320 kernel/signal.c:2734
 do_signal+0x3b/0xc00 arch/x86/kernel/signal.c:815
 exit_to_usermode_loop+0x250/0x2c0 arch/x86/entry/common.c:159
 prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
 do_syscall_64+0x2d7/0x2f0 arch/x86/entry/common.c:299
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

read to 0xffff8881157bbe10 of 8 bytes by task 7949 on cpu 1:
 taskstats_tgid_alloc kernel/taskstats.c:559 [inline]
 taskstats_exit+0xb2/0x717 kernel/taskstats.c:596
 do_exit+0x2c2/0x18e0 kernel/exit.c:864
 do_group_exit+0xb4/0x1c0 kernel/exit.c:983
 __do_sys_exit_group kernel/exit.c:994 [inline]
 __se_sys_exit_group kernel/exit.c:992 [inline]
 __x64_sys_exit_group+0x2e/0x30 kernel/exit.c:992
 do_syscall_64+0xcf/0x2f0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by using smp_load_acquire() and smp_store_release().

Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Will Deacon <will@kernel.org>
Reviewed-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://lore.kernel.org/r/20191009114809.8643-1-christian.brauner@ubuntu.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/taskstats.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -591,25 +591,33 @@ static int taskstats_user_cmd(struct sk_
 static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
-	struct taskstats *stats;
+	struct taskstats *stats_new, *stats;
 
-	if (sig->stats || thread_group_empty(tsk))
-		goto ret;
+	/* Pairs with smp_store_release() below. */
+	stats = smp_load_acquire(&sig->stats);
+	if (stats || thread_group_empty(tsk))
+		return stats;
 
 	/* No problem if kmem_cache_zalloc() fails */
-	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
+	stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
 
 	spin_lock_irq(&tsk->sighand->siglock);
-	if (!sig->stats) {
-		sig->stats = stats;
-		stats = NULL;
+	stats = sig->stats;
+	if (!stats) {
+		/*
+		 * Pairs with smp_store_release() above and order the
+		 * kmem_cache_zalloc().
+		 */
+		smp_store_release(&sig->stats, stats_new);
+		stats = stats_new;
+		stats_new = NULL;
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
 
-	if (stats)
-		kmem_cache_free(taskstats_cache, stats);
-ret:
-	return sig->stats;
+	if (stats_new)
+		kmem_cache_free(taskstats_cache, stats_new);
+
+	return stats;
 }
 
 /* Send pid data out on exit */

