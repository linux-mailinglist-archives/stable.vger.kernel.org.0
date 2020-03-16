Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFAC18628A
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgCPChx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729631AbgCPCfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:35:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B19B206EB;
        Mon, 16 Mar 2020 02:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326111;
        bh=B7VCjfXUJJnPc9HcAd5IjQF9bDnM9fbTDTAhWgmBR34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ogu0GllGWjbmAqEozETsKu62fX5wNH6x/Aoje9FjXXjbaF1CtyNy3SJWXMAtNBfyH
         +fytoFxuqHxlAOzVidQcjOhzk9hGED3wPSlZ1zWVtvJADCqas1AR7skDqf85NMURLD
         SnZjbzwxFbt8y43NY4xEHU2kii0YhyEAcBPrwbqs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Chen <vincent.chen@sifive.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Anup Patel <anup@brainfault.org>,
        Carlos de Paula <me@carlosedp.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 14/20] riscv: avoid the PIC offset of static percpu data in module beyond 2G limits
Date:   Sun, 15 Mar 2020 22:34:47 -0400
Message-Id: <20200316023453.1800-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023453.1800-1-sashal@kernel.org>
References: <20200316023453.1800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

[ Upstream commit 0cff8bff7af886af0923d5c91776cd51603e531f ]

The compiler uses the PIC-relative method to access static variables
instead of GOT when the code model is PIC. Therefore, the limitation of
the access range from the instruction to the symbol address is +-2GB.
Under this circumstance, the kernel cannot load a kernel module if this
module has static per-CPU symbols declared by DEFINE_PER_CPU(). The reason
is that kernel relocates the .data..percpu section of the kernel module to
the end of kernel's .data..percpu. Hence, the distance between the per-CPU
symbols and the instruction will exceed the 2GB limits. To solve this
problem, the kernel should place the loaded module in the memory area
[&_end-2G, VMALLOC_END].

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Suggested-by: Alexandre Ghiti <alex@ghiti.fr>
Suggested-by: Anup Patel <anup@brainfault.org>
Tested-by: Alexandre Ghiti <alex@ghiti.fr>
Tested-by: Carlos de Paula <me@carlosedp.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/module.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 7dd308129b40f..7c012ad1d7ede 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -16,6 +16,10 @@
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/moduleloader.h>
+#include <linux/vmalloc.h>
+#include <linux/sizes.h>
+#include <asm/pgtable.h>
+#include <asm/sections.h>
 
 static int apply_r_riscv_32_rela(struct module *me, u32 *location, Elf_Addr v)
 {
@@ -394,3 +398,15 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 
 	return 0;
 }
+
+#if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
+#define VMALLOC_MODULE_START \
+	 max(PFN_ALIGN((unsigned long)&_end - SZ_2G), VMALLOC_START)
+void *module_alloc(unsigned long size)
+{
+	return __vmalloc_node_range(size, 1, VMALLOC_MODULE_START,
+				    VMALLOC_END, GFP_KERNEL,
+				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				    __builtin_return_address(0));
+}
+#endif
-- 
2.20.1

