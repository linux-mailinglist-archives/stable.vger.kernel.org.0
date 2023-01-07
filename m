Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779E5660B00
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 01:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbjAGAnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 19:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbjAGAnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 19:43:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2174B6B5F9;
        Fri,  6 Jan 2023 16:43:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 629C661EE7;
        Sat,  7 Jan 2023 00:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BBCC433F0;
        Sat,  7 Jan 2023 00:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673052195;
        bh=eHFEk2ziQcEX+0onC2cK7Pczr3ZCinAZ5OSr+1rci68=;
        h=Date:To:From:Subject:From;
        b=iGMkTAYEOXLE4TO5upFoXC29TkZ2SIV19qSWPogzG+UC3s9iO/9QLLDcC1X82mfpw
         orRoyfHpr3uEffrmWOgHM0Nf9c+32ShCTeXEcXiFJl5rQ5Qrp7rrrpulUbLnspSXZ3
         /l6v/fWy0a5zr9KXEq9gBrXz+zzVZCt2M98sT2nA=
Date:   Fri, 06 Jan 2023 16:43:14 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mirsad.todorovac@alu.unizg.hr, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-pie-proc-empty-vm-proc-pid-vm-tests.patch added to mm-hotfixes-unstable branch
Message-Id: <20230107004315.B0BBCC433F0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: proc: fix PIE proc-empty-vm, proc-pid-vm tests
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-fix-pie-proc-empty-vm-proc-pid-vm-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-fix-pie-proc-empty-vm-proc-pid-vm-tests.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fix PIE proc-empty-vm, proc-pid-vm tests
Date: Fri, 6 Jan 2023 22:30:14 +0300

vsyscall detection code uses direct call to the beginning of
the vsyscall page:

	asm ("call %P0" :: "i" (0xffffffffff600000))

It generates "call rel32" instruction but it is not relocated if binary
is PIE, so binary segfaults into random userspace address and vsyscall
page status is detected incorrectly.

Do more direct:

	asm ("call *%rax")

which doesn't do need any relocaltions.

Mark g_vsyscall as volatile for a good measure, I didn't find instruction
setting it to 0. Now the code is obviously correct:

	xor	eax, eax
	mov	rdi, rbp
	mov	rsi, rbp
	mov	DWORD PTR [rip+0x2d15], eax      # g_vsyscall = 0
	mov	rax, 0xffffffffff600000
	call	rax
	mov	DWORD PTR [rip+0x2d02], 1        # g_vsyscall = 1
	mov	eax, DWORD PTR ds:0xffffffffff600000
	mov	DWORD PTR [rip+0x2cf1], 2        # g_vsyscall = 2
	mov	edi, [rip+0x2ceb]                # exit(g_vsyscall)
	call	exit

Note: fixed proc-empty-vm test oopses 5.19.0-28-generic kernel
	but this is separate story.

Link: https://lkml.kernel.org/r/Y7h2xvzKLg36DSq8@p183
Fixes: 5bc73bb3451b9 ("proc: test how it holds up with mapping'less process")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |   12 +++++++-----
 tools/testing/selftests/proc/proc-pid-vm.c   |    9 +++++----
 2 files changed, 12 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~proc-fix-pie-proc-empty-vm-proc-pid-vm-tests
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -25,6 +25,7 @@
 #undef NDEBUG
 #include <assert.h>
 #include <errno.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -41,7 +42,7 @@
  * 1: vsyscall VMA is --xp		vsyscall=xonly
  * 2: vsyscall VMA is r-xp		vsyscall=emulate
  */
-static int g_vsyscall;
+static volatile int g_vsyscall;
 static const char *g_proc_pid_maps_vsyscall;
 static const char *g_proc_pid_smaps_vsyscall;
 
@@ -147,11 +148,12 @@ static void vsyscall(void)
 
 		g_vsyscall = 0;
 		/* gettimeofday(NULL, NULL); */
+		uint64_t rax = 0xffffffffff600000;
 		asm volatile (
-			"call %P0"
-			:
-			: "i" (0xffffffffff600000), "D" (NULL), "S" (NULL)
-			: "rax", "rcx", "r11"
+			"call *%[rax]"
+			: [rax] "+a" (rax)
+			: "D" (NULL), "S" (NULL)
+			: "rcx", "r11"
 		);
 
 		g_vsyscall = 1;
--- a/tools/testing/selftests/proc/proc-pid-vm.c~proc-fix-pie-proc-empty-vm-proc-pid-vm-tests
+++ a/tools/testing/selftests/proc/proc-pid-vm.c
@@ -257,11 +257,12 @@ static void vsyscall(void)
 
 		g_vsyscall = 0;
 		/* gettimeofday(NULL, NULL); */
+		uint64_t rax = 0xffffffffff600000;
 		asm volatile (
-			"call %P0"
-			:
-			: "i" (0xffffffffff600000), "D" (NULL), "S" (NULL)
-			: "rax", "rcx", "r11"
+			"call *%[rax]"
+			: [rax] "+a" (rax)
+			: "D" (NULL), "S" (NULL)
+			: "rcx", "r11"
 		);
 
 		g_vsyscall = 1;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-fix-pie-proc-empty-vm-proc-pid-vm-tests.patch
proc-mark-proc-cmdline-as-permanent.patch

