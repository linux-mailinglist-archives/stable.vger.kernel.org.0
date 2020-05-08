Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE631CB037
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgEHMgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727799AbgEHMga (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9F0321BE5;
        Fri,  8 May 2020 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941389;
        bh=u9rKLODDnxJ62KcHyjqYSqVmX6PsXidIZ0neKNnpZlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mcm4JcTwWIx6k4P0g4BjH7TZUfVR/zBvhd+Y5abi0FW4pLCEc906/NwfQR1oKgivy
         yLjl16pemYR2vM/eAwcxkvwLLRn0RdjrmdIvPfQdbPx8jeyoPs4q4/5fDj8oIIYD7V
         c1yUiKW8ZfrbCl4fiYxD6MkV5QCS+XIdGSh1WcrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Redfearn <matt.redfearn@imgtec.com>,
        Kees Cook <keescook@chromium.org>,
        Eric B Munson <emunson@akamai.com>,
        James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mips@linux-mips.org,
        IMG-MIPSLinuxKerneldevelopers@imgtec.com,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 013/312] MIPS: scall: Handle seccomp filters which redirect syscalls
Date:   Fri,  8 May 2020 14:30:04 +0200
Message-Id: <20200508123125.436806921@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Redfearn <matt.redfearn@imgtec.com>

commit a400bed6d105c23d3673f763596e4b85de14e41a upstream.

