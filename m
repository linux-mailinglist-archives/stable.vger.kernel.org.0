Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B83C451FCA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241129AbhKPApZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232241AbhKOTVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A7DF63378;
        Mon, 15 Nov 2021 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001844;
        bh=HANXrd2/9MTOGH8hczRCGiawaKbg0JM76CqO71X4+oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGUtSbFWfX5q75U4wBW/IQIU8vilFzQQhDyMhTscfb4xF32M7311+ygxd1xh0fqcH
         131/TUec2ssqHedxXya9F8StPKE/3sHMU8j+1dtn2k/IHaUUxeziqsw872ctYTAJ9p
         BqASwmIEVX4Eld/W7HS7MceNti4G4AQGyaW3PdFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Guo Ren <guoren@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Abaci <abaci@linux.alibaba.com>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/917] ftrace: do CPU checking after preemption disabled
Date:   Mon, 15 Nov 2021 17:56:43 +0100
Message-Id: <20211115165439.198917033@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 王贇 <yun.wang@linux.alibaba.com>

[ Upstream commit d33cc657372366a8959f099c619a208b4c5dc664 ]

With CONFIG_DEBUG_PREEMPT we observed reports like:

  BUG: using smp_processor_id() in preemptible
  caller is perf_ftrace_function_call+0x6f/0x2e0
  CPU: 1 PID: 680 Comm: a.out Not tainted
  Call Trace:
   <TASK>
   dump_stack_lvl+0x8d/0xcf
   check_preemption_disabled+0x104/0x110
   ? optimize_nops.isra.7+0x230/0x230
   ? text_poke_bp_batch+0x9f/0x310
   perf_ftrace_function_call+0x6f/0x2e0
   ...
   __text_poke+0x5/0x620
   text_poke_bp_batch+0x9f/0x310

This telling us the CPU could be changed after task is preempted, and
the checking on CPU before preemption will be invalid.

Since now ftrace_test_recursion_trylock() will help to disable the
preemption, this patch just do the checking after trylock() to address
the issue.

Link: https://lkml.kernel.org/r/54880691-5fe2-33e7-d12f-1fa6136f5183@linux.alibaba.com

CC: Steven Rostedt <rostedt@goodmis.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Jisheng Zhang <jszhang@kernel.org>
Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_event_perf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 6aed10e2f7ce0..fba8cb77a73af 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -441,13 +441,13 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
 	if (!rcu_is_watching())
 		return;
 
-	if ((unsigned long)ops->private != smp_processor_id())
-		return;
-
 	bit = ftrace_test_recursion_trylock(ip, parent_ip);
 	if (bit < 0)
 		return;
 
+	if ((unsigned long)ops->private != smp_processor_id())
+		goto out;
+
 	event = container_of(ops, struct perf_event, ftrace_ops);
 
 	/*
-- 
2.33.0



