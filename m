Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34918438AF9
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 19:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhJXRbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 13:31:37 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:44527 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231290AbhJXRbf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 13:31:35 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 19OHSYEs018038;
        Sun, 24 Oct 2021 19:28:34 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Peter Cordes <peter@cordes.ca>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/3] tools/nolibc: x86-64: Fix startup code bug
Date:   Sun, 24 Oct 2021 19:28:14 +0200
Message-Id: <20211024172816.17993-2-w@1wt.eu>
X-Mailer: git-send-email 2.17.5
In-Reply-To: <20211024172816.17993-1-w@1wt.eu>
References: <20211024172816.17993-1-w@1wt.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ammar Faizi <ammar.faizi@students.amikom.ac.id>

Before this patch, the `_start` function looks like this:
```
0000000000001170 <_start>:
    1170:	pop    %rdi
    1171:	mov    %rsp,%rsi
    1174:	lea    0x8(%rsi,%rdi,8),%rdx
    1179:	and    $0xfffffffffffffff0,%rsp
    117d:	sub    $0x8,%rsp
    1181:	call   1000 <main>
    1186:	movzbq %al,%rdi
    118a:	mov    $0x3c,%rax
    1191:	syscall
    1193:	hlt
    1194:	data16 cs nopw 0x0(%rax,%rax,1)
    119f:	nop
```
Note the "and" to %rsp with $-16, it makes the %rsp be 16-byte aligned,
but then there is a "sub" with $0x8 which makes the %rsp no longer
16-byte aligned, then it calls main. That's the bug!

What actually the x86-64 System V ABI mandates is that right before the
"call", the %rsp must be 16-byte aligned, not after the "call". So the
"sub" with $0x8 here breaks the alignment. Remove it.

An example where this rule matters is when the callee needs to align
its stack at 16-byte for aligned move instruction, like `movdqa` and
`movaps`. If the callee can't align its stack properly, it will result
in segmentation fault.

x86-64 System V ABI also mandates the deepest stack frame should be
zero. Just to be safe, let's zero the %rbp on startup as the content
of %rbp may be unspecified when the program starts. Now it looks like
this:
```
0000000000001170 <_start>:
    1170:	pop    %rdi
    1171:	mov    %rsp,%rsi
    1174:	lea    0x8(%rsi,%rdi,8),%rdx
    1179:	xor    %ebp,%ebp                # zero the %rbp
    117b:	and    $0xfffffffffffffff0,%rsp # align the %rsp
    117f:	call   1000 <main>
    1184:	movzbq %al,%rdi
    1188:	mov    $0x3c,%rax
    118f:	syscall
    1191:	hlt
    1192:	data16 cs nopw 0x0(%rax,%rax,1)
    119d:	nopl   (%rax)
```

Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Cc: Louvian Lyndal <louvianlyndal@gmail.com>
Reported-by: Peter Cordes <peter@cordes.ca>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
[wt: I did this on purpose due to a misunderstanding of the spec, other
     archs will thus have to be rechecked, particularly i386]
Cc: stable@vger.kernel.org
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 tools/include/nolibc/nolibc.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index 3430667b0d24..96b6d56acb57 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -399,14 +399,20 @@ struct stat {
 })
 
 /* startup code */
+/*
+ * x86-64 System V ABI mandates:
+ * 1) %rsp must be 16-byte aligned right before the function call.
+ * 2) The deepest stack frame should be zero (the %rbp).
+ *
+ */
 asm(".section .text\n"
     ".global _start\n"
     "_start:\n"
     "pop %rdi\n"                // argc   (first arg, %rdi)
     "mov %rsp, %rsi\n"          // argv[] (second arg, %rsi)
     "lea 8(%rsi,%rdi,8),%rdx\n" // then a NULL then envp (third arg, %rdx)
-    "and $-16, %rsp\n"          // x86 ABI : esp must be 16-byte aligned when
-    "sub $8, %rsp\n"            // entering the callee
+    "xor %ebp, %ebp\n"          // zero the stack frame
+    "and $-16, %rsp\n"          // x86 ABI : esp must be 16-byte aligned before call
     "call main\n"               // main() returns the status code, we'll exit with it.
     "movzb %al, %rdi\n"         // retrieve exit code from 8 lower bits
     "mov $60, %rax\n"           // NR_exit == 60
-- 
2.17.5

