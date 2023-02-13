Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7066950D7
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 20:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjBMTlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 14:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjBMTkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 14:40:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410DC1C58E;
        Mon, 13 Feb 2023 11:40:47 -0800 (PST)
Date:   Mon, 13 Feb 2023 19:40:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676317245;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0eU16cNXLCB0S/zq75mzpT0l8o8RkhqELnIFBo4lwLE=;
        b=2pqbgX+ihuVlT8aCUFwfBVpk3pE3E1SblatXMefXDoYNdqprjV81oB+OgFws5iW2ZeflmX
        Ga2zQzmWKeqPtoIvcqsahgHglBWcq/TFWVRrFzk6nGq0I5Yc01QdpN62M2QjjHo5sVE2Hw
        MJsq0CnRpPwsUKr1+ps2aVYtcvY/bbMFy09HqjeXbhUfepMw85cZG0ZmaeZdO5WF2NJ2vj
        AeyjXBFvgXDgV6nDxRXWiX6WQo+BwX5i2TKNoiRQV2QSdqNismByYE8ZvrxtwZ1jt7Aw9T
        LE2FKMQuQFjkX56Fs6khkfB1hACvB0EN5OVueCGAkfbOtplo7f3lHvaUIhxgsA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676317245;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0eU16cNXLCB0S/zq75mzpT0l8o8RkhqELnIFBo4lwLE=;
        b=Cc381L4V6ogHmAR2NqDiPdXxJcz5ORkYHI8+E6bXFVk+e+LaJsu2Uba8uO+fxSRcdF51Hc
        pUzjYMpY3p+yJxCA==
From:   "irqchip-bot for Marc Zyngier" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqdomain: Fix domain registration race
Cc:     stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        3.19@tip-bot2.tec.linutronix.de, Marc Zyngier <maz@kernel.org>,
        Johan Hovold <johan+linaro@kernel.org>, tglx@linutronix.de
In-Reply-To: <20230213104302.17307-8-johan+linaro@kernel.org>
References: <20230213104302.17307-8-johan+linaro@kernel.org>
MIME-Version: 1.0
Message-ID: <167631724540.4906.12618896508868061064.tip-bot2@tip-bot2>
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

Commit-ID:     8932c32c3053accd50702b36e944ac2016cd103c
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/8932c32c3053accd50702b36e944ac2016cd103c
Author:        Marc Zyngier <maz@kernel.org>
AuthorDate:    Mon, 13 Feb 2023 11:42:49 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Mon, 13 Feb 2023 19:31:24 

irqdomain: Fix domain registration race

Hierarchical domains created using irq_domain_create_hierarchy() are
currently added to the domain list before having been fully initialised.

This specifically means that a racing allocation request might fail to
allocate irq data for the inner domains of a hierarchy in case the
parent domain pointer has not yet been set up.

Note that this is not really any issue for irqchip drivers that are
registered early (e.g. via IRQCHIP_DECLARE() or IRQCHIP_ACPI_DECLARE())
but could potentially cause trouble with drivers that are registered
later (e.g. modular drivers using IRQCHIP_PLATFORM_DRIVER_BEGIN(),
gpiochip drivers, etc.).

Fixes: afb7da83b9f4 ("irqdomain: Introduce helper function irq_domain_add_hierarchy()")
Cc: stable@vger.kernel.org      # 3.19
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ johan: add commit message ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-8-johan+linaro@kernel.org
---
 kernel/irq/irqdomain.c | 62 ++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index df0cbad..a6d1b10 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -126,23 +126,12 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(irq_domain_free_fwnode);
 
-/**
- * __irq_domain_add() - Allocate a new irq_domain data structure
- * @fwnode: firmware node for the interrupt controller
- * @size: Size of linear map; 0 for radix mapping only
- * @hwirq_max: Maximum number of interrupts supported by controller
- * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
- *              direct mapping
- * @ops: domain callbacks
- * @host_data: Controller private data pointer
- *
- * Allocates and initializes an irq_domain structure.
- * Returns pointer to IRQ domain, or NULL on failure.
- */
-struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
-				    irq_hw_number_t hwirq_max, int direct_max,
-				    const struct irq_domain_ops *ops,
-				    void *host_data)
+static struct irq_domain *__irq_domain_create(struct fwnode_handle *fwnode,
+					      unsigned int size,
+					      irq_hw_number_t hwirq_max,
+					      int direct_max,
+					      const struct irq_domain_ops *ops,
+					      void *host_data)
 {
 	struct irqchip_fwid *fwid;
 	struct irq_domain *domain;
@@ -230,12 +219,44 @@ struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int s
 
 	irq_domain_check_hierarchy(domain);
 
+	return domain;
+}
+
+static void __irq_domain_publish(struct irq_domain *domain)
+{
 	mutex_lock(&irq_domain_mutex);
 	debugfs_add_domain_dir(domain);
 	list_add(&domain->link, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
 
 	pr_debug("Added domain %s\n", domain->name);
+}
+
+/**
+ * __irq_domain_add() - Allocate a new irq_domain data structure
+ * @fwnode: firmware node for the interrupt controller
+ * @size: Size of linear map; 0 for radix mapping only
+ * @hwirq_max: Maximum number of interrupts supported by controller
+ * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
+ *              direct mapping
+ * @ops: domain callbacks
+ * @host_data: Controller private data pointer
+ *
+ * Allocates and initializes an irq_domain structure.
+ * Returns pointer to IRQ domain, or NULL on failure.
+ */
+struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
+				    irq_hw_number_t hwirq_max, int direct_max,
+				    const struct irq_domain_ops *ops,
+				    void *host_data)
+{
+	struct irq_domain *domain;
+
+	domain = __irq_domain_create(fwnode, size, hwirq_max, direct_max,
+				     ops, host_data);
+	if (domain)
+		__irq_domain_publish(domain);
+
 	return domain;
 }
 EXPORT_SYMBOL_GPL(__irq_domain_add);
@@ -1138,12 +1159,15 @@ struct irq_domain *irq_domain_create_hierarchy(struct irq_domain *parent,
 	struct irq_domain *domain;
 
 	if (size)
-		domain = irq_domain_create_linear(fwnode, size, ops, host_data);
+		domain = __irq_domain_create(fwnode, size, size, 0, ops, host_data);
 	else
-		domain = irq_domain_create_tree(fwnode, ops, host_data);
+		domain = __irq_domain_create(fwnode, 0, ~0, 0, ops, host_data);
+
 	if (domain) {
 		domain->parent = parent;
 		domain->flags |= flags;
+
+		__irq_domain_publish(domain);
 	}
 
 	return domain;
