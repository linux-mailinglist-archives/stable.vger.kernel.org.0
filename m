Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061C131B69F
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 10:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhBOJqH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 15 Feb 2021 04:46:07 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:27439 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230191AbhBOJqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 04:46:06 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-ZB_QKXmkNjamOMswugvV1Q-1; Mon, 15 Feb 2021 04:45:11 -0500
X-MC-Unique: ZB_QKXmkNjamOMswugvV1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 753B91934100;
        Mon, 15 Feb 2021 09:45:09 +0000 (UTC)
Received: from bahia.redhat.com (ovpn-113-119.ams2.redhat.com [10.36.113.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA8A4682AC;
        Mon, 15 Feb 2021 09:45:07 +0000 (UTC)
From:   Greg Kurz <groug@kaod.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>, lvivier@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH v2] powerpc/pseries: Don't enforce MSI affinity with kdump
Date:   Mon, 15 Feb 2021 10:45:06 +0100
Message-Id: <20210215094506.1196119-1-groug@kaod.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Depending on the number of online CPUs in the original kernel, it is
likely for CPU #0 to be offline in a kdump kernel. The associated IRQs
in the affinity mappings provided by irq_create_affinity_masks() are
thus not started by irq_startup(), as per-design with managed IRQs.

This can be a problem with multi-queue block devices driven by blk-mq :
such a non-started IRQ is very likely paired with the single queue
enforced by blk-mq during kdump (see blk_mq_alloc_tag_set()). This
causes the device to remain silent and likely hangs the guest at
some point.

This is a regression caused by commit 9ea69a55b3b9 ("powerpc/pseries:
Pass MSI affinity to irq_create_mapping()"). Note that this only happens
with the XIVE interrupt controller because XICS has a workaround to bypass
affinity, which is activated during kdump with the "noirqdistrib" kernel
parameter.

The issue comes from a combination of factors:
- discrepancy between the number of queues detected by the multi-queue
  block driver, that was used to create the MSI vectors, and the single
  queue mode enforced later on by blk-mq because of kdump (i.e. keeping
  all queues fixes the issue)
- CPU#0 offline (i.e. kdump always succeed with CPU#0)

Given that I couldn't reproduce on x86, which seems to always have CPU#0
online even during kdump, I'm not sure where this should be fixed. Hence
going for another approach : fine-grained affinity is for performance
and we don't really care about that during kdump. Simply revert to the
previous working behavior of ignoring affinity masks in this case only.

Fixes: 9ea69a55b3b9 ("powerpc/pseries: Pass MSI affinity to irq_create_mapping()")
Cc: lvivier@redhat.com
Cc: stable@vger.kernel.org
Reviewed-by: Laurent Vivier <lvivier@redhat.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Greg Kurz <groug@kaod.org>
---

v2: - added missing #include <linux/crash_dump.h>

 arch/powerpc/platforms/pseries/msi.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index b3ac2455faad..637300330507 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -4,6 +4,7 @@
  * Copyright 2006-2007 Michael Ellerman, IBM Corp.
  */
 
+#include <linux/crash_dump.h>
 #include <linux/device.h>
 #include <linux/irq.h>
 #include <linux/msi.h>
@@ -458,8 +459,28 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
 			return hwirq;
 		}
 
-		virq = irq_create_mapping_affinity(NULL, hwirq,
-						   entry->affinity);
+		/*
+		 * Depending on the number of online CPUs in the original
+		 * kernel, it is likely for CPU #0 to be offline in a kdump
+		 * kernel. The associated IRQs in the affinity mappings
+		 * provided by irq_create_affinity_masks() are thus not
+		 * started by irq_startup(), as per-design for managed IRQs.
+		 * This can be a problem with multi-queue block devices driven
+		 * by blk-mq : such a non-started IRQ is very likely paired
+		 * with the single queue enforced by blk-mq during kdump (see
+		 * blk_mq_alloc_tag_set()). This causes the device to remain
+		 * silent and likely hangs the guest at some point.
+		 *
+		 * We don't really care for fine-grained affinity when doing
+		 * kdump actually : simply ignore the pre-computed affinity
+		 * masks in this case and let the default mask with all CPUs
+		 * be used when creating the IRQ mappings.
+		 */
+		if (is_kdump_kernel())
+			virq = irq_create_mapping(NULL, hwirq);
+		else
+			virq = irq_create_mapping_affinity(NULL, hwirq,
+							   entry->affinity);
 
 		if (!virq) {
 			pr_debug("rtas_msi: Failed mapping hwirq %d\n", hwirq);
-- 
2.26.2

