Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947A53AEEE1
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhFUQdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232329AbhFUQbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:31:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6206F613D9;
        Mon, 21 Jun 2021 16:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292724;
        bh=lrheUlzJotTyvZish14WHKD5NFC80vlbHHZImRKhRZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sh6EVv10L2YqVV2OXbhk9XfgS51qr0JTNoqvtCkarw8VQXas4VVzUbU16loCUCg/w
         g0ieLpBSqsjzHFVQmYefQD1GwWqulCDC6uT87Iv/AXRGW+7yOWePpFYGsoap5aPHRu
         tWKeTbd4UD3xjpF8QJAe9QrWW4nhwZdbvYF5sYsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 106/146] tracing: Do no increment trace_clock_global() by one
Date:   Mon, 21 Jun 2021 18:15:36 +0200
Message-Id: <20210621154918.012183360@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 89529d8b8f8daf92d9979382b8d2eb39966846ea upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_clock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
 


