Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2389523F9B2
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgHHXhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbgHHXhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00A5920723;
        Sat,  8 Aug 2020 23:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929835;
        bh=LeIfYr0l/Y0cKUOJyG6VPSw7hUwxWj1TrqOpoXJKVKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z48B1ejWDUcCsxtCd0dMohzfZds6F1GNGZqW/x/0CX2ycCoNso/vK13hk0YhRVhRu
         ba11/BilW9xk6BHr6S//+enCng/9oXY4ZsA5CZ/YCDVdp1RElAD73W/7j1vuh/BEy9
         pZB3+VbYCXJzAArYPh3eZEC/ysoVNNNjWLTOqWdE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 66/72] irqchip/gic-v4.1: Use GFP_ATOMIC flag in allocate_vpe_l1_table()
Date:   Sat,  8 Aug 2020 19:35:35 -0400
Message-Id: <20200808233542.3617339-66-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit d1bd7e0ba533a2a6f313579ec9b504f6614c35c4 ]

Booting the latest kernel with DEBUG_ATOMIC_SLEEP=y on a GICv4.1 enabled
box, I get the following kernel splat:

[    0.053766] BUG: sleeping function called from invalid context at mm/slab.h:567
[    0.053767] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: swapper/1
[    0.053769] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.8.0-rc3+ #23
[    0.053770] Call trace:
[    0.053774]  dump_backtrace+0x0/0x218
[    0.053775]  show_stack+0x2c/0x38
[    0.053777]  dump_stack+0xc4/0x10c
[    0.053779]  ___might_sleep+0xfc/0x140
[    0.053780]  __might_sleep+0x58/0x90
[    0.053782]  slab_pre_alloc_hook+0x7c/0x90
[    0.053783]  kmem_cache_alloc_trace+0x60/0x2f0
[    0.053785]  its_cpu_init+0x6f4/0xe40
[    0.053786]  gic_starting_cpu+0x24/0x38
[    0.053788]  cpuhp_invoke_callback+0xa0/0x710
[    0.053789]  notify_cpu_starting+0xcc/0xd8
[    0.053790]  secondary_start_kernel+0x148/0x200

 # ./scripts/faddr2line vmlinux its_cpu_init+0x6f4/0xe40
its_cpu_init+0x6f4/0xe40:
allocate_vpe_l1_table at drivers/irqchip/irq-gic-v3-its.c:2818
(inlined by) its_cpu_init_lpis at drivers/irqchip/irq-gic-v3-its.c:3138
(inlined by) its_cpu_init at drivers/irqchip/irq-gic-v3-its.c:5166

It turned out that we're allocating memory using GFP_KERNEL (may sleep)
within the CPU hotplug notifier, which is indeed an atomic context. Bad
thing may happen if we're playing on a system with more than a single
CommonLPIAff group. Avoid it by turning this into an atomic allocation.

Fixes: 5e5168461c22 ("irqchip/gic-v4.1: VPE table (aka GICR_VPROPBASER) allocation")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200630133746.816-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index beac4caefad9a..da44bfa48bc25 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2814,7 +2814,7 @@ static int allocate_vpe_l1_table(void)
 	if (val & GICR_VPROPBASER_4_1_VALID)
 		goto out;
 
-	gic_data_rdist()->vpe_table_mask = kzalloc(sizeof(cpumask_t), GFP_KERNEL);
+	gic_data_rdist()->vpe_table_mask = kzalloc(sizeof(cpumask_t), GFP_ATOMIC);
 	if (!gic_data_rdist()->vpe_table_mask)
 		return -ENOMEM;
 
@@ -2881,7 +2881,7 @@ static int allocate_vpe_l1_table(void)
 
 	pr_debug("np = %d, npg = %lld, psz = %d, epp = %d, esz = %d\n",
 		 np, npg, psz, epp, esz);
-	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(np * PAGE_SIZE));
+	page = alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_SIZE));
 	if (!page)
 		return -ENOMEM;
 
-- 
2.25.1

