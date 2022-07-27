Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146E1582EE4
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbiG0RSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241764AbiG0RSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:18:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E094679EC1;
        Wed, 27 Jul 2022 09:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 226DCB821BA;
        Wed, 27 Jul 2022 16:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E978C433D6;
        Wed, 27 Jul 2022 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940219;
        bh=ZvMHQuwhlJyiVYjn+uTUQOX3msmfEm5zHTUGTE2FyAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XN5h+ivYJPpopnWvGP3Fal8i4z+43nD8X+ALlqRV+ZdPF7M4ySm1SUiO7L+ocM2+R
         oKocYFKi1ah487Q9MEQKoqR+FpbZZj8tXEr9+slL2GbZj9/k5Y+FwmvGbWey8cbheg
         aVmgZH7fDq896aBOAihRLu8rnNBRH1/AVxvU+0UY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/201] x86/extable: Extend extable functionality
Date:   Wed, 27 Jul 2022 18:10:52 +0200
Message-Id: <20220727161033.965478749@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4b5305decc8436bfe363d1c1773e8fa1c828b14d ]

In order to remove further .fixup usage, extend the extable
infrastructure to take additional information from the extable entry
sites.

Specifically add _ASM_EXTABLE_TYPE_REG() and EX_TYPE_IMM_REG that
extend the existing _ASM_EXTABLE_TYPE() by taking an additional
register argument and encoding that and an s16 immediate into the
existing s32 type field. This limits the actual types to the first
byte, 255 seem plenty.

Also add a few flags into the type word, specifically CLEAR_AX and
CLEAR_DX which clear the return and extended return register.

Notes:
 - due to the % in our register names it's hard to make it more
   generally usable as arm64 did.
 - the s16 is far larger than used in these patches, future extentions
   can easily shrink this to get more bits.
 - without the bitfield fix this will not compile, because: 0xFF > -1
   and we can't even extract the TYPE field.

[nathanchance: Build fix for clang-lto builds:
 https://lkml.kernel.org/r/20211210234953.3420108-1-nathan@kernel.org
]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20211110101325.303890153@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/asm.h                 | 37 ++++++++++++
 arch/x86/include/asm/extable.h             |  6 +-
 arch/x86/include/asm/extable_fixup_types.h | 24 ++++++++
 arch/x86/include/asm/insn-eval.h           |  2 +
 arch/x86/lib/insn-eval.c                   | 66 ++++++++++++++--------
 arch/x86/mm/extable.c                      | 40 +++++++++++--
 arch/x86/net/bpf_jit_comp.c                |  2 +-
 7 files changed, 145 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 6aadb9a620ee..8cbdfd77a390 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -147,6 +147,33 @@
 
 #else /* ! __ASSEMBLY__ */
 
+# define DEFINE_EXTABLE_TYPE_REG \
+	".macro extable_type_reg type:req reg:req\n"						\
+	".set found, 0\n"									\
+	".set regnr, 0\n"									\
+	".irp rs,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,r15\n"		\
+	".ifc \\reg, %%\\rs\n"									\
+	".set found, found+1\n"									\
+	".long \\type + (regnr << 8)\n"								\
+	".endif\n"										\
+	".set regnr, regnr+1\n"									\
+	".endr\n"										\
+	".set regnr, 0\n"									\
+	".irp rs,eax,ecx,edx,ebx,esp,ebp,esi,edi,r8d,r9d,r10d,r11d,r12d,r13d,r14d,r15d\n"	\
+	".ifc \\reg, %%\\rs\n"									\
+	".set found, found+1\n"									\
+	".long \\type + (regnr << 8)\n"								\
+	".endif\n"										\
+	".set regnr, regnr+1\n"									\
+	".endr\n"										\
+	".if (found != 1)\n"									\
+	".error \"extable_type_reg: bad register argument\"\n"					\
+	".endif\n"										\
+	".endm\n"
+
+# define UNDEFINE_EXTABLE_TYPE_REG \
+	".purgem extable_type_reg\n"
+
 # define _ASM_EXTABLE_TYPE(from, to, type)			\
 	" .pushsection \"__ex_table\",\"a\"\n"			\
 	" .balign 4\n"						\
@@ -155,6 +182,16 @@
 	" .long " __stringify(type) " \n"			\
 	" .popsection\n"
 
+# define _ASM_EXTABLE_TYPE_REG(from, to, type, reg)				\
+	" .pushsection \"__ex_table\",\"a\"\n"					\
+	" .balign 4\n"								\
+	" .long (" #from ") - .\n"						\
+	" .long (" #to ") - .\n"						\
+	DEFINE_EXTABLE_TYPE_REG							\
+	"extable_type_reg reg=" __stringify(reg) ", type=" __stringify(type) " \n"\
+	UNDEFINE_EXTABLE_TYPE_REG						\
+	" .popsection\n"
+
 /* For C file, we already have NOKPROBE_SYMBOL macro */
 
 /*
diff --git a/arch/x86/include/asm/extable.h b/arch/x86/include/asm/extable.h
index 93f400eb728f..155c991ba95e 100644
--- a/arch/x86/include/asm/extable.h
+++ b/arch/x86/include/asm/extable.h
@@ -21,7 +21,7 @@
  */
 
 struct exception_table_entry {
-	int insn, fixup, type;
+	int insn, fixup, data;
 };
 struct pt_regs;
 
