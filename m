Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5213569431C
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 11:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjBMKnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 05:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjBMKnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 05:43:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348DA16339;
        Mon, 13 Feb 2023 02:43:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C12FA60F92;
        Mon, 13 Feb 2023 10:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794D5C4339E;
        Mon, 13 Feb 2023 10:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676284996;
        bh=GfltTDdqGuUYaFLLjciBdbiewtzinXVmbE1XdpKL8Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/NE5iKGT0M84Lw+kKdUl6P0kuso1oWdyDQ2YTyvP2puYDOWSZ1hPdNZXseMhJiCA
         B0MSuzSmfpXBrjIZ4eya9l/RoFpoPRNqpkVX8U9GKZhQt0+uZ0ZlKA1vrysm6biY2g
         5n2GtmLvkZsy9hVoLRv3Z24Hz2eM2roMvKqXC1vIT3i+lO9mssmzjTcxXrpQvEX/Dd
         92DMRjrVMJLnUOCf8MuKK4Gn4jpHL8oinN+wAyuQ2rBJO/IdNr6xikxnWJx/hqCyN3
         1vRjeFbo80hIZ3yQSpcRknzb/WqO7DpX5tLA859mytVQLU4O1DnhW9Dyx2RVM+TALm
         waW9uVvNX5s+A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pRWJb-0004WY-Gp; Mon, 13 Feb 2023 11:44:07 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH v6 07/20] irqdomain: Fix domain registration race
Date:   Mon, 13 Feb 2023 11:42:49 +0100
Message-Id: <20230213104302.17307-8-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213104302.17307-1-johan+linaro@kernel.org>
References: <20230213104302.17307-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

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
---
 kernel/irq/irqdomain.c | 62 +++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index bfda4adc05c0..8e14805c5508 100644
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
-- 
2.39.1

