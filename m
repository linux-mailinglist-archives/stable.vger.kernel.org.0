Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD04E225B67
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 11:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgGTJXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 05:23:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50256 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727961AbgGTJXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 05:23:52 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0EF2B8CE758EB4A7A53B;
        Mon, 20 Jul 2020 17:23:51 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.226) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Jul 2020 17:23:44 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <maz@kernel.org>
CC:     <tglx@linutronix.de>, <jason@lakedaemon.net>,
        <wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] irqchip/gic-v4.1: Ensure accessing the correct RD when writing INVALLR
Date:   Mon, 20 Jul 2020 17:23:28 +0800
Message-ID: <20200720092328.708-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The GICv4.1 spec tells us that it's CONSTRAINED UNPREDICTABLE to issue a
register-based invalidation operation for a vPEID not mapped to that RD,
or another RD within the same CommonLPIAff group.

To follow this rule, commit f3a059219bc7 ("irqchip/gic-v4.1: Ensure mutual
exclusion between vPE affinity change and RD access") tried to address the
race between the RD accesses and the vPE affinity change, but somehow
forgot to take GICR_INVALLR into account. Let's take the vpe_lock before
evaluating vpe->col_idx to fix it.

Fixes: f3a059219bc7 ("irqchip/gic-v4.1: Ensure mutual exclusion between vPE affinity change and RD access")
Cc: stable@vger.kernel.org
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
* From v1:
  - Add a proper Fixes: tag
  - Cc stable

 drivers/irqchip/irq-gic-v3-its.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index beac4caefad9..5bf2263bdbcc 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4087,18 +4087,22 @@ static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
 static void its_vpe_4_1_invall(struct its_vpe *vpe)
 {
 	void __iomem *rdbase;
+	unsigned long flags;
 	u64 val;
+	int cpu;
 
 	val  = GICR_INVALLR_V;
 	val |= FIELD_PREP(GICR_INVALLR_VPEID, vpe->vpe_id);
 
 	/* Target the redistributor this vPE is currently known on */
-	raw_spin_lock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
-	rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
+	cpu = vpe_to_cpuid_lock(vpe, &flags);
+	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
+	rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
 	gic_write_lpir(val, rdbase + GICR_INVALLR);
 
 	wait_for_syncr(rdbase);
-	raw_spin_unlock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
+	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
+	vpe_to_cpuid_unlock(vpe, flags);
 }
 
 static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
-- 
2.19.1

