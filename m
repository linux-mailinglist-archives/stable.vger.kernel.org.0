Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B59679E1
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfGMLK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 07:10:29 -0400
Received: from terminus.zytor.com ([198.137.202.136]:34549 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfGMLK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 07:10:29 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x6DBA9D73841654
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 13 Jul 2019 04:10:10 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x6DBA9D73841654
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019061801; t=1563016210;
        bh=/xeN6mx3bZPC0ppP8K2hykUZ7NmMmfeRqPslNb6uZ/s=;
        h=Date:From:Cc:Reply-To:To:Subject:From;
        b=qO+fBh2MepC7LOdbXvOYzpBitv6nynt9YIcNELkJWd1h79/MOWNW4uoamOl0pLWmE
         vW2TQy+h6bTMBROsSnp5H69e0RlWQGUwpY2baxUHoTO+QE3V1ZswxmqgOCRGWMYO9S
         etfur/b/8T+uU7yNel5lt7ZUOILC3wyI3ZP8r4uqfXfxAm7Wbf8S23KvWQc9i+7QE4
         evlJmtjOneBVVRXixDYAQt4lKUENzVzvbG58WxvFpBWzYAO3BO1RprgrVMkdgqoKNR
         OgqQkIqjOD1bOxOEqhRP1Ap/Y3t6VtKOr1TramQeGdEA4LV9zNLRrCrNDcEESl0lvW
         /aak5wSe/MQsQ==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x6DBA9xs3841651;
        Sat, 13 Jul 2019 04:10:09 -0700
Date:   Sat, 13 Jul 2019 04:10:09 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-1cf8dfe8a661f0462925df943140e9f6d1ea5233@git.kernel.org>
Cc:     tglx@linutronix.de, jolsa@redhat.com,
        torvalds@linux-foundation.org, alexander.shishkin@linux.intel.com,
        eranian@google.com, mingo@kernel.org, hpa@zytor.com,
        peterz@infradead.org, vincent.weaver@maine.edu,
        stable@vger.kernel.org, mark.rutland@arm.com, acme@redhat.com
Reply-To: torvalds@linux-foundation.org, tglx@linutronix.de,
          jolsa@redhat.com, alexander.shishkin@linux.intel.com,
          linux-kernel@vger.kernel.org, mingo@kernel.org,
          eranian@google.com, peterz@infradead.org, hpa@zytor.com,
          stable@vger.kernel.org, vincent.weaver@maine.edu,
          acme@redhat.com, mark.rutland@arm.com
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/core: Fix race between close() and fork()
Git-Commit-ID: 1cf8dfe8a661f0462925df943140e9f6d1ea5233
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  1cf8dfe8a661f0462925df943140e9f6d1ea5233
Gitweb:     https://git.kernel.org/tip/1cf8dfe8a661f0462925df943140e9f6d1ea5233
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sat, 13 Jul 2019 11:21:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 13 Jul 2019 11:21:25 +0200

perf/core: Fix race between close() and fork()

Syzcaller reported the following Use-after-Free bug:

	close()						clone()

							  copy_process()
							    perf_event_init_task()
							      perf_event_init_context()
							        mutex_lock(parent_ctx->mutex)
								inherit_task_group()
								  inherit_group()
								    inherit_event()
								      mutex_lock(event->child_mutex)
								      // expose event on child list
								      list_add_tail()
								      mutex_unlock(event->child_mutex)
							        mutex_unlock(parent_ctx->mutex)

							    ...
							    goto bad_fork_*

							  bad_fork_cleanup_perf:
							    perf_event_free_task()

	  perf_release()
	    perf_event_release_kernel()
	      list_for_each_entry()
		mutex_lock(ctx->mutex)
		mutex_lock(event->child_mutex)
		// event is from the failing inherit
		// on the other CPU
		perf_remove_from_context()
		list_move()
		mutex_unlock(event->child_mutex)
		mutex_unlock(ctx->mutex)

							      mutex_lock(ctx->mutex)
							      list_for_each_entry_safe()
							        // event already stolen
							      mutex_unlock(ctx->mutex)

							    delayed_free_task()
							      free_task()

	     list_for_each_entry_safe()
	       list_del()
	       free_event()
	         _free_event()
		   // and so event->hw.target
		   // is the already freed failed clone()
		   if (event->hw.target)
		     put_task_struct(event->hw.target)
		       // WHOOPSIE, already quite dead

Which puts the lie to the the comment on perf_event_free_task():
'unexposed, unused context' not so much.

Which is a 'fun' confluence of fail; copy_process() doing an
unconditional free_task() and not respecting refcounts, and perf having
creative locking. In particular:

  82d94856fa22 ("perf/core: Fix lock inversion between perf,trace,cpuhp")

seems to have overlooked this 'fun' parade.

Solve it by using the fact that detached events still have a reference
count on their (previous) context. With this perf_event_free_task()
can detect when events have escaped and wait for their destruction.

Debugged-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reported-by: syzbot+a24c397a29ad22d86c98@syzkaller.appspotmail.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Fixes: 82d94856fa22 ("perf/core: Fix lock inversion between perf,trace,cpuhp")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 49 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 785d708f8553..5dd19bedbf64 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4465,12 +4465,20 @@ static void _free_event(struct perf_event *event)
 	if (event->destroy)
 		event->destroy(event);
 
-	if (event->ctx)
-		put_ctx(event->ctx);
-
+	/*
+	 * Must be after ->destroy(), due to uprobe_perf_close() using
+	 * hw.target.
+	 */
 	if (event->hw.target)
 		put_task_struct(event->hw.target);
 
+	/*
+	 * perf_event_free_task() relies on put_ctx() being 'last', in particular
+	 * all task references must be cleaned up.
+	 */
+	if (event->ctx)
+		put_ctx(event->ctx);
+
 	exclusive_event_destroy(event);
 	module_put(event->pmu->module);
 
@@ -4650,8 +4658,17 @@ again:
 	mutex_unlock(&event->child_mutex);
 
 	list_for_each_entry_safe(child, tmp, &free_list, child_list) {
+		void *var = &child->ctx->refcount;
+
 		list_del(&child->child_list);
 		free_event(child);
+
+		/*
+		 * Wake any perf_event_free_task() waiting for this event to be
+		 * freed.
+		 */
+		smp_mb(); /* pairs with wait_var_event() */
+		wake_up_var(var);
 	}
 
 no_ctx:
@@ -11527,11 +11544,11 @@ static void perf_free_event(struct perf_event *event,
 }
 
 /*
- * Free an unexposed, unused context as created by inheritance by
- * perf_event_init_task below, used by fork() in case of fail.
+ * Free a context as created by inheritance by perf_event_init_task() below,
+ * used by fork() in case of fail.
  *
- * Not all locks are strictly required, but take them anyway to be nice and
- * help out with the lockdep assertions.
+ * Even though the task has never lived, the context and events have been
+ * exposed through the child_list, so we must take care tearing it all down.
  */
 void perf_event_free_task(struct task_struct *task)
 {
@@ -11561,7 +11578,23 @@ void perf_event_free_task(struct task_struct *task)
 			perf_free_event(event, ctx);
 
 		mutex_unlock(&ctx->mutex);
-		put_ctx(ctx);
+
+		/*
+		 * perf_event_release_kernel() could've stolen some of our
+		 * child events and still have them on its free_list. In that
+		 * case we must wait for these events to have been freed (in
+		 * particular all their references to this task must've been
+		 * dropped).
+		 *
+		 * Without this copy_process() will unconditionally free this
+		 * task (irrespective of its reference count) and
+		 * _free_event()'s put_task_struct(event->hw.target) will be a
+		 * use-after-free.
+		 *
+		 * Wait for all events to drop their context reference.
+		 */
+		wait_var_event(&ctx->refcount, refcount_read(&ctx->refcount) == 1);
+		put_ctx(ctx); /* must be last */
 	}
 }
 
