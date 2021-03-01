Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69563328B5B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240087AbhCASdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239845AbhCAS0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:26:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FA4564DBA;
        Mon,  1 Mar 2021 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620845;
        bh=Pbvngsu9x/Kwc/QgYQE/kmB6+PX0x+Yt/JE4PxvxjXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MN6oSiGEVlEEqBn8CFQRHs0/+KLqNA9DIw5qnY3PFM/9afiIS8m1DH5komBT5498p
         /RjRj27NaCLlUWeQnFEzY+6oZRyOlFOC1vDyjcNW7PWNgjdeUKg7ExydVSM+7SYhXv
         BdJJ8SL82fHVeUZMAxC0KqDkzZUOLGQpDn+i5OE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jinyang He <hejinyang@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 270/775] MIPS: relocatable: Provide kaslr_offset() to get the kernel offset
Date:   Mon,  1 Mar 2021 17:07:18 +0100
Message-Id: <20210301161214.974529732@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinyang He <hejinyang@loongson.cn>

[ Upstream commit d4d3ef8b347b73aa60f60f4be06acf1643e79f34 ]

Provide kaslr_offset() to get the kernel offset when KASLR is enabled.
Error may occur before update_kaslr_offset(), so put it at the end of
the offset branch.

Fixes: a307a4ce9ecd ("MIPS: Loongson64: Add KASLR support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/page.h |  6 ++++++
 arch/mips/kernel/relocate.c  | 10 ++++++++++
 arch/mips/kernel/setup.c     |  3 +++
 3 files changed, 19 insertions(+)

diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index 6a77bc4a6eec4..74082e35d57c8 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -255,6 +255,12 @@ extern bool __virt_addr_valid(const volatile void *kaddr);
 
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
+extern unsigned long __kaslr_offset;
+static inline unsigned long kaslr_offset(void)
+{
+	return __kaslr_offset;
+}
+
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
index 0e365b7c742d9..ac16cf2716df5 100644
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -300,6 +300,13 @@ static inline int __init relocation_addr_valid(void *loc_new)
 	return 1;
 }
 
+static inline void __init update_kaslr_offset(unsigned long *addr, long offset)
+{
+	unsigned long *new_addr = (unsigned long *)RELOCATED(addr);
+
+	*new_addr = (unsigned long)offset;
+}
+
 #if defined(CONFIG_USE_OF)
 void __weak *plat_get_fdt(void)
 {
@@ -410,6 +417,9 @@ void *__init relocate_kernel(void)
 
 		/* Return the new kernel's entry point */
 		kernel_entry = RELOCATED(start_kernel);
+
+		/* Error may occur before, so keep it at last */
+		update_kaslr_offset(&__kaslr_offset, offset);
 	}
 out:
 	return kernel_entry;
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 7e1f8e2774373..83ec0d5a0918b 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -84,6 +84,9 @@ static struct resource code_resource = { .name = "Kernel code", };
 static struct resource data_resource = { .name = "Kernel data", };
 static struct resource bss_resource = { .name = "Kernel bss", };
 
+unsigned long __kaslr_offset __ro_after_init;
+EXPORT_SYMBOL(__kaslr_offset);
+
 static void *detect_magic __initdata = detect_memory_region;
 
 #ifdef CONFIG_MIPS_AUTO_PFN_OFFSET
-- 
2.27.0