@@ -31,8 +31,8 @@ struct pt_regs;
 	do {							\
 		(a)->fixup = (b)->fixup + (delta);		\
 		(b)->fixup = (tmp).fixup - (delta);		\
-		(a)->type = (b)->type;				\
-		(b)->type = (tmp).type;				\
+		(a)->data = (b)->data;				\
+		(b)->data = (tmp).data;				\
 	} while (0)
 
 extern int fixup_exception(struct pt_regs *regs, int trapnr,
diff --git a/arch/x86/include/asm/extable_fixup_types.h b/arch/x86/include/asm/extable_fixup_types.h
index 4d709a2768bb..944f8329022a 100644
--- a/arch/x86/include/asm/extable_fixup_types.h
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -2,6 +2,29 @@
 #ifndef _ASM_X86_EXTABLE_FIXUP_TYPES_H
 #define _ASM_X86_EXTABLE_FIXUP_TYPES_H
 
+/*
+ * Our IMM is signed, as such it must live at the top end of the word. Also,
+ * since C99 hex constants are of ambigious type, force cast the mask to 'int'
+ * so that FIELD_GET() will DTRT and sign extend the value when it extracts it.
+ */
+#define EX_DATA_TYPE_MASK		((int)0x000000FF)
+#define EX_DATA_REG_MASK		((int)0x00000F00)
+#define EX_DATA_FLAG_MASK		((int)0x0000F000)
+#define EX_DATA_IMM_MASK		((int)0xFFFF0000)
+
+#define EX_DATA_REG_SHIFT		8
+#define EX_DATA_FLAG_SHIFT		12
+#define EX_DATA_IMM_SHIFT		16
+
+#define EX_DATA_FLAG(flag)		((flag) << EX_DATA_FLAG_SHIFT)
+#define EX_DATA_IMM(imm)		((imm) << EX_DATA_IMM_SHIFT)
+
+/* flags */
+#define EX_FLAG_CLEAR_AX		EX_DATA_FLAG(1)
+#define EX_FLAG_CLEAR_DX		EX_DATA_FLAG(2)
+#define EX_FLAG_CLEAR_AX_DX		EX_DATA_FLAG(3)
+
+/* types */
 #define	EX_TYPE_NONE			 0
 #define	EX_TYPE_DEFAULT			 1
 #define	EX_TYPE_FAULT			 2
@@ -20,5 +43,6 @@
 #define	EX_TYPE_FAULT_MCE_SAFE		13
 
 #define	EX_TYPE_POP_ZERO		14
+#define	EX_TYPE_IMM_REG			15 /* reg := (long)imm */
 
 #endif
diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
index 4ec3613551e3..3df123f437c9 100644
--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -15,6 +15,8 @@
 #define INSN_CODE_SEG_OPND_SZ(params) (params & 0xf)
 #define INSN_CODE_SEG_PARAMS(oper_sz, addr_sz) (oper_sz | (addr_sz << 4))
 
+int pt_regs_offset(struct pt_regs *regs, int regno);
+
 bool insn_has_rep_prefix(struct insn *insn);
 void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs);
 int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs);
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index eb3ccffb9b9d..7760d228041b 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -412,32 +412,39 @@ static short get_segment_selector(struct pt_regs *regs, int seg_reg_idx)
 #endif /* CONFIG_X86_64 */
 }
 
