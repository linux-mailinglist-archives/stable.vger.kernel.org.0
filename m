Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578F92E4062
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502051AbgL1OS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502038AbgL1OS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58492208B6;
        Mon, 28 Dec 2020 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165122;
        bh=pcjUrjtlDVxadrX/fxFj28t2bvrOiK0FHXp453RgHfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uucUnCbC0DKA/R2xxhtEE6ri1FaKdJ7GYW5BPWByPHl+0CIex2wet20e6gzP0JbQ4
         fE1VEI+oQ/Fog3AqI/mzglgV/mRvxfmWPZsjDCCKrPB4cC1rg0yc/jJa9rMLj1pQd0
         a0bkmq6dG685Jt8lh89g0IBa9a+jOpKrj2lcO12c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 420/717] irqchip/ti-sci-intr: Fix freeing of irqs
Date:   Mon, 28 Dec 2020 13:46:58 +0100
Message-Id: <20201228125041.082636388@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lokesh Vutla <lokeshvutla@ti.com>

[ Upstream commit fc6c7cd3878641fd43189f15697e7ad0871f5c1a ]

ti_sci_intr_irq_domain_free() assumes that out_irq of intr is stored in
data->chip_data and uses it for calling ti_sci irq_free() and then
mark the out_irq as available resource. But ti_sci_intr_irq_domain_alloc()
is storing p_hwirq(parent's hardware irq) which is translated from out_irq.
This is causing resource leakage and eventually out_irq resources might
be exhausted. Fix ti_sci_intr_irq_domain_alloc() by storing the out_irq
in data->chip_data.

Fixes: a5b659bd4bc7 ("irqchip/ti-sci-intr: Add support for INTR being a parent to INTR")
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201102120631.11165-1-lokeshvutla@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ti-sci-intr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-ti-sci-intr.c b/drivers/irqchip/irq-ti-sci-intr.c
index ac9d6d658e65c..fe8fad22bcf96 100644
--- a/drivers/irqchip/irq-ti-sci-intr.c
+++ b/drivers/irqchip/irq-ti-sci-intr.c
@@ -129,7 +129,7 @@ static void ti_sci_intr_irq_domain_free(struct irq_domain *domain,
  * @virq:	Corresponding Linux virtual IRQ number
  * @hwirq:	Corresponding hwirq for the IRQ within this IRQ domain
  *
- * Returns parent irq if all went well else appropriate error pointer.
+ * Returns intr output irq if all went well else appropriate error pointer.
  */
 static int ti_sci_intr_alloc_parent_irq(struct irq_domain *domain,
 					unsigned int virq, u32 hwirq)
@@ -173,7 +173,7 @@ static int ti_sci_intr_alloc_parent_irq(struct irq_domain *domain,
 	if (err)
 		goto err_msg;
 
-	return p_hwirq;
+	return out_irq;
 
 err_msg:
 	irq_domain_free_irqs_parent(domain, virq, 1);
@@ -198,19 +198,19 @@ static int ti_sci_intr_irq_domain_alloc(struct irq_domain *domain,
 	struct irq_fwspec *fwspec = data;
 	unsigned long hwirq;
 	unsigned int flags;
-	int err, p_hwirq;
+	int err, out_irq;
 
 	err = ti_sci_intr_irq_domain_translate(domain, fwspec, &hwirq, &flags);
 	if (err)
 		return err;
 
-	p_hwirq = ti_sci_intr_alloc_parent_irq(domain, virq, hwirq);
-	if (p_hwirq < 0)
-		return p_hwirq;
+	out_irq = ti_sci_intr_alloc_parent_irq(domain, virq, hwirq);
+	if (out_irq < 0)
+		return out_irq;
 
 	irq_domain_set_hwirq_and_chip(domain, virq, hwirq,
 				      &ti_sci_intr_irq_chip,
-				      (void *)(uintptr_t)p_hwirq);
+				      (void *)(uintptr_t)out_irq);
 
 	return 0;
 }
-- 
2.27.0



