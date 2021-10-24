Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50742438AF8
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 19:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhJXRbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 13:31:36 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:44526 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhJXRbf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 13:31:35 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 19OHSZC0018040;
        Sun, 24 Oct 2021 19:28:35 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Peter Cordes <peter@cordes.ca>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 3/3] tools/nolibc: fix incorrect truncation of exit code
Date:   Sun, 24 Oct 2021 19:28:16 +0200
Message-Id: <20211024172816.17993-4-w@1wt.eu>
X-Mailer: git-send-email 2.17.5
In-Reply-To: <20211024172816.17993-1-w@1wt.eu>
References: <20211024172816.17993-1-w@1wt.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 tools/include/nolibc/nolibc.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index 7f300dc379e7..3e2c6f2ed587 100644
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
2.17.5

