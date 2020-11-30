Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83722C8342
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 12:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgK3L3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 06:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgK3L3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 06:29:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6EAC0613D2;
        Mon, 30 Nov 2020 03:29:05 -0800 (PST)
Date:   Mon, 30 Nov 2020 11:29:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606735743;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yXzRBKLraE3KGoXGlx30JrxKc1I9+HPSiHX9rysF71o=;
        b=v+6YIrEWBEU67lenTZBRrT/AJL0UUWO4STXKlVG5XsOpXhosgUpLWesiU4UM0VEr877A6p
        Amvu70IceNGKECwMYuEsPPEjyVqj4t/tFlTMEOM1JSeO1MJx1Ct9aMHJQ9PVW2u3oMdO9U
        H+UAUGgWZYWVCOguoXYFuA//nSG5Fb/UDbsY4DcLx9UoyB9NhTvnyZcOXZOHqjQRJBqw6n
        1dHLSK/h7EnZ6EJ0FwZb/UZlRGSn+RZovt5ZdsgF3qFySjTwp8yq6oklSB72d1sAy8IYiH
        fPABWo/xk2HG6q5T2wKzNDBKdlQlNLOReAW4QEmN99AowyoyU+YJly2PEuRJWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606735743;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yXzRBKLraE3KGoXGlx30JrxKc1I9+HPSiHX9rysF71o=;
        b=neakLje28TJ+b8cTBVC7Qhi1XwnpQoK/tUJiymMwjKALRMsgczYw0KFhylGf8CK2cbTOuY
        6Ej8+KF6Lwg4VgCw==
From:   "tip-bot2 for Laurent Vivier" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/irqdomain: Add an
 irq_create_mapping_affinity() function
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kurz <groug@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <20201126082852.1178497-2-lvivier@redhat.com>
References: <20201126082852.1178497-2-lvivier@redhat.com>
MIME-Version: 1.0
Message-ID: <160673574273.3364.16488984497450700332.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     bb4c6910c8b41623104c2e64a30615682689a54d
Gitweb:        https://git.kernel.org/tip/bb4c6910c8b41623104c2e64a30615682689a54d
Author:        Laurent Vivier <lvivier@redhat.com>
AuthorDate:    Thu, 26 Nov 2020 09:28:51 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 30 Nov 2020 12:21:31 +01:00

genirq/irqdomain: Add an irq_create_mapping_affinity() function

There is currently no way to convey the affinity of an interrupt
via irq_create_mapping(), which creates issues for devices that
expect that affinity to be managed by the kernel.

In order to sort this out, rename irq_create_mapping() to
irq_create_mapping_affinity() with an additional affinity parameter that
can be passed down to irq_domain_alloc_descs().

irq_create_mapping() is re-implemented as a wrapper around
irq_create_mapping_affinity().

No functional change.

Fixes: e75eafb9b039 ("genirq/msi: Switch to new irq spreading infrastructure")
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kurz <groug@kaod.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201126082852.1178497-2-lvivier@redhat.com

---
 include/linux/irqdomain.h | 12 ++++++++++--
 kernel/irq/irqdomain.c    | 13 ++++++++-----
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 71535e8..ea5a337 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -384,11 +384,19 @@ extern void irq_domain_associate_many(struct irq_domain *domain,
 extern void irq_domain_disassociate(struct irq_domain *domain,
 				    unsigned int irq);
 
-extern unsigned int irq_create_mapping(struct irq_domain *host,
-				       irq_hw_number_t hwirq);
+extern unsigned int irq_create_mapping_affinity(struct irq_domain *host,
+				      irq_hw_number_t hwirq,
+				      const struct irq_affinity_desc *affinity);
 extern unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec);
 extern void irq_dispose_mapping(unsigned int virq);
 
+static inline unsigned int irq_create_mapping(struct irq_domain *host,
+					      irq_hw_number_t hwirq)
+{
+	return irq_create_mapping_affinity(host, hwirq, NULL);
+}
+
+
 /**
  * irq_linear_revmap() - Find a linux irq from a hw irq number.
  * @domain: domain owning this hardware interrupt
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index cf8b374..e4ca696 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -624,17 +624,19 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 
 /**
- * irq_create_mapping() - Map a hardware interrupt into linux irq space
+ * irq_create_mapping_affinity() - Map a hardware interrupt into linux irq space
  * @domain: domain owning this hardware interrupt or NULL for default domain
  * @hwirq: hardware irq number in that domain space
+ * @affinity: irq affinity
  *
  * Only one mapping per hardware interrupt is permitted. Returns a linux
  * irq number.
  * If the sense/trigger is to be specified, set_irq_type() should be called
  * on the number returned from that call.
  */
-unsigned int irq_create_mapping(struct irq_domain *domain,
-				irq_hw_number_t hwirq)
+unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
+				       irq_hw_number_t hwirq,
+				       const struct irq_affinity_desc *affinity)
 {
 	struct device_node *of_node;
 	int virq;
@@ -660,7 +662,8 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	}
 
 	/* Allocate a virtual interrupt number */
-	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node), NULL);
+	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node),
+				      affinity);
 	if (virq <= 0) {
 		pr_debug("-> virq allocation failed\n");
 		return 0;
@@ -676,7 +679,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 
 	return virq;
 }
-EXPORT_SYMBOL_GPL(irq_create_mapping);
+EXPORT_SYMBOL_GPL(irq_create_mapping_affinity);
 
 /**
  * irq_create_strict_mappings() - Map a range of hw irqs to fixed linux irqs
