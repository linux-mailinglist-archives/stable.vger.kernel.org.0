Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3894991A9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354926AbiAXUNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:13:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37400 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379284AbiAXULD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:11:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CD8C61371;
        Mon, 24 Jan 2022 20:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56573C340E5;
        Mon, 24 Jan 2022 20:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055062;
        bh=coNUTtreSapjjg9ezr4KWHjBcWf3lunj23LcLPSUqUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfSaHCQUBeDPGEaJieQ0T5AERxPeQvgeJct+569PwYqiMqIs28szylAJuOPQlx5jB
         R7DnfTF7onHPe9KckNih9ZWi6EtsqRe2q5FgM3pLiwnmNb/0oWuTl4U/bfy2meST7s
         WPHDl83eNAxCc7v1kcykexBoe3iXA0r2tOA8M55g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Peter Cordes <peter@cordes.ca>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.15 028/846] tools/nolibc: x86-64: Fix startup code bug
Date:   Mon, 24 Jan 2022 19:32:25 +0100
Message-Id: <20220124184101.893309402@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ammar Faizi <ammar.faizi@students.amikom.ac.id>

commit 937ed91c712273131de6d2a02caafd3ee84e0c72 upstream.

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
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/nolibc/nolibc.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

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


