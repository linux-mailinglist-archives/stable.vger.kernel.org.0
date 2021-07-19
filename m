Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B506D3CD833
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbhGSOVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242153AbhGSOUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5000C611C1;
        Mon, 19 Jul 2021 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706852;
        bh=7b4kQ3frdkLozzWz2WbAPeNubGN3rPCGqNgqGd8tXH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdw1EddkQMByQgXi+aw/g5OAceRZwHOqNSCIOeQ+ROks6WWbel4Dhk6Xp6KavX8iG
         8z6Kw7B/7I33Sz8tNMsEkIm0cDfexWIlyDlS2CG507IrN5ttvy8oPMFRm+mxZDmawo
         3U/hpFgtDbOokKOYk530HvYN9tMSOJsYu5Jq3zBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 127/188] powerpc/barrier: Avoid collision with clangs __lwsync macro
Date:   Mon, 19 Jul 2021 16:51:51 +0200
Message-Id: <20210719144940.650247691@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 015d98149b326e0f1f02e44413112ca8b4330543 upstream.

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
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/ClangBuiltLinux/linux/issues/1386
Link: https://github.com/llvm/llvm-project/commit/62b5df7fe2b3fda1772befeda15598fbef96a614
Link: https://lore.kernel.org/r/20210528182752.1852002-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/barrier.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -43,6 +43,8 @@
 #    define SMPWMB      eieio
 #endif
 
+/* clang defines this macro for a builtin, which will not work with runtime patching */
+#undef __lwsync
 #define __lwsync()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
 #define dma_rmb()	__lwsync()
 #define dma_wmb()	__asm__ __volatile__ (stringify_in_c(SMPWMB) : : :"memory")


