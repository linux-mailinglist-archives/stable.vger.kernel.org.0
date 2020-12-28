Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0AB2E63A9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404919AbgL1NrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404959AbgL1Np4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:45:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7559C20715;
        Mon, 28 Dec 2020 13:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163140;
        bh=ZWJcQ3sXqPbn10ObetNaW/z+bXwaDEj2/+qPZfPaOnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0D9V1NrF9EoUpiqFmxpvbHobD21SCY0uTi4cUpxWhYrgJEQig8FmhoLEVnM7E0ur
         OADvRqaGv7Q9dJgdh6xV4v4wVh1HcKAj7ZbXOJgZ5csVpcwXs4sIwEP54uzmjRaqZf
         x27dIjZRgdTe39JZ8d4BGOMG2qEL/Sd9maQZagZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/453] genirq/irqdomain: Dont try to free an interrupt that has no mapping
Date:   Mon, 28 Dec 2020 13:47:01 +0100
Message-Id: <20201228124946.112130006@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 4615fbc3788ddc8e7c6d697714ad35a53729aa2c ]

When an interrupt allocation fails for N interrupts, it is pretty
common for the error handling code to free the same number of interrupts,
no matter how many interrupts have actually been allocated.

This may result in the domain freeing code to be unexpectedly called
for interrupts that have no mapping in that domain. Things end pretty
badly.

Instead, add some checks to irq_domain_free_irqs_hierarchy() to make sure
that thiss does not follow the hierarchy if no mapping exists for a given
interrupt.

Fixes: 6a6544e520abe ("genirq/irqdomain: Remove auto-recursive hierarchy support")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20201129135551.396777-1-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 5a60de39457c7..5e03cbee70d67 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1288,8 +1288,15 @@ static void irq_domain_free_irqs_hierarchy(struct irq_domain *domain,
 					   unsigned int irq_base,
 					   unsigned int nr_irqs)
 {
-	if (domain->ops->free)
-		domain->ops->free(domain, irq_base, nr_irqs);
+	unsigned int i;
+
+	if (!domain->ops->free)
+		return;
+
+	for (i = 0; i < nr_irqs; i++) {
+		if (irq_domain_get_irq_data(domain, irq_base + i))
+			domain->ops->free(domain, irq_base + i, 1);
+	}
 }
 
 int irq_domain_alloc_irqs_hierarchy(struct irq_domain *domain,
-- 
2.27.0



