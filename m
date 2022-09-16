Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E245BAA73
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiIPKZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiIPKXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:23:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD28D193E3;
        Fri, 16 Sep 2022 03:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1987EB82543;
        Fri, 16 Sep 2022 10:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374AAC433C1;
        Fri, 16 Sep 2022 10:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323276;
        bh=Zk/Ie0S+4bGfBwclpLt46krqKDXNjId4eAEIiY0EuCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4UDjMerodcjbQ9Z1Yqy786ECJRYlwyem3whDJ2SNjjPjwEaOkYxVYX3O57M94klk
         JLWFpPGDC/eE4c3Vf4a7ADrab267r0H3G3lihNMuJQkmCG96ZaVpULc/vcgkx1JXHW
         /T27BUHaxVI13SRonzF6ySZu/o00BefVswRY9aFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhuacai@loongson.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 33/38] LoongArch: Fix section mismatch due to acpi_os_ioremap()
Date:   Fri, 16 Sep 2022 12:09:07 +0200
Message-Id: <20220916100449.854045492@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit e0fba87c854347007fb9fc873e890b686cc61302 ]

Now acpi_os_ioremap() is marked with __init because it calls memblock_
is_memory() which is also marked with __init in the !ARCH_KEEP_MEMBLOCK
case. However, acpi_os_ioremap() is called by ordinary functions such
as acpi_os_{read, write}_memory() and causes section mismatch warnings:

WARNING: modpost: vmlinux.o: section mismatch in reference: acpi_os_read_memory (section: .text) -> acpi_os_ioremap (section: .init.text)
WARNING: modpost: vmlinux.o: section mismatch in reference: acpi_os_write_memory (section: .text) -> acpi_os_ioremap (section: .init.text)

Fix these warnings by selecting ARCH_KEEP_MEMBLOCK unconditionally and
removing the __init modifier of acpi_os_ioremap(). This can also give a
chance to track "memory" and "reserved" memblocks after early boot.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Kconfig            | 1 +
 arch/loongarch/include/asm/acpi.h | 2 +-
 arch/loongarch/kernel/acpi.c      | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 62b5b07fa4e1c..ca64bf5f5b038 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -36,6 +36,7 @@ config LOONGARCH
 	select ARCH_INLINE_SPIN_UNLOCK_BH if !PREEMPTION
 	select ARCH_INLINE_SPIN_UNLOCK_IRQ if !PREEMPTION
 	select ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE if !PREEMPTION
+	select ARCH_KEEP_MEMBLOCK
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_SPARSEMEM_ENABLE
diff --git a/arch/loongarch/include/asm/acpi.h b/arch/loongarch/include/asm/acpi.h
index 62044cd5b7bc5..825c2519b9d1f 100644
--- a/arch/loongarch/include/asm/acpi.h
+++ b/arch/loongarch/include/asm/acpi.h
@@ -15,7 +15,7 @@ extern int acpi_pci_disabled;
 extern int acpi_noirq;
 
 #define acpi_os_ioremap acpi_os_ioremap
-void __init __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size);
+void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size);
 
 static inline void disable_acpi(void)
 {
diff --git a/arch/loongarch/kernel/acpi.c b/arch/loongarch/kernel/acpi.c
index bb729ee8a2370..796a24055a942 100644
--- a/arch/loongarch/kernel/acpi.c
+++ b/arch/loongarch/kernel/acpi.c
@@ -113,7 +113,7 @@ void __init __acpi_unmap_table(void __iomem *map, unsigned long size)
 	early_memunmap(map, size);
 }
 
-void __init __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
+void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
 {
 	if (!memblock_is_memory(phys))
 		return ioremap(phys, size);
-- 
2.35.1



