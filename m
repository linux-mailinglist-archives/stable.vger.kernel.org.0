Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B03E1A1349
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 20:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDGSEV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 Apr 2020 14:04:21 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:62855 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726277AbgDGSEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 14:04:21 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20831296-1500050 
        for multiple; Tue, 07 Apr 2020 19:04:09 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAHk-=wjTmay+NhnZ5Q+GM9buDioT0ie8njJgcquTFGD_qQhXpw@mail.gmail.com>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org> <20200407031042.8o-fYMox-%akpm@linux-foundation.org> <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com> <158627540139.8918.10102358634447361335@build.alporthouse.com> <CAHk-=wjTmay+NhnZ5Q+GM9buDioT0ie8njJgcquTFGD_qQhXpw@mail.gmail.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe' list iteration
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Message-ID: <158628265081.8918.1825514020221532657@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 07 Apr 2020 19:04:10 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Linus Torvalds (2020-04-07 18:28:34)
> On Tue, Apr 7, 2020 at 9:04 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> > It'll take some time to reconstruct the original report, but the case in
> > question was in removing the last element of the list of the last list,
> > switch to a global lock over all such lists to park the HW, which in
> > doing so added one more element to the original list. [If we happen to
> > be retiring along the kernel timeline in the first place.]
> 
> Please point to the real code and the list.
> 
> Honestly, what you describe sounds complex enough that I think your
> locking is simply just buggy.
> 
> IOW, this patch seems to really just paper over a locking bug, and the
> KASAN report tied to it.
> 
> Because the fundamental issue is that READ_ONCE() can not fix a bug
> here. Reading the next pointer once fundamentally cannot matter if it
> can change concurrently: the code is buggy, and the READ_ONCE() just
> means that it gets one or the other value randomly, and that the list
> walking is fundamentally racy.
> 
> One the other hand, if the next pointer _cannot_ change concurrently,
> then READ_ONCE() cannot make a difference.
> 
> So as fat as I can tell, we have two possibilities, and in both cases
> changing the code to use READ_ONCE() is not the right thing to do. In
> one case it hides a bug, and in another case it's just pointless.
> 
> > list->next changed from pointing to list_head, to point to the new
> > element instead. However, we don't have to check the next element yet
> > and want to terminate the list iteration.
> 
> I'd really like to see the actual code that has that list walking. You say:
> 
> > For reference,
> > drivers/gpu/drm/i915/gt/intel_engine_pm.c::__engine_park()
> 
> .. but that function doesn't have any locking or list-walking. Is it
> the "call_idle_barriers()" loop? What is it?

list_for_each_safe @ intel_gt_requests.c::retire_requests
list_del @ i915_requests.c::i915_request_retire
list_add @ i915_requests.c::__i915_request_create

> I'd really like to see the KASAN report and the discussion about this change.
> 
> And if there was no discussion, then the patch just seems like "I
> changed code randomly and the KASAN report went away, so it's all
> good".
> 
> > Global activity is serialised by engine->wakeref.mutex; every active
> > timeline is required to hold an engine wakeref, but retiring is local to
> > timelines and serialised by their own timeline->mutex.
> >
> > lock(&timeline->lock)
> > list_for_each_safe(&timeline->requests)
> >   \-> i915_request_retire [list_del(&timeline->requests)]
> >    \-> intel_timeline_exit
> >     \-> lock(&engine->wakeref.mutex)
> >         engine_park [list_add_tail(&engine->kernel_context->timeline->requests)]
> 
> in that particular list_for_each_safe() thing, there's no possibility
> that the 'next' field would be reloaded, since the list_del() in the
> above will be somethign the compiler is aware of.
> 
> So yes, the beginning list_for_each_safe() might load it twice (or a
> hundred times), but by the time that list_del() in
> i915_request_retire() has been called, if the compiler then reloads it
> afterwards, that would be a major compiler bug, since it's after that
> value could have been written in the local thread.

