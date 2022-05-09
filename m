Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6156151F708
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 10:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbiEIIql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 04:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237557AbiEIIic (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:38:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123561F35EB
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:34:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00E4B614AB
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111AEC385A8;
        Mon,  9 May 2022 08:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652085237;
        bh=BCoiRFATU8xowG4t0E0Vq1XVcl0LhYRjhODrA7fQB8U=;
        h=Subject:To:Cc:From:Date:From;
        b=Nu0wxhOxIbMZXB6zzkwq14ynbBawAi/RfLYp4sNJqDMZ7USaug96If/2r3H3RCkvE
         qBUdexRqi8TYF/5e8A0Che+Gdwso3RRDjORczeKWxlURPPG6qXtWldK9Ssg6vNZX9m
         VGLofGsJKKW+MfX1VkFkGA5KdZJMX2bWfDpT3Xo4=
Subject: FAILED: patch "[PATCH] powerpc/vdso: Fix incorrect CFI in gettimeofday.S" failed to apply to 5.15-stable tree
To:     mpe@ellerman.id.au, amodra@gmail.com, segher@kernel.crashing.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:33:46 +0200
Message-ID: <1652085226120148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6d65028eb67dbb7627651adfc460d64196d38bd8 Mon Sep 17 00:00:00 2001
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Mon, 2 May 2022 22:50:10 +1000
Subject: [PATCH] powerpc/vdso: Fix incorrect CFI in gettimeofday.S

As reported by Alan, the CFI (Call Frame Information) in the VDSO time
routines is incorrect since commit ce7d8056e38b ("powerpc/vdso: Prepare
for switching VDSO to generic C implementation.").

DWARF has a concept called the CFA (Canonical Frame Address), which on
powerpc is calculated as an offset from the stack pointer (r1). That
means when the stack pointer is changed there must be a corresponding
CFI directive to update the calculation of the CFA.

The current code is missing those directives for the changes to r1,
which prevents gdb from being able to generate a backtrace from inside
VDSO functions, eg:

  Breakpoint 1, 0x00007ffff7f804dc in __kernel_clock_gettime ()
  (gdb) bt
  #0  0x00007ffff7f804dc in __kernel_clock_gettime ()
  #1  0x00007ffff7d8872c in clock_gettime@@GLIBC_2.17 () from /lib64/libc.so.6
  #2  0x00007fffffffd960 in ?? ()
  #3  0x00007ffff7d8872c in clock_gettime@@GLIBC_2.17 () from /lib64/libc.so.6
  Backtrace stopped: frame did not save the PC

Alan helpfully describes some rules for correctly maintaining the CFI information:

  1) Every adjustment to the current frame address reg (ie. r1) must be
     described, and exactly at the instruction where r1 changes. Why?
     Because stack unwinding might want to access previous frames.

  2) If a function changes LR or any non-volatile register, the save
     location for those regs must be given. The CFI can be at any
     instruction after the saves up to the point that the reg is
     changed.
     (Exception: LR save should be described before a bl. not after)

  3) If asychronous unwind info is needed then restores of LR and
     non-volatile regs must also be described. The CFI can be at any
     instruction after the reg is restored up to the point where the
     save location is (potentially) trashed.

Fix the inability to backtrace by adding CFI directives describing the
changes to r1, ie. satisfying rule 1.

Also change the information for LR to point to the copy saved on the
stack, not the value in r0 that will be overwritten by the function
call.

Finally, add CFI directives describing the save/restore of r2.

With the fix gdb can correctly back trace and navigate up and down the stack:

  Breakpoint 1, 0x00007ffff7f804dc in __kernel_clock_gettime ()
  (gdb) bt
  #0  0x00007ffff7f804dc in __kernel_clock_gettime ()
  #1  0x00007ffff7d8872c in clock_gettime@@GLIBC_2.17 () from /lib64/libc.so.6
  #2  0x0000000100015b60 in gettime ()
  #3  0x000000010000c8bc in print_long_format ()
  #4  0x000000010000d180 in print_current_files ()
  #5  0x00000001000054ac in main ()
  (gdb) up
  #1  0x00007ffff7d8872c in clock_gettime@@GLIBC_2.17 () from /lib64/libc.so.6
  (gdb)
  #2  0x0000000100015b60 in gettime ()
  (gdb)
  #3  0x000000010000c8bc in print_long_format ()
  (gdb)
  #4  0x000000010000d180 in print_current_files ()
  (gdb)
  #5  0x00000001000054ac in main ()
  (gdb)
  Initial frame selected; you cannot go up.
  (gdb) down
  #4  0x000000010000d180 in print_current_files ()
  (gdb)
  #3  0x000000010000c8bc in print_long_format ()
  (gdb)
  #2  0x0000000100015b60 in gettime ()
  (gdb)
  #1  0x00007ffff7d8872c in clock_gettime@@GLIBC_2.17 () from /lib64/libc.so.6
  (gdb)
  #0  0x00007ffff7f804dc in __kernel_clock_gettime ()
  (gdb)

Fixes: ce7d8056e38b ("powerpc/vdso: Prepare for switching VDSO to generic C implementation.")
Cc: stable@vger.kernel.org # v5.11+
Reported-by: Alan Modra <amodra@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Link: https://lore.kernel.org/r/20220502125010.1319370-1-mpe@ellerman.id.au

diff --git a/arch/powerpc/kernel/vdso/gettimeofday.S b/arch/powerpc/kernel/vdso/gettimeofday.S
index eb9c81e1c218..0c4ecc8fec5a 100644
--- a/arch/powerpc/kernel/vdso/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso/gettimeofday.S
@@ -22,12 +22,15 @@
 .macro cvdso_call funct call_time=0
   .cfi_startproc
 	PPC_STLU	r1, -PPC_MIN_STKFRM(r1)
+  .cfi_adjust_cfa_offset PPC_MIN_STKFRM
 	mflr		r0
-  .cfi_register lr, r0
 	PPC_STLU	r1, -PPC_MIN_STKFRM(r1)
+  .cfi_adjust_cfa_offset PPC_MIN_STKFRM
 	PPC_STL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
+  .cfi_rel_offset lr, PPC_MIN_STKFRM + PPC_LR_STKOFF
 #ifdef __powerpc64__
 	PPC_STL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
+  .cfi_rel_offset r2, PPC_MIN_STKFRM + STK_GOT
 #endif
 	get_datapage	r5
 	.ifeq	\call_time
@@ -39,13 +42,15 @@
 	PPC_LL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
 #ifdef __powerpc64__
 	PPC_LL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
+  .cfi_restore r2
 #endif
 	.ifeq	\call_time
 	cmpwi		r3, 0
 	.endif
 	mtlr		r0
-  .cfi_restore lr
 	addi		r1, r1, 2 * PPC_MIN_STKFRM
+  .cfi_restore lr
+  .cfi_def_cfa_offset 0
 	crclr		so
 	.ifeq	\call_time
 	beqlr+

