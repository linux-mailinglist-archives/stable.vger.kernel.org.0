Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C1469E888
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 20:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjBUTsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 14:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjBUTsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 14:48:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB617166CB
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 11:48:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 371CD61024
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 19:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A04C433EF;
        Tue, 21 Feb 2023 19:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677008887;
        bh=2UimnkwEgTehkPrErMu/cXtyFXSNiLgcqMX7oUBUh1w=;
        h=Date:From:To:Cc:Subject:From;
        b=XXbCKl7br8LnHX7kbhLsYjTScWDnSxlRW8IzrxixA1aqAEO+EtMF6FWhMelIApC0L
         yK/OEG+h9drzWRCM1lEqIRqe8g2l4gSrVkwKbg3hsDCCAaWN2T5NKP4x/ROg1KLLkY
         j+YBhojOix42WrFdhPNAdaYrv2ueg+QZflNnM3s7JCTWLyL+UkUraiIkkrgmUCEvoB
         1IymP8TDOmCqYAw7YfatBEtNLtuiYbseyI/1+rri4uTTUYvXYOSuO4OZZd99Ketjrn
         B5c+a4aV5O+oYkYhb9Jh7mS5NmGk3jCafh4Gyh4GhMUuE6kqiIxUOJkgLTZ+2k8IXM
         1trjKIScuMLBQ==
Date:   Tue, 21 Feb 2023 12:48:05 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, llvm@lists.linux.dev
Subject: static call fixes for clang's conditional tail calls (6.2 and 6.1)
Message-ID: <Y/Uf9WUi/rANmOk8@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cDCkuJHwthT+9XaI"
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cDCkuJHwthT+9XaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg and Sasha,

Please consider applying the following commits to 6.2 (they apply
cleanly with some fuzz for me):

db7adcfd1cec ("x86/alternatives: Introduce int3_emulate_jcc()")
ac0ee0a9560c ("x86/alternatives: Teach text_poke_bp() to patch Jcc.d32 instructions")
923510c88d2b ("x86/static_call: Add support for Jcc tail-calls")

I have attached backports to 6.1.

Without these changes, kernels built with any version of clang using -Os
or clang 17.0.0 (tip of tree) at any kernel-supported optimization level
do not boot. This has been tested by people affected by this problem,
see https://github.com/ClangBuiltLinux/linux/issues/1774 for more info.

If there are any problems, please let me know.

Cheers,
Nathan

--cDCkuJHwthT+9XaI
Content-Type: application/mbox
Content-Disposition: attachment; filename="clang-jcc-series-6.1.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom a0539dc166faebf980f242ad619d51e1f241e971 Mon Sep 17 00:00:00 2001=0A=
=46rom: Peter Zijlstra <peterz@infradead.org>=0ADate: Mon, 23 Jan 2023 21:5=
9:16 +0100=0ASubject: [PATCH 6.1 1/3] x86/alternatives: Introduce int3_emul=
ate_jcc()=0A=0Acommit db7adcfd1cec4e95155e37bc066fddab302c6340 upstream.=0A=
=0AMove the kprobe Jcc emulation into int3_emulate_jcc() so it can be=0Ause=
d by more code -- specifically static_call() will need this.=0A=0ASigned-of=
f-by: Peter Zijlstra (Intel) <peterz@infradead.org>=0ASigned-off-by: Ingo M=
olnar <mingo@kernel.org>=0AReviewed-by: Masami Hiramatsu (Google) <mhiramat=
@kernel.org>=0ALink: https://lore.kernel.org/r/20230123210607.057678245@inf=
radead.org=0ASigned-off-by: Nathan Chancellor <nathan@kernel.org>=0A---=0A =
arch/x86/include/asm/text-patching.h | 31 +++++++++++++++++++++++=0A arch/x=
86/kernel/kprobes/core.c       | 38 ++++++----------------------=0A 2 files=
 changed, 39 insertions(+), 30 deletions(-)=0A=0Adiff --git a/arch/x86/incl=
