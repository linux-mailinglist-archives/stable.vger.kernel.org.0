Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DA22A557C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388441AbgKCVS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388674AbgKCVJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65E2C205ED;
        Tue,  3 Nov 2020 21:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437741;
        bh=qYPKpn4mGAPG4AcrVDqkr+LvDahHxitaUN/6VnaLAAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jm9Pxb7CcyxHjdZ11tdQGdFdMZfhr89EeJMEfOyNJAdO7V8qIHFeplym/SNT0Z7jv
         hUtFIo5choieOW1QCwwf8yyCGyqSaZMcDVUhI8bWXtsPu6QQ+AJu0LlgxUjL4zwMWW
         kcvlUe9ebSkfFaY5ri2weqN9kyr4I2lQ4UwAT5CM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 014/125] x86/unwind/orc: Fix inactive tasks with stack pointer in %sp on GCC 10 compiled kernels
Date:   Tue,  3 Nov 2020 21:36:31 +0100
Message-Id: <20201103203158.817761247@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit f2ac57a4c49d40409c21c82d23b5706df9b438af ]

GCC 10 optimizes the scheduler code differently than its predecessors.

When CONFIG_DEBUG_SECTION_MISMATCH=y, the Makefile forces GCC not
to inline some functions (-fno-inline-functions-called-once). Before GCC
10, "no-inlined" __schedule() starts with the usual prologue:

  push %bp
  mov %sp, %bp

So the ORC unwinder simply picks stack pointer from %bp and
unwinds from __schedule() just perfectly:

  $ cat /proc/1/stack
  [<0>] ep_poll+0x3e9/0x450
  [<0>] do_epoll_wait+0xaa/0xc0
  [<0>] __x64_sys_epoll_wait+0x1a/0x20
  [<0>] do_syscall_64+0x33/0x40
  [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

But now, with GCC 10, there is no %bp prologue in __schedule():

  $ cat /proc/1/stack
  <nothing>

The ORC entry of the point in __schedule() is:

  sp:sp+88 bp:last_sp-48 type:call end:0

In this case, nobody subtracts sizeof "struct inactive_task_frame" in
__unwind_start(). The struct is put on the stack by __switch_to_asm() and
only then __switch_to_asm() stores %sp to task->thread.sp. But we start
unwinding from a point in __schedule() (stored in frame->ret_addr by
'call') and not in __switch_to_asm().

So for these example values in __unwind_start():

  sp=ffff94b50001fdc8 bp=ffff8e1f41d29340 ip=__schedule+0x1f0

The stack is:

  ffff94b50001fdc8: ffff8e1f41578000 # struct inactive_task_frame
  ffff94b50001fdd0: 0000000000000000
  ffff94b50001fdd8: ffff8e1f41d29340
  ffff94b50001fde0: ffff8e1f41611d40 # ...
  ffff94b50001fde8: ffffffff93c41920 # bx
  ffff94b50001fdf0: ffff8e1f41d29340 # bp
  ffff94b50001fdf8: ffffffff9376cad0 # ret_addr (and end of the struct)

0xffffffff9376cad0 is __schedule+0x1f0 (after the call to
__switch_to_asm).  Now follow those 88 bytes from the ORC entry (sp+88).
The entry is correct, __schedule() really pushes 48 bytes (8*7) + 32 bytes
via subq to store some local values (like 4U below). So to unwind, look
at the offset 88-sizeof(long) = 0x50 from here:

  ffff94b50001fe00: ffff8e1f41578618
  ffff94b50001fe08: 00000cc000000255
  ffff94b50001fe10: 0000000500000004
  ffff94b50001fe18: 7793fab6956b2d00 # NOTE (see below)
  ffff94b50001fe20: ffff8e1f41578000
  ffff94b50001fe28: ffff8e1f41578000
  ffff94b50001fe30: ffff8e1f41578000
  ffff94b50001fe38: ffff8e1f41578000
  ffff94b50001fe40: ffff94b50001fed8
  ffff94b50001fe48: ffff8e1f41577ff0
  ffff94b50001fe50: ffffffff9376cf12

Here                ^^^^^^^^^^^^^^^^ is the correct ret addr from
__schedule(). It translates to schedule+0x42 (insn after a call to
__schedule()).

BUT, unwind_next_frame() tries to take the address starting from
0xffff94b50001fdc8. That is exactly from thread.sp+88-sizeof(long) =
0xffff94b50001fdc8+88-8 = 0xffff94b50001fe18, which is garbage marked as
NOTE above. So this quits the unwinding as 7793fab6956b2d00 is obviously
not a kernel address.

There was a fix to skip 'struct inactive_task_frame' in
unwind_get_return_address_ptr in the following commit:

  187b96db5ca7 ("x86/unwind/orc: Fix unwind_get_return_address_ptr() for inactive tasks")

But we need to skip the struct already in the unwinder proper. So
subtract the size (increase the stack pointer) of the structure in
__unwind_start() directly. This allows for removal of the code added by
commit 187b96db5ca7 completely, as the address is now at
'(unsigned long *)state->sp - 1', the same as in the generic case.

[ mingo: Cleaned up the changelog a bit, for better readability. ]

Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
Bug: https://bugzilla.suse.com/show_bug.cgi?id=1176907
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20201014053051.24199-1-jslaby@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/unwind_orc.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index a5e2ce931f692..e64c5b78fbfd3 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -255,19 +255,12 @@ EXPORT_SYMBOL_GPL(unwind_get_return_address);
 
 unsigned long *unwind_get_return_address_ptr(struct unwind_state *state)
 {
-	struct task_struct *task = state->task;
-
 	if (unwind_done(state))
 		return NULL;
 
 	if (state->regs)
 		return &state->regs->ip;
 
-	if (task != current && state->sp == task->thread.sp) {
-		struct inactive_task_frame *frame = (void *)task->thread.sp;
-		return &frame->ret_addr;
-	}
-
 	if (state->sp)
 		return (unsigned long *)state->sp - 1;
 
@@ -550,7 +543,7 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 	} else {
 		struct inactive_task_frame *frame = (void *)task->thread.sp;
 
-		state->sp = task->thread.sp;
+		state->sp = task->thread.sp + sizeof(*frame);
 		state->bp = READ_ONCE_NOCHECK(frame->bp);
 		state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
 		state->signal = (void *)state->ip == ret_from_fork;
-- 
2.27.0



