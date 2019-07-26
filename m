Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 523E2767FF
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387707AbfGZNle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387684AbfGZNld (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8318C22C7E;
        Fri, 26 Jul 2019 13:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148492;
        bh=GW0O4su0+jo8cvZFRc9DvBmZIcDS/EEOKB/t6yQRqUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHD/LV4k55pGSQ9Trvhls3fGsTApaqzqAbMON9JUXEogrHP/vp1QzeWgUA/VFPTT1
         8Xt6xu9x2DUQ92OUlr6GugolbQgBZYl/+vKe9iJjSQI9mxGbUSSeJPyL0XBpyMkbpr
         ZMwIGAf5vm718QMfnJUtbBj2mEJvcNlkRi8jnBF0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Dmitry V. Levin" <ldv@altlinux.org>,
        kbuild test robot <lkp@intel.com>,
        Greentime Hu <greentime@andestech.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Elvira Khabirova <lineprinter@altlinux.org>,
        Eugene Syromyatnikov <esyr@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Helge Deller <deller@gmx.de>,
        "James E . J . Bottomley" <jejb@parisc-linux.org>,
        James Hogan <jhogan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Burton <paul.burton@mips.com>,
        Paul Mackerras <paulus@samba.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 66/85] nds32: fix asm/syscall.h
Date:   Fri, 26 Jul 2019 09:39:16 -0400
Message-Id: <20190726133936.11177-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Dmitry V. Levin" <ldv@altlinux.org>

[ Upstream commit 33644b95eb342201511fc951d8fcd10362bd435b ]

PTRACE_GET_SYSCALL_INFO is a generic ptrace API that lets ptracer obtain
details of the syscall the tracee is blocked in.

There are two reasons for a special syscall-related ptrace request.

Firstly, with the current ptrace API there are cases when ptracer cannot
retrieve necessary information about syscalls.  Some examples include:

 * The notorious int-0x80-from-64-bit-task issue. See [1] for details.
   In short, if a 64-bit task performs a syscall through int 0x80, its
   tracer has no reliable means to find out that the syscall was, in
   fact, a compat syscall, and misidentifies it.

 * Syscall-enter-stop and syscall-exit-stop look the same for the
   tracer. Common practice is to keep track of the sequence of
   ptrace-stops in order not to mix the two syscall-stops up. But it is
   not as simple as it looks; for example, strace had a (just recently
   fixed) long-standing bug where attaching strace to a tracee that is
   performing the execve system call led to the tracer identifying the
   following syscall-exit-stop as syscall-enter-stop, which messed up
   all the state tracking.

 * Since the introduction of commit 84d77d3f06e7 ("ptrace: Don't allow
   accessing an undumpable mm"), both PTRACE_PEEKDATA and
   process_vm_readv become unavailable when the process dumpable flag is
   cleared. On such architectures as ia64 this results in all syscall
   arguments being unavailable for the tracer.

Secondly, ptracers also have to support a lot of arch-specific code for
obtaining information about the tracee.  For some architectures, this
requires a ptrace(PTRACE_PEEKUSER, ...) invocation for every syscall
argument and return value.

PTRACE_GET_SYSCALL_INFO returns the following structure:

struct ptrace_syscall_info {
	__u8 op;	/* PTRACE_SYSCALL_INFO_* */
	__u32 arch __attribute__((__aligned__(sizeof(__u32))));
	__u64 instruction_pointer;
	__u64 stack_pointer;
	union {
		struct {
			__u64 nr;
			__u64 args[6];
		} entry;
		struct {
			__s64 rval;
			__u8 is_error;
		} exit;
		struct {
			__u64 nr;
			__u64 args[6];
			__u32 ret_data;
		} seccomp;
	};
};

The structure was chosen according to [2], except for the following
changes:

 * seccomp substructure was added as a superset of entry substructure

 * the type of nr field was changed from int to __u64 because syscall
   numbers are, as a practical matter, 64 bits

 * stack_pointer field was added along with instruction_pointer field
   since it is readily available and can save the tracer from extra
   PTRACE_GETREGS/PTRACE_GETREGSET calls

 * arch is always initialized to aid with tracing system calls such as
   execve()

 * instruction_pointer and stack_pointer are always initialized so they
   could be easily obtained for non-syscall stops

 * a boolean is_error field was added along with rval field, this way
   the tracer can more reliably distinguish a return value from an error
   value

strace has been ported to PTRACE_GET_SYSCALL_INFO.  Starting with
release 4.26, strace uses PTRACE_GET_SYSCALL_INFO API as the preferred
mechanism of obtaining syscall information.

[1] https://lore.kernel.org/lkml/CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com/
[2] https://lore.kernel.org/lkml/CAObL_7GM0n80N7J_DFw_eQyfLyzq+sf4y2AvsCCV88Tb3AwEHA@mail.gmail.com/

This patch (of 7):

All syscall_get_*() and syscall_set_*() functions must be defined as
static inline as on all other architectures, otherwise asm/syscall.h
cannot be included in more than one compilation unit.

This bug has to be fixed in order to extend the generic
ptrace API with PTRACE_GET_SYSCALL_INFO request.

Link: http://lkml.kernel.org/r/20190510152749.GA28558@altlinux.org
Fixes: 1932fbe36e02 ("nds32: System calls handling")
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Reported-by: kbuild test robot <lkp@intel.com>
Acked-by: Greentime Hu <greentime@andestech.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Elvira Khabirova <lineprinter@altlinux.org>
Cc: Eugene Syromyatnikov <esyr@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Helge Deller <deller@gmx.de>	[parisc]
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nds32/include/asm/syscall.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/nds32/include/asm/syscall.h b/arch/nds32/include/asm/syscall.h
index 899b2fb4b52f..7b5180d78e20 100644
--- a/arch/nds32/include/asm/syscall.h
+++ b/arch/nds32/include/asm/syscall.h
@@ -26,7 +26,8 @@ struct pt_regs;
  *
  * It's only valid to call this when @task is known to be blocked.
  */
-int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
+static inline int
+syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
 	return regs->syscallno;
 }
