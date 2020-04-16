Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51111AC3E6
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408723AbgDPNvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404215AbgDPNvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:51:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 236E521744;
        Thu, 16 Apr 2020 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045072;
        bh=TKjKt4c8R5PbFTZGOjOIpuwNjRkmsDLnSXzoCoYSvxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/B2qhEh1BI9QqFPUzYoTxWTN5Px2waVObR8aIlotFm+CB6s9uGAspo7B+ixu9Da5
         wRK5Adbek/brWtZTPtySmpeH399EnCyO8euLwc1dcvq2jGnAeMRX3MAL37Uli0AkqA
         R09EnAWU/XyE+5uADogxtASlVs86R4OnODbMzDzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Clement Courbet <courbet@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 216/232] powerpc: Make setjmp/longjmp signature standard
Date:   Thu, 16 Apr 2020 15:25:10 +0200
Message-Id: <20200416131342.509411147@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
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
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/setjmp.h |    6 ++++--
 arch/powerpc/kernel/Makefile      |    3 ---
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
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -5,9 +5,6 @@
 
 CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 
-# Avoid clang warnings around longjmp/setjmp declarations
-CFLAGS_crash.o += -ffreestanding
-
 ifdef CONFIG_PPC64
 CFLAGS_prom_init.o	+= $(NO_MINIMAL_TOC)
 endif
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