Commit d218af78492a ("MIPS: scall: Always run the seccomp syscall
filters") modified the syscall code to always call the seccomp filters,
but missed the case where a filter may redirect the syscall, as
revealed by the seccomp_bpf self test.

The syscall path now restores the syscall from the stack after the
filter rather than saving it locally. Syscall number checking and
syscall function table lookup is done after the filter may have run such
that redirected syscalls are also checked, and executed.

The regular path of syscall number checking and pointer lookup is also
made more consistent between ABIs with scall64-64.S being the reference.

With this patch in place, the seccomp_bpf self test now passes
TRACE_syscall.syscall_redirected and TRACE_syscall.syscall_dropped on
all MIPS ABIs.

Fixes: d218af78492a ("MIPS: scall: Always run the seccomp syscall filters")
Signed-off-by: Matt Redfearn <matt.redfearn@imgtec.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Eric B Munson <emunson@akamai.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mips@linux-mips.org
Cc: IMG-MIPSLinuxKerneldevelopers@imgtec.com
Cc: linux-kernel@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/12916/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/scall32-o32.S |   11 +++++------
 arch/mips/kernel/scall64-64.S  |    3 +--
 arch/mips/kernel/scall64-n32.S |   14 +++++++++-----
 arch/mips/kernel/scall64-o32.S |   14 +++++++++-----
 4 files changed, 24 insertions(+), 18 deletions(-)

--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -35,7 +35,6 @@ NESTED(handle_sys, PT_SIZE, sp)
 
 	lw	t1, PT_EPC(sp)		# skip syscall on return
 
-	subu	v0, v0, __NR_O32_Linux	# check syscall number
 	addiu	t1, 4			# skip to next instruction
 	sw	t1, PT_EPC(sp)
 
@@ -89,6 +88,7 @@ loads_done:
 	and	t0, t1
 	bnez	t0, syscall_trace_entry # -> yes
 syscall_common:
+	subu	v0, v0, __NR_O32_Linux	# check syscall number
 	sltiu	t0, v0, __NR_O32_Linux_syscalls + 1
 	beqz	t0, illegal_syscall
 
@@ -118,24 +118,23 @@ o32_syscall_exit:
 
 syscall_trace_entry:
 	SAVE_STATIC
-	move	s0, v0
 	move	a0, sp
 
 	/*
 	 * syscall number is in v0 unless we called syscall(__NR_###)
 	 * where the real syscall number is in a0
 	 */
-	addiu	a1, v0,  __NR_O32_Linux
-	bnez	v0, 1f /* __NR_syscall at offset 0 */
+	move	a1, v0
+	subu	t2, v0,  __NR_O32_Linux
+	bnez	t2, 1f /* __NR_syscall at offset 0 */
 	lw	a1, PT_R4(sp)
 
 1:	jal	syscall_trace_enter
 
 	bltz	v0, 1f			# seccomp failed? Skip syscall
 
-	move	v0, s0			# restore syscall
-
 	RESTORE_STATIC
+	lw	v0, PT_R2(sp)		# Restore syscall (maybe modified)
 	lw	a0, PT_R4(sp)		# Restore argument registers
 	lw	a1, PT_R5(sp)
 	lw	a2, PT_R6(sp)
--- a/arch/mips/kernel/scall64-64.S
+++ b/arch/mips/kernel/scall64-64.S
@@ -82,15 +82,14 @@ n64_syscall_exit:
 
 syscall_trace_entry:
 	SAVE_STATIC
-	move	s0, v0
 	move	a0, sp
 	move	a1, v0
 	jal	syscall_trace_enter
 
 	bltz	v0, 1f			# seccomp failed? Skip syscall
 
-	move	v0, s0
 	RESTORE_STATIC
+	ld	v0, PT_R2(sp)		# Restore syscall (maybe modified)
 	ld	a0, PT_R4(sp)		# Restore argument registers
 	ld	a1, PT_R5(sp)
 	ld	a2, PT_R6(sp)
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -42,9 +42,6 @@ NESTED(handle_sysn32, PT_SIZE, sp)
 #endif
 	beqz	t0, not_n32_scall
 
-	dsll	t0, v0, 3		# offset into table
-	ld	t2, (sysn32_call_table - (__NR_N32_Linux * 8))(t0)
-
 	sd	a3, PT_R26(sp)		# save a3 for syscall restarting
 
 	li	t1, _TIF_WORK_SYSCALL_ENTRY
@@ -53,6 +50,9 @@ NESTED(handle_sysn32, PT_SIZE, sp)
 	bnez	t0, n32_syscall_trace_entry
 
 syscall_common:
+	dsll	t0, v0, 3		# offset into table
+	ld	t2, (sysn32_call_table - (__NR_N32_Linux * 8))(t0)
+
 	jalr	t2			# Do The Real Thing (TM)
 
 	li	t0, -EMAXERRNO - 1	# error?
@@ -71,21 +71,25 @@ syscall_common:
 
 n32_syscall_trace_entry:
 	SAVE_STATIC
-	move	s0, t2
 	move	a0, sp
 	move	a1, v0
 	jal	syscall_trace_enter
 
 	bltz	v0, 1f			# seccomp failed? Skip syscall
 
-	move	t2, s0
 	RESTORE_STATIC
+	ld	v0, PT_R2(sp)		# Restore syscall (maybe modified)
 	ld	a0, PT_R4(sp)		# Restore argument registers
 	ld	a1, PT_R5(sp)
 	ld	a2, PT_R6(sp)
 	ld	a3, PT_R7(sp)
 	ld	a4, PT_R8(sp)
 	ld	a5, PT_R9(sp)
+
+	dsubu	t2, v0, __NR_N32_Linux	# check (new) syscall number
+	sltiu   t0, t2, __NR_N32_Linux_syscalls + 1
+	beqz	t0, not_n32_scall
+
 	j	syscall_common
 
 1:	j	syscall_exit
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -52,9 +52,6 @@ NESTED(handle_sys, PT_SIZE, sp)
 	sll	a2, a2, 0
 	sll	a3, a3, 0
 
-	dsll	t0, v0, 3		# offset into table
-	ld	t2, (sys32_call_table - (__NR_O32_Linux * 8))(t0)
-
 	sd	a3, PT_R26(sp)		# save a3 for syscall restarting
 
 	/*
@@ -88,6 +85,9 @@ loads_done:
 	bnez	t0, trace_a_syscall
 
 syscall_common:
+	dsll	t0, v0, 3		# offset into table
+	ld	t2, (sys32_call_table - (__NR_O32_Linux * 8))(t0)
+
 	jalr	t2			# Do The Real Thing (TM)
 
 	li	t0, -EMAXERRNO - 1	# error?
@@ -112,7 +112,6 @@ trace_a_syscall:
 	sd	a6, PT_R10(sp)
 	sd	a7, PT_R11(sp)		# For indirect syscalls
 
-	move	s0, t2			# Save syscall pointer
 	move	a0, sp
 	/*
 	 * absolute syscall number is in v0 unless we called syscall(__NR_###)
@@ -133,8 +132,8 @@ trace_a_syscall:
 
 	bltz	v0, 1f			# seccomp failed? Skip syscall
 
-	move	t2, s0
 	RESTORE_STATIC
+	ld	v0, PT_R2(sp)		# Restore syscall (maybe modified)
 	ld	a0, PT_R4(sp)		# Restore argument registers
 	ld	a1, PT_R5(sp)
 	ld	a2, PT_R6(sp)
@@ -143,6 +142,11 @@ trace_a_syscall:
 	ld	a5, PT_R9(sp)
 	ld	a6, PT_R10(sp)
 	ld	a7, PT_R11(sp)		# For indirect syscalls
+
+	dsubu	t0, v0, __NR_O32_Linux	# check (new) syscall number
+	sltiu	t0, t0, __NR_O32_Linux_syscalls + 1
+	beqz	t0, not_o32_scall
+
 	j	syscall_common
 
 1:	j	syscall_exit


