Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF9C66677E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjALAPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbjALAPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:15:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F1330569;
        Wed, 11 Jan 2023 16:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5338B81D81;
        Thu, 12 Jan 2023 00:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E981C433D2;
        Thu, 12 Jan 2023 00:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482525;
        bh=bGE+wkjAMzWQe9hEkU9h8NDHtDNdMNtxgGhqaT55++c=;
        h=Date:To:From:Subject:From;
        b=nJJGielTvayQScEosP5LpWn2H2N5RqUtwm7OCW/8x19hGivUSgr4Tg6o0IWNOT279
         Cv7oO6Eqcc2ScNreu89tpYf16m8XosTQZyPiJqypVrbAS11rL3NWhNZWB2SZpODGgJ
         MDDZXBXpWJujknETxVnE7DzxNhCp3fo4m/7GZ9nU=
Date:   Wed, 11 Jan 2023 16:15:24 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mirsad.todorovac@alu.unizg.hr, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] proc-fix-pie-proc-empty-vm-proc-pid-vm-tests.patch removed from -mm tree
Message-Id: <20230112001525.5E981C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: proc: fix PIE proc-empty-vm, proc-pid-vm tests
has been removed from the -mm tree.  Its filename was
     proc-fix-pie-proc-empty-vm-proc-pid-vm-tests.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

proc-mark-proc-cmdline-as-permanent.patch