ude/asm/text-patching.h b/arch/x86/include/asm/text-patching.h=0Aindex 1cc1=
5528ce29..85b85a275a43 100644=0A--- a/arch/x86/include/asm/text-patching.h=
=0A+++ b/arch/x86/include/asm/text-patching.h=0A@@ -183,6 +183,37 @@ void i=
nt3_emulate_ret(struct pt_regs *regs)=0A 	unsigned long ip =3D int3_emulate=
_pop(regs);=0A 	int3_emulate_jmp(regs, ip);=0A }=0A+=0A+static __always_inl=
ine=0A+void int3_emulate_jcc(struct pt_regs *regs, u8 cc, unsigned long ip,=
 unsigned long disp)=0A+{=0A+	static const unsigned long jcc_mask[6] =3D {=
=0A+		[0] =3D X86_EFLAGS_OF,=0A+		[1] =3D X86_EFLAGS_CF,=0A+		[2] =3D X86_E=
FLAGS_ZF,=0A+		[3] =3D X86_EFLAGS_CF | X86_EFLAGS_ZF,=0A+		[4] =3D X86_EFLA=
GS_SF,=0A+		[5] =3D X86_EFLAGS_PF,=0A+	};=0A+=0A+	bool invert =3D cc & 1;=
=0A+	bool match;=0A+=0A+	if (cc < 0xc) {=0A+		match =3D regs->flags & jcc_m=
ask[cc >> 1];=0A+	} else {=0A+		match =3D ((regs->flags & X86_EFLAGS_SF) >>=
 X86_EFLAGS_SF_BIT) ^=0A+			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF=
_BIT);=0A+		if (cc >=3D 0xe)=0A+			match =3D match || (regs->flags & X86_EF=
LAGS_ZF);=0A+	}=0A+=0A+	if ((match && !invert) || (!match && invert))=0A+		=
ip +=3D disp;=0A+=0A+	int3_emulate_jmp(regs, ip);=0A+}=0A+=0A #endif /* !CO=
NFIG_UML_X86 */=0A =0A #endif /* _ASM_X86_TEXT_PATCHING_H */=0Adiff --git a=
/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c=0Aindex 5b=
e7f23099e1..ea155f0cf545 100644=0A--- a/arch/x86/kernel/kprobes/core.c=0A++=
+ b/arch/x86/kernel/kprobes/core.c=0A@@ -471,50 +471,26 @@ static void kpro=
be_emulate_call(struct kprobe *p, struct pt_regs *regs)=0A }=0A NOKPROBE_SY=
MBOL(kprobe_emulate_call);=0A =0A-static nokprobe_inline=0A-void __kprobe_e=
mulate_jmp(struct kprobe *p, struct pt_regs *regs, bool cond)=0A+static voi=
d kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs)=0A {=0A 	unsig=
ned long ip =3D regs->ip - INT3_INSN_SIZE + p->ainsn.size;=0A =0A-	if (cond=
)=0A-		ip +=3D p->ainsn.rel32;=0A+	ip +=3D p->ainsn.rel32;=0A 	int3_emulate=
_jmp(regs, ip);=0A }=0A-=0A-static void kprobe_emulate_jmp(struct kprobe *p=
, struct pt_regs *regs)=0A-{=0A-	__kprobe_emulate_jmp(p, regs, true);=0A-}=
=0A NOKPROBE_SYMBOL(kprobe_emulate_jmp);=0A =0A-static const unsigned long =
jcc_mask[6] =3D {=0A-	[0] =3D X86_EFLAGS_OF,=0A-	[1] =3D X86_EFLAGS_CF,=0A-=
	[2] =3D X86_EFLAGS_ZF,=0A-	[3] =3D X86_EFLAGS_CF | X86_EFLAGS_ZF,=0A-	[4] =
=3D X86_EFLAGS_SF,=0A-	[5] =3D X86_EFLAGS_PF,=0A-};=0A-=0A static void kpro=
be_emulate_jcc(struct kprobe *p, struct pt_regs *regs)=0A {=0A-	bool invert=
 =3D p->ainsn.jcc.type & 1;=0A-	bool match;=0A+	unsigned long ip =3D regs->=
ip - INT3_INSN_SIZE + p->ainsn.size;=0A =0A-	if (p->ainsn.jcc.type < 0xc) {=
=0A-		match =3D regs->flags & jcc_mask[p->ainsn.jcc.type >> 1];=0A-	} else =
{=0A-		match =3D ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^=0A-=
			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);=0A-		if (p->ainsn.=
jcc.type >=3D 0xe)=0A-			match =3D match || (regs->flags & X86_EFLAGS_ZF);=
=0A-	}=0A-	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && i=
nvert));=0A+	int3_emulate_jcc(regs, p->ainsn.jcc.type, ip, p->ainsn.rel32);=
=0A }=0A NOKPROBE_SYMBOL(kprobe_emulate_jcc);=0A =0A static void kprobe_emu=
late_loop(struct kprobe *p, struct pt_regs *regs)=0A {=0A+	unsigned long ip=
 =3D regs->ip - INT3_INSN_SIZE + p->ainsn.size;=0A 	bool match;=0A =0A 	if =
(p->ainsn.loop.type !=3D 3) {	/* LOOP* */=0A@@ -542,7 +518,9 @@ static void=
 kprobe_emulate_loop(struct kprobe *p, struct pt_regs *regs)=0A 	else if (p=
->ainsn.loop.type =3D=3D 1)	/* LOOPE */=0A 		match =3D match && (regs->flag=
s & X86_EFLAGS_ZF);=0A =0A-	__kprobe_emulate_jmp(p, regs, match);=0A+	if (m=
atch)=0A+		ip +=3D p->ainsn.rel32;=0A+	int3_emulate_jmp(regs, ip);=0A }=0A =
NOKPROBE_SYMBOL(kprobe_emulate_loop);=0A =0A=0Abase-commit: 129c15b606278f9=
254a16013f7e5a94a128d9bcd=0A-- =0A2.39.2=0A=0A=0AFrom 00b6c51f30708c378ed35=
7067596ee75f2784655 Mon Sep 17 00:00:00 2001=0AFrom: Peter Zijlstra <peterz=
@infradead.org>=0ADate: Mon, 23 Jan 2023 21:59:17 +0100=0ASubject: [PATCH 6=
=2E1 2/3] x86/alternatives: Teach text_poke_bp() to patch=0A Jcc.d32 instru=
ctions=0A=0Acommit ac0ee0a9560c97fa5fe1409e450c2425d4ebd17a upstream.=0A=0A=
In order to re-write Jcc.d32 instructions text_poke_bp() needs to be=0Ataug=
ht about them.=0A=0AThe biggest hurdle is that the whole machinery is curre=
ntly made for 5=0Abyte instructions and extending this would grow struct te=
xt_poke_loc=0Awhich is currently a nice 16 bytes and used in an array.=0A=
=0AHowever, since text_poke_loc contains a full copy of the (s32)=0Adisplac=
ement, it is possible to map the Jcc.d32 2 byte opcodes to=0AJcc.d8 1 byte =
opcode for the int3 emulation.=0A=0AThis then leaves the replacement bytes;=
 fudge that by only storing the=0Alast 5 bytes and adding the rule that 'le=
ngth =3D=3D 6' instruction will=0Abe prefixed with a 0x0f byte.=0A=0ASigned=
-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>=0ASigned-off-by: Ing=
o Molnar <mingo@kernel.org>=0AReviewed-by: Masami Hiramatsu (Google) <mhira=
mat@kernel.org>=0ALink: https://lore.kernel.org/r/20230123210607.115718513@=
infradead.org=0A[nathan: Introduce is_jcc32() as part of this change; upstr=
eam=0A         introduced it in 3b6c1747da48]=0ASigned-off-by: Nathan Chanc=
ellor <nathan@kernel.org>=0A---=0A arch/x86/kernel/alternative.c | 59 +++++=
+++++++++++++++++++++++-------=0A 1 file changed, 48 insertions(+), 11 dele=
tions(-)=0A=0Adiff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/=
alternative.c=0Aindex 5cadcea035e0..d1d92897ed6b 100644=0A--- a/arch/x86/ke=
rnel/alternative.c=0A+++ b/arch/x86/kernel/alternative.c=0A@@ -339,6 +339,1=
2 @@ void __init_or_module noinline apply_alternatives(struct alt_instr *st=
art,=0A 	}=0A }=0A =0A+static inline bool is_jcc32(struct insn *insn)=0A+{=
=0A+	/* Jcc.d32 second opcode byte is in the range: 0x80-0x8f */=0A+	return=
 insn->opcode.bytes[0] =3D=3D 0x0f && (insn->opcode.bytes[1] & 0xf0) =3D=3D=
 0x80;=0A+}=0A+=0A #if defined(CONFIG_RETPOLINE) && defined(CONFIG_OBJTOOL)=
