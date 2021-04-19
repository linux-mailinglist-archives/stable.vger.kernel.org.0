Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97B03643D7
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241251AbhDSNWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241434AbhDSNUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DE85613FE;
        Mon, 19 Apr 2021 13:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838204;
        bh=wXWpex12SHrBn0sW3zIXCkNd8glVnd6jKRfNdBjBuGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlG/gAcsiURKmpoVzeGwRt/7awVI1mCUV7EAz3xB+f8RcfXvqG5tCqaqGF/DphkpM
         BYBLktrEGsyD/Fi0xK6srdDdH43MBOGQ3lAqtkEyKbleOCiLV8Q6O7cAmba4UG5Tru
         KY0g6InEL0eA4tuErQIbZQF/rmBH0+tD85jmCsZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Braha <julianbraha@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/103] lib: fix kconfig dependency on ARCH_WANT_FRAME_POINTERS
Date:   Mon, 19 Apr 2021 15:05:57 +0200
Message-Id: <20210419130529.400704138@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 7d37cb2c912dc5c25ffac784a4f9b98c06c6bd08 ]

When LATENCYTOP, LOCKDEP, or FAULT_INJECTION_STACKTRACE_FILTER is
enabled and ARCH_WANT_FRAME_POINTERS is disabled, Kbuild gives a warning
such as:

  WARNING: unmet direct dependencies detected for FRAME_POINTER
    Depends on [n]: DEBUG_KERNEL [=y] && (M68K || UML || SUPERH) || ARCH_WANT_FRAME_POINTERS [=n] || MCOUNT [=n]
    Selected by [y]:
    - LATENCYTOP [=y] && DEBUG_KERNEL [=y] && STACKTRACE_SUPPORT [=y] && PROC_FS [=y] && !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC && !X86

Depending on ARCH_WANT_FRAME_POINTERS causes a recursive dependency
error.  ARCH_WANT_FRAME_POINTERS is to be selected by the architecture,
and is not supposed to be overridden by other config options.

Link: https://lkml.kernel.org/r/20210329165329.27994-1-julianbraha@gmail.com
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c789b39ed527..dcf4a9028e16 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1302,7 +1302,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && LOCK_DEBUGGING_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !ARM && !S390 && !MICROBLAZE && !ARC && !X86
+	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	select KALLSYMS
 	select KALLSYMS_ALL
 
@@ -1596,7 +1596,7 @@ config LATENCYTOP
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 	depends on PROC_FS
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC && !X86
+	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
@@ -1849,7 +1849,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC && !X86
+	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
-- 
2.30.2



