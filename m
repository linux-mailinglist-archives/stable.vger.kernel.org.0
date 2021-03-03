Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D597D32BC20
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443113AbhCCNlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:41:05 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13846 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452280AbhCCHVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 02:21:11 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Dr52Y2dg7z7rYg;
        Wed,  3 Mar 2021 15:18:45 +0800 (CST)
Received: from ubuntu-82.huawei.com (10.175.104.82) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Wed, 3 Mar 2021 15:20:20 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <gregkh@linuxfoundation.org>, <catalin.marinas@arm.com>,
        <will@kernel.org>, <akpm@linux-foundation.org>,
        <nsaenzjulienne@suse.de>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <rppt@kernel.org>,
        <lorenzo.pieralisi@arm.com>, <guohanjun@huawei.com>,
        <sudeep.holla@arm.com>, <rjw@rjwysocki.net>, <lenb@kernel.org>,
        <song.bao.hua@hisilicon.com>, <ardb@kernel.org>,
        <anshuman.khandual@arm.com>, <bhelgaas@google.com>, <guro@fb.com>,
        <robh+dt@kernel.org>
CC:     <stable@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <frowand.list@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-riscv@lists.infradead.org>, <jingxiangfeng@huawei.com>,
        <wangkefeng.wang@huawei.com>, Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH stable v5.10 1/7] arm64: mm: Move reserve_crashkernel() into mem_init()
Date:   Wed, 3 Mar 2021 15:33:13 +0800
Message-ID: <20210303073319.2215839-2-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
References: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

commit 0a30c53573b07d5561457e41fb0ab046cd857da5 upstream

crashkernel might reserve memory located in ZONE_DMA. We plan to delay
ZONE_DMA's initialization after unflattening the devicetree and ACPI's
boot table initialization, so move it later in the boot process.
Specifically into bootmem_init() since request_standard_resources()
depends on it.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Link: https://lore.kernel.org/r/20201119175400.9995-2-nsaenzjulienne@suse.de
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 arch/arm64/mm/init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 00576a960f11..686653e33250 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -386,8 +386,6 @@ void __init arm64_memblock_init(void)
 	else
 		arm64_dma32_phys_limit = PHYS_MASK + 1;
 
-	reserve_crashkernel();
-
 	reserve_elfcorehdr();
 
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
@@ -427,6 +425,12 @@ void __init bootmem_init(void)
 	sparse_init();
 	zone_sizes_init(min, max);
 
+	/*
+	 * request_standard_resources() depends on crashkernel's memory being
+	 * reserved, so do it here.
+	 */
+	reserve_crashkernel();
+
 	memblock_dump_all();
 }
 
-- 
2.25.1

