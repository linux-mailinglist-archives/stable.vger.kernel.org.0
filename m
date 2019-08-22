Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A2899DA6
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390203AbfHVRns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403965AbfHVRXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:37 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB01A23429;
        Thu, 22 Aug 2019 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494617;
        bh=bd/KsCNq4Sz5Jbvsz/sYkrat2W+Vji9WU3bZS2+NJng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pxBDZmjv2zkwQpj5F7IMWpAdGsr2sv3KvrDLBURILI7U2Oobw4hMO71IG33zHSm+L
         B67aXbwTNamEETWt10QLAnDsb5aoTExw2J+OmmIhsIMPq8/WAddI9Jt1KCwqHl74UG
         LjVB6sz60rZezSzv9IClehtvq/1egmgWPzxtQbGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 045/103] bpf: get rid of pure_initcall dependency to enable jits
Date:   Thu, 22 Aug 2019 10:18:33 -0700
Message-Id: <20190822171730.624842710@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
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
[bwh: Backported to 4.9 as dependency of commit 2e4a30983b0f
 "bpf: restrict access to core bpf sysctls":
 - Drop change in arch/mips/net/ebpf_jit.c
 - Drop change to bpf_jit_kallsyms
 - Adjust filenames, context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/net/bpf_jit_32.c         |    2 --
 arch/arm64/net/bpf_jit_comp.c     |    2 --
 arch/mips/net/bpf_jit.c           |    2 --
 arch/powerpc/net/bpf_jit_comp.c   |    2 --
 arch/powerpc/net/bpf_jit_comp64.c |    2 --
 arch/s390/net/bpf_jit_comp.c      |    2 --
 arch/sparc/net/bpf_jit_comp.c     |    2 --
 arch/x86/net/bpf_jit_comp.c       |    2 --
 kernel/bpf/core.c                 |   15 +++++++++++----
 net/core/sysctl_net_core.c        |   14 +++++++++-----
 net/socket.c                      |    9 ---------
 11 files changed, 20 insertions(+), 34 deletions(-)

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
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -30,8 +30,6 @@
 
 #include "bpf_jit.h"
 
-int bpf_jit_enable __read_mostly;
-
 #define TMP_REG_1 (MAX_BPF_JIT_REG + 0)
 #define TMP_REG_2 (MAX_BPF_JIT_REG + 1)
 #define TCALL_CNT (MAX_BPF_JIT_REG + 2)
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -1194,8 +1194,6 @@ jmp_cmp:
 	return 0;
 }
 
-int bpf_jit_enable __read_mostly;
-
 void bpf_jit_compile(struct bpf_prog *fp)
 {
 	struct jit_ctx ctx;
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
 	int *p = area;
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
--- a/arch/sparc/net/bpf_jit_comp.c
+++ b/arch/sparc/net/bpf_jit_comp.c
@@ -10,8 +10,6 @@
 
 #include "bpf_jit.h"
 
-int bpf_jit_enable __read_mostly;
-
 static inline bool is_simm13(unsigned int value)
 {
 	return value + 0x1000 < 0x2000;
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
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -208,6 +208,10 @@ struct bpf_prog *bpf_patch_insn_single(s
 }
 
 #ifdef CONFIG_BPF_JIT
+/* All BPF JIT sysctl knobs here. */
+int bpf_jit_enable   __read_mostly = IS_BUILTIN(CONFIG_BPF_JIT_ALWAYS_ON);
+int bpf_jit_harden   __read_mostly;
+
 struct bpf_binary_header *
 bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 		     unsigned int alignment,
@@ -244,8 +248,6 @@ void bpf_jit_binary_free(struct bpf_bina
 	module_memfree(hdr);
 }
 
-int bpf_jit_harden __read_mostly;
-
 static int bpf_jit_blind_insn(const struct bpf_insn *from,
 			      const struct bpf_insn *aux,
 			      struct bpf_insn *to_buff)
@@ -925,8 +927,13 @@ load_byte:
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
@@ -981,7 +988,7 @@ struct bpf_prog *bpf_prog_select_runtime
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
 	fp->bpf_func = (void *) __bpf_prog_run;
 #else
-	fp->bpf_func = (void *) __bpf_prog_ret0;
+	fp->bpf_func = (void *) __bpf_prog_ret0_warn;
 #endif
 
 	/* eBPF JITs can rewrite the program in case constant
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -24,6 +24,7 @@
 
 static int zero = 0;
 static int one = 1;
+static int two __maybe_unused = 2;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
@@ -292,13 +293,14 @@ static struct ctl_table net_core_table[]
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
@@ -306,7 +308,9 @@ static struct ctl_table net_core_table[]
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
--- a/net/socket.c
+++ b/net/socket.c
@@ -2550,15 +2550,6 @@ out_fs:
 
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


