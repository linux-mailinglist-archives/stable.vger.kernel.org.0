Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9912F1E2D9A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391491AbgEZTWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390048AbgEZTKM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:10:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCAAF208B3;
        Tue, 26 May 2020 19:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520212;
        bh=GU2D2mRPFvVsOoMBcRg66MyY3nXhu9te59IzEmrUMN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLMc7xtUFONavf120fZnPFi6Q6PiRiEV3RceEHLrKnVeZnQ7WIljHYnBTSYzIbIv9
         6hRgS0d//LZSKN6DIRvBT1euNy7i2bTt1/30po6G8KdokZOgr4mNyh+cSspEuw8vxU
         YFGBYKlWSws1x1SkYAFUTBHHA/EYtLuesgvX+a4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 101/111] x86/unwind/orc: Fix unwind_get_return_address_ptr() for inactive tasks
Date:   Tue, 26 May 2020 20:53:59 +0200
Message-Id: <20200526183942.478236620@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
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
@@ -311,12 +311,19 @@ EXPORT_SYMBOL_GPL(unwind_get_return_addr
 
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
 


