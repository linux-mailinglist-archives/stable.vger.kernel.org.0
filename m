Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D9F35400A
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240618AbhDEJPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240355AbhDEJPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE0E261002;
        Mon,  5 Apr 2021 09:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614097;
        bh=g1GEh3DaFz9pq3eT97ZJ15eZY32UTZJ1ZlJMbDMdH4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03a8uJ7HspxNn9158rmu8h14SFCXnm9SbD/RKqWF+q8QwB8uXuWUztr86FYbRhAPG
         rFQCc8ShsIi+QeMDWUX/5u4JbE0NLCl2yJIxbaV+rigtAirQWMmIAFqaRZcNPGp+e9
         HZbzvVv9H1oCx4uOB13tKCF+Xwu5+0adubFLz5kU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.11 083/152] tracing: Fix stack trace event size
Date:   Mon,  5 Apr 2021 10:53:52 +0200
Message-Id: <20210405085036.947003307@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 9deb193af69d3fd6dd8e47f292b67c805a787010 upstream.

Commit cbc3b92ce037 fixed an issue to modify the macros of the stack trace
event so that user space could parse it properly. Originally the stack
trace format to user space showed that the called stack was a dynamic
array. But it is not actually a dynamic array, in the way that other
dynamic event arrays worked, and this broke user space parsing for it. The
update was to make the array look to have 8 entries in it. Helper
functions were added to make it parse it correctly, as the stack was
dynamic, but was determined by the size of the event stored.

Although this fixed user space on how it read the event, it changed the
internal structure used for the stack trace event. It changed the array
size from [0] to [8] (added 8 entries). This increased the size of the
stack trace event by 8 words. The size reserved on the ring buffer was the
size of the stack trace event plus the number of stack entries found in
the stack trace. That commit caused the amount to be 8 more than what was
needed because it did not expect the caller field to have any size. This
produced 8 entries of garbage (and reading random data) from the stack
trace event:

          <idle>-0       [002] d... 1976396.837549: <stack trace>
 => trace_event_raw_event_sched_switch
 => __traceiter_sched_switch
 => __schedule
 => schedule_idle
 => do_idle
 => cpu_startup_entry
 => secondary_startup_64_no_verify
 => 0xc8c5e150ffff93de
 => 0xffff93de
 => 0
 => 0
 => 0xc8c5e17800000000
 => 0x1f30affff93de
 => 0x00000004
 => 0x200000000

Instead, subtract the size of the caller field from the size of the event
to make sure that only the amount needed to store the stack trace is
reserved.

Link: https://lore.kernel.org/lkml/your-ad-here.call-01617191565-ext-9692@work.hours/

Cc: stable@vger.kernel.org
Fixes: cbc3b92ce037 ("tracing: Set kernel_stack's caller size properly")
Reported-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Vasily Gorbik <gor@linux.ibm.com>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2984,7 +2984,8 @@ static void __ftrace_trace_stack(struct
 
 	size = nr_entries * sizeof(unsigned long);
 	event = __trace_buffer_lock_reserve(buffer, TRACE_STACK,
-					    sizeof(*entry) + size, flags, pc);
+				    (sizeof(*entry) - sizeof(entry->caller)) + size,
+				    flags, pc);
 	if (!event)
 		goto out;
 	entry = ring_buffer_event_data(event);