-static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
-			  enum reg_type type)
+static const int pt_regoff[] = {
+	offsetof(struct pt_regs, ax),
+	offsetof(struct pt_regs, cx),
+	offsetof(struct pt_regs, dx),
+	offsetof(struct pt_regs, bx),
+	offsetof(struct pt_regs, sp),
+	offsetof(struct pt_regs, bp),
+	offsetof(struct pt_regs, si),
+	offsetof(struct pt_regs, di),
+#ifdef CONFIG_X86_64
+	offsetof(struct pt_regs, r8),
+	offsetof(struct pt_regs, r9),
+	offsetof(struct pt_regs, r10),
+	offsetof(struct pt_regs, r11),
+	offsetof(struct pt_regs, r12),
+	offsetof(struct pt_regs, r13),
+	offsetof(struct pt_regs, r14),
+	offsetof(struct pt_regs, r15),
+#endif
+};
+
+int pt_regs_offset(struct pt_regs *regs, int regno)
 {
+	if ((unsigned)regno < ARRAY_SIZE(pt_regoff))
+		return pt_regoff[regno];
+	return -EDOM;
+}
+
+static int get_regno(struct insn *insn, enum reg_type type)
+{
+	int nr_registers = ARRAY_SIZE(pt_regoff);
 	int regno = 0;
 
-	static const int regoff[] = {
-		offsetof(struct pt_regs, ax),
-		offsetof(struct pt_regs, cx),
-		offsetof(struct pt_regs, dx),
-		offsetof(struct pt_regs, bx),
-		offsetof(struct pt_regs, sp),
-		offsetof(struct pt_regs, bp),
-		offsetof(struct pt_regs, si),
-		offsetof(struct pt_regs, di),
-#ifdef CONFIG_X86_64
-		offsetof(struct pt_regs, r8),
-		offsetof(struct pt_regs, r9),
-		offsetof(struct pt_regs, r10),
-		offsetof(struct pt_regs, r11),
-		offsetof(struct pt_regs, r12),
-		offsetof(struct pt_regs, r13),
-		offsetof(struct pt_regs, r14),
-		offsetof(struct pt_regs, r15),
-#endif
-	};
-	int nr_registers = ARRAY_SIZE(regoff);
 	/*
 	 * Don't possibly decode a 32-bit instructions as
 	 * reading a 64-bit-only register.
@@ -505,7 +512,18 @@ static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
 		WARN_ONCE(1, "decoded an instruction with an invalid register");
 		return -EINVAL;
 	}
-	return regoff[regno];
+	return regno;
+}
+
+static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
+			  enum reg_type type)
+{
+	int regno = get_regno(insn, type);
+
+	if (regno < 0)
+		return regno;
+
+	return pt_regs_offset(regs, regno);
 }
 
 /**
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index f59a4d017070..251732113624 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -2,12 +2,25 @@
 #include <linux/extable.h>
 #include <linux/uaccess.h>
 #include <linux/sched/debug.h>
+#include <linux/bitfield.h>
 #include <xen/xen.h>
 
 #include <asm/fpu/internal.h>
 #include <asm/sev.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>
+#include <asm/insn-eval.h>
+
+static inline unsigned long *pt_regs_nr(struct pt_regs *regs, int nr)
+{
+	int reg_offset = pt_regs_offset(regs, nr);
+	static unsigned long __dummy;
+
+	if (WARN_ON_ONCE(reg_offset < 0))
+		return &__dummy;
+
+	return (unsigned long *)((unsigned long)regs + reg_offset);
+}
 
 static inline unsigned long
 ex_fixup_addr(const struct exception_table_entry *x)
@@ -15,10 +28,15 @@ ex_fixup_addr(const struct exception_table_entry *x)
 	return (unsigned long)&x->fixup + x->fixup;
 }
 
-static bool ex_handler_default(const struct exception_table_entry *fixup,
+static bool ex_handler_default(const struct exception_table_entry *e,
 			       struct pt_regs *regs)
 {
-	regs->ip = ex_fixup_addr(fixup);
+	if (e->data & EX_FLAG_CLEAR_AX)
+		regs->ax = 0;
+	if (e->data & EX_FLAG_CLEAR_DX)
+		regs->dx = 0;
+
+	regs->ip = ex_fixup_addr(e);
 	return true;
 }
 
@@ -111,17 +129,25 @@ static bool ex_handler_pop_zero(const struct exception_table_entry *fixup,
 	return ex_handler_default(fixup, regs);
 }
 
+static bool ex_handler_imm_reg(const struct exception_table_entry *fixup,
+			       struct pt_regs *regs, int reg, int imm)
+{
+	*pt_regs_nr(regs, reg) = (long)imm;
+	return ex_handler_default(fixup, regs);
+}
+
 int ex_get_fixup_type(unsigned long ip)
 {
 	const struct exception_table_entry *e = search_exception_tables(ip);
 
-	return e ? e->type : EX_TYPE_NONE;
+	return e ? FIELD_GET(EX_DATA_TYPE_MASK, e->data) : EX_TYPE_NONE;
 }
 
 int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 		    unsigned long fault_addr)
 {
 	const struct exception_table_entry *e;
+	int type, reg, imm;
 
 #ifdef CONFIG_PNPBIOS
 	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
@@ -141,7 +167,11 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 	if (!e)
 		return 0;
 
-	switch (e->type) {
+	type = FIELD_GET(EX_DATA_TYPE_MASK, e->data);
+	reg  = FIELD_GET(EX_DATA_REG_MASK,  e->data);
+	imm  = FIELD_GET(EX_DATA_IMM_MASK,  e->data);
+
+	switch (type) {
 	case EX_TYPE_DEFAULT:
 	case EX_TYPE_DEFAULT_MCE_SAFE:
 		return ex_handler_default(e, regs);
@@ -170,6 +200,8 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 		break;
 	case EX_TYPE_POP_ZERO:
 		return ex_handler_pop_zero(e, regs);
+	case EX_TYPE_IMM_REG:
+		return ex_handler_imm_reg(e, regs, reg, imm);
 	}
 	BUG();
 }
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 4f3a60037150..dccaab2113f9 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1342,7 +1342,7 @@ st:			if (is_imm8(insn->off))
 				}
 				ex->insn = delta;
 
-				ex->type = EX_TYPE_BPF;
+				ex->data = EX_TYPE_BPF;
 
 				if (dst_reg > BPF_REG_9) {
 					pr_err("verifier error\n");
-- 
2.35.1



