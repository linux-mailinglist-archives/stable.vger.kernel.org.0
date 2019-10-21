Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B128BDEAFE
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 13:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfJULdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 07:33:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57248 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfJULdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 07:33:32 -0400
Received: from [213.220.153.21] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iMVwI-0007A3-CJ; Mon, 21 Oct 2019 11:33:30 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        christian.brauner@ubuntu.com
Cc:     bsingharora@gmail.com, dvyukov@google.com, elver@google.com,
        parri.andrea@gmail.com, stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH v6] taskstats: fix data-race
Date:   Mon, 21 Oct 2019 13:33:27 +0200
Message-Id: <20191021113327.22365-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009114809.8643-1-christian.brauner@ubuntu.com>
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
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
The tasks reads sig->stats without holding sighand lock.

cpu1:
task calls exit_group()
 do_exit()
 do_group_exit()
 taskstats_exit()
 taskstats_tgid_alloc()
The task takes sighand lock and assigns new stats to sig->stats.

The first approach used smp_load_acquire() and smp_store_release().
However, after having discussed this it seems that the data dependency
for kmem_cache_alloc() would be fixed by WRITE_ONCE().
Furthermore, the smp_load_acquire() would only manage to order the stats
check before the thread_group_empty() check. So it seems just using
READ_ONCE() and WRITE_ONCE() will do the job and I wanted to bring this
up for discussion at least.

Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
Cc: Will Deacon <will@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Andrea Parri <parri.andrea@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v1 */
Link: https://lore.kernel.org/r/20191005112806.13960-1-christian.brauner@ubuntu.com

/* v2 */
Link: https://lore.kernel.org/r/20191006235216.7483-1-christian.brauner@ubuntu.com
- Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>:
  - fix the original double-checked locking using memory barriers

/* v3 */
Link: https://lore.kernel.org/r/20191007110117.1096-1-christian.brauner@ubuntu.com
- Andrea Parri <parri.andrea@gmail.com>:
  - document memory barriers to make checkpatch happy

/* v4 */
Link: https://lore.kernel.org/r/20191009113134.5171-1-christian.brauner@ubuntu.com
- Andrea Parri <parri.andrea@gmail.com>:
  - use smp_load_acquire(), not READ_ONCE()
  - update commit message

/* v5 */
Link: https://lore.kernel.org/r/20191009114809.8643-1-christian.brauner@ubuntu.com
- Andrea Parri <parri.andrea@gmail.com>:
  - fix typo in smp_load_acquire()

/* v6 */
- Christian Brauner <christian.brauner@ubuntu.com>:
  - bring up READ_ONCE()/WRITE_ONCE() approach for discussion
---
 kernel/taskstats.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 13a0f2e6ebc2..111bb4139aa2 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -554,25 +554,29 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
-	struct taskstats *stats;
+	struct taskstats *stats_new, *stats;
 
-	if (sig->stats || thread_group_empty(tsk))
-		goto ret;
+	/* Pairs with WRITE_ONCE() below. */
+	stats = READ_ONCE(sig->stats);
+	if (stats || thread_group_empty(tsk))
+		return stats;
 
 	/* No problem if kmem_cache_zalloc() fails */
-	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
+	stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
 
 	spin_lock_irq(&tsk->sighand->siglock);
-	if (!sig->stats) {
-		sig->stats = stats;
-		stats = NULL;
+	if (!stats) {
+		stats = stats_new;
+		/* Pairs with READ_ONCE() above. */
+		WRITE_ONCE(sig->stats, stats_new);
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
-- 
2.23.0

