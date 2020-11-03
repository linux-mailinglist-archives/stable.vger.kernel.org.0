Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD7B2A4829
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgKCOad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:30:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:38760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729691AbgKCO3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 09:29:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604413752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/VP6WSc6DvlLF9yrIYqTd35xwvJM48FVR6NQTa6cRdE=;
        b=BIxVKjeS2OJ2M6nP4MV63BmFv+afq7Gw0kHRI4vzji0sOTK4rMPq3t2yZS4liGg/3ld0DO
        XSfaIzERkXeZlCh51sH9eOB3tW1viBO36oy9NxnAgWSLW1CcWYDJSsFn/hiS6KGma9kYf8
        TQTDTbm4TZdk6qnzUrniENlX0Hov/0k=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F29F9B1AC
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 14:29:11 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 01/14] xen/events: don't use chip_data for legacy IRQs
Date:   Tue,  3 Nov 2020 15:28:58 +0100
Message-Id: <20201103142911.21980-2-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103142911.21980-1-jgross@suse.com>
References: <20201103142911.21980-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
Xen is using the chip_data pointer for storing IRQ specific data. When
running as a HVM domain this can result in problems for legacy IRQs, as
those might use chip_data for their own purposes.

Use a local array for this purpose in case of legacy IRQs, avoiding the
double use.

This is upstream commit 0891fb39ba67bd7ae023ea0d367297ffff010781

Cc: stable@vger.kernel.org
Fixes: c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Stefan Bader <stefan.bader@canonical.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20200930091614.13660-1-jgross@suse.com
---
 drivers/xen/events/events_base.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 95e5a9300ff0..fdeeef2b9947 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -90,6 +90,8 @@ static bool (*pirq_needs_eoi)(unsigned irq);
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) != 0)
 
+static struct irq_info *legacy_info_ptrs[NR_IRQS_LEGACY];
+
 static struct irq_chip xen_dynamic_chip;
 static struct irq_chip xen_percpu_chip;
 static struct irq_chip xen_pirq_chip;
@@ -154,7 +156,18 @@ int get_evtchn_to_irq(unsigned evtchn)
 /* Get info for IRQ */
 struct irq_info *info_for_irq(unsigned irq)
 {
-	return irq_get_chip_data(irq);
+	if (irq < nr_legacy_irqs())
+		return legacy_info_ptrs[irq];
+	else
+		return irq_get_chip_data(irq);
+}
+
+static void set_info_for_irq(unsigned int irq, struct irq_info *info)
+{
+	if (irq < nr_legacy_irqs())
+		legacy_info_ptrs[irq] = info;
+	else
+		irq_set_chip_data(irq, info);
 }
 
 /* Constructors for packed IRQ information. */
@@ -375,7 +388,7 @@ static void xen_irq_init(unsigned irq)
 	info->type = IRQT_UNBOUND;
 	info->refcnt = -1;
 
-	irq_set_chip_data(irq, info);
+	set_info_for_irq(irq, info);
 
 	list_add_tail(&info->list, &xen_irq_list_head);
 }
@@ -424,14 +437,14 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 
 static void xen_free_irq(unsigned irq)
 {
-	struct irq_info *info = irq_get_chip_data(irq);
+	struct irq_info *info = info_for_irq(irq);
 
 	if (WARN_ON(!info))
 		return;
 
 	list_del(&info->list);
 
-	irq_set_chip_data(irq, NULL);
+	set_info_for_irq(irq, NULL);
 
 	WARN_ON(info->refcnt > 0);
 
@@ -601,7 +614,7 @@ EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
 static void __unbind_from_irq(unsigned int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
-	struct irq_info *info = irq_get_chip_data(irq);
+	struct irq_info *info = info_for_irq(irq);
 
 	if (info->refcnt > 0) {
 		info->refcnt--;
@@ -1105,7 +1118,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 
 void unbind_from_irqhandler(unsigned int irq, void *dev_id)
 {
-	struct irq_info *info = irq_get_chip_data(irq);
+	struct irq_info *info = info_for_irq(irq);
 
 	if (WARN_ON(!info))
 		return;
@@ -1139,7 +1152,7 @@ int evtchn_make_refcounted(unsigned int evtchn)
 	if (irq == -1)
 		return -ENOENT;
 
-	info = irq_get_chip_data(irq);
+	info = info_for_irq(irq);
 
 	if (!info)
 		return -ENOENT;
@@ -1167,7 +1180,7 @@ int evtchn_get(unsigned int evtchn)
 	if (irq == -1)
 		goto done;
 
-	info = irq_get_chip_data(irq);
+	info = info_for_irq(irq);
 
 	if (!info)
 		goto done;
-- 
2.26.2