=0A =0A /*=0A@@ -427,8 +433,7 @@ static int patch_retpoline(void *addr, str=
uct insn *insn, u8 *bytes)=0A 	 *   [ NOP ]=0A 	 * 1:=0A 	 */=0A-	/* Jcc.d3=
2 second opcode byte is in the range: 0x80-0x8f */=0A-	if (op =3D=3D 0x0f &=
& (insn->opcode.bytes[1] & 0xf0) =3D=3D 0x80) {=0A+	if (is_jcc32(insn)) {=
=0A 		cc =3D insn->opcode.bytes[1] & 0xf;=0A 		cc ^=3D 1; /* invert conditi=
on */=0A =0A@@ -1311,6 +1316,11 @@ void text_poke_sync(void)=0A 	on_each_cp=
u(do_sync_core, NULL, 1);=0A }=0A =0A+/*=0A+ * NOTE: crazy scheme to allow =
patching Jcc.d32 but not increase the size of=0A+ * this thing. When len =
=3D=3D 6 everything is prefixed with 0x0f and we map=0A+ * opcode to Jcc.d8=
, using len to distinguish.=0A+ */=0A struct text_poke_loc {=0A 	/* addr :=
=3D _stext + rel_addr */=0A 	s32 rel_addr;=0A@@ -1432,6 +1442,10 @@ noinstr=
 int poke_int3_handler(struct pt_regs *regs)=0A 		int3_emulate_jmp(regs, (l=
ong)ip + tp->disp);=0A 		break;=0A =0A+	case 0x70 ... 0x7f: /* Jcc */=0A+		=
int3_emulate_jcc(regs, tp->opcode & 0xf, (long)ip, tp->disp);=0A+		break;=
=0A+=0A 	default:=0A 		BUG();=0A 	}=0A@@ -1505,16 +1519,26 @@ static void t=
ext_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries=0A 	 * =
Second step: update all but the first byte of the patched range.=0A 	 */=0A=
 	for (do_sync =3D 0, i =3D 0; i < nr_entries; i++) {=0A-		u8 old[POKE_MAX_=
OPCODE_SIZE] =3D { tp[i].old, };=0A+		u8 old[POKE_MAX_OPCODE_SIZE+1] =3D { =
tp[i].old, };=0A+		u8 _new[POKE_MAX_OPCODE_SIZE+1];=0A+		const u8 *new =3D =
tp[i].text;=0A 		int len =3D tp[i].len;=0A =0A 		if (len - INT3_INSN_SIZE >=
 0) {=0A 			memcpy(old + INT3_INSN_SIZE,=0A 			       text_poke_addr(&tp[i]=
) + INT3_INSN_SIZE,=0A 			       len - INT3_INSN_SIZE);=0A+=0A+			if (len =
=3D=3D 6) {=0A+				_new[0] =3D 0x0f;=0A+				memcpy(_new + 1, new, 5);=0A+		=
		new =3D _new;=0A+			}=0A+=0A 			text_poke(text_poke_addr(&tp[i]) + INT3_I=
NSN_SIZE,=0A-				  (const char *)tp[i].text + INT3_INSN_SIZE,=0A+				  new =
+ INT3_INSN_SIZE,=0A 				  len - INT3_INSN_SIZE);=0A+=0A 			do_sync++;=0A 	=
	}=0A =0A@@ -1542,8 +1566,7 @@ static void text_poke_bp_batch(struct text_p=
oke_loc *tp, unsigned int nr_entries=0A 		 * The old instruction is recorde=
d so that the event can be=0A 		 * processed forwards or backwards.=0A 		 *=
/=0A-		perf_event_text_poke(text_poke_addr(&tp[i]), old, len,=0A-				     t=
p[i].text, len);=0A+		perf_event_text_poke(text_poke_addr(&tp[i]), old, len=
, new, len);=0A 	}=0A =0A 	if (do_sync) {=0A@@ -1560,10 +1583,15 @@ static =
void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries=
=0A 	 * replacing opcode.=0A 	 */=0A 	for (do_sync =3D 0, i =3D 0; i < nr_e=
ntries; i++) {=0A-		if (tp[i].text[0] =3D=3D INT3_INSN_OPCODE)=0A+		u8 byte=
 =3D tp[i].text[0];=0A+=0A+		if (tp[i].len =3D=3D 6)=0A+			byte =3D 0x0f;=
=0A+=0A+		if (byte =3D=3D INT3_INSN_OPCODE)=0A 			continue;=0A =0A-		text_p=
oke(text_poke_addr(&tp[i]), tp[i].text, INT3_INSN_SIZE);=0A+		text_poke(tex=
t_poke_addr(&tp[i]), &byte, INT3_INSN_SIZE);=0A 		do_sync++;=0A 	}=0A =0A@@=
 -1581,9 +1609,11 @@ static void text_poke_loc_init(struct text_poke_loc *t=
p, void *addr,=0A 			       const void *opcode, size_t len, const void *emu=
late)=0A {=0A 	struct insn insn;=0A-	int ret, i;=0A+	int ret, i =3D 0;=0A =
=0A-	memcpy((void *)tp->text, opcode, len);=0A+	if (len =3D=3D 6)=0A+		i =
=3D 1;=0A+	memcpy((void *)tp->text, opcode+i, len-i);=0A 	if (!emulate)=0A =
		emulate =3D opcode;=0A =0A@@ -1594,6 +1624,13 @@ static void text_poke_lo=
c_init(struct text_poke_loc *tp, void *addr,=0A 	tp->len =3D len;=0A 	tp->o=
pcode =3D insn.opcode.bytes[0];=0A =0A+	if (is_jcc32(&insn)) {=0A+		/*=0A+	=
	 * Map Jcc.d32 onto Jcc.d8 and use len to distinguish.=0A+		 */=0A+		tp->o=
pcode =3D insn.opcode.bytes[1] - 0x10;=0A+	}=0A+=0A 	switch (tp->opcode) {=
=0A 	case RET_INSN_OPCODE:=0A 	case JMP32_INSN_OPCODE:=0A@@ -1610,7 +1647,6=
 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,=0A=
 		BUG_ON(len !=3D insn.length);=0A 	};=0A =0A-=0A 	switch (tp->opcode) {=
=0A 	case INT3_INSN_OPCODE:=0A 	case RET_INSN_OPCODE:=0A@@ -1619,6 +1655,7 =
@@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,=0A =
	case CALL_INSN_OPCODE:=0A 	case JMP32_INSN_OPCODE:=0A 	case JMP8_INSN_OPCO=
DE:=0A+	case 0x70 ... 0x7f: /* Jcc */=0A 		tp->disp =3D insn.immediate.valu=
e;=0A 		break;=0A =0A-- =0A2.39.2=0A=0A=0AFrom db720e3226a717120221095b2ddb=
bac34da79ec0 Mon Sep 17 00:00:00 2001=0AFrom: Peter Zijlstra <peterz@infrad=
ead.org>=0ADate: Thu, 26 Jan 2023 16:34:27 +0100=0ASubject: [PATCH 6.1 3/3]=
 x86/static_call: Add support for Jcc tail-calls=0A=0Acommit 923510c88d2b7d=
947c4217835fd9ca6bd65cc56c upstream.=0A=0AClang likes to create conditional=
 tail calls like:=0A=0A  0000000000000350 <amd_pmu_add_event>:=0A  350:    =
   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1) 351: R_X86_64_NONE      =
__fentry__-0x4=0A  355:       48 83 bf 20 01 00 00 00         cmpq   $0x0,0=
x120(%rdi)=0A  35d:       0f 85 00 00 00 00       jne    363 <amd_pmu_add_e=
vent+0x13>     35f: R_X86_64_PLT32     __SCT__amd_pmu_branch_add-0x4=0A  36=
3:       e9 00 00 00 00          jmp    368 <amd_pmu_add_event+0x18>     36=
4: R_X86_64_PLT32     __x86_return_thunk-0x4=0A=0AWhere 0x35d is a static c=
all site that's turned into a conditional=0Atail-call using the Jcc class o=
f instructions.=0A=0ATeach the in-line static call text patching about this=
=2E=0A=0ANotably, since there is no conditional-ret, in that case patch the=
 Jcc=0Ato point at an empty stub function that does the ret -- or the retur=
n=0Athunk when needed.=0A=0AReported-by: "Erhard F." <erhard_f@mailbox.org>=
=0ASigned-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>=0ASigned-of=
f-by: Ingo Molnar <mingo@kernel.org>=0AReviewed-by: Masami Hiramatsu (Googl=
e) <mhiramat@kernel.org>=0ALink: https://lore.kernel.org/r/Y9Kdg9QjHkr9G5b5=
@hirez.programming.kicks-ass.net=0A[nathan: Backport to 6.1:=0A         - U=
se __x86_return_thunk instead of x86_return_thunk for func in=0A           =
__static_call_transform()=0A         - Remove ASM_FUNC_ALIGN in __static_ca=
ll_return() asm, as call=0A           depth tracking was merged in 6.2]=0AS=
igned-off-by: Nathan Chancellor <nathan@kernel.org>=0A---=0A arch/x86/kerne=
l/static_call.c | 49 ++++++++++++++++++++++++++++++++---=0A 1 file changed,=
 46 insertions(+), 3 deletions(-)=0A=0Adiff --git a/arch/x86/kernel/static_=
call.c b/arch/x86/kernel/static_call.c=0Aindex aaaba85d6d7f..a9b54b795ebf 1=
00644=0A--- a/arch/x86/kernel/static_call.c=0A+++ b/arch/x86/kernel/static_=
call.c=0A@@ -9,6 +9,7 @@ enum insn_type {=0A 	NOP =3D 1,  /* site cond-call=
 */=0A 	JMP =3D 2,  /* tramp / site tail-call */=0A 	RET =3D 3,  /* tramp /=
 site cond-tail-call */=0A+	JCC =3D 4,=0A };=0A =0A /*=0A@@ -25,12 +26,39 @=
@ static const u8 xor5rax[] =3D { 0x2e, 0x2e, 0x2e, 0x31, 0xc0 };=0A =0A st=
atic const u8 retinsn[] =3D { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };=0A=
 =0A+static u8 __is_Jcc(u8 *insn) /* Jcc.d32 */=0A+{=0A+	u8 ret =3D 0;=0A+=
=0A+	if (insn[0] =3D=3D 0x0f) {=0A+		u8 tmp =3D insn[1];=0A+		if ((tmp & 0x=
f0) =3D=3D 0x80)=0A+			ret =3D tmp;=0A+	}=0A+=0A+	return ret;=0A+}=0A+=0A+e=
xtern void __static_call_return(void);=0A+=0A+asm (".global __static_call_r=
eturn\n\t"=0A+     ".type __static_call_return, @function\n\t"=0A+     "__s=
tatic_call_return:\n\t"=0A+     ANNOTATE_NOENDBR=0A+     ANNOTATE_RETPOLINE=
_SAFE=0A+     "ret; int3\n\t"=0A+     ".size __static_call_return, . - __st=
atic_call_return \n\t");=0A+=0A static void __ref __static_call_transform(v=
oid *insn, enum insn_type type,=0A 					  void *func, bool modinit)=0A {=0A=
 	const void *emulate =3D NULL;=0A 	int size =3D CALL_INSN_SIZE;=0A 	const =
void *code;=0A+	u8 op, buf[6];=0A+=0A+	if ((type =3D=3D JMP || type =3D=3D =
RET) && (op =3D __is_Jcc(insn)))=0A+		type =3D JCC;=0A =0A 	switch (type) {=
=0A 	case CALL:=0A@@ -56,6 +84,20 @@ static void __ref __static_call_transf=
orm(void *insn, enum insn_type type,=0A 		else=0A 			code =3D &retinsn;=0A =
		break;=0A+=0A+	case JCC:=0A+		if (!func) {=0A+			func =3D __static_call_r=
eturn;=0A+			if (cpu_feature_enabled(X86_FEATURE_RETHUNK))=0A+				func =3D =
__x86_return_thunk;=0A+		}=0A+=0A+		buf[0] =3D 0x0f;=0A+		__text_gen_insn(b=
uf+1, op, insn+1, func, 5);=0A+		code =3D buf;=0A+		size =3D 6;=0A+=0A+		br=
eak;=0A 	}=0A =0A 	if (memcmp(insn, code, size) =3D=3D 0)=0A@@ -67,9 +109,9=
 @@ static void __ref __static_call_transform(void *insn, enum insn_type ty=
pe,=0A 	text_poke_bp(insn, code, size, emulate);=0A }=0A =0A-static void __=
static_call_validate(void *insn, bool tail, bool tramp)=0A+static void __st=
atic_call_validate(u8 *insn, bool tail, bool tramp)=0A {=0A-	u8 opcode =3D =
*(u8 *)insn;=0A+	u8 opcode =3D insn[0];=0A =0A 	if (tramp && memcmp(insn+5,=
 tramp_ud, 3)) {=0A 		pr_err("trampoline signature fail");=0A@@ -78,7 +120,=
8 @@ static void __static_call_validate(void *insn, bool tail, bool tramp)=
=0A =0A 	if (tail) {=0A 		if (opcode =3D=3D JMP32_INSN_OPCODE ||=0A-		    o=
pcode =3D=3D RET_INSN_OPCODE)=0A+		    opcode =3D=3D RET_INSN_OPCODE ||=0A+=
		    __is_Jcc(insn))=0A 			return;=0A 	} else {=0A 		if (opcode =3D=3D CAL=
L_INSN_OPCODE ||=0A-- =0A2.39.2=0A=0A
--cDCkuJHwthT+9XaI--
