Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E81465AFA
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 01:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354550AbhLBAhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 19:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354479AbhLBAhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 19:37:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D13C06174A;
        Wed,  1 Dec 2021 16:33:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55916CE1DC7;
        Thu,  2 Dec 2021 00:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D5EC53FCF;
        Thu,  2 Dec 2021 00:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638405228;
        bh=5HUVxeq8HcizJpGoPFk7yffUPU/ibyovCpDh3FIdjs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dU46npYrvQQCBefVbeLl7+zZ6YHB0fe/MJz+kwGCvBe5HmW/kRWFL1XC9S3IDjycF
         pt1CtenA7cNVtwYQKJ2hxxU0n23+oryS6tUVlCf14rBmnvgnXtJRA9yyNy7U7Q6U8D
         f+38hmva2f4wx6Uk+XQDbxZhsOd+uf1MbZYqu5nWZEVZIU53Y8GSkdvDlzrk1T/Epq
         CTrHLuNK/8Jxo4J/zEQZm9ugxsxSjup0YLJGDD42R8uSkN79xrx473Px/GhYgTANtK
         BFcVbP4SkndwvRbwoQuwasaXwbXNYJwGIYjOkAnJdj6aVp1fxl2qpI1gZ8kJXaxRj8
         8q1VmqrGq+1kQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 3E02D5C1010; Wed,  1 Dec 2021 16:33:48 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com, mingo@kernel.org,
        jiangshanlai@gmail.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com,
        oleg@redhat.com, joel@joelfernandes.org, Willy Tarreau <w@1wt.eu>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        stable@vger.kernel.org, "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH rcu 3/6] tools/nolibc: fix incorrect truncation of exit code
Date:   Wed,  1 Dec 2021 16:33:43 -0800
Message-Id: <20211202003346.3129110-3-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20211202003322.GA3128775@paulmck-ThinkPad-P17-Gen-1>
References: <20211202003322.GA3128775@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

Ammar Faizi reported that our exit code handling is wrong. We truncate
it to the lowest 8 bits but the syscall itself is expected to take a
regular 32-bit signed integer, not an unsigned char. It's the kernel
that later truncates it to the lowest 8 bits. The difference is visible
in strace, where the program below used to show exit(255) instead of
exit(-1):

  int main(void)
  {
        return -1;
  }

This patch applies the fix to all archs. x86_64, i386, arm64, armv7 and
mips were all tested and confirmed to work fine now. Risc-v was not
tested but the change is trivial and exactly the same as for other archs.

Reported-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc: stable@vger.kernel.org
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 tools/include/nolibc/nolibc.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index 7f300dc379e70..3e2c6f2ed587f 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -414,7 +414,7 @@ asm(".section .text\n"
     "xor %ebp, %ebp\n"          // zero the stack frame
     "and $-16, %rsp\n"          // x86 ABI : esp must be 16-byte aligned before call
     "call main\n"               // main() returns the status code, we'll exit with it.
-    "movzb %al, %rdi\n"         // retrieve exit code from 8 lower bits
+    "mov %eax, %edi\n"          // retrieve exit code (32 bit)
     "mov $60, %rax\n"           // NR_exit == 60
     "syscall\n"                 // really exit
     "hlt\n"                     // ensure it does not return
@@ -602,9 +602,9 @@ asm(".section .text\n"
     "push %ebx\n"               // support both regparm and plain stack modes
     "push %eax\n"
     "call main\n"               // main() returns the status code in %eax
-    "movzbl %al, %ebx\n"        // retrieve exit code from lower 8 bits
-    "movl   $1, %eax\n"         // NR_exit == 1
-    "int    $0x80\n"            // exit now
+    "mov %eax, %ebx\n"          // retrieve exit code (32-bit int)
+    "movl $1, %eax\n"           // NR_exit == 1
+    "int $0x80\n"               // exit now
     "hlt\n"                     // ensure it does not
     "");
 
@@ -788,7 +788,6 @@ asm(".section .text\n"
     "and %r3, %r1, $-8\n"         // AAPCS : sp must be 8-byte aligned in the
     "mov %sp, %r3\n"              //         callee, an bl doesn't push (lr=pc)
     "bl main\n"                   // main() returns the status code, we'll exit with it.
-    "and %r0, %r0, $0xff\n"       // limit exit code to 8 bits
     "movs r7, $1\n"               // NR_exit == 1
     "svc $0x00\n"
     "");
@@ -985,7 +984,6 @@ asm(".section .text\n"
     "add x2, x2, x1\n"            //           + argv
     "and sp, x1, -16\n"           // sp must be 16-byte aligned in the callee
     "bl main\n"                   // main() returns the status code, we'll exit with it.
-    "and x0, x0, 0xff\n"          // limit exit code to 8 bits
     "mov x8, 93\n"                // NR_exit == 93
     "svc #0\n"
     "");
@@ -1190,7 +1188,7 @@ asm(".section .text\n"
     "addiu $sp,$sp,-16\n"         // the callee expects to save a0..a3 there!
     "jal main\n"                  // main() returns the status code, we'll exit with it.
     "nop\n"                       // delayed slot
-    "and $a0, $v0, 0xff\n"        // limit exit code to 8 bits
+    "move $a0, $v0\n"             // retrieve 32-bit exit code from v0
     "li $v0, 4001\n"              // NR_exit == 4001
     "syscall\n"
     ".end __start\n"
@@ -1388,7 +1386,6 @@ asm(".section .text\n"
     "add   a2,a2,a1\n"           //             + argv
     "andi  sp,a1,-16\n"          // sp must be 16-byte aligned
     "call  main\n"               // main() returns the status code, we'll exit with it.
-    "andi  a0, a0, 0xff\n"       // limit exit code to 8 bits
     "li a7, 93\n"                // NR_exit == 93
     "ecall\n"
     "");
-- 
2.31.1.189.g2e36527f23

