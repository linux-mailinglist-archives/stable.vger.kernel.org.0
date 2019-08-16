Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EED990B36
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 00:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfHPW71 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 16 Aug 2019 18:59:27 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:51250 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbfHPW70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 18:59:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone.i.decadent.org.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hylBp-0004eV-NU; Fri, 16 Aug 2019 23:59:21 +0100
Date:   Fri, 16 Aug 2019 23:59:20 +0100
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Subject: [PATCH 4.9 01/13] bpf: get rid of pure_initcall dependency to enable
 jits
Message-ID: <20190816225920.GE9843@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.10.1 (2018-07-13)
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
[bwh: Backported to 4.9 as dependency of commit 2e4a30983b0f
 "bpf: restrict access to core bpf sysctls":
 - Drop change in arch/mips/net/ebpf_jit.c
 - Drop change to bpf_jit_kallsyms
 - Adjust filenames, context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 arch/arm/net/bpf_jit_32.c         |  2 --
 arch/arm64/net/bpf_jit_comp.c     |  2 --
 arch/mips/net/bpf_jit.c           |  2 --
 arch/powerpc/net/bpf_jit_comp.c   |  2 --
 arch/powerpc/net/bpf_jit_comp64.c |  2 --
 arch/s390/net/bpf_jit_comp.c      |  2 --
 arch/sparc/net/bpf_jit_comp.c     |  2 --
 arch/x86/net/bpf_jit_comp.c       |  2 --
 kernel/bpf/core.c                 | 15 +++++++++++----
 net/core/sysctl_net_core.c        | 14 +++++++++-----
 net/socket.c                      |  9 ---------
 11 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 93d0b6d0b63e..7fd448b23b94 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -72,8 +72,6 @@ struct jit_ctx {
 #endif
 };
 
-int bpf_jit_enable __read_mostly;
-
 static inline int call_neg_helper(struct sk_buff *skb, int offset, void *ret,
 		      unsigned int size)
 {
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index b47a26f4290c..939c607b1376 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -30,8 +30,6 @@
 
 #include "bpf_jit.h"
 
-int bpf_jit_enable __read_mostly;
-
 #define TMP_REG_1 (MAX_BPF_JIT_REG + 0)
 #define TMP_REG_2 (MAX_BPF_JIT_REG + 1)
 #define TCALL_CNT (MAX_BPF_JIT_REG + 2)
diff --git a/arch/mips/net/bpf_jit.c b/arch/mips/net/bpf_jit.c
index 248603739198..bb9f779326d0 100644
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -1194,8 +1194,6 @@ static int build_body(struct jit_ctx *ctx)
 	return 0;
 }
 
-int bpf_jit_enable __read_mostly;
-
 void bpf_jit_compile(struct bpf_prog *fp)
 {
 	struct jit_ctx ctx;
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index 9c58194c7ea5..158f43008314 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -18,8 +18,6 @@
 
 #include "bpf_jit32.h"
 
-int bpf_jit_enable __read_mostly;
-
 static inline void bpf_flush_icache(void *start, void *end)
 {
 	smp_wmb();
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 9f0810cfe5f3..888ee95340da 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -21,8 +21,6 @@
 
 #include "bpf_jit64.h"
 
-int bpf_jit_enable __read_mostly;
-
 static void bpf_jit_fill_ill_insns(void *area, unsigned int size)
 {
 	int *p = area;
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 8bd25aebf488..896344b6e036 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -28,8 +28,6 @@
 #include <asm/nospec-branch.h>
 #include "bpf_jit.h"
 
-int bpf_jit_enable __read_mostly;
-
 struct bpf_jit {
 	u32 seen;		/* Flags to remember seen eBPF instructions */
 	u32 seen_reg[16];	/* Array to remember which registers are used */
diff --git a/arch/sparc/net/bpf_jit_comp.c b/arch/sparc/net/bpf_jit_comp.c
index a6d9204a6a0b..98a4da3012e3 100644
--- a/arch/sparc/net/bpf_jit_comp.c
+++ b/arch/sparc/net/bpf_jit_comp.c
@@ -10,8 +10,6 @@
 
 #include "bpf_jit.h"
 
-int bpf_jit_enable __read_mostly;
-
 static inline bool is_simm13(unsigned int value)
 {
 	return value + 0x1000 < 0x2000;
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index cd9764520851..d9dabd0c31fc 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -15,8 +15,6 @@
 #include <asm/nospec-branch.h>
 #include <linux/bpf.h>
 
-int bpf_jit_enable __read_mostly;
-
 /*
  * assembly code in arch/x86/net/bpf_jit.S
  */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 879ca844ba1d..da03ab4ec578 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -208,6 +208,10 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 }
 
 #ifdef CONFIG_BPF_JIT
+/* All BPF JIT sysctl knobs here. */
+int bpf_jit_enable   __read_mostly = IS_BUILTIN(CONFIG_BPF_JIT_ALWAYS_ON);
+int bpf_jit_harden   __read_mostly;
+
 struct bpf_binary_header *
 bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 		     unsigned int alignment,
@@ -244,8 +248,6 @@ void bpf_jit_binary_free(struct bpf_binary_header *hdr)
 	module_memfree(hdr);
 }
 
-int bpf_jit_harden __read_mostly;
-
 static int bpf_jit_blind_insn(const struct bpf_insn *from,
 			      const struct bpf_insn *aux,
 			      struct bpf_insn *to_buff)
@@ -925,8 +927,13 @@ static unsigned int __bpf_prog_run(void *ctx, const struct bpf_insn *insn)
 STACK_FRAME_NON_STANDARD(__bpf_prog_run); /* jump table */
 
 #else
-static unsigned int __bpf_prog_ret0(void *ctx, const struct bpf_insn *insn)
+static unsigned int __bpf_prog_ret0_warn(void *ctx,
+					 const struct bpf_insn *insn)
 {
+	/* If this handler ever gets executed, then BPF_JIT_ALWAYS_ON
+	 * is not working properly, so warn about it!
+	 */
+	WARN_ON_ONCE(1);
 	return 0;
 }
 #endif
@@ -981,7 +988,7 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
 	fp->bpf_func = (void *) __bpf_prog_run;
 #else
-	fp->bpf_func = (void *) __bpf_prog_ret0;
+	fp->bpf_func = (void *) __bpf_prog_ret0_warn;
 #endif
 
 	/* eBPF JITs can rewrite the program in case constant
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 546ba76b35a5..7b7d26a4f8c8 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -24,6 +24,7 @@
 
 static int zero = 0;
 static int one = 1;
+static int two __maybe_unused = 2;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
@@ -292,13 +293,14 @@ static struct ctl_table net_core_table[] = {
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
@@ -306,7 +308,9 @@ static struct ctl_table net_core_table[] = {
 		.data		= &bpf_jit_harden,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 # endif
 #endif
diff --git a/net/socket.c b/net/socket.c
index d9e2989c10c4..bf99bc1fab2c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2550,15 +2550,6 @@ static int __init sock_init(void)
 
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
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom


