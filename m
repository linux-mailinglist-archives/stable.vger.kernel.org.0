Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E7D66C576
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbjAPQGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbjAPQGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:06:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611CA1B56F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:04:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E47E161049
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD749C433D2;
        Mon, 16 Jan 2023 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885055;
        bh=2VvR/RGbmNrpXVPy6mHg+cIputdg0K+Ld4hXimDQlf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQB3EJN0lg7NIIv/ePjzuhcr/pUbILIk9xxUuQvfqznaUp6lWIiXHp1BGJVtnZcEn
         dianqrawj7/ZiqMSORECVNcvaU4ChHlDS9mf6Tf64/+TPhR2CPJdkTwL7E9aPVvvCJ
         XlqD+ceUJd/U+31LJQdtChsfM9DVXm92OVKcfKcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 57/86] tools/nolibc: x86: Remove `r8`, `r9` and `r10` from the clobber list
Date:   Mon, 16 Jan 2023 16:51:31 +0100
Message-Id: <20230116154749.416276733@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ammar Faizi <ammar.faizi@students.amikom.ac.id>

[ Upstream commit bf91666959eeac44fb686e9359e37830944beef2 ]

Linux x86-64 syscall only clobbers rax, rcx and r11 (and "memory").

  - rax for the return value.
  - rcx to save the return address.
  - r11 to save the rflags.

Other registers are preserved.

Having r8, r9 and r10 in the syscall clobber list is harmless, but this
results in a missed-optimization.

As the syscall doesn't clobber r8-r10, GCC should be allowed to reuse
their value after the syscall returns to userspace. But since they are
in the clobber list, GCC will always miss this opportunity.

Remove them from the x86-64 syscall clobber list to help GCC generate
better code and fix the comment.

See also the x86-64 ABI, section A.2 AMD64 Linux Kernel Conventions,
A.2.1 Calling Conventions [1].

Extra note:
Some people may think it does not really give a benefit to remove r8,
r9 and r10 from the syscall clobber list because the impression of
syscall is a C function call, and function call always clobbers those 3.

However, that is not the case for nolibc.h, because we have a potential
to inline the "syscall" instruction (which its opcode is "0f 05") to the
user functions.

All syscalls in the nolibc.h are written as a static function with inline
ASM and are likely always inline if we use optimization flag, so this is
a profit not to have r8, r9 and r10 in the clobber list.

Here is the example where this matters.

Consider the following C code:
```
  #include "tools/include/nolibc/nolibc.h"
  #define read_abc(a, b, c) __asm__ volatile("nop"::"r"(a),"r"(b),"r"(c))

  int main(void)
  {
  	int a = 0xaa;
  	int b = 0xbb;
  	int c = 0xcc;

  	read_abc(a, b, c);
  	write(1, "test\n", 5);
  	read_abc(a, b, c);

  	return 0;
  }
```

Compile with:
    gcc -Os test.c -o test -nostdlib

With r8, r9, r10 in the clobber list, GCC generates this:

0000000000001000 <main>:
    1000:	f3 0f 1e fa          	endbr64
    1004:	41 54                	push   %r12
    1006:	41 bc cc 00 00 00    	mov    $0xcc,%r12d
    100c:	55                   	push   %rbp
    100d:	bd bb 00 00 00       	mov    $0xbb,%ebp
    1012:	53                   	push   %rbx
    1013:	bb aa 00 00 00       	mov    $0xaa,%ebx
    1018:	90                   	nop
    1019:	b8 01 00 00 00       	mov    $0x1,%eax
    101e:	bf 01 00 00 00       	mov    $0x1,%edi
    1023:	ba 05 00 00 00       	mov    $0x5,%edx
    1028:	48 8d 35 d1 0f 00 00 	lea    0xfd1(%rip),%rsi
    102f:	0f 05                	syscall
    1031:	90                   	nop
    1032:	31 c0                	xor    %eax,%eax
    1034:	5b                   	pop    %rbx
    1035:	5d                   	pop    %rbp
    1036:	41 5c                	pop    %r12
    1038:	c3                   	ret

GCC thinks that syscall will clobber r8, r9, r10. So it spills 0xaa,
0xbb and 0xcc to callee saved registers (r12, rbp and rbx). This is
clearly extra memory access and extra stack size for preserving them.

But syscall does not actually clobber them, so this is a missed
optimization.

Now without r8, r9, r10 in the clobber list, GCC generates better code:

