Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B925DB6A
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfGCCPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbfGCCPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:15:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFEC42187F;
        Wed,  3 Jul 2019 02:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120119;
        bh=C8xCHjx7Onv/nUMr7qUYITBwriv4d3kV0pgWH2yt3bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ssn5qfAALwS9po+K+CJRz6O1yz7fkqdu9oulOMY8pdzNO88blAcSJv1JFtJGauK2n
         INRbA62Fe/kUFznpIE7/08OfEPcks32NxZIwzNcUW4Yui2e61lkDGFO8I3C1hVt3EM
         LR3gfogymcGB0/AWgSrD1MKx9l/k4vGYhaO3I4dM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Ren <ren_guo@c-sky.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 04/39] irqchip/irq-csky-mpintc: Support auto irq deliver to all cpus
Date:   Tue,  2 Jul 2019 22:14:39 -0400
Message-Id: <20190703021514.17727-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021514.17727-1-sashal@kernel.org>
References: <20190703021514.17727-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <ren_guo@c-sky.com>

[ Upstream commit db56c5128e6625cb16efc4910b60627e46f608e3 ]

The csky,mpintc could deliver a external irq to one cpu or all cpus, but
it couldn't deliver a external irq to a group of cpus with cpu_mask. So
we only use auto deliver mode when affinity mask_val is equal to
cpu_present_mask.

There is no limitation for only two cpus in SMP system.

Signed-off-by: Guo Ren <ren_guo@c-sky.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-csky-mpintc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-csky-mpintc.c b/drivers/irqchip/irq-csky-mpintc.c
index c67c961ab6cc..a4c1aacba1ff 100644
--- a/drivers/irqchip/irq-csky-mpintc.c
+++ b/drivers/irqchip/irq-csky-mpintc.c
@@ -89,8 +89,19 @@ static int csky_irq_set_affinity(struct irq_data *d,
 	if (cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-	/* Enable interrupt destination */
-	cpu |= BIT(31);
+	/*
+	 * The csky,mpintc could support auto irq deliver, but it only
+	 * could deliver external irq to one cpu or all cpus. So it
+	 * doesn't support deliver external irq to a group of cpus
+	 * with cpu_mask.
+	 * SO we only use auto deliver mode when affinity mask_val is
+	 * equal to cpu_present_mask.
+	 *
+	 */
+	if (cpumask_equal(mask_val, cpu_present_mask))
+		cpu = 0;
+	else
+		cpu |= BIT(31);
 
 	writel_relaxed(cpu, INTCG_base + INTCG_CIDSTR + offset);
 
-- 
2.20.1

