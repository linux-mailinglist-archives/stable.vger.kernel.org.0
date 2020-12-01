Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D022CA7A6
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391995AbgLAQB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388270AbgLAQB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 11:01:27 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23FE02224A;
        Tue,  1 Dec 2020 16:00:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kk84U-002R6y-1M; Tue, 01 Dec 2020 11:00:06 -0500
Message-ID: <20201201160005.921595496@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 01 Dec 2020 10:58:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org,
        Andrea Righi <andrea.righi@canonical.com>
Subject: [for-linus][PATCH 06/12] ring-buffer: Set the right timestamp in the slow path of
 __rb_reserve_next()
References: <20201201155835.647858317@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Righi <andrea.righi@canonical.com>

In the slow path of __rb_reserve_next() a nested event(s) can happen
between evaluating the timestamp delta of the current event and updating
write_stamp via local_cmpxchg(); in this case the delta is not valid
anymore and it should be set to 0 (same timestamp as the interrupting
event), since the event that we are currently processing is not the last
event in the buffer.

Link: https://lkml.kernel.org/r/X8IVJcp1gRE+FJCJ@xps-13-7390

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lwn.net/Articles/831207
Fixes: a389d86f7fd0 ("ring-buffer: Have nested events still record running time stamp")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bccaf88d3706..35d91b20d47a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3287,11 +3287,11 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		ts = rb_time_stamp(cpu_buffer->buffer);
 		barrier();
  /*E*/		if (write == (local_read(&tail_page->write) & RB_WRITE_MASK) &&
-		    info->after < ts) {
+		    info->after < ts &&
+		    rb_time_cmpxchg(&cpu_buffer->write_stamp,
+				    info->after, ts)) {
 			/* Nothing came after this event between C and E */
 			info->delta = ts - info->after;
-			(void)rb_time_cmpxchg(&cpu_buffer->write_stamp,
-					      info->after, ts);
 			info->ts = ts;
 		} else {
 			/*
-- 
2.28.0


