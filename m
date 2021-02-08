Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72216313C50
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbhBHSF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:05:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235158AbhBHSAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:00:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2999B64EC3;
        Mon,  8 Feb 2021 17:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807122;
        bh=ft/YBWz1t9UpptJmcSTd20AycxE77gRkYFZxdGCheSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKYy3XVdONa1dMQmZareFCdHevU80djeMgmkTq8jDykky9QzIcTJMh0h98rjhayOm
         hOAIDiUwssqA6rNWKAzN8O76JgjFEWVyBFG2CMNI4063MX1g0pL+KgBS+mEjv+gsFj
         /nf4YcUaztRfujiqn2eVWglNLsvfEb6SEDdQ3jShEevUeSDiARX6JObJfeJHo3To7e
         eNrHbKHXaKiolWH6SzVDAmLetygxmR3aredxo+KyGhEc2yLxHo/4NBd/Zh8m+5npdV
         KQ/urQWhmBpGWTUYEXRlKESpGsMrmI48bQ6F/dnVZtl5sFuZSOHiXsdEio3Gdfeg72
         MWp27hteu7pGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alex@ghiti.fr>, Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 26/36] riscv: virt_addr_valid must check the address belongs to linear mapping
Date:   Mon,  8 Feb 2021 12:57:56 -0500
Message-Id: <20210208175806.2091668-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alex@ghiti.fr>

[ Upstream commit 2ab543823322b564f205cb15d0f0302803c87d11 ]

virt_addr_valid macro checks that a virtual address is valid, ie that
the address belongs to the linear mapping and that the corresponding
 physical page exists.

Add the missing check that ensures the virtual address belongs to the
linear mapping, otherwise __virt_to_phys, when compiled with
CONFIG_DEBUG_VIRTUAL enabled, raises a WARN that is interpreted as a
kernel bug by syzbot.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/page.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index 2d50f76efe481..64a675c5c30ac 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -135,7 +135,10 @@ extern phys_addr_t __phys_addr_symbol(unsigned long x);
 
 #endif /* __ASSEMBLY__ */
 
-#define virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
+#define virt_addr_valid(vaddr)	({						\
+	unsigned long _addr = (unsigned long)vaddr;				\
+	(unsigned long)(_addr) >= PAGE_OFFSET && pfn_valid(virt_to_pfn(_addr));	\
+})
 
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_NON_EXEC
 
-- 
2.27.0

