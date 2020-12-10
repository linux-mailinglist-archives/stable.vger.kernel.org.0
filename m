Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72C22D6288
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391059AbgLJOhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391049AbgLJOgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:36:53 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.4 21/54] s390/pci: fix CPU address in MSI for directed IRQ
Date:   Thu, 10 Dec 2020 15:26:58 +0100
Message-Id: <20201210142603.083190701@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

commit a2bd4097b3ec242f4de4924db463a9c94530e03a upstream.

The directed MSIs are delivered to CPUs whose address is
written to the MSI message address. The current code assumes
that a CPU logical number (as it is seen by the kernel)
is also the CPU address.

The above assumption is not correct, as the CPU address
is rather the value returned by STAP instruction. That
value does not necessarily match the kernel logical CPU
number.

Fixes: e979ce7bced2 ("s390/pci: provide support for CPU directed interrupts")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/pci/pci_irq.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -103,9 +103,10 @@ static int zpci_set_irq_affinity(struct
 {
 	struct msi_desc *entry = irq_get_msi_desc(data->irq);
 	struct msi_msg msg = entry->msg;
+	int cpu_addr = smp_cpu_get_cpu_address(cpumask_first(dest));
 
 	msg.address_lo &= 0xff0000ff;
-	msg.address_lo |= (cpumask_first(dest) << 8);
+	msg.address_lo |= (cpu_addr << 8);
 	pci_write_msi_msg(data->irq, &msg);
 
 	return IRQ_SET_MASK_OK;
@@ -238,6 +239,7 @@ int arch_setup_msi_irqs(struct pci_dev *
 	unsigned long bit;
 	struct msi_desc *msi;
 	struct msi_msg msg;
+	int cpu_addr;
 	int rc, irq;
 
 	zdev->aisb = -1UL;
@@ -287,9 +289,15 @@ int arch_setup_msi_irqs(struct pci_dev *
 					 handle_percpu_irq);
 		msg.data = hwirq - bit;
 		if (irq_delivery == DIRECTED) {
+			if (msi->affinity)
+				cpu = cpumask_first(&msi->affinity->mask);
+			else
+				cpu = 0;
+			cpu_addr = smp_cpu_get_cpu_address(cpu);
+
 			msg.address_lo = zdev->msi_addr & 0xff0000ff;
-			msg.address_lo |= msi->affinity ?
-				(cpumask_first(&msi->affinity->mask) << 8) : 0;
+			msg.address_lo |= (cpu_addr << 8);
+
 			for_each_possible_cpu(cpu) {
 				airq_iv_set_data(zpci_ibv[cpu], hwirq, irq);
 			}


