Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AE21E2E09
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391511AbgEZTFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391510AbgEZTFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27CFC20873;
        Tue, 26 May 2020 19:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519933;
        bh=jx3K9gvlPa4X4mgLce8D9qbCcXHG4T5cLM5C7xiUHIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJohIplYg9VAMW/Y1MDA9rvd53a/PWkOTaqrL+x5cv5Aaknd9/FSI5W3l0QrYWx8Q
         Tna6PtkJTkUYeyuV7T3aJzVuGYdslHFE7nYLAyx6G2c1UDQIrEAxY695Pcv7Z1CCyi
         3jtzVkXPzOt+XxQg2K73FFUn382iotG0sS6KRLDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.19 74/81] x86/unwind/orc: Fix unwind_get_return_address_ptr() for inactive tasks
Date:   Tue, 26 May 2020 20:53:49 +0200
Message-Id: <20200526183935.279225178@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 187b96db5ca79423618dfa29a05c438c34f9e1f0 upstream.

Normally, show_trace_log_lvl() scans the stack, looking for text
addresses to print.  In parallel, it unwinds the stack with
unwind_next_frame().  If the stack address matches the pointer returned
by unwind_get_return_address_ptr() for the current frame, the text
address is printed normally without a question mark.  Otherwise it's
considered a breadcrumb (potentially from a previous call path) and it's
printed with a question mark to indicate that the address is unreliable
and typically can be ignored.

Since the following commit:

  f1d9a2abff66 ("x86/unwind/orc: Don't skip the first frame for inactive tasks")

... for inactive tasks, show_trace_log_lvl() prints *only* unreliable
addresses (prepended with '?').

That happens because, for the first frame of an inactive task,
unwind_get_return_address_ptr() returns the wrong return address
pointer: one word *below* the task stack pointer.  show_trace_log_lvl()
starts scanning at the stack pointer itself, so it never finds the first
'reliable' address, causing only guesses to being printed.

The first frame of an inactive task isn't a normal stack frame.  It's
actually just an instance of 'struct inactive_task_frame' which is left
behind by __switch_to_asm().  Now that this inactive frame is actually
exposed to callers, fix unwind_get_return_address_ptr() to interpret it
properly.

Fixes: f1d9a2abff66 ("x86/unwind/orc: Don't skip the first frame for inactive tasks")
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200522135435.vbxs7umku5pyrdbk@treble
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/unwind_orc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -300,12 +300,19 @@ EXPORT_SYMBOL_GPL(unwind_get_return_addr
 
 unsigned long *unwind_get_return_address_ptr(struct unwind_state *state)
 {
+	struct task_struct *task = state->task;
+
 	if (unwind_done(state))
 		return NULL;
 
 	if (state->regs)
 		return &state->regs->ip;
 
+	if (task != current && state->sp == task->thread.sp) {
+		struct inactive_task_frame *frame = (void *)task->thread.sp;
+		return &frame->ret_addr;
+	}
+
 	if (state->sp)
 		return (unsigned long *)state->sp - 1;
 


