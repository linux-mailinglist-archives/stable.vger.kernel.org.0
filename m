Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46532CA7AA
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403957AbgLAQB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391860AbgLAQB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 11:01:28 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FD8622247;
        Tue,  1 Dec 2020 16:00:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kk84U-002R9s-Uc; Tue, 01 Dec 2020 11:00:06 -0500
Message-ID: <20201201160006.827647495@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 01 Dec 2020 10:58:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 12/12] ring-buffer: Always check to put back before stamp when crossing
 pages
References: <20201201155835.647858317@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The current ring buffer logic checks to see if the updating of the event
buffer was interrupted, and if it is, it will try to fix up the before stamp
with the write stamp to make them equal again. This logic is flawed, because
if it is not interrupted, the two are guaranteed to be different, as the
current event just updated the before stamp before allocation. This
guarantees that the next event (this one or another interrupting one) will
think it interrupted the time updates of a previous event and inject an
absolute time stamp to compensate.

The correct logic is to always update the timestamps when traversing to a
new sub buffer.

Cc: stable@vger.kernel.org
Fixes: a389d86f7fd09 ("ring-buffer: Have nested events still record running time stamp")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 35d91b20d47a..a6268e09160a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3234,14 +3234,12 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 
 	/* See if we shot pass the end of this buffer page */
 	if (unlikely(write > BUF_PAGE_SIZE)) {
-		if (tail != w) {
-			/* before and after may now different, fix it up*/
-			b_ok = rb_time_read(&cpu_buffer->before_stamp, &info->before);
-			a_ok = rb_time_read(&cpu_buffer->write_stamp, &info->after);
-			if (a_ok && b_ok && info->before != info->after)
-				(void)rb_time_cmpxchg(&cpu_buffer->before_stamp,
-						      info->before, info->after);
-		}
+		/* before and after may now different, fix it up*/
+		b_ok = rb_time_read(&cpu_buffer->before_stamp, &info->before);
+		a_ok = rb_time_read(&cpu_buffer->write_stamp, &info->after);
+		if (a_ok && b_ok && info->before != info->after)
+			(void)rb_time_cmpxchg(&cpu_buffer->before_stamp,
+					      info->before, info->after);
 		return rb_move_tail(cpu_buffer, tail, info);
 	}
 
-- 
2.28.0


