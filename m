Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B25B1D8417
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733130AbgERSGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733111AbgERSGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:06:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB4F20715;
        Mon, 18 May 2020 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825177;
        bh=UhPmA86skCTZ0I4hcyBv0aJ4L7RzqQ9W+BIRB10S1Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtTeBza3nHRbvgCPGMa9Ui1hol3LDG4Y4dSPvEFs/6kmdVWY/iHsBco8bReFucHGp
         o3O9fmT8ks+3mJAY72yWDlDyZfW7bHKIC3RWOIH8qu7V26+rMG+eUe0Em3rAAFk465
         sERL/KdOxoop1oUG0cE3UUwPQNIrbH7c9qXyLpWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.6 159/194] x86/unwind/orc: Fix error handling in __unwind_start()
Date:   Mon, 18 May 2020 19:37:29 +0200
Message-Id: <20200518173544.427788088@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 71c95825289f585014fe9741b051d32a7a916680 upstream.

The unwind_state 'error' field is used to inform the reliable unwinding
code that the stack trace can't be trusted.  Set this field for all
errors in __unwind_start().

Also, move the zeroing out of the unwind_state struct to before the ORC
table initialization check, to prevent the caller from reading
uninitialized data if the ORC table is corrupted.

Fixes: af085d9084b4 ("stacktrace/x86: add function for detecting reliable stack traces")
Fixes: d3a09104018c ("x86/unwinder/orc: Dont bail on stack overflow")
Fixes: 98d0c8ebf77e ("x86/unwind/orc: Prevent unwinding before ORC initialization")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/d6ac7215a84ca92b895fdd2e1aa546729417e6e6.1589487277.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/unwind_orc.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -611,23 +611,23 @@ EXPORT_SYMBOL_GPL(unwind_next_frame);
 void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		    struct pt_regs *regs, unsigned long *first_frame)
 {
-	if (!orc_init)
-		goto done;
-
 	memset(state, 0, sizeof(*state));
 	state->task = task;
 
+	if (!orc_init)
+		goto err;
+
 	/*
 	 * Refuse to unwind the stack of a task while it's executing on another
 	 * CPU.  This check is racy, but that's ok: the unwinder has other
 	 * checks to prevent it from going off the rails.
 	 */
 	if (task_on_another_cpu(task))
-		goto done;
+		goto err;
 
 	if (regs) {
 		if (user_mode(regs))
-			goto done;
+			goto the_end;
 
 		state->ip = regs->ip;
 		state->sp = regs->sp;
@@ -660,6 +660,7 @@ void __unwind_start(struct unwind_state
 		 * generate some kind of backtrace if this happens.
 		 */
 		void *next_page = (void *)PAGE_ALIGN((unsigned long)state->sp);
+		state->error = true;
 		if (get_stack_info(next_page, state->task, &state->stack_info,
 				   &state->stack_mask))
 			return;
@@ -685,8 +686,9 @@ void __unwind_start(struct unwind_state
 
 	return;
 
-done:
+err:
+	state->error = true;
+the_end:
 	state->stack_info.type = STACK_TYPE_UNKNOWN;
-	return;
 }
 EXPORT_SYMBOL_GPL(__unwind_start);


