Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421696950E1
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 20:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjBMTlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 14:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbjBMTlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 14:41:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A447F20D13;
        Mon, 13 Feb 2023 11:40:49 -0800 (PST)
Date:   Mon, 13 Feb 2023 19:40:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676317248;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I0P3cKwwzq7UwdBcPOvJrRfC3Q6kvdGRMBw77mYRrlM=;
        b=Zcu/xBhUaRgtXBgkuz3N8RlBdS/PtSh2EVrZgp9VhK6Tavk2+IejcXLa1xqyIIWvefZf2l
        rcuQCi2ZZgFyNLH28+R3cvcIuJQ8S7cMfGRBqVTLLfiePO8ov+dXED4/jecWK1xX5HNBIR
        kXsusjl7JBFa+meoB5/hfqDk9NgFzFw8LSZJVwCp2drGSgI08JnW+yejRzdExufYhZSf6d
        0GkFLMDyQqxvGf2gX6tpo7hj0/LOgrWvENAHl4sHb7qax9KxSxuvT8MZIHiJubdJIsQO8o
        pZ/a4UQR8JsJdOA8bjSFQqv3+uDMIhSya2H/5oENNJukS+wUHWRBmEbNEfDsoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676317248;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I0P3cKwwzq7UwdBcPOvJrRfC3Q6kvdGRMBw77mYRrlM=;
        b=go1a7xAo4YDy0kf7182Zd00x33e7zBm0lqpilNbs+b5kwHC5LxcIJ2nUAstHnKa5sI63TN
        rI8nB0BRJ4ofF5DQ==
From:   "irqchip-bot for Johan Hovold" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqdomain: Fix disassociation race
Cc:     stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        4.13@tip-bot2.tec.linutronix.de,
        "Hsin-Yi Wang" <hsinyi@chromium.org>,
        "Mark-PK Tsai" <mark-pk.tsai@mediatek.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20230213104302.17307-3-johan+linaro@kernel.org>
References: <20230213104302.17307-3-johan+linaro@kernel.org>
MIME-Version: 1.0
Message-ID: <167631724735.4906.17602457971577144696.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     3f883c38f5628f46b30bccf090faec054088e262
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/3f883c38f5628f46b30bccf090faec054088e262
Author:        Johan Hovold <johan+linaro@kernel.org>
AuthorDate:    Mon, 13 Feb 2023 11:42:44 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Mon, 13 Feb 2023 19:31:24 

irqdomain: Fix disassociation race

The global irq_domain_mutex is held when mapping interrupts from
non-hierarchical domains but currently not when disposing them.

This specifically means that updates of the domain mapcount is racy
(currently only used for statistics in debugfs).

Make sure to hold the global irq_domain_mutex also when disposing
mappings from non-hierarchical domains.

Fixes: 9dc6be3d4193 ("genirq/irqdomain: Add map counter")
Cc: stable@vger.kernel.org      # 4.13
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-3-johan+linaro@kernel.org
---
 kernel/irq/irqdomain.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 6661de1..f77549a 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -538,6 +538,9 @@ static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 		return;
 
 	hwirq = irq_data->hwirq;
+
+	mutex_lock(&irq_domain_mutex);
+
 	irq_set_status_flags(irq, IRQ_NOREQUEST);
 
 	/* remove chip and handler */
@@ -557,6 +560,8 @@ static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 
 	/* Clear reverse map for this hwirq */
 	irq_domain_clear_mapping(domain, hwirq);
+
+	mutex_unlock(&irq_domain_mutex);
 }
 
 static int irq_domain_associate_locked(struct irq_domain *domain, unsigned int virq,
