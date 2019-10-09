Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F297D0DB6
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 13:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfJILb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 07:31:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58609 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729831AbfJILb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 07:31:57 -0400
Received: from [79.140.115.128] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iIAC5-0008JA-HD; Wed, 09 Oct 2019 11:31:49 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     parri.andrea@gmail.com
Cc:     bsingharora@gmail.com, christian.brauner@ubuntu.com,
        dvyukov@google.com, elver@google.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH] taskstats: fix data-race
Date:   Wed,  9 Oct 2019 13:31:34 +0200
Message-Id: <20191009113134.5171-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191008154418.GA16972@andrea>
References: <20191008154418.GA16972@andrea>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When assiging and testing taskstats in taskstats_exit() there's a race
when writing and reading sig->stats when a thread-group with more than
one thread exits:

cpu0:
thread catches fatal signal and whole thread-group gets taken down
 do_exit()
 do_group_exit()
 taskstats_exit()
 taskstats_tgid_alloc()
The tasks reads sig->stats without holding sighand lock seeing garbage.

cpu1:
task calls exit_group()
 do_exit()
 do_group_exit()
 taskstats_exit()
 taskstats_tgid_alloc()
The task takes sighand lock and assigns new stats to sig->stats.

Fix this by using smp_load_acquire() and smp_store_release().

Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
---
/* v1 */
Link: https://lore.kernel.org/r/20191005112806.13960-1-christian.brauner@ubuntu.com

/* v2 */
Link: https://lore.kernel.org/r/20191006235216.7483-1-christian.brauner@ubuntu.com
- Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>:
  - fix the original double-checked locking using memory barriers

/* v3 */
Link: https://lore.kernel.org/r/20191007110117.1096-1-christian.brauner@ubuntu.com/
- Andrea Parri <parri.andrea@gmail.com>:
  - document memory barriers to make checkpatch happy

/* v4 */
- Andrea Parri <parri.andrea@gmail.com>:
  - use smp_load_acquire(), not READ_ONCE()
  - update commit message
---
 kernel/taskstats.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 13a0f2e6ebc2..e6b45315607a 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -554,24 +554,30 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
-	struct taskstats *stats;
+	struct taskstats *stats_new, *stats;
 
-	if (sig->stats || thread_group_empty(tsk))
-		goto ret;
+	/* Pairs with smp_store_release() below. */
+	stats = smp_load_acquire(sig->stats);
+	if (stats || thread_group_empty(tsk))
+		return stats;
 
 	/* No problem if kmem_cache_zalloc() fails */
-	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
+	stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
 
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!sig->stats) {
-		sig->stats = stats;
-		stats = NULL;
+		/*
+		 * Pairs with smp_store_release() above and order the
+		 * kmem_cache_zalloc().
+		 */
+		smp_store_release(&sig->stats, stats_new);
+		stats_new = NULL;
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
 
-	if (stats)
-		kmem_cache_free(taskstats_cache, stats);
-ret:
+	if (stats_new)
+		kmem_cache_free(taskstats_cache, stats_new);
+
 	return sig->stats;
 }
 
-- 
2.23.0

