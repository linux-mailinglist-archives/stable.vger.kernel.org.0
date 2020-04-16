Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4E81AC490
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409470AbgDPOBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392795AbgDPOBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:01:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 161D4217D8;
        Thu, 16 Apr 2020 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045684;
        bh=USXPWGJ/YKf0rRFL56rcX8aUIC+Psvx24aboiTldo2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKE9s5Bnr2su15sX/tOijblfuO+TYr/xY5NVFLJKZGtwZtGEU2r9bLbbJ9Q0mqA17
         OJLbmAyL5ENm7DGOIUL7qMkD/v75l47SzJOZShDc0kQ42tWJxLdJDO16mAIbPZlINp
         oESWsWBhmkxJnzw/hST7eYkg8OGLWy/Zr0N2yIGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Clement Courbet <courbet@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.6 236/254] powerpc: Make setjmp/longjmp signature standard
Date:   Thu, 16 Apr 2020 15:25:25 +0200
Message-Id: <20200416131355.046567363@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clement Courbet <courbet@google.com>

commit c17eb4dca5a353a9dbbb8ad6934fe57af7165e91 upstream.

Declaring setjmp()/longjmp() as taking longs makes the signature
non-standard, and makes clang complain. In the past, this has been
worked around by adding -ffreestanding to the compile flags.

The implementation looks like it only ever propagates the value
(in longjmp) or sets it to 1 (in setjmp), and we only call longjmp
with integer parameters.

This allows removing -ffreestanding from the compilation flags.

Fixes: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Clement Courbet <courbet@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200330080400.124803-1-courbet@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/setjmp.h |    6 ++++--
 arch/powerpc/kexec/Makefile       |    3 ---
 arch/powerpc/xmon/Makefile        |    3 ---
 3 files changed, 4 insertions(+), 8 deletions(-)

--- a/arch/powerpc/include/asm/setjmp.h
+++ b/arch/powerpc/include/asm/setjmp.h
@@ -7,7 +7,9 @@
 
 #define JMP_BUF_LEN    23
 
-extern long setjmp(long *) __attribute__((returns_twice));
-extern void longjmp(long *, long) __attribute__((noreturn));
+typedef long jmp_buf[JMP_BUF_LEN];
+
+extern int setjmp(jmp_buf env) __attribute__((returns_twice));
+extern void longjmp(jmp_buf env, int val) __attribute__((noreturn));
 
 #endif /* _ASM_POWERPC_SETJMP_H */
--- a/arch/powerpc/kexec/Makefile
+++ b/arch/powerpc/kexec/Makefile
@@ -3,9 +3,6 @@
 # Makefile for the linux kernel.
 #
 
-# Avoid clang warnings around longjmp/setjmp declarations
-CFLAGS_crash.o += -ffreestanding
-
 obj-y				+= core.o crash.o core_$(BITS).o
 
 obj-$(CONFIG_PPC32)		+= relocate_32.o
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -1,9 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for xmon
 
-# Avoid clang warnings around longjmp/setjmp declarations
-subdir-ccflags-y := -ffreestanding
-
 GCOV_PROFILE := n
 KCOV_INSTRUMENT := n
 UBSAN_SANITIZE := n