My understanding of how KCSAN works is that it installs a watchpoint
after a read and complains if the value changes within X us.

> So this doesn't explain it to me.
> 
> What it *sounds* like is that the "engine" lock that you do *not* hold
> initially, is not protecting some accessor to that list, so you have a
> race on the list at the time of that list_del().

We take an engine wakeref prior to creating a request, and release it
upon retiring the request [through the respective context/timelines,
across all the engines that might be used for that context]. When the
engine wakeref hits zero, that mutex is taken to prevent any other new
request being created, and under that mutex while we know that the
engine->kernel_context->timeline is empty, we submit a request to switch
the GPU to point into our scratch context.

That submission can run concurrently to the list iteration, but only
_after_ the final list_del.

> And that race may be what KASAN is reporting, and what that patch is
> _hiding_ from KASAN - but not fixing.

Yes, it was sent as a means to silence KCSAN with a query as to whether
or not it could happen in practice with an aggressive compiler.

> See what I am saying and why I find this patch questionable?
> 
> There may be something really subtle going on, but it really smells
> like "two threads are modifying the same list at the same time".

In strict succession.
 
> And there's no way that the READ_ONCE() will fix that bug, it will
> only make KASAN shut up about it.

There's some more shutting up required for KCSAN to bring the noise down
to usable levels which I hope has been done so I don't have to argue for
it, such as

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 1e6650ed066d..c7c8dd89f279 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -164,7 +164,7 @@ static inline void destroy_timer_on_stack(struct timer_list *timer) { }
  */
 static inline int timer_pending(const struct timer_list * timer)
 {
-	return timer->entry.pprev != NULL;
+	return READ_ONCE(timer->entry.pprev) != NULL;
 }

 extern void add_timer_on(struct timer_list *timer, int cpu);
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 5352ce50a97e..7461b3f33629 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -565,8 +565,9 @@ bool mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner,
 		/*
 		 * Use vcpu_is_preempted to detect lock holder preemption issue.
 		 */
-		if (!owner->on_cpu || need_resched() ||
-				vcpu_is_preempted(task_cpu(owner))) {
+		if (!READ_ONCE(owner->on_cpu) ||
+		    need_resched() ||
+		    vcpu_is_preempted(task_cpu(owner))) {
 			ret = false;
 			break;
 		}
@@ -602,7 +603,7 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
 	 * on cpu or its cpu is preempted
 	 */
 	if (owner)
-		retval = owner->on_cpu && !vcpu_is_preempted(task_cpu(owner));
+		retval = READ_ONCE(owner->on_cpu) && !vcpu_is_preempted(task_cpu(owner));
 	rcu_read_unlock();

 	/*
diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index 1f7734949ac8..4a81fba4cf70 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -75,7 +75,7 @@ osq_wait_next(struct optimistic_spin_queue *lock,
 		 * wait for either @lock to point to us, through its Step-B, or
 		 * wait for a new @node->next from its Step-C.
 		 */
-		if (node->next) {
+		if (READ_ONCE(node->next)) {
 			next = xchg(&node->next, NULL);
 			if (next)
 				break;
@@ -154,7 +154,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
 	 */

 	for (;;) {
-		if (prev->next == node &&
+		if (READ_ONCE(prev->next) == node &&
 		    cmpxchg(&prev->next, node, NULL) == node)
 			break;

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 0d9b6be9ecc8..eef4835cecf2 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -650,7 +650,7 @@ static inline bool owner_on_cpu(struct task_struct *owner)
 	 * As lock holder preemption issue, we both skip spinning if
 	 * task is not on cpu or its cpu is preempted
 	 */
-	return owner->on_cpu && !vcpu_is_preempted(task_cpu(owner));
+	return READ_ONCE(owner->on_cpu) && !vcpu_is_preempted(task_cpu(owner));
 }

 static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem,

