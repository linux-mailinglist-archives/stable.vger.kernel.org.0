Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4888F6B45E1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbjCJOiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbjCJOiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:38:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8935F8F2F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:37:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C18BAB822E3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298DFC4339C;
        Fri, 10 Mar 2023 14:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459070;
        bh=eEWdMEfgYi6bXxDwofG6Lz/FNiAtm7mD9df/w6jkscI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgC7m/kOd6b1v+s38569l+lh708hDHOs5Wj2NpwUqvgdXnkGjtbgh1nh9m7ms22mP
         8uOfEq1lI5sTUV/BN0i6BzivTlmMG+bn3qIywRGJuW7VqUV52GJ3bJjVZPmPuxVlqJ
         G60Dmo0TLHCARev7AN3XWjxgsKjrzNQUzqE2T28g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Jihong <yangjihong1@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.4 238/357] x86/kprobes: Fix arch_check_optimized_kprobe check within optimized_kprobe range
Date:   Fri, 10 Mar 2023 14:38:47 +0100
Message-Id: <20230310133745.245112858@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Jihong <yangjihong1@huawei.com>

commit f1c97a1b4ef709e3f066f82e3ba3108c3b133ae6 upstream.

When arch_prepare_optimized_kprobe calculating jump destination address,
it copies original instructions from jmp-optimized kprobe (see
__recover_optprobed_insn), and calculated based on length of original
instruction.

arch_check_optimized_kprobe does not check KPROBE_FLAG_OPTIMATED when
checking whether jmp-optimized kprobe exists.
As a result, setup_detour_execution may jump to a range that has been
overwritten by jump destination address, resulting in an inval opcode error.

For example, assume that register two kprobes whose addresses are
<func+9> and <func+11> in "func" function.
The original code of "func" function is as follows:

   0xffffffff816cb5e9 <+9>:     push   %r12
   0xffffffff816cb5eb <+11>:    xor    %r12d,%r12d
   0xffffffff816cb5ee <+14>:    test   %rdi,%rdi
   0xffffffff816cb5f1 <+17>:    setne  %r12b
   0xffffffff816cb5f5 <+21>:    push   %rbp

1.Register the kprobe for <func+11>, assume that is kp1, corresponding optimized_kprobe is op1.
  After the optimization, "func" code changes to:

   0xffffffff816cc079 <+9>:     push   %r12
   0xffffffff816cc07b <+11>:    jmp    0xffffffffa0210000
   0xffffffff816cc080 <+16>:    incl   0xf(%rcx)
   0xffffffff816cc083 <+19>:    xchg   %eax,%ebp
   0xffffffff816cc084 <+20>:    (bad)
   0xffffffff816cc085 <+21>:    push   %rbp

Now op1->flags == KPROBE_FLAG_OPTIMATED;

2. Register the kprobe for <func+9>, assume that is kp2, corresponding optimized_kprobe is op2.

register_kprobe(kp2)
  register_aggr_kprobe
    alloc_aggr_kprobe
      __prepare_optimized_kprobe
        arch_prepare_optimized_kprobe
          __recover_optprobed_insn    // copy original bytes from kp1->optinsn.copied_insn,
                                      // jump address = <func+14>

3. disable kp1:

disable_kprobe(kp1)
  __disable_kprobe
    ...
    if (p == orig_p || aggr_kprobe_disabled(orig_p)) {
      ret = disarm_kprobe(orig_p, true)       // add op1 in unoptimizing_list, not unoptimized
      orig_p->flags |= KPROBE_FLAG_DISABLED;  // op1->flags ==  KPROBE_FLAG_OPTIMATED | KPROBE_FLAG_DISABLED
    ...

4. unregister kp2
__unregister_kprobe_top
  ...
  if (!kprobe_disabled(ap) && !kprobes_all_disarmed) {
    optimize_kprobe(op)
      ...
      if (arch_check_optimized_kprobe(op) < 0) // because op1 has KPROBE_FLAG_DISABLED, here not return
        return;
      p->kp.flags |= KPROBE_FLAG_OPTIMIZED;   //  now op2 has KPROBE_FLAG_OPTIMIZED
  }

"func" code now is:

   0xffffffff816cc079 <+9>:     int3
   0xffffffff816cc07a <+10>:    push   %rsp
   0xffffffff816cc07b <+11>:    jmp    0xffffffffa0210000
   0xffffffff816cc080 <+16>:    incl   0xf(%rcx)
   0xffffffff816cc083 <+19>:    xchg   %eax,%ebp
   0xffffffff816cc084 <+20>:    (bad)
   0xffffffff816cc085 <+21>:    push   %rbp

5. if call "func", int3 handler call setup_detour_execution:

  if (p->flags & KPROBE_FLAG_OPTIMIZED) {
    ...
    regs->ip = (unsigned long)op->optinsn.insn + TMPL_END_IDX;
    ...
  }

The code for the destination address is

   0xffffffffa021072c:  push   %r12
   0xffffffffa021072e:  xor    %r12d,%r12d
   0xffffffffa0210731:  jmp    0xffffffff816cb5ee <func+14>

However, <func+14> is not a valid start instruction address. As a result, an error occurs.

Link: https://lore.kernel.org/all/20230216034247.32348-3-yangjihong1@huawei.com/

Fixes: f66c0447cca1 ("kprobes: Set unoptimized flag after unoptimizing code")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Cc: stable@vger.kernel.org
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/opt.c |    2 +-
 include/linux/kprobes.h       |    1 +
 kernel/kprobes.c              |    4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -314,7 +314,7 @@ int arch_check_optimized_kprobe(struct o
 
 	for (i = 1; i < op->optinsn.size; i++) {
 		p = get_kprobe(op->kp.addr + i);
-		if (p && !kprobe_disabled(p))
+		if (p && !kprobe_disarmed(p))
 			return -EEXIST;
 	}
 
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -319,6 +319,7 @@ extern int proc_kprobes_optimization_han
 #endif
 extern void wait_for_kprobe_optimizer(void);
 bool optprobe_queued_unopt(struct optimized_kprobe *op);
+bool kprobe_disarmed(struct kprobe *p);
 #else
 static inline void wait_for_kprobe_optimizer(void) { }
 #endif /* CONFIG_OPTPROBES */
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -406,8 +406,8 @@ static inline int kprobe_optready(struct
 	return 0;
 }
 
-/* Return true(!0) if the kprobe is disarmed. Note: p must be on hash list */
-static inline int kprobe_disarmed(struct kprobe *p)
+/* Return true if the kprobe is disarmed. Note: p must be on hash list */
+bool kprobe_disarmed(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 


