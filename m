Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E5B49A9FD
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323930AbiAYD3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3412672AbiAYAh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 19:37:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01581C09F495;
        Mon, 24 Jan 2022 12:11:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94BA26131F;
        Mon, 24 Jan 2022 20:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A71C340E5;
        Mon, 24 Jan 2022 20:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055071;
        bh=TEw8/WP6YfHH4W4x2h4ZS/43zd1x6SlbIuZzOc87T74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YY98EUjQ6v0HPiq+dqM194w4TybQptNBKZwe3ny+YMCq5N0qL6rXde5HhB7Te9Ax+
         O/EOWP29j7+NnS7LMh6mcx5dfPTmr3gz5CS0la7eLkOV4mMnxUKZJz76FXL/QLwsxT
         3nwAVv69pUP4Zussail3o+2Af31UlMnJ0mtHTY+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.15 031/846] tools/nolibc: fix incorrect truncation of exit code
Date:   Mon, 24 Jan 2022 19:32:28 +0100
Message-Id: <20220124184101.994950551@linuxfoundation.org>
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

From: Willy Tarreau <w@1wt.eu>

commit de0244ae40ae91145faaf164a4252347607c3711 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/nolibc/nolibc.h |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

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


