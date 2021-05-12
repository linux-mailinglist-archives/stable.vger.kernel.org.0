Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7410B37D299
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351175AbhELSKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352912AbhELSEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04F2161412;
        Wed, 12 May 2021 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842606;
        bh=2qTl8uZxoMT78WUK54xsmpIkQsgZUY1/f/fVyhzZUNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgZJArJmVEmLWJE3w1NbSfqkofCdWvgoj7i5aTSBNm0jSjuBdydu7si2/S11Aj0ap
         ZQxvRkdrKAdHzC7csG9B24ObcLio+VERHBxj+ZbgI7TUYIU2RHP5rhCA6XZ4nBnu5A
         0dZAdfew3BrejcRQbTF1DxwZablKMv834tZ7Yyrtok5ZBvGo5X3ajKlHPlW39g9ySU
         P1b2snZkvPvCSBumKv19F/7XOmUwPNbQVFIAb3vzN0II2lsrdAY770b0KmVPTTsf8L
         91Z+oyrN+MKq2Gr45VlLYr3UyqOJZu1fiIoz14ZEKBKcy7Ud0zwnXMamNR73XEgxkR
         3VfazHBkOz38g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 12/34] um: Disable CONFIG_GCOV with MODULES
Date:   Wed, 12 May 2021 14:02:43 -0400
Message-Id: <20210512180306.664925-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ad3d19911632debc886ef4a992d41d6de7927006 ]

CONFIG_GCOV doesn't work with modules, and for various reasons
it cannot work, see also
https://lore.kernel.org/r/d36ea54d8c0a8dd706826ba844a6f27691f45d55.camel@sipsolutions.net

Make CONFIG_GCOV depend on !MODULES to avoid anyone
running into issues there. This also means we need
not export the gcov symbols.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/Kconfig.debug      |  1 +
 arch/um/kernel/Makefile    |  1 -
 arch/um/kernel/gmon_syms.c | 16 ----------------
 3 files changed, 1 insertion(+), 17 deletions(-)
 delete mode 100644 arch/um/kernel/gmon_syms.c

diff --git a/arch/um/Kconfig.debug b/arch/um/Kconfig.debug
index 315d368e63ad..1dfb2959c73b 100644
--- a/arch/um/Kconfig.debug
+++ b/arch/um/Kconfig.debug
@@ -17,6 +17,7 @@ config GCOV
 	bool "Enable gcov support"
 	depends on DEBUG_INFO
 	depends on !KCOV
+	depends on !MODULES
 	help
 	  This option allows developers to retrieve coverage data from a UML
 	  session.
diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
index 5aa882011e04..e698e0c7dbdc 100644
--- a/arch/um/kernel/Makefile
+++ b/arch/um/kernel/Makefile
@@ -21,7 +21,6 @@ obj-y = config.o exec.o exitcode.o irq.o ksyms.o mem.o \
 
 obj-$(CONFIG_BLK_DEV_INITRD) += initrd.o
 obj-$(CONFIG_GPROF)	+= gprof_syms.o
-obj-$(CONFIG_GCOV)	+= gmon_syms.o
 obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 
diff --git a/arch/um/kernel/gmon_syms.c b/arch/um/kernel/gmon_syms.c
deleted file mode 100644
index 9361a8eb9bf1..000000000000
--- a/arch/um/kernel/gmon_syms.c
+++ /dev/null
@@ -1,16 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- */
-
-#include <linux/module.h>
-
-extern void __bb_init_func(void *)  __attribute__((weak));
-EXPORT_SYMBOL(__bb_init_func);
-
-extern void __gcov_init(void *)  __attribute__((weak));
-EXPORT_SYMBOL(__gcov_init);
-extern void __gcov_merge_add(void *, unsigned int)  __attribute__((weak));
-EXPORT_SYMBOL(__gcov_merge_add);
-extern void __gcov_exit(void)  __attribute__((weak));
-EXPORT_SYMBOL(__gcov_exit);
-- 
2.30.2

