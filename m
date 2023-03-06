Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F946ACD05
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 19:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjCFStZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 13:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjCFStW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 13:49:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783D465115
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:49:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 378F0B8107E
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 18:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A884C433A1;
        Mon,  6 Mar 2023 18:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678128558;
        bh=NLwJzkoVQXjiILy0i28WxECNOZzAz2fzjUF7I195/2k=;
        h=Subject:To:Cc:From:Date:From;
        b=a4Rb/UFzIxMdJiWqXMctT2OKw0PncamuPI80bgcHD3PI4FaH3NnkPH5mO+bqhdko4
         i1jMdhFDesHiKjY3DCTe2RUxywV4Hsk3LBC5b80qdmbVsFekFw5OAe2y8UJBoh9f4n
         /sQjjg8sOQQZxvTrGSQIBuzUqOfIkFy6DNCHbhbM=
Subject: FAILED: patch "[PATCH] irqdomain: Fix domain registration race" failed to apply to 4.19-stable tree
To:     maz@kernel.org, johan+linaro@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 19:49:11 +0100
Message-ID: <1678128551129114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 8932c32c3053accd50702b36e944ac2016cd103c
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678128551129114@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

8932c32c3053 ("irqdomain: Fix domain registration race")
20c36ce2164f ("irqdomain: Change the type of 'size' in __irq_domain_add() to be consistent")
3a1d24ca9573 ("irq/irqdomain: Fix comment typo")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8932c32c3053accd50702b36e944ac2016cd103c Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Mon, 13 Feb 2023 11:42:49 +0100
Subject: [PATCH] irqdomain: Fix domain registration race

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

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index df0cbad1b0d7..a6d1b108b8f7 100644
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

