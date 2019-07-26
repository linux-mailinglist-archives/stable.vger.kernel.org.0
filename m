Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D694276DFB
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfGZP14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388299AbfGZP1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:27:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A81422CBD;
        Fri, 26 Jul 2019 15:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154871;
        bh=O+6u/nPnMRk8gDVO8rOSjivwnuGNYD3CWrEmn9RcmOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKclmbgALfbUJb0YvtnhWfAX748TnGwrWjodG9lGjM8Vd8utY3t4Rz52gq4XYTr5h
         Sd7jOhFpORa87ox+dFeMs9BPOFproOZRNYdF3GIEtW7jpNEEH1dPT/ZiwAjzGiyXeq
         ANqTWkl2373KI6TYbpY3zHJjciiBZzmfgXcIytY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a24c397a29ad22d86c98@syzkaller.appspotmail.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.2 55/66] perf/core: Fix race between close() and fork()
Date:   Fri, 26 Jul 2019 17:24:54 +0200
Message-Id: <20190726152307.847797843@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 1cf8dfe8a661f0462925df943140e9f6d1ea5233 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |   49 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4469,12 +4469,20 @@ static void _free_event(struct perf_even
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
 
@@ -4654,8 +4662,17 @@ again:
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
@@ -11529,11 +11546,11 @@ static void perf_free_event(struct perf_
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
@@ -11563,7 +11580,23 @@ void perf_event_free_task(struct task_st
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
 


