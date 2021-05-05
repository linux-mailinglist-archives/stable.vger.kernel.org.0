Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705D73742E3
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbhEEQs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235623AbhEEQqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:46:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F33F610FB;
        Wed,  5 May 2021 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232600;
        bh=4SUyrWMklPhz6u+2+ZQbOuVSYJvmj9deWcfZDult3CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owPyY2PKK7qkXDN5bARnSR4Zo0Y4QvnFqjkd5LSQA1b3KArPm+erZfByr/2+cZfOM
         wpN3h28QQsdCBmfmAN6FFJEUNFwkpdPuoAv38L3HN/zG+gfDoRJxoqNXFtb7kA2aVG
         XhZh/zd+CD4u1oyLTxnJoZEJpbZwQtOxoLfCovP5y59//Tl3ZTxJBMAiqbDbPakytp
         WDF3/vqOkM5IIjHpY/XLZgso7PEha/jJczMeA3c4/ztzjSt5XgPG8oxT9ZzQALCMj/
         z4XiONvjndSFkGM3bzQbvVIsKftgj5i9n/QgXQXyBMGJm3mYcsBeA315wDHVsHkL3i
         L+Pf6PMAnBzsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 100/104] ia64: module: fix symbolizer crash on fdescr
Date:   Wed,  5 May 2021 12:34:09 -0400
Message-Id: <20210505163413.3461611-100-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

[ Upstream commit 99e729bd40fb3272fa4b0140839d5e957b58588a ]

Noticed failure as a crash on ia64 when tried to symbolize all backtraces
collected by page_owner=on:

    $ cat /sys/kernel/debug/page_owner
    <oops>

    CPU: 1 PID: 2074 Comm: cat Not tainted 5.12.0-rc4 #226
    Hardware name: hp server rx3600, BIOS 04.03 04/08/2008
    ip is at dereference_module_function_descriptor+0x41/0x100

Crash happens at dereference_module_function_descriptor() due to
use-after-free when dereferencing ".opd" section header.

All section headers are already freed after module is laoded successfully.

To keep symbolizer working the change stores ".opd" address and size after
module is relocated to a new place and before section headers are
discarded.

To make similar errors less obscure module_finalize() now zeroes out all
variables relevant to module loading only.

Link: https://lkml.kernel.org/r/20210403074803.3309096-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/include/asm/module.h |  6 +++++-
 arch/ia64/kernel/module.c      | 29 +++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/include/asm/module.h b/arch/ia64/include/asm/module.h
index 5a29652e6def..7271b9c5fc76 100644
--- a/arch/ia64/include/asm/module.h
+++ b/arch/ia64/include/asm/module.h
@@ -14,16 +14,20 @@
 struct elf64_shdr;			/* forward declration */
 
 struct mod_arch_specific {
+	/* Used only at module load time. */
 	struct elf64_shdr *core_plt;	/* core PLT section */
 	struct elf64_shdr *init_plt;	/* init PLT section */
 	struct elf64_shdr *got;		/* global offset table */
 	struct elf64_shdr *opd;		/* official procedure descriptors */
 	struct elf64_shdr *unwind;	/* unwind-table section */
 	unsigned long gp;		/* global-pointer for module */
+	unsigned int next_got_entry;	/* index of next available got entry */
 
+	/* Used at module run and cleanup time. */
 	void *core_unw_table;		/* core unwind-table cookie returned by unwinder */
 	void *init_unw_table;		/* init unwind-table cookie returned by unwinder */
-	unsigned int next_got_entry;	/* index of next available got entry */
+	void *opd_addr;			/* symbolize uses .opd to get to actual function */
+	unsigned long opd_size;
 };
 
 #define ARCH_SHF_SMALL	SHF_IA_64_SHORT
diff --git a/arch/ia64/kernel/module.c b/arch/ia64/kernel/module.c
index 00a496cb346f..2cba53c1da82 100644
--- a/arch/ia64/kernel/module.c
+++ b/arch/ia64/kernel/module.c
@@ -905,9 +905,31 @@ register_unwind_table (struct module *mod)
 int
 module_finalize (const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs, struct module *mod)
 {
+	struct mod_arch_specific *mas = &mod->arch;
+
 	DEBUGP("%s: init: entry=%p\n", __func__, mod->init);
-	if (mod->arch.unwind)
+	if (mas->unwind)
 		register_unwind_table(mod);
+
+	/*
+	 * ".opd" was already relocated to the final destination. Store
+	 * it's address for use in symbolizer.
+	 */
+	mas->opd_addr = (void *)mas->opd->sh_addr;
+	mas->opd_size = mas->opd->sh_size;
+
+	/*
+	 * Module relocation was already done at this point. Section
+	 * headers are about to be deleted. Wipe out load-time context.
+	 */
+	mas->core_plt = NULL;
+	mas->init_plt = NULL;
+	mas->got = NULL;
+	mas->opd = NULL;
+	mas->unwind = NULL;
+	mas->gp = 0;
+	mas->next_got_entry = 0;
+
 	return 0;
 }
 
@@ -926,10 +948,9 @@ module_arch_cleanup (struct module *mod)
 
 void *dereference_module_function_descriptor(struct module *mod, void *ptr)
 {
-	Elf64_Shdr *opd = mod->arch.opd;
+	struct mod_arch_specific *mas = &mod->arch;
 
-	if (ptr < (void *)opd->sh_addr ||
-			ptr >= (void *)(opd->sh_addr + opd->sh_size))
+	if (ptr < mas->opd_addr || ptr >= mas->opd_addr + mas->opd_size)
 		return ptr;
 
 	return dereference_function_descriptor(ptr);
-- 
2.30.2

