Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D9A65D844
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbjADQNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbjADQMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:12:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DE6615A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:12:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA74A6179F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F98C433F0;
        Wed,  4 Jan 2023 16:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848729;
        bh=OtasWp51uoh1GKZJjeCWnmyPy+gugPGzgdtqTOPndOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XESwv+ctWCpgLBQ92arju+aFpgjJwe7bWRk1kmpZttFje2b+wOslhlTHy+GUolOMY
         2Ll33zxaCMXAUEDGlaOZdsYFg6zNQkJVynW6X/1hFOdqtTr1N2dCP/32YxGACY7Wa7
         RnnTPlRr5wD4X2WUQlG0TG+iWE3qvmNKbYeCDhCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.0 005/177] arm64: Prohibit instrumentation on arch_stack_walk()
Date:   Wed,  4 Jan 2023 17:04:56 +0100
Message-Id: <20230104160507.819828707@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 0fbcd8abf3375052cc7627cc53aba6f2eb189fbb upstream.

Mark arch_stack_walk() as noinstr instead of notrace and inline functions
called from arch_stack_walk() as __always_inline so that user does not
put any instrumentations on it, because this function can be used from
return_address() which is used by lockdep.

Without this, if the kernel built with CONFIG_LOCKDEP=y, just probing
arch_stack_walk() via <tracefs>/kprobe_events will crash the kernel on
arm64.

 # echo p arch_stack_walk >> ${TRACEFS}/kprobe_events
 # echo 1 > ${TRACEFS}/events/kprobes/enable
  kprobes: Failed to recover from reentered kprobes.
  kprobes: Dump kprobe:
  .symbol_name = arch_stack_walk, .offset = 0, .addr = arch_stack_walk+0x0/0x1c0
  ------------[ cut here ]------------
  kernel BUG at arch/arm64/kernel/probes/kprobes.c:241!
  kprobes: Failed to recover from reentered kprobes.
  kprobes: Dump kprobe:
  .symbol_name = arch_stack_walk, .offset = 0, .addr = arch_stack_walk+0x0/0x1c0
  ------------[ cut here ]------------
  kernel BUG at arch/arm64/kernel/probes/kprobes.c:241!
  PREEMPT SMP
  Modules linked in:
  CPU: 0 PID: 17 Comm: migration/0 Tainted: G                 N 6.1.0-rc5+ #6
  Hardware name: linux,dummy-virt (DT)
  Stopper: 0x0 <- 0x0
  pstate: 600003c5 (nZCv DAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : kprobe_breakpoint_handler+0x178/0x17c
  lr : kprobe_breakpoint_handler+0x178/0x17c
  sp : ffff8000080d3090
  x29: ffff8000080d3090 x28: ffff0df5845798c0 x27: ffffc4f59057a774
  x26: ffff0df5ffbba770 x25: ffff0df58f420f18 x24: ffff49006f641000
  x23: ffffc4f590579768 x22: ffff0df58f420f18 x21: ffff8000080d31c0
  x20: ffffc4f590579768 x19: ffffc4f590579770 x18: 0000000000000006
  x17: 5f6b636174735f68 x16: 637261203d207264 x15: 64612e202c30203d
  x14: 2074657366666f2e x13: 30633178302f3078 x12: 302b6b6c61775f6b
  x11: 636174735f686372 x10: ffffc4f590dc5bd8 x9 : ffffc4f58eb31958
  x8 : 00000000ffffefff x7 : ffffc4f590dc5bd8 x6 : 80000000fffff000
  x5 : 000000000000bff4 x4 : 0000000000000000 x3 : 0000000000000000
  x2 : 0000000000000000 x1 : ffff0df5845798c0 x0 : 0000000000000064
  Call trace:
  kprobes: Failed to recover from reentered kprobes.
  kprobes: Dump kprobe:
  .symbol_name = arch_stack_walk, .offset = 0, .addr = arch_stack_walk+0x0/0x1c0
  ------------[ cut here ]------------
  kernel BUG at arch/arm64/kernel/probes/kprobes.c:241!

Fixes: 39ef362d2d45 ("arm64: Make return_address() use arch_stack_walk()")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/166994751368.439920.3236636557520824664.stgit@devnote3
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/stacktrace.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -23,8 +23,8 @@
  *
  * The regs must be on a stack currently owned by the calling task.
  */
-static inline void unwind_init_from_regs(struct unwind_state *state,
-					 struct pt_regs *regs)
+static __always_inline void unwind_init_from_regs(struct unwind_state *state,
+						  struct pt_regs *regs)
 {
 	unwind_init_common(state, current);
 
@@ -58,8 +58,8 @@ static __always_inline void unwind_init_
  * duration of the unwind, or the unwind will be bogus. It is never valid to
  * call this for the current task.
  */
-static inline void unwind_init_from_task(struct unwind_state *state,
-					 struct task_struct *task)
+static __always_inline void unwind_init_from_task(struct unwind_state *state,
+						  struct task_struct *task)
 {
 	unwind_init_common(state, task);
 
@@ -190,7 +190,7 @@ void show_stack(struct task_struct *tsk,
 	barrier();
 }
 
-noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
+noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
 			      void *cookie, struct task_struct *task,
 			      struct pt_regs *regs)
 {


