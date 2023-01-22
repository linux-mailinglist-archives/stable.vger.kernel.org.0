Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D86A676F9B
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbjAVPX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjAVPXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CC72103
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD733B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354CAC433EF;
        Sun, 22 Jan 2023 15:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400994;
        bh=+XqtRsdgUOiJZZ4uCiFAeB3305IkLDoILd2B8C5aIcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROOHrWU2w7jmFyq43BsfKHtiAfwbDQ+QDoYHUTMvCBrRAk4H+k5YOuvUmc7pO1kHu
         bUoVViKfpDRHAhg44qE7VNp/ptlWnnz8jLmaeMZc5SXJCPMoqXXAxghMjejTFsI0EI
         9JOerMlgrr3tCU61+al+/iOH4gHH5Tov5vqsPkh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexey Dobriyan <adobriyan@gmail.com>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 040/193] proc: fix PIE proc-empty-vm, proc-pid-vm tests
Date:   Sun, 22 Jan 2023 16:02:49 +0100
Message-Id: <20230122150248.234682864@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 5316a017d093f644675a56523bcf5787ba8f4fef upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/proc/proc-empty-vm.c | 12 +++++++-----
 tools/testing/selftests/proc/proc-pid-vm.c   |  9 +++++----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/proc/proc-empty-vm.c b/tools/testing/selftests/proc/proc-empty-vm.c
index d95b1cb43d9d..7588428b8fcd 100644
--- a/tools/testing/selftests/proc/proc-empty-vm.c
+++ b/tools/testing/selftests/proc/proc-empty-vm.c
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
diff --git a/tools/testing/selftests/proc/proc-pid-vm.c b/tools/testing/selftests/proc/proc-pid-vm.c
index 69551bfa215c..cacbd2a4aec9 100644
--- a/tools/testing/selftests/proc/proc-pid-vm.c
+++ b/tools/testing/selftests/proc/proc-pid-vm.c
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
-- 
2.39.1



