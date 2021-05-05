Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A597373A0A
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhEEMHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233379AbhEEMGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C71BE61176;
        Wed,  5 May 2021 12:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216355;
        bh=mo+pLhm0iARN28qqYwnsgXDffYSc8JemS3k1mRWK1IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WN/LgxmySzsCtV0ugARukWGUr6VBWMVn9HzS49G02wi+EOh324xVpmU9DOhgDUYDk
         VdbjXTi+p2qBasZXrmdpYy7D6SdJ4iIIONNRiX67LqgYoM2p3qjph2rcWt9HA/GVGh
         0jVghdNcUuTjSllygDXKtePxRXsWt1qqjGDFZIGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Romain Naour <romain.naour@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.19 06/15] mips: Do not include hi and lo in clobber list for R6
Date:   Wed,  5 May 2021 14:05:11 +0200
Message-Id: <20210505120503.986548271@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505120503.781531508@linuxfoundation.org>
References: <20210505120503.781531508@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Romain Naour <romain.naour@gmail.com>

commit 1d7ba0165d8206ac073f7ac3b14fc0836b66eae7 upstream

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
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/vdso/gettimeofday.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/mips/vdso/gettimeofday.c
+++ b/arch/mips/vdso/gettimeofday.c
@@ -18,6 +18,12 @@
 #include <asm/unistd.h>
 #include <asm/vdso.h>
 
+#if MIPS_ISA_REV < 6
+#define VDSO_SYSCALL_CLOBBERS "hi", "lo",
+#else
+#define VDSO_SYSCALL_CLOBBERS
+#endif
+
 #ifdef CONFIG_MIPS_CLOCK_VSYSCALL
 
 static __always_inline long gettimeofday_fallback(struct timeval *_tv,
@@ -34,7 +40,9 @@ static __always_inline long gettimeofday
 	: "=r" (ret), "=r" (error)
 	: "r" (tv), "r" (tz), "r" (nr)
 	: "$1", "$3", "$8", "$9", "$10", "$11", "$12", "$13",
-	  "$14", "$15", "$24", "$25", "hi", "lo", "memory");
+	  "$14", "$15", "$24", "$25",
+	  VDSO_SYSCALL_CLOBBERS
+	  "memory");
 
 	return error ? -ret : ret;
 }
@@ -55,7 +63,9 @@ static __always_inline long clock_gettim
 	: "=r" (ret), "=r" (error)
 	: "r" (clkid), "r" (ts), "r" (nr)
 	: "$1", "$3", "$8", "$9", "$10", "$11", "$12", "$13",
-	  "$14", "$15", "$24", "$25", "hi", "lo", "memory");
+	  "$14", "$15", "$24", "$25",
+	  VDSO_SYSCALL_CLOBBERS
+	  "memory");
 
 	return error ? -ret : ret;
 }


