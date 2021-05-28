Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CD9394707
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 20:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhE1SbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 14:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhE1SbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 14:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43175613B5;
        Fri, 28 May 2021 18:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622226588;
        bh=QSRZ6S+Sdf5WKAtAbGtJdidvTJ3wPSV/gRZewGESIdk=;
        h=From:To:Cc:Subject:Date:From;
        b=hNQ+OCbF7nGq0MnBf2zAPV0EqKgB5b70lnJOPG/Bwu1By3raVTVvicfYq/ICuuHbd
         TC4czzsMTLqk/RFcDpjfix5VBAQA34WlMU6mD/3sEKEkGHA1scGO+5EtIlxJb6bb58
         962RSm5GttFs0CsZ8cXfAJ+eZhpLF/JFoUYqjV/b6uVemz8qtqktlMljUQ5UGd4Azl
         XD5WWPTootKdW6q8HHwnhvXYLSk+a70AX587QpUItcVK6WevBjXPBPIYj903/XSfic
         FIdC1ILIpNVc42D925oe+PjwSOgQwuqCkmAe0+hc+y9hJY7LAyK7zRUkUDuMF+CJTg
         9n7m86SCQtTlQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] powerpc/barrier: Avoid collision with clang's __lwsync macro
Date:   Fri, 28 May 2021 11:27:52 -0700
Message-Id: <20210528182752.1852002-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A change in clang 13 results in the __lwsync macro being defined as
__builtin_ppc_lwsync, which emits 'lwsync' or 'msync' depending on what
the target supports. This breaks the build because of -Werror in
arch/powerpc, along with thousands of warnings:

 In file included from arch/powerpc/kernel/pmc.c:12:
 In file included from include/linux/bug.h:5:
 In file included from arch/powerpc/include/asm/bug.h:109:
 In file included from include/asm-generic/bug.h:20:
 In file included from include/linux/kernel.h:12:
 In file included from include/linux/bitops.h:32:
 In file included from arch/powerpc/include/asm/bitops.h:62:
 arch/powerpc/include/asm/barrier.h:49:9: error: '__lwsync' macro redefined [-Werror,-Wmacro-redefined]
 #define __lwsync()      __asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
        ^
 <built-in>:308:9: note: previous definition is here
 #define __lwsync __builtin_ppc_lwsync
        ^
 1 error generated.

Undefine this macro so that the runtime patching introduced by
commit 2d1b2027626d ("powerpc: Fixup lwsync at runtime") continues to
work properly with clang and the build no longer breaks.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1386
Link: https://github.com/llvm/llvm-project/commit/62b5df7fe2b3fda1772befeda15598fbef96a614
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/include/asm/barrier.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
index 7ae29cfb06c0..f0e687236484 100644
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -46,6 +46,8 @@
 #    define SMPWMB      eieio
 #endif
 
+/* clang defines this macro for a builtin, which will not work with runtime patching */
+#undef __lwsync
 #define __lwsync()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
 #define dma_rmb()	__lwsync()
 #define dma_wmb()	__asm__ __volatile__ (stringify_in_c(SMPWMB) : : :"memory")

base-commit: 97e5bf604b7a0d6e1b3e00fe31d5fd4b9bffeaae
-- 
2.32.0.rc0

