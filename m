Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C5833B62A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhCON5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhCON4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2633D64EED;
        Mon, 15 Mar 2021 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816608;
        bh=lQqZ31p/1FjojljzydhEX/AOh6vMwibdy62aoftNbNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJj/dgetBi+hYNmdRcXoLvgVS5ezIgd0+IuLr0H5wezQ09WBTxT/T3yxef2hDT7fL
         F4bPHF689BN4n0ee82LWCk8QZrgeleii2alC+Tl05QQ8yO+L8CG613JkdnQQ6AuDey
         wOPRGm/a26rOuutliJA0Kw5n6ZaLh76gkJDUDw3o=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 002/168] powerpc/pseries: Dont enforce MSI affinity with kdump
Date:   Mon, 15 Mar 2021 14:53:54 +0100
Message-Id: <20210315135550.414757224@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Greg Kurz <groug@kaod.org>

commit f9619d5e5174867536b7e558683bc4408eab833f upstream.

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
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Laurent Vivier <lvivier@redhat.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210215094506.1196119-1-groug@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/msi.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -4,6 +4,7 @@
  * Copyright 2006-2007 Michael Ellerman, IBM Corp.
  */
 
+#include <linux/crash_dump.h>
 #include <linux/device.h>
 #include <linux/irq.h>
 #include <linux/msi.h>
@@ -458,8 +459,28 @@ again:
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


