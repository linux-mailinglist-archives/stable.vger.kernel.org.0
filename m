Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5A435CC6C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244797AbhDLQ2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244570AbhDLQ0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:26:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6BCE61370;
        Mon, 12 Apr 2021 16:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244700;
        bh=wXWpex12SHrBn0sW3zIXCkNd8glVnd6jKRfNdBjBuGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uE0mgrLBc1/AJ1vweo3oZFy96GRd1a04ll0BjHxvPoqh5ypoxXCM9Sh6cZEnEUt9A
         8uDU59A5HVz8d2g82auk2Vn20bY/+sdkSjCpi+5YADkb8rrTIusY/Vz/tURC2S5cmv
         9THCzTjwris2bo9lqtB1U4oNKHo7HD8nUvxujE5AHu89VC/O3xsMw1GaloAc49ZJs3
         ALqu3V3fA3tqaWLScw29JulJmFWSgNnrIp5LAvqOoCMnqeBMXLesJpHWPOMusYtWgo
         SAm2YkyIx+3Di7utJREj27LCEkS0vFhZkgO7GfyrhS5FSGp8XKjjG13fH3o9Mj+bYe
         YQjvsF967zT6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 46/46] lib: fix kconfig dependency on ARCH_WANT_FRAME_POINTERS
Date:   Mon, 12 Apr 2021 12:24:01 -0400
Message-Id: <20210412162401.314035-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

