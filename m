Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118095761B
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfF0AfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbfF0AfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:35:16 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B11217F9;
        Thu, 27 Jun 2019 00:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595715;
        bh=2Rg3rhytNCFIIBZMHw/pfbljMPMzG/fPxvGHuncYIXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLG1jwMFV5ZclKx/FPHSgVzfRBekjLbVDcNkaTOLhZ4G7XwGUa2rL63SXuQYPKWc0
         50W7KjzIcbYl0AAWjMr7XyD3xicJx+rjss3SDFZYMhUvzWfaDSQ4anFvAOmSJHWf0J
         wQt31Qx8628U6IaigXknggYyWEnni/2u1k4zDqfo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.1 89/95] powerpc: enable a 30-bit ZONE_DMA for 32-bit pmac
Date:   Wed, 26 Jun 2019 20:30:14 -0400
Message-Id: <20190627003021.19867-89-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 9739ab7eda459f0669ec9807e0d9be5020bab88c ]

With the strict dma mask checking introduced with the switch to
the generic DMA direct code common wifi chips on 32-bit powerbooks
stopped working.  Add a 30-bit ZONE_DMA to the 32-bit pmac builds
to allow them to reliably allocate dma coherent memory.

Fixes: 65a21b71f948 ("powerpc/dma: remove dma_nommu_dma_supported")
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/page.h         | 7 +++++++
 arch/powerpc/mm/mem.c                   | 3 ++-
 arch/powerpc/platforms/powermac/Kconfig | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index ed870468ef6f..d408711d09fb 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -330,6 +330,13 @@ struct vm_area_struct;
 #endif /* __ASSEMBLY__ */
 #include <asm/slice.h>
 
+/*
+ * Allow 30-bit DMA for very limited Broadcom wifi chips on many powerbooks.
+ */
+#ifdef CONFIG_PPC32
+#define ARCH_ZONE_DMA_BITS 30
+#else
 #define ARCH_ZONE_DMA_BITS 31
+#endif
 
 #endif /* _ASM_POWERPC_PAGE_H */
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index f6787f90e158..b98ce400a889 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -255,7 +255,8 @@ void __init paging_init(void)
 	       (long int)((top_of_ram - total_ram) >> 20));
 
 #ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA]	= min(max_low_pfn, 0x7fffffffUL >> PAGE_SHIFT);
+	max_zone_pfns[ZONE_DMA]	= min(max_low_pfn,
+			((1UL << ARCH_ZONE_DMA_BITS) - 1) >> PAGE_SHIFT);
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
diff --git a/arch/powerpc/platforms/powermac/Kconfig b/arch/powerpc/platforms/powermac/Kconfig
index f834a19ed772..c02d8c503b29 100644
--- a/arch/powerpc/platforms/powermac/Kconfig
+++ b/arch/powerpc/platforms/powermac/Kconfig
@@ -7,6 +7,7 @@ config PPC_PMAC
 	select PPC_INDIRECT_PCI if PPC32
 	select PPC_MPC106 if PPC32
 	select PPC_NATIVE
+	select ZONE_DMA if PPC32
 	default y
 
 config PPC_PMAC64
-- 
2.20.1

