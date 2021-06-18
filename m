Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A56E3ACC0C
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 15:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhFRNXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 09:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230494AbhFRNXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 09:23:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 540BC613F2;
        Fri, 18 Jun 2021 13:21:27 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1luER4-003VGC-Bc; Fri, 18 Jun 2021 09:21:26 -0400
Message-ID: <20210618132126.196372966@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 18 Jun 2021 09:20:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 4/4] tracing: Do no increment trace_clock_global() by one
References: <20210618132046.600413369@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The trace_clock_global() tries to make sure the events between CPUs is
somewhat in order. A global value is used and updated by the latest read
of a clock. If one CPU is ahead by a little, and is read by another CPU, a
lock is taken, and if the timestamp of the other CPU is behind, it will
simply use the other CPUs timestamp.

The lock is also only taken with a "trylock" due to tracing, and strange
recursions can happen. The lock is not taken at all in NMI context.

In the case where the lock is not able to be taken, the non synced
timestamp is returned. But it will not be less than the saved global
timestamp.

The problem arises because when the time goes "backwards" the time
returned is the saved timestamp plus 1. If the lock is not taken, and the
plus one to the timestamp is returned, there's a small race that can cause
the time to go backwards!

	CPU0				CPU1
	----				----
				trace_clock_global() {
				    ts = clock() [ 1000 ]
				    trylock(clock_lock) [ success ]
				    global_ts = ts; [ 1000 ]

				    <interrupted by NMI>
 trace_clock_global() {
    ts = clock() [ 999 ]
    if (ts < global_ts)
	ts = global_ts + 1 [ 1001 ]

    trylock(clock_lock) [ fail ]

    return ts [ 1001]
 }
				    unlock(clock_lock);
				    return ts; [ 1000 ]
				}

 trace_clock_global() {
    ts = clock() [ 1000 ]
    if (ts < global_ts) [ false 1000 == 1000 ]

    trylock(clock_lock) [ success ]
    global_ts = ts; [ 1000 ]
    unlock(clock_lock)

    return ts; [ 1000 ]
 }

The above case shows to reads of trace_clock_global() on the same CPU, but
the second read returns one less than the first read. That is, time when
backwards, and this is not what is allowed by trace_clock_global().

This was triggered by heavy tracing and the ring buffer checker that tests
for the clock going backwards:

 Ring buffer clock went backwards: 20613921464 -> 20613921463
 ------------[ cut here ]------------
 WARNING: CPU: 2 PID: 0 at kernel/trace/ring_buffer.c:3412 check_buffer+0x1b9/0x1c0
 Modules linked in:
 [..]
 [CPU: 2]TIME DOES NOT MATCH expected:20620711698 actual:20620711697 delta:6790234 before:20613921463 after:20613921463
   [20613915818] PAGE TIME STAMP
   [20613915818] delta:0
   [20613915819] delta:1
   [20613916035] delta:216
   [20613916465] delta:430
   [20613916575] delta:110
   [20613916749] delta:174
   [20613917248] delta:499
   [20613917333] delta:85
   [20613917775] delta:442
   [20613917921] delta:146
   [20613918321] delta:400
   [20613918568] delta:247
   [20613918768] delta:200
   [20613919306] delta:538
   [20613919353] delta:47
   [20613919980] delta:627
   [20613920296] delta:316
   [20613920571] delta:275
   [20613920862] delta:291
   [20613921152] delta:290
   [20613921464] delta:312
   [20613921464] delta:0 TIME EXTEND
   [20613921464] delta:0

This happened more than once, and always for an off by one result. It also
started happening after commit aafe104aa9096 was added.

Cc: stable@vger.kernel.org
Fixes: aafe104aa9096 ("tracing: Restructure trace_clock_global() to never block")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_clock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index c1637f90c8a3..4702efb00ff2 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -115,9 +115,9 @@ u64 notrace trace_clock_global(void)
 	prev_time = READ_ONCE(trace_clock_struct.prev_time);
 	now = sched_clock_cpu(this_cpu);
 
-	/* Make sure that now is always greater than prev_time */
+	/* Make sure that now is always greater than or equal to prev_time */
 	if ((s64)(now - prev_time) < 0)
-		now = prev_time + 1;
+		now = prev_time;
 
 	/*
 	 * If in an NMI context then dont risk lockups and simply return
@@ -131,7 +131,7 @@ u64 notrace trace_clock_global(void)
 		/* Reread prev_time in case it was already updated */
 		prev_time = READ_ONCE(trace_clock_struct.prev_time);
 		if ((s64)(now - prev_time) < 0)
-			now = prev_time + 1;
+			now = prev_time;
 
 		trace_clock_struct.prev_time = now;
 
-- 
2.30.2
