Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD4E14BBF5
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgA1N7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 08:59:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgA1N7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 08:59:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D181C2468D;
        Tue, 28 Jan 2020 13:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580219943;
        bh=8qa/C4WSRjh0Y0jvPc58tQQl7y91KRwZ/i3eMqfuevs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkRBQCop+7YuyO4G2Hnpgm4R3pg2OdXm+WisgSwbzcTEX5ei6PMJZUFcTwQTIg5yA
         e2RCOBgB5NaKmDaUtkHL5vCjFtvlzHYhA2w4E5KQx0suRm313qxdt65Y6zuWeV8dCs
         TwI1d1AMQ0Jf1rZBoKGwocHMlIKZ5rByHxwejH6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.14 23/46] ARM: 8950/1: ftrace/recordmcount: filter relocation types
Date:   Tue, 28 Jan 2020 14:57:57 +0100
Message-Id: <20200128135752.858200031@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135749.822297911@linuxfoundation.org>
References: <20200128135749.822297911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 927d780ee371d7e121cea4fc7812f6ef2cea461c upstream.

Scenario 1, ARMv7
=================

If code in arch/arm/kernel/ftrace.c would operate on mcount() pointer
the following may be generated:

00000230 <prealloc_fixed_plts>:
 230:   b5f8            push    {r3, r4, r5, r6, r7, lr}
 232:   b500            push    {lr}
 234:   f7ff fffe       bl      0 <__gnu_mcount_nc>
                        234: R_ARM_THM_CALL     __gnu_mcount_nc
 238:   f240 0600       movw    r6, #0
                        238: R_ARM_THM_MOVW_ABS_NC      __gnu_mcount_nc
 23c:   f8d0 1180       ldr.w   r1, [r0, #384]  ; 0x180

FTRACE currently is not able to deal with it:

WARNING: CPU: 0 PID: 0 at .../kernel/trace/ftrace.c:1979 ftrace_bug+0x1ad/0x230()
...
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.116-... #1
...
[<c0314e3d>] (unwind_backtrace) from [<c03115e9>] (show_stack+0x11/0x14)
[<c03115e9>] (show_stack) from [<c051a7f1>] (dump_stack+0x81/0xa8)
[<c051a7f1>] (dump_stack) from [<c0321c5d>] (warn_slowpath_common+0x69/0x90)
[<c0321c5d>] (warn_slowpath_common) from [<c0321cf3>] (warn_slowpath_null+0x17/0x1c)
[<c0321cf3>] (warn_slowpath_null) from [<c038ee9d>] (ftrace_bug+0x1ad/0x230)
[<c038ee9d>] (ftrace_bug) from [<c038f1f9>] (ftrace_process_locs+0x27d/0x444)
[<c038f1f9>] (ftrace_process_locs) from [<c08915bd>] (ftrace_init+0x91/0xe8)
[<c08915bd>] (ftrace_init) from [<c0885a67>] (start_kernel+0x34b/0x358)
[<c0885a67>] (start_kernel) from [<00308095>] (0x308095)
---[ end trace cb88537fdc8fa200 ]---
ftrace failed to modify [<c031266c>] prealloc_fixed_plts+0x8/0x60
 actual: 44:f2:e1:36
ftrace record flags: 0
 (0)   expected tramp: c03143e9

Scenario 2, ARMv4T
==================

ftrace: allocating 14435 entries in 43 pages
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/trace/ftrace.c:2029 ftrace_bug+0x204/0x310
CPU: 0 PID: 0 Comm: swapper Not tainted 4.19.5 #1
Hardware name: Cirrus Logic EDB9302 Evaluation Board
[<c0010a24>] (unwind_backtrace) from [<c000ecb0>] (show_stack+0x20/0x2c)
[<c000ecb0>] (show_stack) from [<c03c72e8>] (dump_stack+0x20/0x30)
[<c03c72e8>] (dump_stack) from [<c0021c18>] (__warn+0xdc/0x104)
[<c0021c18>] (__warn) from [<c0021d7c>] (warn_slowpath_null+0x4c/0x5c)
[<c0021d7c>] (warn_slowpath_null) from [<c0095360>] (ftrace_bug+0x204/0x310)
[<c0095360>] (ftrace_bug) from [<c04dabac>] (ftrace_init+0x3b4/0x4d4)
[<c04dabac>] (ftrace_init) from [<c04cef4c>] (start_kernel+0x20c/0x410)
[<c04cef4c>] (start_kernel) from [<00000000>] (  (null))
---[ end trace 0506a2f5dae6b341 ]---
ftrace failed to modify
[<c000c350>] perf_trace_sys_exit+0x5c/0xe8
 actual:   1e:ff:2f:e1
Initializing ftrace call sites
ftrace record flags: 0
 (0)
 expected tramp: c000fb24

The analysis for this problem has been already performed previously,
refer to the link below.

Fix the above problems by allowing only selected reloc types in
__mcount_loc. The list itself comes from the legacy recordmcount.pl
script.

Link: https://lore.kernel.org/lkml/56961010.6000806@pengutronix.de/
Cc: stable@vger.kernel.org
Fixes: ed60453fa8f8 ("ARM: 6511/1: ftrace: add ARM support for C version of recordmcount")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/recordmcount.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -53,6 +53,10 @@
 #define R_AARCH64_ABS64	257
 #endif
 
+#define R_ARM_PC24		1
+#define R_ARM_THM_CALL		10
+#define R_ARM_CALL		28
+
 static int fd_map;	/* File descriptor for file being modified. */
 static int mmap_failed; /* Boolean flag. */
 static char gpfx;	/* prefix for global symbol name (sometimes '_') */
@@ -428,6 +432,18 @@ is_mcounted_section_name(char const *con
 #define RECORD_MCOUNT_64
 #include "recordmcount.h"
 
+static int arm_is_fake_mcount(Elf32_Rel const *rp)
+{
+	switch (ELF32_R_TYPE(w(rp->r_info))) {
+	case R_ARM_THM_CALL:
+	case R_ARM_CALL:
+	case R_ARM_PC24:
+		return 0;
+	}
+
+	return 1;
+}
+
 /* 64-bit EM_MIPS has weird ELF64_Rela.r_info.
  * http://techpubs.sgi.com/library/manuals/4000/007-4658-001/pdf/007-4658-001.pdf
  * We interpret Table 29 Relocation Operation (Elf64_Rel, Elf64_Rela) [p.40]
@@ -529,6 +545,7 @@ do_file(char const *const fname)
 			 altmcount = "__gnu_mcount_nc";
 			 make_nop = make_nop_arm;
 			 rel_type_nop = R_ARM_NONE;
+			 is_fake_mcount32 = arm_is_fake_mcount;
 			 break;
 	case EM_AARCH64:
 			reltype = R_AARCH64_ABS64;


