Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9855C38A0DC
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhETJ0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:26:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231654AbhETJ0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 934816135B;
        Thu, 20 May 2021 09:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502698;
        bh=2qTl8uZxoMT78WUK54xsmpIkQsgZUY1/f/fVyhzZUNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FhhMhqWIO6trz5MTLzOLiD6dhc3bMEmzp/4vyYUIEvMpSyb0bwpt+WHefxJRosl3d
         8TbVWvBriYqS6qdUE8bczwHmjuIimQ0K8d6kkiq418INCnIG0YEnQSe1jsGixwzuJE
         Z/BPHy0CNkEShubPS3gYKiu6rakNM3nCcSRUQd+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 19/45] um: Disable CONFIG_GCOV with MODULES
Date:   Thu, 20 May 2021 11:22:07 +0200
Message-Id: <20210520092054.143376360@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



