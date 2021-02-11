Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62D73182AD
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 01:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhBKAgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 19:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhBKAgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 19:36:51 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE6DC0613D6
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 16:36:11 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r38so2428008pgk.13
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 16:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=QF21Dl7+gdn0eSb+7G4tGiqAM8tPJVmxKF08xPTiWCs=;
        b=RDmGYIvgWVkSN1yhbqyvnpxyePmr4OA3emhnoN5j1+/vLTNOvXMdBXvSxvOnaxtKFD
         4pkVsNct/kRI9pahCmYpNVKxIK8kuiEHTWJtXJsQA7WwXb7Homd5/oVRxCvqaAYLkuD1
         sb9T2gIVkAIjivVQuNrB+nxVWj2ZOGvprVLEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=QF21Dl7+gdn0eSb+7G4tGiqAM8tPJVmxKF08xPTiWCs=;
        b=tocLpDMSNPEl7cUumSOzv5F0y/VKP0qQbE73rfTQjIz1HLvV7genNqLwkykppitr5a
         2VeAGKULhVkWN9uiAK8Xg5ixXuzmD5AjNlgdV4eT9GaRmNW3rLJKULTJUOB6tLA1Vjpd
         d1H7ld/m1h7OvIE7xXV7mmuzw1Fs1fPW5lYCDVQUf+Svdb/SJ2FKIFVYWEIZC3lnIOWV
         F8U2UHYWyaLoREyn5TQYGynMJ9CfVNtspKHy+xWPgV/sKQ2dPS/7KH8TyWmGvc4ZhGkW
         ezQCQL89dxrvi8CWsQ9SbdearvGfXW+aFEkyBUuELoBvk3OF+oN6McKlpK4OAB0R17MY
         CAcQ==
X-Gm-Message-State: AOAM5317DsZOizNxwl+RLYmGvp2TXN7SrPW/Ht6tsK3XB9oz47Iq1NzN
        amo4H/VUDQVmRDLS9SiRft7B7eFoF3/BqA==
X-Google-Smtp-Source: ABdhPJxlWZ5/OAvxLAvLJb7YheL/YodJ1Fuv3vDUHKsyapJV38YJ65rO+MVeGsbMpBTdl0hQudeK5Q==
X-Received: by 2002:a63:fa0b:: with SMTP id y11mr5622043pgh.35.1613003770728;
        Wed, 10 Feb 2021 16:36:10 -0800 (PST)
Received: from chromium.org ([2620:15c:202:201:5533:1106:2710:3ce])
        by smtp.gmail.com with ESMTPSA id j2sm3256202pgq.34.2021.02.10.16.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 16:36:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <X9DkdTGAiAEfUvm5@kroah.com>
