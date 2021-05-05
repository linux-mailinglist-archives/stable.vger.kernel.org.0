Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C734A374549
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbhEEREg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237903AbhEERBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 218EC61A2D;
        Wed,  5 May 2021 16:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232851;
        bh=Y70RnH11d1XJD+3iLneAnjF4aLY0S1a2wNl5ugiGzqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2Gtsju8Xm8P1ZokxZW8ac24T1wQDBuVRX162EK1svEhwW4OsytuPzVhNvHDZ1lwS
         Vl16FVkIYfHfj0Sz3habvDWHFrAd5Y7WqaK/33Qb15Ki+DRSkCnQxCVLLndAXobrBv
         i2N42iD+YOvf2dmxqOgFiZERy5/nVaJqkuYGvlQk6VV1xuAgAMbaqEGOqDmrZhmdi0
         SfRfvyavTMgsFbFRjs4deck0z/0kFtKSfkwTVIznbknRmmmHTZcVNQo3LFzJk5YwUS
         khN7TKxJi/FZcjrDborHOrA8bx2HVz17Y3Lzk19nPePa+vtqFnvCoV2ubpVCQnl+gv
         JL4raCUQGFIkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 32/32] ia64: module: fix symbolizer crash on fdescr
Date:   Wed,  5 May 2021 12:40:04 -0400
Message-Id: <20210505164004.3463707-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164004.3463707-1-sashal@kernel.org>
References: <20210505164004.3463707-1-sashal@kernel.org>
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
index f319144260ce..9fbf32e6e881 100644
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
 
 #define MODULE_PROC_FAMILY	"ia64"
diff --git a/arch/ia64/kernel/module.c b/arch/ia64/kernel/module.c
index 1a42ba885188..ee693c8cec49 100644
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

