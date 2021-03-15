Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC3533BAAB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbhCOOKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234627AbhCOOEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7C8464EF8;
        Mon, 15 Mar 2021 14:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817073;
        bh=PfnVeY2t2Sio7VEsOHhFYgCN4N3QZ/B7btLz1CFDubw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrAQoZI2kXqpXvGX8o4kq85dBEo3Asw22UrcsOF0MjBXaM9knrke0uzeGFbu6gHBG
         vdq1B4FLZaBFiD7drbh4fQIlIUuJgkoBAATu6x8VoBR7pQa40P30/GYQH2qjQ8R3Io
         NDA1aPoaNKo9MqaO4+3b6fxo0WKJj5mqwJv5G8YI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Babrou <ivan@cloudflare.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>, stable@kernel.org
Subject: [PATCH 5.11 286/306] x86/unwind/orc: Disable KASAN checking in the ORC unwinder, part 2
Date:   Mon, 15 Mar 2021 14:55:49 +0100
Message-Id: <20210315135517.348763486@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit e504e74cc3a2c092b05577ce3e8e013fae7d94e6 upstream.

KASAN reserves "redzone" areas between stack frames in order to detect
stack overruns.  A read or write to such an area triggers a KASAN
"stack-out-of-bounds" BUG.

Normally, the ORC unwinder stays in-bounds and doesn't access the
redzone.  But sometimes it can't find ORC metadata for a given
instruction.  This can happen for code which is missing ORC metadata, or
for generated code.  In such cases, the unwinder attempts to fall back
to frame pointers, as a best-effort type thing.

This fallback often works, but when it doesn't, the unwinder can get
confused and go off into the weeds into the KASAN redzone, triggering
the aforementioned KASAN BUG.

But in this case, the unwinder's confusion is actually harmless and
working as designed.  It already has checks in place to prevent
off-stack accesses, but those checks get short-circuited by the KASAN
BUG.  And a BUG is a lot more disruptive than a harmless unwinder
warning.

Disable the KASAN checks by using READ_ONCE_NOCHECK() for all stack
accesses.  This finishes the job started by commit 881125bfe65b
("x86/unwind: Disable KASAN checking in the ORC unwinder"), which only
partially fixed the issue.

Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
Reported-by: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Tested-by: Ivan Babrou <ivan@cloudflare.com>
Cc: stable@kernel.org
Link: https://lkml.kernel.org/r/9583327904ebbbeda399eca9c56d6c7085ac20fe.1612534649.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/unwind_orc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -367,8 +367,8 @@ static bool deref_stack_regs(struct unwi
 	if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
 		return false;
 
-	*ip = regs->ip;
-	*sp = regs->sp;
+	*ip = READ_ONCE_NOCHECK(regs->ip);
+	*sp = READ_ONCE_NOCHECK(regs->sp);
 	return true;
 }
 
@@ -380,8 +380,8 @@ static bool deref_stack_iret_regs(struct
 	if (!stack_access_ok(state, addr, IRET_FRAME_SIZE))
 		return false;
 
-	*ip = regs->ip;
-	*sp = regs->sp;
+	*ip = READ_ONCE_NOCHECK(regs->ip);
+	*sp = READ_ONCE_NOCHECK(regs->sp);
 	return true;
 }
 
@@ -402,12 +402,12 @@ static bool get_reg(struct unwind_state
 		return false;
 
 	if (state->full_regs) {
-		*val = ((unsigned long *)state->regs)[reg];
+		*val = READ_ONCE_NOCHECK(((unsigned long *)state->regs)[reg]);
 		return true;
 	}
 
 	if (state->prev_regs) {
-		*val = ((unsigned long *)state->prev_regs)[reg];
+		*val = READ_ONCE_NOCHECK(((unsigned long *)state->prev_regs)[reg]);
 		return true;
 	}
 


