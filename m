Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D489C4125D0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384671AbhITSse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384096AbhITSqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:46:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D2263361;
        Mon, 20 Sep 2021 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159220;
        bh=walABZlX11JaDQYOkSKG4JpsE8wTH7I7GPEVcS8ooGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRM2GW7WVLz/mRmsipx2Wue5RhJgwXA+hzCU62ENSdJVimFnLVSPWt9msTCGyCIgY
         CzerZLL5YF9tILmxkUWfkMYfUNeeeBDfGDlDu0PzBSeKxw+cvYKnbDFdWokBuCWJ3c
         EW2vGlc4tSMr5qlIbm1tX4HScTp1ijEH03ZCsg9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Lee <liguozhu@hisilicon.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 100/168] riscv: fix the global name pfn_base confliction error
Date:   Mon, 20 Sep 2021 18:43:58 +0200
Message-Id: <20210920163924.927901763@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

[ Upstream commit fb31f0a499332a053477ed57312b214e42476e6d ]

RISCV uses a global variable pfn_base for page/pfn translation. But this
is a common name and will be used elsewhere. In those cases, the
page-pfn macros which refer to this name will be referred to the
local/input variable instead. (such as in vfio_pin_pages_remote). This
make everything wrong.

This patch changes the name from pfn_base to riscv_pfn_base to fix
this problem.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/page.h | 4 ++--
 arch/riscv/mm/init.c          | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index b0ca5058e7ae..767852ae5e84 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -79,8 +79,8 @@ typedef struct page *pgtable_t;
 #endif
 
 #ifdef CONFIG_MMU
-extern unsigned long pfn_base;
-#define ARCH_PFN_OFFSET		(pfn_base)
+extern unsigned long riscv_pfn_base;
+#define ARCH_PFN_OFFSET		(riscv_pfn_base)
 #else
 #define ARCH_PFN_OFFSET		(PAGE_OFFSET >> PAGE_SHIFT)
 #endif /* CONFIG_MMU */
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 7cb4f391d106..9786100f3a14 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -234,8 +234,8 @@ static struct pt_alloc_ops _pt_ops __initdata;
 #define pt_ops _pt_ops
 #endif
 
-unsigned long pfn_base __ro_after_init;
-EXPORT_SYMBOL(pfn_base);
+unsigned long riscv_pfn_base __ro_after_init;
+EXPORT_SYMBOL(riscv_pfn_base);
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
 pgd_t trampoline_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
@@ -579,7 +579,7 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 	kernel_map.va_kernel_pa_offset = kernel_map.virt_addr - kernel_map.phys_addr;
 #endif
 
-	pfn_base = PFN_DOWN(kernel_map.phys_addr);
+	riscv_pfn_base = PFN_DOWN(kernel_map.phys_addr);
 
 	/*
 	 * Enforce boot alignment requirements of RV32 and
-- 
2.30.2