@@ -47,7 +48,8 @@ int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
  * system call instruction.  This may not be the same as what the
  * register state looked like at system call entry tracing.
  */
-void syscall_rollback(struct task_struct *task, struct pt_regs *regs)
+static inline void
+syscall_rollback(struct task_struct *task, struct pt_regs *regs)
 {
 	regs->uregs[0] = regs->orig_r0;
 }
@@ -62,7 +64,8 @@ void syscall_rollback(struct task_struct *task, struct pt_regs *regs)
  * It's only valid to call this when @task is stopped for tracing on exit
  * from a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
  */
-long syscall_get_error(struct task_struct *task, struct pt_regs *regs)
+static inline long
+syscall_get_error(struct task_struct *task, struct pt_regs *regs)
 {
 	unsigned long error = regs->uregs[0];
 	return IS_ERR_VALUE(error) ? error : 0;
@@ -79,7 +82,8 @@ long syscall_get_error(struct task_struct *task, struct pt_regs *regs)
  * It's only valid to call this when @task is stopped for tracing on exit
  * from a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
  */
-long syscall_get_return_value(struct task_struct *task, struct pt_regs *regs)
+static inline long
+syscall_get_return_value(struct task_struct *task, struct pt_regs *regs)
 {
 	return regs->uregs[0];
 }
@@ -99,8 +103,9 @@ long syscall_get_return_value(struct task_struct *task, struct pt_regs *regs)
  * It's only valid to call this when @task is stopped for tracing on exit
  * from a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
  */
-void syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
-			      int error, long val)
+static inline void
+syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
+			 int error, long val)
 {
 	regs->uregs[0] = (long)error ? error : val;
 }
@@ -118,8 +123,9 @@ void syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
  * entry to a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
  */
 #define SYSCALL_MAX_ARGS 6
-void syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
-			   unsigned long *args)
+static inline void
+syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
+		      unsigned long *args)
 {
 	args[0] = regs->orig_r0;
 	args++;
@@ -138,8 +144,9 @@ void syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
  * It's only valid to call this when @task is stopped for tracing on
  * entry to a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
  */
-void syscall_set_arguments(struct task_struct *task, struct pt_regs *regs,
-			   const unsigned long *args)
+static inline void
+syscall_set_arguments(struct task_struct *task, struct pt_regs *regs,
+		      const unsigned long *args)
 {
 	regs->orig_r0 = args[0];
 	args++;
-- 
2.20.1

