Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4994247732
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404395AbgHQTq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729346AbgHQPVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:21:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D264B206FA;
        Mon, 17 Aug 2020 15:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677681;
        bh=LeIfYr0l/Y0cKUOJyG6VPSw7hUwxWj1TrqOpoXJKVKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNRMD+cF23yGI1qDSyYYUenlqpUCWSbhhHZ7oaKBFdf8RUzdgkXscdLfIydVr522c
         jkTnp8OIPzeF8idvl5Z7wGM8TYweT0b/08PebkoigTK7U61viO9wCpiG/7+0+5pIeE
         2/casE3xZZb38RCjCusPVRseBsDg3zHCgzucdPO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 070/464] irqchip/gic-v4.1: Use GFP_ATOMIC flag in allocate_vpe_l1_table()
Date:   Mon, 17 Aug 2020 17:10:23 +0200
Message-Id: <20200817143837.120735004@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



