Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3566177F6B
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbgCCRul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731540AbgCCRuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:50:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F6220870;
        Tue,  3 Mar 2020 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257839;
        bh=v7LP2winjKetF0qZfTiptQyPeagnjzB8CG1jVUdNI6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlozodSvIIxDKA6ubcKLT6ra7jddrshoW5b02EnGNUZHlz1oAlfuCvx+j0UJb3CmF
         QGlQy7z90zKhwrydxyoAB7Pftpbhq1D36VJ9cG3b8Ael02yiaaxUR3SfHFNiv5rbN5
         vlPOBkWlhasNlpG/860OdJOmD2Jey8Y2ukdYcjD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, bristot@redhat.com,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.5 149/176] kprobes: Set unoptimized flag after unoptimizing code
Date:   Tue,  3 Mar 2020 18:43:33 +0100
Message-Id: <20200303174321.922319806@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit f66c0447cca1281116224d474cdb37d6a18e4b5b upstream.

Set the unoptimized flag after confirming the code is completely
unoptimized. Without this fix, when a kprobe hits the intermediate
modified instruction (the first byte is replaced by an INT3, but
later bytes can still be a jump address operand) while unoptimizing,
it can return to the middle byte of the modified code, which causes
an invalid instruction exception in the kernel.

Usually, this is a rare case, but if we put a probe on the function
call while text patching, it always causes a kernel panic as below:

 # echo p text_poke+5 > kprobe_events
 # echo 1 > events/kprobes/enable
 # echo 0 > events/kprobes/enable

invalid opcode: 0000 [#1] PREEMPT SMP PTI
 RIP: 0010:text_poke+0x9/0x50
 Call Trace:
  arch_unoptimize_kprobe+0x22/0x28
  arch_unoptimize_kprobes+0x39/0x87
  kprobe_optimizer+0x6e/0x290
  process_one_work+0x2a0/0x610
  worker_thread+0x28/0x3d0
  ? process_one_work+0x610/0x610
  kthread+0x10d/0x130
  ? kthread_park+0x80/0x80
  ret_from_fork+0x3a/0x50

text_poke() is used for patching the code in optprobes.

This can happen even if we blacklist text_poke() and other functions,
because there is a small time window during which we show the intermediate
code to other CPUs.

 [ mingo: Edited the changelog. ]

Tested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bristot@redhat.com
Fixes: 6274de4984a6 ("kprobes: Support delayed unoptimizing")
Link: https://lkml.kernel.org/r/157483422375.25881.13508326028469515760.stgit@devnote2
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kprobes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -510,6 +510,8 @@ static void do_unoptimize_kprobes(void)
 	arch_unoptimize_kprobes(&unoptimizing_list, &freeing_list);
 	/* Loop free_list for disarming */
 	list_for_each_entry_safe(op, tmp, &freeing_list, list) {
+		/* Switching from detour code to origin */
+		op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
 		/* Disarm probes if marked disabled */
 		if (kprobe_disabled(&op->kp))
 			arch_disarm_kprobe(&op->kp);
@@ -665,6 +667,7 @@ static void force_unoptimize_kprobe(stru
 {
 	lockdep_assert_cpus_held();
 	arch_unoptimize_kprobe(op);
+	op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
 	if (kprobe_disabled(&op->kp))
 		arch_disarm_kprobe(&op->kp);
 }
@@ -681,7 +684,6 @@ static void unoptimize_kprobe(struct kpr
 	if (!kprobe_optimized(p))
 		return;
 
-	op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
 	if (!list_empty(&op->list)) {
 		if (optprobe_queued_unopt(op)) {
 			/* Queued in unoptimizing queue */


