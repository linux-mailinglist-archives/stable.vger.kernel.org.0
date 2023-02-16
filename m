Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D73C698B42
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 04:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBPDpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 22:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBPDpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 22:45:04 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22B9BDDB;
        Wed, 15 Feb 2023 19:45:02 -0800 (PST)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PHLPq1Lr8zJsW9;
        Thu, 16 Feb 2023 11:43:11 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 16 Feb 2023 11:44:58 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <naveen.n.rao@linux.ibm.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <mhiramat@kernel.org>, <ast@kernel.org>,
        <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <yangjihong1@huawei.com>
Subject: [PATCH v2 2/2] x86/kprobes: Fix arch_check_optimized_kprobe check within optimized_kprobe range
Date:   Thu, 16 Feb 2023 11:42:47 +0800
Message-ID: <20230216034247.32348-3-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
In-Reply-To: <20230216034247.32348-1-yangjihong1@huawei.com>
References: <20230216034247.32348-1-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Fixes: f66c0447cca1 ("kprobes: Set unoptimized flag after unoptimizing code")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 arch/x86/kernel/kprobes/opt.c | 2 +-
 include/linux/kprobes.h       | 1 +
 kernel/kprobes.c              | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index f406bfa9a8cd..57b0037d0a99 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -353,7 +353,7 @@ int arch_check_optimized_kprobe(struct optimized_kprobe *op)
 
 	for (i = 1; i < op->optinsn.size; i++) {
 		p = get_kprobe(op->kp.addr + i);
-		if (p && !kprobe_disabled(p))
+		if (p && !kprobe_disarmed(p))
 			return -EEXIST;
 	}
 
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index ab39285f71a6..85a64cb95d75 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -379,6 +379,7 @@ DEFINE_INSN_CACHE_OPS(optinsn);
 
 extern void wait_for_kprobe_optimizer(void);
 bool optprobe_queued_unopt(struct optimized_kprobe *op);
+bool kprobe_disarmed(struct kprobe *p);
 #else /* !CONFIG_OPTPROBES */
 static inline void wait_for_kprobe_optimizer(void) { }
 #endif /* CONFIG_OPTPROBES */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 90b0fac6efa0..99c3f4de3e5c 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -458,7 +458,7 @@ static inline int kprobe_optready(struct kprobe *p)
 }
 
 /* Return true if the kprobe is disarmed. Note: p must be on hash list */
-static inline bool kprobe_disarmed(struct kprobe *p)
+bool kprobe_disarmed(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
-- 
2.30.GIT

