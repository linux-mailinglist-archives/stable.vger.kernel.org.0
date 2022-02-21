Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877994BDD4F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347152AbiBUJEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:04:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347135AbiBUJEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:04:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32402DA9C;
        Mon, 21 Feb 2022 00:58:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB3B8B80EAC;
        Mon, 21 Feb 2022 08:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88E6C36AE3;
        Mon, 21 Feb 2022 08:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433901;
        bh=V+GAnAacYdkyKm/bNFvDuRxcECMVX1bM81QitkE3o3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGFJYiFMUtoaMeQ9aM+dtGfddAfl8scLujkE3AJvvCn/m84ZPgwUjHx3B7IdLFPqY
         ZSsdq9OcB0JSJGgxXbxtGib21T3XfnL7v3coTi9pWfRRqfXrNxX6Qx033ls4NpOQ4p
         1Kul/4MeIEEWwhuHljuu9gLVrFd2cgqApV6WWdZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Helge Deller <deller@gmx.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Torsten Duwe <duwe@suse.de>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Sven Schnelle <svens@stackframe.org>,
        Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Jessica Yu <jeyu@kernel.org>, linux-parisc@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.4 24/80] module/ftrace: handle patchable-function-entry
Date:   Mon, 21 Feb 2022 09:49:04 +0100
Message-Id: <20220221084916.374474220@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit a1326b17ac03a9012cb3d01e434aacb4d67a416c upstream.

When using patchable-function-entry, the compiler will record the
callsites into a section named "__patchable_function_entries" rather
than "__mcount_loc". Let's abstract this difference behind a new
FTRACE_CALLSITE_SECTION, so that architectures don't have to handle this
explicitly (e.g. with custom module linker scripts).

As parisc currently handles this explicitly, it is fixed up accordingly,
with its custom linker script removed. Since FTRACE_CALLSITE_SECTION is
only defined when DYNAMIC_FTRACE is selected, the parisc module loading
code is updated to only use the definition in that case. When
DYNAMIC_FTRACE is not selected, modules shouldn't have this section, so
this removes some redundant work in that case.

To make sure that this is keep up-to-date for modules and the main
kernel, a comment is added to vmlinux.lds.h, with the existing ifdeffery
simplified for legibility.

I built parisc generic-{32,64}bit_defconfig with DYNAMIC_FTRACE enabled,
and verified that the section made it into the .ko files for modules.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Helge Deller <deller@gmx.de>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Torsten Duwe <duwe@suse.de>
Tested-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Tested-by: Sven Schnelle <svens@stackframe.org>
Tested-by: Torsten Duwe <duwe@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: linux-parisc@vger.kernel.org
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Makefile              |    1 -
 arch/parisc/kernel/module.c       |   10 +++++++---
 arch/parisc/kernel/module.lds     |    7 -------
 include/asm-generic/vmlinux.lds.h |   14 +++++++-------
 include/linux/ftrace.h            |    5 +++++
 kernel/module.c                   |    2 +-
 6 files changed, 20 insertions(+), 19 deletions(-)
 delete mode 100644 arch/parisc/kernel/module.lds

--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -65,7 +65,6 @@ KBUILD_CFLAGS += -DCC_USING_PATCHABLE_FU
 		 -DFTRACE_PATCHABLE_FUNCTION_SIZE=$(NOP_COUNT)
 
 CC_FLAGS_FTRACE := -fpatchable-function-entry=$(NOP_COUNT),$(shell echo $$(($(NOP_COUNT)-1)))
-KBUILD_LDS_MODULE += $(srctree)/arch/parisc/kernel/module.lds
 endif
 
 OBJCOPY_FLAGS =-O binary -R .note -R .comment -S
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -43,6 +43,7 @@
 #include <linux/elf.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
+#include <linux/ftrace.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/bug.h>
@@ -862,7 +863,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 	const char *strtab = NULL;
 	const Elf_Shdr *s;
 	char *secstrings;
-	int err, symindex = -1;
+	int symindex = -1;
 	Elf_Sym *newptr, *oldptr;
 	Elf_Shdr *symhdr = NULL;
 #ifdef DEBUG
@@ -946,11 +947,13 @@ int module_finalize(const Elf_Ehdr *hdr,
 			/* patch .altinstructions */
 			apply_alternatives(aseg, aseg + s->sh_size, me->name);
 
+#ifdef CONFIG_DYNAMIC_FTRACE
 		/* For 32 bit kernels we're compiling modules with
 		 * -ffunction-sections so we must relocate the addresses in the
-		 *__mcount_loc section.
+		 *  ftrace callsite section.
 		 */
-		if (symindex != -1 && !strcmp(secname, "__mcount_loc")) {
+		if (symindex != -1 && !strcmp(secname, FTRACE_CALLSITE_SECTION)) {
+			int err;
 			if (s->sh_type == SHT_REL)
 				err = apply_relocate((Elf_Shdr *)sechdrs,
 							strtab, symindex,
@@ -962,6 +965,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 			if (err)
 				return err;
 		}
+#endif
 	}
 	return 0;
 }
--- a/arch/parisc/kernel/module.lds
+++ /dev/null
@@ -1,7 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-SECTIONS {
-	__mcount_loc : {
-		*(__patchable_function_entries)
-	}
-}
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -110,17 +110,17 @@
 #endif
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
-#ifdef CC_USING_PATCHABLE_FUNCTION_ENTRY
-#define MCOUNT_REC()	. = ALIGN(8);				\
-			__start_mcount_loc = .;			\
-			KEEP(*(__patchable_function_entries))	\
-			__stop_mcount_loc = .;
-#else
+/*
+ * The ftrace call sites are logged to a section whose name depends on the
+ * compiler option used. A given kernel image will only use one, AKA
+ * FTRACE_CALLSITE_SECTION. We capture all of them here to avoid header
+ * dependencies for FTRACE_CALLSITE_SECTION's definition.
+ */
 #define MCOUNT_REC()	. = ALIGN(8);				\
 			__start_mcount_loc = .;			\
 			KEEP(*(__mcount_loc))			\
+			KEEP(*(__patchable_function_entries))	\
 			__stop_mcount_loc = .;
-#endif
 #else
 #define MCOUNT_REC()
 #endif
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -738,6 +738,11 @@ static inline unsigned long get_lock_par
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 extern void ftrace_init(void);
+#ifdef CC_USING_PATCHABLE_FUNCTION_ENTRY
+#define FTRACE_CALLSITE_SECTION	"__patchable_function_entries"
+#else
+#define FTRACE_CALLSITE_SECTION	"__mcount_loc"
+#endif
 #else
 static inline void ftrace_init(void) { }
 #endif
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3377,7 +3377,7 @@ static int find_module_sections(struct m
 #endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 	/* sechdrs[0].sh_size is always zero */
-	mod->ftrace_callsites = section_objs(info, "__mcount_loc",
+	mod->ftrace_callsites = section_objs(info, FTRACE_CALLSITE_SECTION,
 					     sizeof(*mod->ftrace_callsites),
 					     &mod->num_ftrace_callsites);
 #endif


