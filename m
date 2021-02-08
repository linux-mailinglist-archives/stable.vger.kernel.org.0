Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B136F313696
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhBHPM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:12:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232200AbhBHPKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:10:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85D8F64ED4;
        Mon,  8 Feb 2021 15:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796835;
        bh=7QAP6juxWHp+KETu5g2tT4DiAtwc6vaVDvyDdb2MMKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2I0R7qVI65eG9T7mMro/04iWLSH0QBcHjxP1f4q/OTHmakpMhmvd07TEt4xVGfn4n
         sM+bPLGgKNAPm+2bMOl/0P8yEicL0q1lZRo6S0m4WxqgZYFAuX30gHhCX8wZWjOpA1
         10PZ+aINuzVRCrSXIjTv22miQmX57UqdhfFcwttQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Barret Rhoden <brho@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 08/30] elfcore: fix building with clang
Date:   Mon,  8 Feb 2021 16:00:54 +0100
Message-Id: <20210208145805.582779586@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.239714726@linuxfoundation.org>
References: <20210208145805.239714726@linuxfoundation.org>
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
@@ -90,7 +90,6 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayac
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


