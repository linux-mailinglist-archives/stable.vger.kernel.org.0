Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639FCA8A6E
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbfIDP7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbfIDP7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5736C20820;
        Wed,  4 Sep 2019 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612760;
        bh=TGRMB95YGQkQ03FI3rbztcHl2l8WMOmLww0pLVy6bpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWshuuCr0L0GBvgTb/bA3iz7epxmfJbAbVGVOrgqsq7AGeBwMAIoFFcwHHdtxWCpn
         7/ZulQpq5y+ZgdMm2yTmONOgxAJ8LcTdBARe93DOqpx947dZ7ik7lNvy+oCN4Y7Okx
         b0uWmNu7msMrQONLBrjEWK541cdbRHBKhraJHmWc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anup Patel <Anup.Patel@wdc.com>, Anup Patel <anup.patel@wdc.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 65/94] RISC-V: Fix FIXMAP area corruption on RV32 systems
Date:   Wed,  4 Sep 2019 11:57:10 -0400
Message-Id: <20190904155739.2816-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <Anup.Patel@wdc.com>

[ Upstream commit a256f2e329df0773022d28df2c3d206b9aaf1e61 ]

Currently, various virtual memory areas of Linux RISC-V are organized
in increasing order of their virtual addresses is as follows:
1. User space area (This is lowest area and starts at 0x0)
2. FIXMAP area
3. VMALLOC area
4. Kernel area (This is highest area and starts at PAGE_OFFSET)

The maximum size of user space aread is represented by TASK_SIZE.

On RV32 systems, TASK_SIZE is defined as VMALLOC_START which causes the
user space area to overlap the FIXMAP area. This allows user space apps
to potentially corrupt the FIXMAP area and kernel OF APIs will crash
whenever they access corrupted FDT in the FIXMAP area.

On RV64 systems, TASK_SIZE is set to fixed 256GB and no other areas
happen to overlap so we don't see any FIXMAP area corruptions.

This patch fixes FIXMAP area corruption on RV32 systems by setting
TASK_SIZE to FIXADDR_START. We also move FIXADDR_TOP, FIXADDR_SIZE,
and FIXADDR_START defines to asm/pgtable.h so that we can avoid cyclic
header includes.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Tested-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/fixmap.h  |  4 ----
 arch/riscv/include/asm/pgtable.h | 12 ++++++++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/include/asm/fixmap.h b/arch/riscv/include/asm/fixmap.h
index c207f6634b91c..15b3edaabc280 100644
--- a/arch/riscv/include/asm/fixmap.h
+++ b/arch/riscv/include/asm/fixmap.h
@@ -25,10 +25,6 @@ enum fixed_addresses {
 	__end_of_fixed_addresses
 };
 
-#define FIXADDR_SIZE		(__end_of_fixed_addresses * PAGE_SIZE)
-#define FIXADDR_TOP		(VMALLOC_START)
-#define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
-
 #define FIXMAP_PAGE_IO		PAGE_KERNEL
 
 #define __early_set_fixmap	__set_fixmap
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index f7c3f7de15f27..e6faa469c133b 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -408,14 +408,22 @@ static inline void pgtable_cache_init(void)
 #define VMALLOC_END      (PAGE_OFFSET - 1)
 #define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
 
+#define FIXADDR_TOP      VMALLOC_START
+#ifdef CONFIG_64BIT
+#define FIXADDR_SIZE     PMD_SIZE
+#else
+#define FIXADDR_SIZE     PGDIR_SIZE
+#endif
+#define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
+
 /*
- * Task size is 0x40000000000 for RV64 or 0xb800000 for RV32.
+ * Task size is 0x4000000000 for RV64 or 0x9fc00000 for RV32.
  * Note that PGDIR_SIZE must evenly divide TASK_SIZE.
  */
 #ifdef CONFIG_64BIT
 #define TASK_SIZE (PGDIR_SIZE * PTRS_PER_PGD / 2)
 #else
-#define TASK_SIZE VMALLOC_START
+#define TASK_SIZE FIXADDR_START
 #endif
 
 #include <asm-generic/pgtable.h>
-- 
2.20.1

