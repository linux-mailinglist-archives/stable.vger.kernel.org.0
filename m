Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6374F99CD4
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392186AbfHVRhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404273AbfHVRYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:39 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 332092341E;
        Thu, 22 Aug 2019 17:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494678;
        bh=wy5KoSJmIv5PrAHz5Ep3SD8p4yqJdHmOkyvC/C4rbK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlzT0A+bdXsuzIAnlrvx6xDC8dHL96EkqAeEvxR+5mD5shSLZx+CXet9FrQFK32jl
         x6kGhSkY2EFfbxK+fYeiDF8ovPXp7xHZozoczVsViw9LTl8viU9HFpPrO1e2dwp391
         ndGSX0foAmpc+rBJ85Zuc5LeUUBMwVZtk/yPS1ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 05/71] bpf: get rid of pure_initcall dependency to enable jits
Date:   Thu, 22 Aug 2019 10:18:40 -0700
Message-Id: <20190822171726.700480610@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit fa9dd599b4dae841924b022768354cfde9affecb upstream.

Having a pure_initcall() callback just to permanently enable BPF
JITs under CONFIG_BPF_JIT_ALWAYS_ON is unnecessary and could leave
a small race window in future where JIT is still disabled on boot.
Since we know about the setting at compilation time anyway, just
initialize it properly there. Also consolidate all the individual
bpf_jit_enable variables into a single one and move them under one
location. Moreover, don't allow for setting unspecified garbage
values on them.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[bwh: Backported to 4.14 as dependency of commit 2e4a30983b0f
 "bpf: restrict access to core bpf sysctls":
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/net/bpf_jit_32.c         |    2 --
 arch/arm64/net/bpf_jit_comp.c     |    2 --
 arch/mips/net/bpf_jit.c           |    2 --
 arch/mips/net/ebpf_jit.c          |    2 --
 arch/powerpc/net/bpf_jit_comp.c   |    2 --
 arch/powerpc/net/bpf_jit_comp64.c |    2 --
 arch/s390/net/bpf_jit_comp.c      |    2 --
 arch/sparc/net/bpf_jit_comp_32.c  |    2 --
 arch/sparc/net/bpf_jit_comp_64.c  |    2 --
 arch/x86/net/bpf_jit_comp.c       |    2 --
 kernel/bpf/core.c                 |   19 ++++++++++++-------
 net/core/sysctl_net_core.c        |   18 ++++++++++++------
 net/socket.c                      |    9 ---------
 13 files changed, 24 insertions(+), 42 deletions(-)

--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -25,8 +25,6 @@
 
 #include "bpf_jit_32.h"
 
-int bpf_jit_enable __read_mostly;
-
 /*
  * eBPF prog stack layout:
  *
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -31,8 +31,6 @@
 
 #include "bpf_jit.h"
 
-int bpf_jit_enable __read_mostly;
-
 #define TMP_REG_1 (MAX_BPF_JIT_REG + 0)
 #define TMP_REG_2 (MAX_BPF_JIT_REG + 1)
 #define TCALL_CNT (MAX_BPF_JIT_REG + 2)
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -1207,8 +1207,6 @@ jmp_cmp:
 	return 0;
 }
 
-int bpf_jit_enable __read_mostly;
-
 void bpf_jit_compile(struct bpf_prog *fp)
 {
 	struct jit_ctx ctx;
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -177,8 +177,6 @@ static u32 b_imm(unsigned int tgt, struc
 		(ctx->idx * 4) - 4;
 }
 
-int bpf_jit_enable __read_mostly;
-
 enum which_ebpf_reg {
 	src_reg,
 	src_reg_no_fp,
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -18,8 +18,6 @@
 
 #include "bpf_jit32.h"
 
-int bpf_jit_enable __read_mostly;
-
 static inline void bpf_flush_icache(void *start, void *end)
 {
 	smp_wmb();
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -21,8 +21,6 @@
 
 #include "bpf_jit64.h"
 
-int bpf_jit_enable __read_mostly;
-
 static void bpf_jit_fill_ill_insns(void *area, unsigned int size)
 {
 	memset32(area, BREAKPOINT_INSTRUCTION, size/4);
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -30,8 +30,6 @@
 #include <asm/set_memory.h>
 #include "bpf_jit.h"
 
-int bpf_jit_enable __read_mostly;
-
 struct bpf_jit {
 	u32 seen;		/* Flags to remember seen eBPF instructions */
 	u32 seen_reg[16];	/* Array to remember which registers are used */
--- a/arch/sparc/net/bpf_jit_comp_32.c
+++ b/arch/sparc/net/bpf_jit_comp_32.c
@@ -11,8 +11,6 @@
 
 #include "bpf_jit_32.h"
 
-int bpf_jit_enable __read_mostly;
-
 static inline bool is_simm13(unsigned int value)
 {
 	return value + 0x1000 < 0x2000;
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -12,8 +12,6 @@
 
 #include "bpf_jit_64.h"
 
-int bpf_jit_enable __read_mostly;
-
 static inline bool is_simm13(unsigned int value)
 {
 	return value + 0x1000 < 0x2000;
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -16,8 +16,6 @@
 #include <asm/nospec-branch.h>
 #include <linux/bpf.h>
 
-int bpf_jit_enable __read_mostly;
-
 /*
  * assembly code in arch/x86/net/bpf_jit.S
  */
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -290,6 +290,11 @@ struct bpf_prog *bpf_patch_insn_single(s
 }
 
 #ifdef CONFIG_BPF_JIT
+/* All BPF JIT sysctl knobs here. */
+int bpf_jit_enable   __read_mostly = IS_BUILTIN(CONFIG_BPF_JIT_ALWAYS_ON);
+int bpf_jit_harden   __read_mostly;
+int bpf_jit_kallsyms __read_mostly;
+
 static __always_inline void
 bpf_get_prog_addr_region(const struct bpf_prog *prog,
 			 unsigned long *symbol_start,
@@ -358,8 +363,6 @@ static DEFINE_SPINLOCK(bpf_lock);
 static LIST_HEAD(bpf_kallsyms);
 static struct latch_tree_root bpf_tree __cacheline_aligned;
 
-int bpf_jit_kallsyms __read_mostly;
-
 static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
 {
 	WARN_ON_ONCE(!list_empty(&aux->ksym_lnode));
@@ -540,8 +543,6 @@ void __weak bpf_jit_free(struct bpf_prog
 	bpf_prog_unlock_free(fp);
 }
 
-int bpf_jit_harden __read_mostly;
-
 static int bpf_jit_blind_insn(const struct bpf_insn *from,
 			      const struct bpf_insn *aux,
 			      struct bpf_insn *to_buff)
@@ -1327,9 +1328,13 @@ EVAL4(PROG_NAME_LIST, 416, 448, 480, 512
 };
 
 #else
-static unsigned int __bpf_prog_ret0(const void *ctx,
-				    const struct bpf_insn *insn)
+static unsigned int __bpf_prog_ret0_warn(const void *ctx,
+					 const struct bpf_insn *insn)
 {
+	/* If this handler ever gets executed, then BPF_JIT_ALWAYS_ON
+	 * is not working properly, so warn about it!
+	 */
+	WARN_ON_ONCE(1);
 	return 0;
 }
 #endif
@@ -1386,7 +1391,7 @@ struct bpf_prog *bpf_prog_select_runtime
 
 	fp->bpf_func = interpreters[(round_up(stack_depth, 32) / 32) - 1];
 #else
-	fp->bpf_func = __bpf_prog_ret0;
+	fp->bpf_func = __bpf_prog_ret0_warn;
 #endif
 
 	/* eBPF JITs can rewrite the program in case constant
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -25,6 +25,7 @@
 
 static int zero = 0;
 static int one = 1;
+static int two __maybe_unused = 2;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
@@ -325,13 +326,14 @@ static struct ctl_table net_core_table[]
 		.data		= &bpf_jit_enable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-#ifndef CONFIG_BPF_JIT_ALWAYS_ON
-		.proc_handler	= proc_dointvec
-#else
 		.proc_handler	= proc_dointvec_minmax,
+# ifdef CONFIG_BPF_JIT_ALWAYS_ON
 		.extra1		= &one,
 		.extra2		= &one,
-#endif
+# else
+		.extra1		= &zero,
+		.extra2		= &two,
+# endif
 	},
 # ifdef CONFIG_HAVE_EBPF_JIT
 	{
@@ -339,14 +341,18 @@ static struct ctl_table net_core_table[]
 		.data		= &bpf_jit_harden,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "bpf_jit_kallsyms",
 		.data		= &bpf_jit_kallsyms,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 # endif
 #endif
--- a/net/socket.c
+++ b/net/socket.c
@@ -2656,15 +2656,6 @@ out_fs:
 
 core_initcall(sock_init);	/* early initcall */
 
-static int __init jit_init(void)
-{
-#ifdef CONFIG_BPF_JIT_ALWAYS_ON
-	bpf_jit_enable = 1;
-#endif
-	return 0;
-}
-pure_initcall(jit_init);
-
 #ifdef CONFIG_PROC_FS
 void socket_seq_show(struct seq_file *seq)
 {


