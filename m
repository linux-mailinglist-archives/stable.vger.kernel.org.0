Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB78351A522
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343927AbiEDQTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353255AbiEDQSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:18:52 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7772CF1A;
        Wed,  4 May 2022 09:15:16 -0700 (PDT)
Date:   Wed, 04 May 2022 16:15:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651680914;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qSkxNoLoTWt5gxztnJFu/bozk0kevl2CiKD8B3IjPtA=;
        b=gGmPTEAtzAu9bws8mpM9ve2mZf13HiO92k0cTzjN62/Ddv0pnq8iKCcRlKjWxS2XcqM9PG
        XhIaLHNB2WkjQhPAspmD+26TKZ13x4B5bMHXbNl1VC7rpYGe69SYPSbiS+sxa3KC1TZqHY
        ACf9qbJBo09+Y91jxrbZtGsNL/engbaDiYGaJjz2/aA5dCPmGMSMaHzacQPLI4ab4TFtVE
        KhI1ahGoVkgcttkYEy2X+17bQvXjwNM6mQlT17LT1tX1v1rdBSqeoiQ+t5EvX3eDUpnGvH
        wFjVH/53HrkIICM1/FpGNjkCM3QnUm4fFKfmsNc4YRE+DZp4qRPnQQfmtUMPbw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651680914;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qSkxNoLoTWt5gxztnJFu/bozk0kevl2CiKD8B3IjPtA=;
        b=GKvGmYLr8XYCbl6ZlD7qs2M+BNAEyMqdQVE5AAEtlLxzwNGYiJHhLAI69k7bHfMCzi6HTW
        thZWPzs37GTbl6Cw==
From:   "irqchip-bot for Max Filippov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/xtensa-mx: Fix initial IRQ
 affinity in non-SMP setup
Cc:     stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20220426161912.1113784-1-jcmvbkbc@gmail.com>
References: <20220426161912.1113784-1-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Message-ID: <165168091368.4207.10786680163387255992.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     168f633b1722597673e5aa5a6c7721191a9d221f
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/168f633b1722597673e5aa5a6c7721191a9d221f
Author:        Max Filippov <jcmvbkbc@gmail.com>
AuthorDate:    Tue, 26 Apr 2022 09:19:12 -07:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Wed, 04 May 2022 16:35:38 +01:00

irqchip/xtensa-mx: Fix initial IRQ affinity in non-SMP setup

When irq-xtensa-mx chip is used in non-SMP configuration its
irq_set_affinity callback is not called leaving IRQ affinity set empty.
As a result IRQ delivery does not work in that configuration.
Initialize IRQ affinity of the xtensa MX interrupt distributor to CPU 0
for all external IRQ lines.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220426161912.1113784-1-jcmvbkbc@gmail.com
---
 drivers/irqchip/irq-xtensa-mx.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-xtensa-mx.c b/drivers/irqchip/irq-xtensa-mx.c
index 2793333..8c581c9 100644
--- a/drivers/irqchip/irq-xtensa-mx.c
+++ b/drivers/irqchip/irq-xtensa-mx.c
@@ -151,14 +151,25 @@ static struct irq_chip xtensa_mx_irq_chip = {
 	.irq_set_affinity = xtensa_mx_irq_set_affinity,
 };
 
+static void __init xtensa_mx_init_common(struct irq_domain *root_domain)
+{
+	unsigned int i;
+
+	irq_set_default_host(root_domain);
+	secondary_init_irq();
+
+	/* Initialize default IRQ routing to CPU 0 */
+	for (i = 0; i < XCHAL_NUM_EXTINTERRUPTS; ++i)
+		set_er(1, MIROUT(i));
+}
+
 int __init xtensa_mx_init_legacy(struct device_node *interrupt_parent)
 {
 	struct irq_domain *root_domain =
 		irq_domain_add_legacy(NULL, NR_IRQS - 1, 1, 0,
 				&xtensa_mx_irq_domain_ops,
 				&xtensa_mx_irq_chip);
-	irq_set_default_host(root_domain);
-	secondary_init_irq();
+	xtensa_mx_init_common(root_domain);
 	return 0;
 }
 
@@ -168,8 +179,7 @@ static int __init xtensa_mx_init(struct device_node *np,
 	struct irq_domain *root_domain =
 		irq_domain_add_linear(np, NR_IRQS, &xtensa_mx_irq_domain_ops,
 				&xtensa_mx_irq_chip);
-	irq_set_default_host(root_domain);
-	secondary_init_irq();
+	xtensa_mx_init_common(root_domain);
 	return 0;
 }
 IRQCHIP_DECLARE(xtensa_mx_irq_chip, "cdns,xtensa-mx", xtensa_mx_init);
