Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8509B3136CA
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhBHPP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231995AbhBHPLj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:11:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 578A264EE7;
        Mon,  8 Feb 2021 15:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796920;
        bh=NqXv7MiDfSAas23UZ7y5XWx6QI+fE1q6ngNEVJcUs3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKXiigX/D4PjKQ71sup2VXp02mT6xHOBgajJwrVONL5IkkvXSYRsFAUT4spGGAoIe
         0B8LXKFlcv9ns3H6VbAPZ0nS2YqXaFcubQ6M2RS0GxAFvsWJ/nKk+MsID70+7GuwmG
         8KCXI7tOOnJCpN0LB9C80diB7OjNRtbm9UPMU8qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Barret Rhoden <brho@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 04/38] elfcore: fix building with clang
Date:   Mon,  8 Feb 2021 16:00:51 +0100
Message-Id: <20210208145806.310937132@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 6e7b64b9dd6d96537d816ea07ec26b7dedd397b9 upstream.

kernel/elfcore.c only contains weak symbols, which triggers a bug with
clang in combination with recordmcount:

  Cannot find symbol for section 2: .text.
  kernel/elfcore.o: failed

Move the empty stubs into linux/elfcore.h as inline functions.  As only
two architectures use these, just use the architecture specific Kconfig
symbols to key off the declaration.

Link: https://lkml.kernel.org/r/20201204165742.3815221-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Barret Rhoden <brho@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/elfcore.h |   22 ++++++++++++++++++++++
 kernel/Makefile         |    1 -
 kernel/elfcore.c        |   26 --------------------------
 3 files changed, 22 insertions(+), 27 deletions(-)
 delete mode 100644 kernel/elfcore.c

--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -58,6 +58,7 @@ static inline int elf_core_copy_task_xfp
 }
 #endif
 
+#if defined(CONFIG_UM) || defined(CONFIG_IA64)
 /*
  * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
  * extra segments containing the gate DSO contents.  Dumping its
@@ -72,5 +73,26 @@ elf_core_write_extra_phdrs(struct coredu
 extern int
 elf_core_write_extra_data(struct coredump_params *cprm);
 extern size_t elf_core_extra_data_size(void);
+#else
+static inline Elf_Half elf_core_extra_phdrs(void)
+{
+	return 0;
+}
+
+static inline int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
+{
+	return 1;
+}
+
+static inline int elf_core_write_extra_data(struct coredump_params *cprm)
+{
+	return 1;
+}
+
+static inline size_t elf_core_extra_data_size(void)
+{
+	return 0;
+}
+#endif
 
 #endif /* _LINUX_ELFCORE_H */
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -92,7 +92,6 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayac
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
-obj-$(CONFIG_ELFCORE) += elfcore.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_TRACE_CLOCK) += trace/
--- a/kernel/elfcore.c
+++ /dev/null
@@ -1,26 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/elf.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/binfmts.h>
-#include <linux/elfcore.h>
-
-Elf_Half __weak elf_core_extra_phdrs(void)
-{
-	return 0;
-}
-
-int __weak elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
-{
-	return 1;
-}
-
-int __weak elf_core_write_extra_data(struct coredump_params *cprm)
-{
-	return 1;
-}
-
-size_t __weak elf_core_extra_data_size(void)
-{
-	return 0;
-}


