Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01ED147AD7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbgAXJil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:38:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731330AbgAXJik (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:38:40 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7F120838;
        Fri, 24 Jan 2020 09:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858720;
        bh=tdHS2uyHNpJxd74kC4TWYCvxQJtk1uXsCPH6CaJF740=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEA8IUN6phQZe+0L75MNglLpEZpj+bTN0yXt2IwrzTOHwuDZfwNNpj/NKEJng7YZ7
         YPZCCGnYpQu3fFo/+MBTIsk47JYJsROj9p/Y6wIAlx1KdKLhAqPLbc5onN3+glu4mm
         H94RX7w5w00PSEZ5dY47+I7dZizcssM8Clw8sOVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 041/102] soc/tegra: pmc: Fix crashes for hierarchical interrupts
Date:   Fri, 24 Jan 2020 10:30:42 +0100
Message-Id: <20200124092812.484915575@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit c9e753767a9c75d2044fb7343950a6a992d34a16 upstream.

Interrupts that don't have an associated wake event or GPIO wake events
end up with an associate IRQ chip that is NULL and which causes IRQ code
to crash. This is because we don't implicitly set the parent IRQ chip by
allocating the interrupt at the parent. However, there really isn't a
corresponding interrupt at the parent, so we need to work around this by
setting the special no_irq_chip as the IRQ chip for these interrupts.

Fixes: 19906e6b1667 ("soc/tegra: pmc: Add wake event support")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/tegra/pmc.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -1899,6 +1899,20 @@ static int tegra_pmc_irq_alloc(struct ir
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
@@ -1908,10 +1922,22 @@ static int tegra_pmc_irq_alloc(struct ir
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
 


