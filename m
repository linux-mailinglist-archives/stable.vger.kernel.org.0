Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395673739CF
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhEEMFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231300AbhEEMFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:05:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B72B861154;
        Wed,  5 May 2021 12:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216278;
        bh=4Gd08GrUQlZo744reVOwq1co2zM52J3r8/eig9YH4wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxpHatG3e8P5w/L842P2eYGdcJM0pREQS5gCo1FUSlVOSmOJ+lcQ/jTSPZOTatoar
         xt3ARFpB7lwSxTb9NE/J2BqArjkNnuVmWz5MyDirH97go22YFdlEiDvKFTY5XtVNED
         qQcIci4CvUfi79Hhcv6NvCso0YdLWV0eDkvwGQng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Romain Naour <romain.naour@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 01/21] mips: Do not include hi and lo in clobber list for R6
Date:   Wed,  5 May 2021 14:04:15 +0200
Message-Id: <20210505112324.778328824@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Romain Naour <romain.naour@gmail.com>

commit 1d7ba0165d8206ac073f7ac3b14fc0836b66eae7 upstream.

>From [1]
"GCC 10 (PR 91233) won't silently allow registers that are not
architecturally available to be present in the clobber list anymore,
resulting in build failure for mips*r6 targets in form of:
...
.../sysdep.h:146:2: error: the register ‘lo’ cannot be clobbered in ‘asm’ for the current target
  146 |  __asm__ volatile (      \
      |  ^~~~~~~

This is because base R6 ISA doesn't define hi and lo registers w/o DSP
extension. This patch provides the alternative clobber list for r6 targets
that won't include those registers."

Since kernel 5.4 and mips support for generic vDSO [2], the kernel fail to
build for mips r6 cpus with gcc 10 for the same reason as glibc.

[1] https://sourceware.org/git/?p=glibc.git;a=commit;h=020b2a97bb15f807c0482f0faee2184ed05bcad8
[2] '24640f233b46 ("mips: Add support for generic vDSO")'

Signed-off-by: Romain Naour <romain.naour@gmail.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/vdso/gettimeofday.h |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/arch/mips/include/asm/vdso/gettimeofday.h
+++ b/arch/mips/include/asm/vdso/gettimeofday.h
@@ -26,6 +26,12 @@
 
 #define __VDSO_USE_SYSCALL		ULLONG_MAX
 
+#if MIPS_ISA_REV < 6
+#define VDSO_SYSCALL_CLOBBERS "hi", "lo",
+#else
+#define VDSO_SYSCALL_CLOBBERS
+#endif
+
 static __always_inline long gettimeofday_fallback(
 				struct __kernel_old_timeval *_tv,
 				struct timezone *_tz)
@@ -41,7 +47,9 @@ static __always_inline long gettimeofday
 	: "=r" (ret), "=r" (error)
 	: "r" (tv), "r" (tz), "r" (nr)
 	: "$1", "$3", "$8", "$9", "$10", "$11", "$12", "$13",
-	  "$14", "$15", "$24", "$25", "hi", "lo", "memory");
+	  "$14", "$15", "$24", "$25",
+	  VDSO_SYSCALL_CLOBBERS
+	  "memory");
 
 	return error ? -ret : ret;
 }
@@ -65,7 +73,9 @@ static __always_inline long clock_gettim
 	: "=r" (ret), "=r" (error)
 	: "r" (clkid), "r" (ts), "r" (nr)
 	: "$1", "$3", "$8", "$9", "$10", "$11", "$12", "$13",
-	  "$14", "$15", "$24", "$25", "hi", "lo", "memory");
+	  "$14", "$15", "$24", "$25",
+	  VDSO_SYSCALL_CLOBBERS
+	  "memory");
 
 	return error ? -ret : ret;
 }
@@ -89,7 +99,9 @@ static __always_inline int clock_getres_
 	: "=r" (ret), "=r" (error)
 	: "r" (clkid), "r" (ts), "r" (nr)
 	: "$1", "$3", "$8", "$9", "$10", "$11", "$12", "$13",
-	  "$14", "$15", "$24", "$25", "hi", "lo", "memory");
+	  "$14", "$15", "$24", "$25",
+	  VDSO_SYSCALL_CLOBBERS
+	  "memory");
 
 	return error ? -ret : ret;
 }
@@ -113,7 +125,9 @@ static __always_inline long clock_gettim
 	: "=r" (ret), "=r" (error)
 	: "r" (clkid), "r" (ts), "r" (nr)
 	: "$1", "$3", "$8", "$9", "$10", "$11", "$12", "$13",
-	  "$14", "$15", "$24", "$25", "hi", "lo", "memory");
+	  "$14", "$15", "$24", "$25",
+	  VDSO_SYSCALL_CLOBBERS
+	  "memory");
 
 	return error ? -ret : ret;
 }
@@ -133,7 +147,9 @@ static __always_inline int clock_getres3
 	: "=r" (ret), "=r" (error)
 	: "r" (clkid), "r" (ts), "r" (nr)
 	: "$1", "$3", "$8", "$9", "$10", "$11", "$12", "$13",
-	  "$14", "$15", "$24", "$25", "hi", "lo", "memory");
+	  "$14", "$15", "$24", "$25",
+	  VDSO_SYSCALL_CLOBBERS
+	  "memory");
 
 	return error ? -ret : ret;
 }