References: <20201207170533.10738-1-mark.rutland@arm.com> <202012081319.D5827CF@keescook> <X9DkdTGAiAEfUvm5@kroah.com>
Subject: Re: [PATCH] lkdtm: don't move ctors to .rodata
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, <stable@vger.kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>
Date:   Wed, 10 Feb 2021 16:36:08 -0800
Message-ID: <161300376813.1254594.5196098885798133458@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Greg Kroah-Hartman (2020-12-09 06:51:33)
> On Tue, Dec 08, 2020 at 01:20:56PM -0800, Kees Cook wrote:
> > On Mon, Dec 07, 2020 at 05:05:33PM +0000, Mark Rutland wrote:
> > > When building with KASAN and LKDTM, clang may implictly generate an
> > > asan.module_ctor function in the LKDTM rodata object. The Makefile mo=
ves
> > > the lkdtm_rodata_do_nothing() function into .rodata by renaming the
> > > file's .text section to .rodata, and consequently also moves the ctor
> > > function into .rodata, leading to a boot time crash (splat below) when
> > > the ctor is invoked by do_ctors().
> > >=20
> > > Let's prevent this by marking the function as noinstr rather than
> > > notrace, and renaming the file's .noinstr.text to .rodata. Marking the
> > > function as noinstr will prevent tracing and kprobes, and will inhibit
> > > any undesireable compiler instrumentation.
> > >=20
> > > The ctor function (if any) will be placed in .text and will work
> > > correctly.
> > >=20
> > > Example splat before this patch is applied:
> > >=20
> > > [    0.916359] Unable to handle kernel execute from non-executable me=
mory at virtual address ffffa0006b60f5ac
> > > [    0.922088] Mem abort info:
> > > [    0.922828]   ESR =3D 0x8600000e
> > > [    0.923635]   EC =3D 0x21: IABT (current EL), IL =3D 32 bits
> > > [    0.925036]   SET =3D 0, FnV =3D 0
> > > [    0.925838]   EA =3D 0, S1PTW =3D 0
> > > [    0.926714] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D00000000=
427b3000
> > > [    0.928489] [ffffa0006b60f5ac] pgd=3D000000023ffff003, p4d=3D00000=
0023ffff003, pud=3D000000023fffe003, pmd=3D0068000042000f01
> > > [    0.931330] Internal error: Oops: 8600000e [#1] PREEMPT SMP
> > > [    0.932806] Modules linked in:
> > > [    0.933617] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.0-rc7 #2
> > > [    0.935620] Hardware name: linux,dummy-virt (DT)
> > > [    0.936924] pstate: 40400005 (nZcv daif +PAN -UAO -TCO BTYPE=3D--)
> > > [    0.938609] pc : asan.module_ctor+0x0/0x14
> > > [    0.939759] lr : do_basic_setup+0x4c/0x70
> > > [    0.940889] sp : ffff27b600177e30
> > > [    0.941815] x29: ffff27b600177e30 x28: 0000000000000000
> > > [    0.943306] x27: 0000000000000000 x26: 0000000000000000
> > > [    0.944803] x25: 0000000000000000 x24: 0000000000000000
> > > [    0.946289] x23: 0000000000000001 x22: 0000000000000000
> > > [    0.947777] x21: ffffa0006bf4a890 x20: ffffa0006befb6c0
> > > [    0.949271] x19: ffffa0006bef9358 x18: 0000000000000068
> > > [    0.950756] x17: fffffffffffffff8 x16: 0000000000000000
> > > [    0.952246] x15: 0000000000000000 x14: 0000000000000000
> > > [    0.953734] x13: 00000000838a16d5 x12: 0000000000000001
> > > [    0.955223] x11: ffff94000da74041 x10: dfffa00000000000
> > > [    0.956715] x9 : 0000000000000000 x8 : ffffa0006b60f5ac
> > > [    0.958199] x7 : f9f9f9f9f9f9f9f9 x6 : 000000000000003f
> > > [    0.959683] x5 : 0000000000000040 x4 : 0000000000000000
> > > [    0.961178] x3 : ffffa0006bdc15a0 x2 : 0000000000000005
> > > [    0.962662] x1 : 00000000000000f9 x0 : ffffa0006bef9350
> > > [    0.964155] Call trace:
> > > [    0.964844]  asan.module_ctor+0x0/0x14
> > > [    0.965895]  kernel_init_freeable+0x158/0x198
> > > [    0.967115]  kernel_init+0x14/0x19c
> > > [    0.968104]  ret_from_fork+0x10/0x30
> > > [    0.969110] Code: 00000003 00000000 00000000 00000000 (00000000)
> > > [    0.970815] ---[ end trace b5339784e20d015c ]---
> > >=20
> > > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> >=20
> > Oh, eek. Why was a ctor generated at all? But yes, this looks good.
> > Greg, can you pick this up please?
> >=20
> > Acked-by: Kees Cook <keescook@chromium.org>
>=20
> Now picked up, thanks.
>=20

Can this be backported to 5.4 and 5.10 stable trees? I just ran across
this trying to use kasan on 5.4 with lkdtm and it blows up early. This
patch applies on 5.4 cleanly but doesn't compile because it's missing
noinstr. Here's a version of the patch that introduces noinstr on 5.4.97
so this patch can be picked to 5.4 stable trees.

----8<----
From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 9 Mar 2020 22:47:17 +0100
Subject: [PATCH] vmlinux.lds.h: Create section for protection against
 instrumentation

commit 6553896666433e7efec589838b400a2a652b3ffa upstream.

Some code pathes, especially the low level entry code, must be protected
against instrumentation for various reasons:

 - Low level entry code can be a fragile beast, especially on x86.

 - With NO_HZ_FULL RCU state needs to be established before using it.

Having a dedicated section for such code allows to validate with tooling
that no unsafe functions are invoked.

Add the .noinstr.text section and the noinstr attribute to mark
functions. noinstr implies notrace. Kprobes will gain a section check
later.

Provide also a set of markers: instrumentation_begin()/end()

These are used to mark code inside a noinstr function which calls
into regular instrumentable text section as safe.

The instrumentation markers are only active when CONFIG_DEBUG_ENTRY is
enabled as the end marker emits a NOP to prevent the compiler from merging
the annotation points. This means the objtool verification requires a
kernel compiled with this option.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200505134100.075416272@linutronix.de
[swboyd@chromium.org: Account for commit eff8728fe698 ("vmlinux.lds.h: Add
PGO and AutoFDO input sections") getting picked first]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/powerpc/kernel/vmlinux.lds.S |  1 +
 include/asm-generic/sections.h    |  3 ++
 include/asm-generic/vmlinux.lds.h | 10 ++++++
 include/linux/compiler.h          | 53 +++++++++++++++++++++++++++++++
 include/linux/compiler_types.h    |  4 +++
 scripts/mod/modpost.c             |  2 +-
 6 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinu=
x.lds.S
index a4e576019d79..3ea360cad337 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -102,6 +102,7 @@ SECTIONS
 #ifdef CONFIG_PPC64
 		*(.tramp.ftrace.text);
 #endif
+		NOINSTR_TEXT
 		SCHED_TEXT
 		CPUIDLE_TEXT
 		LOCK_TEXT
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index d1779d442aa5..66397ed10acb 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -53,6 +53,9 @@ extern char __ctors_start[], __ctors_end[];
 /* Start and end of .opd section - used for function descriptors. */
 extern char __start_opd[], __end_opd[];
=20
+/* Start and end of instrumentation protected text section */
+extern char __noinstr_text_start[], __noinstr_text_end[];
+
 extern __visible const void __nosave_begin, __nosave_end;
=20
 /* Function descriptor handling (if any).  Override in asm/sections.h */
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinu=
x.lds.h
index 130f16cc0b86..9a4a5a43e886 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -510,6 +510,15 @@
 #define RODATA          RO_DATA_SECTION(4096)
 #define RO_DATA(align)  RO_DATA_SECTION(align)
=20
+/*
+ * Non-instrumentable text section
+ */
+#define NOINSTR_TEXT							\
+		ALIGN_FUNCTION();					\
+		__noinstr_text_start =3D .;				\
+		*(.noinstr.text)					\
+		__noinstr_text_end =3D .;
+
 /*
  * .text section. Map to function alignment to avoid address changes
  * during second ld run in second ld pass when generating System.map
@@ -524,6 +533,7 @@
 		*(TEXT_MAIN .text.fixup)				\
 		*(.text.unlikely .text.unlikely.*)			\
 		*(.text.unknown .text.unknown.*)			\
+		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\
 	MEM_KEEP(init.text*)						\
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index f164a9b12813..9446e8fbe55c 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -134,12 +134,65 @@ void ftrace_likely_update(struct ftrace_likely_data *=
f, int val,
 /* Annotate a C jump table to allow objtool to follow the code flow */
 #define __annotate_jump_table __section(.rodata..c_jump_table)
=20
+#ifdef CONFIG_DEBUG_ENTRY
+/* Begin/end of an instrumentation safe region */
+#define instrumentation_begin() ({					\
+	asm volatile("%c0:\n\t"						\
+		     ".pushsection .discard.instr_begin\n\t"		\
+		     ".long %c0b - .\n\t"				\
+		     ".popsection\n\t" : : "i" (__COUNTER__));		\
+})
+
+/*
+ * Because instrumentation_{begin,end}() can nest, objtool validation cons=
iders
+ * _begin() a +1 and _end() a -1 and computes a sum over the instructions.
+ * When the value is greater than 0, we consider instrumentation allowed.
+ *
+ * There is a problem with code like:
+ *
+ * noinstr void foo()
+ * {
+ *	instrumentation_begin();
+ *	...
+ *	if (cond) {
+ *		instrumentation_begin();
+ *		...
+ *		instrumentation_end();
+ *	}
+ *	bar();
+ *	instrumentation_end();
+ * }
+ *
+ * If instrumentation_end() would be an empty label, like all the other
+ * annotations, the inner _end(), which is at the end of a conditional blo=
ck,
+ * would land on the instruction after the block.
+ *
+ * If we then consider the sum of the !cond path, we'll see that the call =
to
+ * bar() is with a 0-value, even though, we meant it to happen with a posi=
tive
+ * value.
+ *
+ * To avoid this, have _end() be a NOP instruction, this ensures it will be
+ * part of the condition block and does not escape.
+ */
+#define instrumentation_end() ({					\
+	asm volatile("%c0: nop\n\t"					\
+		     ".pushsection .discard.instr_end\n\t"		\
+		     ".long %c0b - .\n\t"				\
+		     ".popsection\n\t" : : "i" (__COUNTER__));		\
+})
+#endif /* CONFIG_DEBUG_ENTRY */
+
 #else
 #define annotate_reachable()
 #define annotate_unreachable()
 #define __annotate_jump_table
 #endif
=20
+#ifndef instrumentation_begin
+#define instrumentation_begin()		do { } while(0)
+#define instrumentation_end()		do { } while(0)
+#endif
+
 #ifndef ASM_UNREACHABLE
 # define ASM_UNREACHABLE
 #endif
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 77433633572e..b94d08d055ff 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -118,6 +118,10 @@ struct ftrace_likely_data {
 #define notrace			__attribute__((__no_instrument_function__))
 #endif
=20
+/* Section for code which can't be instrumented at all */
+#define noinstr								\
+	noinline notrace __attribute((__section__(".noinstr.text")))
+
 /*
  * it doesn't make sense on ARM (currently the only user of __naked)
  * to trace naked functions because then mcount is called without
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 52f1152c9838..13cda6aa2688 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -960,7 +960,7 @@ static void check_section(const char *modname, struct e=
lf_info *elf,
=20
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
-		".kprobes.text", ".cpuidle.text"
+		".kprobes.text", ".cpuidle.text", ".noinstr.text"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", ".text.*", \
 		".coldtext"
--=20
https://chromeos.dev
