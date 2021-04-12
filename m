Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE7335CB82
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243959AbhDLQYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243766AbhDLQYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 575B361355;
        Mon, 12 Apr 2021 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244640;
        bh=WHm+Gc828UNvafC9vAYAFpxs1ezQlKxILMRK0EzJinQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSIKwn+OvhbgYOq3YUjPheLl+qCS3S2e87eUFB/MHgCG+9799gFz1GEJunWWfYhSk
         43Xz0ua5w9nkX/cfFLNf7GI3W4DJnRSis2/X/wBZ4MXX6ryiqM6vlnhHeTNGtZMzYc
         Z5q8rkhhJsFgwWe0mcITbKWVfBonpio1OdfObgzBlHg634Ju1vLpJNIoo6usRgdGm5
         bv+JHo1b76IzUgODlVSH34F1Lqmpt0/Gvb9xgsd9icPisOvkidBVQw8JfMTCxc4gPY
         87ywvytbgoXhapGdFY6ZHqVBKijtLHCIVB7LKw+oU8ef551q1BSJr+1WwR/MtMdIoA
         bQLiXcjSgKS2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 51/51] lib: fix kconfig dependency on ARCH_WANT_FRAME_POINTERS
Date:   Mon, 12 Apr 2021 12:22:56 -0400
Message-Id: <20210412162256.313524-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
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
index 7937265ef879..431b6b7ec04d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1325,7 +1325,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && LOCK_DEBUGGING_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !ARM && !S390 && !MICROBLAZE && !ARC && !X86
+	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	select KALLSYMS
 	select KALLSYMS_ALL
 
@@ -1619,7 +1619,7 @@ config LATENCYTOP
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 	depends on PROC_FS
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC && !X86
+	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
@@ -1872,7 +1872,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC && !X86
+	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
-- 
2.30.2

