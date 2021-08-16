Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A843ED695
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbhHPNWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240926AbhHPNUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA615632D4;
        Mon, 16 Aug 2021 13:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119729;
        bh=rhRNTqah8YTVHZgRxQq5DW2nG/PJfiHbEL/DrhcF9Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+Dv2DbktugMf8T9D/Tbdl83Q1TCYxv3bIcDnlTAeHKBe7IZBHqxMYuBGNRH7yfKz
         yFGq8nl0ul3DlU3Lxg239NYZgLVgYgocS0y8TKd3s7gnbHSlGgm3U0WFOrpGuBQ746
         dH/wLJasHfT6rcLOxxQm+4L+hFVyUcx3DZ313pkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 140/151] powerpc/xive: Do not skip CPU-less nodes when creating the IPIs
Date:   Mon, 16 Aug 2021 15:02:50 +0200
Message-Id: <20210816125448.681174462@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit cbc06f051c524dcfe52ef0d1f30647828e226d30 upstream.

On PowerVM, CPU-less nodes can be populated with hot-plugged CPUs at
runtime. Today, the IPI is not created for such nodes, and hot-plugged
CPUs use a bogus IPI, which leads to soft lockups.

We can not directly allocate and request the IPI on demand because
bringup_up() is called under the IRQ sparse lock. The alternative is
to allocate the IPIs for all possible nodes at startup and to request
the mapping on demand when the first CPU of a node is brought up.

Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
Cc: stable@vger.kernel.org # v5.13
Reported-by: Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Tested-by: Laurent Vivier <lvivier@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210807072057.184698-1-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/sysdev/xive/common.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -67,6 +67,7 @@ static struct irq_domain *xive_irq_domai
 static struct xive_ipi_desc {
 	unsigned int irq;
 	char name[16];
+	atomic_t started;
 } *xive_ipis;
 
 /*
@@ -1120,7 +1121,7 @@ static const struct irq_domain_ops xive_
 	.alloc  = xive_ipi_irq_domain_alloc,
 };
 
-static int __init xive_request_ipi(void)
+static int __init xive_init_ipis(void)
 {
 	struct fwnode_handle *fwnode;
 	struct irq_domain *ipi_domain;
@@ -1144,10 +1145,6 @@ static int __init xive_request_ipi(void)
 		struct xive_ipi_desc *xid = &xive_ipis[node];
 		struct xive_ipi_alloc_info info = { node };
 
-		/* Skip nodes without CPUs */
-		if (cpumask_empty(cpumask_of_node(node)))
-			continue;
-
 		/*
 		 * Map one IPI interrupt per node for all cpus of that node.
 		 * Since the HW interrupt number doesn't have any meaning,
@@ -1159,11 +1156,6 @@ static int __init xive_request_ipi(void)
 		xid->irq = ret;
 
 		snprintf(xid->name, sizeof(xid->name), "IPI-%d", node);
-
-		ret = request_irq(xid->irq, xive_muxed_ipi_action,
-				  IRQF_PERCPU | IRQF_NO_THREAD, xid->name, NULL);
-
-		WARN(ret < 0, "Failed to request IPI %d: %d\n", xid->irq, ret);
 	}
 
 	return ret;
@@ -1178,6 +1170,22 @@ out:
 	return ret;
 }
 
+static int __init xive_request_ipi(unsigned int cpu)
+{
+	struct xive_ipi_desc *xid = &xive_ipis[early_cpu_to_node(cpu)];
+	int ret;
+
+	if (atomic_inc_return(&xid->started) > 1)
+		return 0;
+
+	ret = request_irq(xid->irq, xive_muxed_ipi_action,
+			  IRQF_PERCPU | IRQF_NO_THREAD,
+			  xid->name, NULL);
+
+	WARN(ret < 0, "Failed to request IPI %d: %d\n", xid->irq, ret);
+	return ret;
+}
+
 static int xive_setup_cpu_ipi(unsigned int cpu)
 {
 	unsigned int xive_ipi_irq = xive_ipi_cpu_to_irq(cpu);
@@ -1192,6 +1200,9 @@ static int xive_setup_cpu_ipi(unsigned i
 	if (xc->hw_ipi != XIVE_BAD_IRQ)
 		return 0;
 
+	/* Register the IPI */
+	xive_request_ipi(cpu);
+
 	/* Grab an IPI from the backend, this will populate xc->hw_ipi */
 	if (xive_ops->get_ipi(cpu, xc))
 		return -EIO;
@@ -1231,6 +1242,8 @@ static void xive_cleanup_cpu_ipi(unsigne
 	if (xc->hw_ipi == XIVE_BAD_IRQ)
 		return;
 
+	/* TODO: clear IPI mapping */
+
 	/* Mask the IPI */
 	xive_do_source_set_mask(&xc->ipi_data, true);
 
@@ -1253,7 +1266,7 @@ void __init xive_smp_probe(void)
 	smp_ops->cause_ipi = xive_cause_ipi;
 
 	/* Register the IPI */
-	xive_request_ipi();
+	xive_init_ipis();
 
 	/* Allocate and setup IPI for the boot CPU */
 	xive_setup_cpu_ipi(smp_processor_id());


