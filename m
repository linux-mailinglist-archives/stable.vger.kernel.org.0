Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B22378538
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhEJK7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233967AbhEJKzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED5D61C2B;
        Mon, 10 May 2021 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643382;
        bh=3XajU10dEMXk9toIBhGzvm02aQA3tpd2LUqRYNKKr64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r35nBSeZw7vmVYo+RSP26DL5BT2QX61bARIZKhwJA4UjWJ6oxmYNuQ0ZaHD3ULMeo
         Y/ZgvHh7IufgL3jwpvxt8VbZrT5sQRCgYr6byxhyhuZ9vF9umnvEUIzUnVGAfx661V
         iPNEc+Yfi8KOPSn5Y6X+nzuOaZVHTKCfCxD6C9QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Konstantin Kharlamov <hi-angel@yandex.ru>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 292/299] tracing: Restructure trace_clock_global() to never block
Date:   Mon, 10 May 2021 12:21:29 +0200
Message-Id: <20210510102014.576061569@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit aafe104aa9096827a429bc1358f8260ee565b7cc upstream.

It was reported that a fix to the ring buffer recursion detection would
cause a hung machine when performing suspend / resume testing. The
following backtrace was extracted from debugging that case:

Call Trace:
 trace_clock_global+0x91/0xa0
 __rb_reserve_next+0x237/0x460
 ring_buffer_lock_reserve+0x12a/0x3f0
 trace_buffer_lock_reserve+0x10/0x50
 __trace_graph_return+0x1f/0x80
 trace_graph_return+0xb7/0xf0
 ? trace_clock_global+0x91/0xa0
 ftrace_return_to_handler+0x8b/0xf0
 ? pv_hash+0xa0/0xa0
 return_to_handler+0x15/0x30
 ? ftrace_graph_caller+0xa0/0xa0
 ? trace_clock_global+0x91/0xa0
 ? __rb_reserve_next+0x237/0x460
 ? ring_buffer_lock_reserve+0x12a/0x3f0
 ? trace_event_buffer_lock_reserve+0x3c/0x120
 ? trace_event_buffer_reserve+0x6b/0xc0
 ? trace_event_raw_event_device_pm_callback_start+0x125/0x2d0
 ? dpm_run_callback+0x3b/0xc0
 ? pm_ops_is_empty+0x50/0x50
 ? platform_get_irq_byname_optional+0x90/0x90
 ? trace_device_pm_callback_start+0x82/0xd0
 ? dpm_run_callback+0x49/0xc0

With the following RIP:

RIP: 0010:native_queued_spin_lock_slowpath+0x69/0x200

Since the fix to the recursion detection would allow a single recursion to
happen while tracing, this lead to the trace_clock_global() taking a spin
lock and then trying to take it again:

ring_buffer_lock_reserve() {
  trace_clock_global() {
    arch_spin_lock() {
      queued_spin_lock_slowpath() {
        /* lock taken */
        (something else gets traced by function graph tracer)
          ring_buffer_lock_reserve() {
            trace_clock_global() {
              arch_spin_lock() {
                queued_spin_lock_slowpath() {
                /* DEAD LOCK! */

Tracing should *never* block, as it can lead to strange lockups like the
above.

Restructure the trace_clock_global() code to instead of simply taking a
lock to update the recorded "prev_time" simply use it, as two events
happening on two different CPUs that calls this at the same time, really
doesn't matter which one goes first. Use a trylock to grab the lock for
updating the prev_time, and if it fails, simply try again the next time.
If it failed to be taken, that means something else is already updating
it.

Link: https://lkml.kernel.org/r/20210430121758.650b6e8a@gandalf.local.home

Cc: stable@vger.kernel.org
Tested-by: Konstantin Kharlamov <hi-angel@yandex.ru>
Tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Fixes: b02414c8f045 ("ring-buffer: Fix recursion protection transitions between interrupt context") # started showing the problem
Fixes: 14131f2f98ac3 ("tracing: implement trace_clock_*() APIs") # where the bug happened
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212761
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_clock.c |   48 ++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 16 deletions(-)

--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -95,33 +95,49 @@ u64 notrace trace_clock_global(void)
 {
 	unsigned long flags;
 	int this_cpu;
-	u64 now;
+	u64 now, prev_time;
 
 	raw_local_irq_save(flags);
 
 	this_cpu = raw_smp_processor_id();
-	now = sched_clock_cpu(this_cpu);
+
 	/*
-	 * If in an NMI context then dont risk lockups and return the
-	 * cpu_clock() time:
+	 * The global clock "guarantees" that the events are ordered
+	 * between CPUs. But if two events on two different CPUS call
+	 * trace_clock_global at roughly the same time, it really does
+	 * not matter which one gets the earlier time. Just make sure
+	 * that the same CPU will always show a monotonic clock.
+	 *
+	 * Use a read memory barrier to get the latest written
+	 * time that was recorded.
 	 */
-	if (unlikely(in_nmi()))
-		goto out;
+	smp_rmb();
+	prev_time = READ_ONCE(trace_clock_struct.prev_time);
+	now = sched_clock_cpu(this_cpu);
 
-	arch_spin_lock(&trace_clock_struct.lock);
+	/* Make sure that now is always greater than prev_time */
+	if ((s64)(now - prev_time) < 0)
+		now = prev_time + 1;
 
 	/*
-	 * TODO: if this happens often then maybe we should reset
-	 * my_scd->clock to prev_time+1, to make sure
-	 * we start ticking with the local clock from now on?
+	 * If in an NMI context then dont risk lockups and simply return
+	 * the current time.
 	 */
-	if ((s64)(now - trace_clock_struct.prev_time) < 0)
-		now = trace_clock_struct.prev_time + 1;
-
-	trace_clock_struct.prev_time = now;
-
-	arch_spin_unlock(&trace_clock_struct.lock);
+	if (unlikely(in_nmi()))
+		goto out;
 
+	/* Tracing can cause strange recursion, always use a try lock */
+	if (arch_spin_trylock(&trace_clock_struct.lock)) {
+		/* Reread prev_time in case it was already updated */
+		prev_time = READ_ONCE(trace_clock_struct.prev_time);
+		if ((s64)(now - prev_time) < 0)
+			now = prev_time + 1;
+
+		trace_clock_struct.prev_time = now;
+
+		/* The unlock acts as the wmb for the above rmb */
+		arch_spin_unlock(&trace_clock_struct.lock);
+	}
  out:
 	raw_local_irq_restore(flags);
 


