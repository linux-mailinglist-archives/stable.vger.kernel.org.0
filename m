Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFBD6C54C
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389169AbfGRDEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389055AbfGRDEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:04:42 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CB542173B;
        Thu, 18 Jul 2019 03:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419081;
        bh=8qK39oZ1HwAVbPc5r9k4uxw2bpeMX8lNuXgpCkS2DGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAOTPFwBtQs1GuKHQeYLWFgEy4gwKvEZ6zi/IsfqYWL0myRyvsbUS/frRjAhazpjB
         v1Ij6hJIodppclji91xJjQLP0h0z8Hp2af3epiT/IYGPJdMczkUzi7sBf1/KXO82dL
         8HBFG8LTtt7mkgvOZCpUHZlXLI1Tvxfu1fQtKXKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <ren_guo@c-sky.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 09/54] irqchip/irq-csky-mpintc: Support auto irq deliver to all cpus
Date:   Thu, 18 Jul 2019 12:01:04 +0900
Message-Id: <20190718030054.082427622@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



