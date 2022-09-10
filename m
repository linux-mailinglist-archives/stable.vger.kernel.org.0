Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E775B498B
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiIJVVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiIJVUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:20:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7F84F3A0;
        Sat, 10 Sep 2022 14:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B28CCB80945;
        Sat, 10 Sep 2022 21:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7671FC433D7;
        Sat, 10 Sep 2022 21:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844664;
        bh=Zk/Ie0S+4bGfBwclpLt46krqKDXNjId4eAEIiY0EuCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uep0H1YM1vfkXScWVfmbNJu8oHDhyThz5v1HGjuSx4mK6rdUXM2l+xp0yq4KU4cAH
         +B/i+9VGmho2TiveCJ8DNerTTPWSl0IPdSmFmDn6vBpbAXedItwsW3NY0ywrrQfl7K
         iCM2zADg7AfGrUIInOcIUk+lEug7WnkODPtN2GdxdTKgx1sK6k+ZuWEmfX7llTaQLo
         j1xu0oq8xFOP3bpXboBtt4O12t3dGgjq7gB6mcrupFT8EmD1n83KviMq4ASYk43+ID
         HES8RMUPBOifcjSNFv3pCDSFeOTtR1+40/QX4pW+9iY2XX3pojxw4ZjyekdUMjIRGF
         wbhBHV8zBTpHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Sasha Levin <sashal@kernel.org>, chenhuacai@kernel.org,
        lvjianmin@loongson.cn, git@xen0n.name, maz@kernel.org,
        jiaxun.yang@flygoat.com, loongarch@lists.linux.dev
Subject: [PATCH AUTOSEL 5.19 35/38] LoongArch: Fix section mismatch due to acpi_os_ioremap()
Date:   Sat, 10 Sep 2022 17:16:20 -0400
Message-Id: <20220910211623.69825-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

