Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C759413E084
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgAPQn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:43:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgAPQnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:43:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47F3221D56;
        Thu, 16 Jan 2020 16:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193035;
        bh=XGdk5WT+R06Kr+1Mhh/012oks8FY/Y1ued3z88w1Llw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aetdFYkie744r+ccxWQ00/E8k+ouMZ40We2HvkTmT9EC1dHXjy+vaFwAQo1WgwSd1
         iMCPrftx/7RKnpdEy2u+RO2SrDhdzkMp5nc4ToYp6wLZq3aCWYPfLpLxcwm1eQRXnr
         XzpR17j/2D8Kvo/6SvNL2+S5BO/hf0X3xfVT1YkE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 011/205] soc/tegra: pmc: Fix crashes for hierarchical interrupts
Date:   Thu, 16 Jan 2020 11:39:46 -0500
Message-Id: <20200116164300.6705-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit c9e753767a9c75d2044fb7343950a6a992d34a16 ]

Interrupts that don't have an associated wake event or GPIO wake events
end up with an associate IRQ chip that is NULL and which causes IRQ code
to crash. This is because we don't implicitly set the parent IRQ chip by
allocating the interrupt at the parent. However, there really isn't a
corresponding interrupt at the parent, so we need to work around this by
setting the special no_irq_chip as the IRQ chip for these interrupts.

Fixes: 19906e6b1667 ("soc/tegra: pmc: Add wake event support")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index 9f9c1c677cf4..0447afa970f5 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -1899,6 +1899,20 @@ static int tegra_pmc_irq_alloc(struct irq_domain *domain, unsigned int virq,
 							    event->id,
 							    &pmc->irq, pmc);
 
+			/*
+			 * GPIOs don't have an equivalent interrupt in the
+			 * parent controller (GIC). However some code, such
+			 * as the one in irq_get_irqchip_state(), require a
+			 * valid IRQ chip to be set. Make sure that's the
+			 * case by passing NULL here, which will install a
+			 * dummy IRQ chip for the interrupt in the parent
+			 * domain.
+			 */
+			if (domain->parent)
+				irq_domain_set_hwirq_and_chip(domain->parent,
+							      virq, 0, NULL,
+							      NULL);
+
 			break;
 		}
 	}
@@ -1908,10 +1922,22 @@ static int tegra_pmc_irq_alloc(struct irq_domain *domain, unsigned int virq,
 	 * dummy hardware IRQ number. This is used in the ->irq_set_type()
 	 * and ->irq_set_wake() callbacks to return early for these IRQs.
 	 */
-	if (i == soc->num_wake_events)
+	if (i == soc->num_wake_events) {
 		err = irq_domain_set_hwirq_and_chip(domain, virq, ULONG_MAX,
 						    &pmc->irq, pmc);
 
+		/*
+		 * Interrupts without a wake event don't have a corresponding
+		 * interrupt in the parent controller (GIC). Pass NULL for the
+		 * chip here, which causes a dummy IRQ chip to be installed
+		 * for the interrupt in the parent domain, to make this
+		 * explicit.
+		 */
+		if (domain->parent)
+			irq_domain_set_hwirq_and_chip(domain->parent, virq, 0,
+						      NULL, NULL);
+	}
+
 	return err;
 }
 
-- 
2.20.1