0000000000001000 <main>:
    1000:	f3 0f 1e fa          	endbr64
    1004:	41 b8 aa 00 00 00    	mov    $0xaa,%r8d
    100a:	41 b9 bb 00 00 00    	mov    $0xbb,%r9d
    1010:	41 ba cc 00 00 00    	mov    $0xcc,%r10d
    1016:	90                   	nop
    1017:	b8 01 00 00 00       	mov    $0x1,%eax
    101c:	bf 01 00 00 00       	mov    $0x1,%edi
    1021:	ba 05 00 00 00       	mov    $0x5,%edx
    1026:	48 8d 35 d3 0f 00 00 	lea    0xfd3(%rip),%rsi
    102d:	0f 05                	syscall
    102f:	90                   	nop
    1030:	31 c0                	xor    %eax,%eax
    1032:	c3                   	ret

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Acked-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Link: https://gitlab.com/x86-psABIs/x86-64-ABI/-/wikis/x86-64-psABI [1]
Link: https://lore.kernel.org/lkml/20211011040344.437264-1-ammar.faizi@students.amikom.ac.id/
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 184177c3d6e0 ("tools/nolibc: restore mips branch ordering in the _start block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/nolibc.h | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index d64020c1922c..ece7a70d8b39 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -265,12 +265,17 @@ struct stat {
  *   - arguments are in rdi, rsi, rdx, r10, r8, r9 respectively
  *   - the system call is performed by calling the syscall instruction
  *   - syscall return comes in rax
- *   - rcx and r8..r11 may be clobbered, others are preserved.
+ *   - rcx and r11 are clobbered, others are preserved.
  *   - the arguments are cast to long and assigned into the target registers
  *     which are then simply passed as registers to the asm code, so that we
  *     don't have to experience issues with register constraints.
  *   - the syscall number is always specified last in order to allow to force
  *     some registers before (gcc refuses a %-register at the last position).
+ *   - see also x86-64 ABI section A.2 AMD64 Linux Kernel Conventions, A.2.1
+ *     Calling Conventions.
+ *
+ * Link x86-64 ABI: https://gitlab.com/x86-psABIs/x86-64-ABI/-/wikis/x86-64-psABI
+ *
  */
 
 #define my_syscall0(num)                                                      \
@@ -280,9 +285,9 @@ struct stat {
 									      \
 	asm volatile (                                                        \
 		"syscall\n"                                                   \
-		: "=a" (_ret)                                                 \
+		: "=a"(_ret)                                                  \
 		: "0"(_num)                                                   \
-		: "rcx", "r8", "r9", "r10", "r11", "memory", "cc"             \
+		: "rcx", "r11", "memory", "cc"                                \
 	);                                                                    \
 	_ret;                                                                 \
 })
@@ -295,10 +300,10 @@ struct stat {
 									      \
 	asm volatile (                                                        \
 		"syscall\n"                                                   \
-		: "=a" (_ret)                                                 \
+		: "=a"(_ret)                                                  \
 		: "r"(_arg1),                                                 \
 		  "0"(_num)                                                   \
-		: "rcx", "r8", "r9", "r10", "r11", "memory", "cc"             \
+		: "rcx", "r11", "memory", "cc"                                \
 	);                                                                    \
 	_ret;                                                                 \
 })
@@ -312,10 +317,10 @@ struct stat {
 									      \
 	asm volatile (                                                        \
 		"syscall\n"                                                   \
-		: "=a" (_ret)                                                 \
+		: "=a"(_ret)                                                  \
 		: "r"(_arg1), "r"(_arg2),                                     \
 		  "0"(_num)                                                   \
-		: "rcx", "r8", "r9", "r10", "r11", "memory", "cc"             \
+		: "rcx", "r11", "memory", "cc"                                \
 	);                                                                    \
 	_ret;                                                                 \
 })
@@ -330,10 +335,10 @@ struct stat {
 									      \
 	asm volatile (                                                        \
 		"syscall\n"                                                   \
-		: "=a" (_ret)                                                 \
+		: "=a"(_ret)                                                  \
 		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
 		  "0"(_num)                                                   \
-		: "rcx", "r8", "r9", "r10", "r11", "memory", "cc"             \
+		: "rcx", "r11", "memory", "cc"                                \
 	);                                                                    \
 	_ret;                                                                 \
 })
@@ -349,10 +354,10 @@ struct stat {
 									      \
 	asm volatile (                                                        \
 		"syscall\n"                                                   \
-		: "=a" (_ret), "=r"(_arg4)                                    \
+		: "=a"(_ret)                                                  \
 		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
 		  "0"(_num)                                                   \
-		: "rcx", "r8", "r9", "r11", "memory", "cc"                    \
+		: "rcx", "r11", "memory", "cc"                                \
 	);                                                                    \
 	_ret;                                                                 \
 })
@@ -369,10 +374,10 @@ struct stat {
 									      \
 	asm volatile (                                                        \
 		"syscall\n"                                                   \
-		: "=a" (_ret), "=r"(_arg4), "=r"(_arg5)                       \
+		: "=a"(_ret)                                                  \
 		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
 		  "0"(_num)                                                   \
-		: "rcx", "r9", "r11", "memory", "cc"                          \
+		: "rcx", "r11", "memory", "cc"                                \
 	);                                                                    \
 	_ret;                                                                 \
 })
@@ -390,7 +395,7 @@ struct stat {
 									      \
 	asm volatile (                                                        \
 		"syscall\n"                                                   \
-		: "=a" (_ret), "=r"(_arg4), "=r"(_arg5)                       \
+		: "=a"(_ret)                                                  \
 		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
 		  "r"(_arg6), "0"(_num)                                       \
 		: "rcx", "r11", "memory", "cc"                                \
-- 
2.35.1



