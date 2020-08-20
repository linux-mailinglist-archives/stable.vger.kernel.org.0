Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BD224B2CD
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgHTJhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgHTJhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:37:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9CB92173E;
        Thu, 20 Aug 2020 09:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916226;
        bh=48wIedm+vXTcv1jx/nKkpxIEJmP65C2seVmGkC8H3eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEOohxqKMZtq6o+A52RjP5RdcDDUdwWb0XMu1Anxk2X0KGfVqN4L5GDvFLtH5B9k2
         Sj8iWL8k05HlHzMt61gJ5hUGx4tpxdtuRFAHOnooAGGIP7+qW+TZWj8JS1FpK/lrN4
         Uhnb3ceohrjBnI/kViZBhGRhGalkHMxJvLuC+Dfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.7 054/204] irqchip/gic-v4.1: Ensure accessing the correct RD when writing INVALLR
Date:   Thu, 20 Aug 2020 11:19:11 +0200
Message-Id: <20200820091608.968078042@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

commit 3af9571cd585efafc2facbd8dbd407317ff898cf upstream.

The GICv4.1 spec tells us that it's CONSTRAINED UNPREDICTABLE to issue a
register-based invalidation operation for a vPEID not mapped to that RD,
or another RD within the same CommonLPIAff group.

To follow this rule, commit f3a059219bc7 ("irqchip/gic-v4.1: Ensure mutual
exclusion between vPE affinity change and RD access") tried to address the
race between the RD accesses and the vPE affinity change, but somehow
forgot to take GICR_INVALLR into account. Let's take the vpe_lock before
evaluating vpe->col_idx to fix it.

Fixes: f3a059219bc7 ("irqchip/gic-v4.1: Ensure mutual exclusion between vPE affinity change and RD access")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200720092328.708-1-yuzenghui@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-gic-v3-its.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3974,18 +3974,22 @@ static void its_vpe_4_1_deschedule(struc
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


