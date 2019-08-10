Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1AD888D3C
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfHJUn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:43:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54450 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726707AbfHJUn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:56 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDQ-00053r-6U; Sat, 10 Aug 2019 21:43:52 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-0003he-8n; Sat, 10 Aug 2019 21:43:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Roman Gushchin" <guro@fb.com>,
        "Will Deacon" <will.deacon@arm.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "huang ying" <huang.ying.caritas@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Davidlohr Bueso" <dave@stgolabs.net>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Waiman Long" <longman@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.775611502@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 112/157] trace: Fix preempt_enable_no_resched() abuse
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit d6097c9e4454adf1f8f2c9547c2fa6060d55d952 upstream.

Unless the very next line is schedule(), or implies it, one must not use
preempt_enable_no_resched(). It can cause a preemption to go missing and
thereby cause arbitrary delays, breaking the PREEMPT=y invariant.

Link: http://lkml.kernel.org/r/20190423200318.GY14281@hirez.programming.kicks-ass.net

Cc: Waiman Long <longman@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Fixes: 2c2d7329d8af ("tracing/ftrace: use preempt_enable_no_resched_notrace in ring_buffer_time_stamp()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -729,7 +729,7 @@ u64 ring_buffer_time_stamp(struct ring_b
 
 	preempt_disable_notrace();
 	time = rb_time_stamp(buffer);
-	preempt_enable_no_resched_notrace();
+	preempt_enable_notrace();
 
 	return time;
 }

