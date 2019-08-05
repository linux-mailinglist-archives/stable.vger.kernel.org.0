Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF0F81CF8
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbfHENXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729103AbfHENXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:23:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC0DB2067D;
        Mon,  5 Aug 2019 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011398;
        bh=bVKtZbN9rtW/cD/kOWvK9wk6jF0LAT151bZvHyQi7sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGTdrxjfXM/sjUFPhXsGYryjVsqSJaG3dY5/01eEOr/BQn6NPqGPRGbOCkjlr7p2T
         Hd5IJpnczSSVpg/Lgh1ghTBCnneixcSoqccuPFV3tZbk38cgFpCMOehyMoJp9R/vcY
         SHH510eXoJo/RhthQg6yg4IpYFCiIuYo9rgCAzhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 071/131] bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()
Date:   Mon,  5 Aug 2019 15:02:38 +0200
Message-Id: <20190805124956.311636834@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3193c0836f203a91bef96d88c64cccf0be090d9c ]

On x86-64, with CONFIG_RETPOLINE=n, GCC's "global common subexpression
elimination" optimization results in ___bpf_prog_run()'s jumptable code
changing from this:

	select_insn:
		jmp *jumptable(, %rax, 8)
		...
	ALU64_ADD_X:
		...
		jmp *jumptable(, %rax, 8)
	ALU_ADD_X:
		...
		jmp *jumptable(, %rax, 8)

to this:

	select_insn:
		mov jumptable, %r12
		jmp *(%r12, %rax, 8)
		...
	ALU64_ADD_X:
		...
		jmp *(%r12, %rax, 8)
	ALU_ADD_X:
		...
		jmp *(%r12, %rax, 8)

The jumptable address is placed in a register once, at the beginning of
the function.  The function execution can then go through multiple
indirect jumps which rely on that same register value.  This has a few
issues:

1) Objtool isn't smart enough to be able to track such a register value
   across multiple recursive indirect jumps through the jump table.

2) With CONFIG_RETPOLINE enabled, this optimization actually results in
   a small slowdown.  I measured a ~4.7% slowdown in the test_bpf
   "tcpdump port 22" selftest.

   This slowdown is actually predicted by the GCC manual:

     Note: When compiling a program using computed gotos, a GCC
     extension, you may get better run-time performance if you
     disable the global common subexpression elimination pass by
     adding -fno-gcse to the command line.

So just disable the optimization for this function.

Fixes: e55a73251da3 ("bpf: Fix ORC unwinding in non-JIT BPF code")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/30c3ca29ba037afcbd860a8672eef0021addf9fe.1563413318.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-gcc.h   | 2 ++
 include/linux/compiler_types.h | 4 ++++
 kernel/bpf/core.c              | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index e8579412ad214..d7ee4c6bad482 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -170,3 +170,5 @@
 #else
 #define __diag_GCC_8(s)
 #endif
+
+#define __no_fgcse __attribute__((optimize("-fno-gcse")))
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 19e58b9138a04..0454d82f8bd82 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -187,6 +187,10 @@ struct ftrace_likely_data {
 #define asm_volatile_goto(x...) asm goto(x)
 #endif
 
+#ifndef __no_fgcse
+# define __no_fgcse
+#endif
+
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index f2148db91439e..ceee0730fba58 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1295,7 +1295,7 @@ bool bpf_opcode_in_insntable(u8 code)
  *
  * Decode and execute eBPF instructions.
  */
-static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
+static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 {
 #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
 #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
-- 
2.20.1



