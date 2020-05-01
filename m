Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9397D1C1468
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731132AbgEANjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731130AbgEANjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D820205C9;
        Fri,  1 May 2020 13:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340341;
        bh=4hZvBE6xsC/iubCP5MVXG8dhgb8LLPoFp3HBF0HbDCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdJbZQTdB7nH4qkdKKtEXe/pvcd3HB3/fr360PnwGcCbGiPqtwR+PEs8Z5ocR0BXe
         3qOp+Lsi2xnDoyReGpdN8hE8TdlVWzIRAgWpHZtfEotp3DcQv8+O4DQ5f36W48KY5Y
         PPGGhSxPKd/Dn6BzmY57G1snshZ5s6jmoiWmmj+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Schmidt <alexs@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 39/83] s390/pci: do not set affinity for floating irqs
Date:   Fri,  1 May 2020 15:23:18 +0200
Message-Id: <20200501131535.610985340@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 86dbf32da150339ca81509fa2eb84c814b55258b upstream.

with the introduction of CPU directed interrupts the kernel
parameter pci=force_floating was introduced to fall back
to the previous behavior using floating irqs.

However we were still setting the affinity in that case,
both in __irq_alloc_descs() and via the irq_set_affinity
callback in struct irq_chip.

For the former only set the affinity in the directed case.

The latter is explicitly set in zpci_directed_irq_init()
so we can just leave it unset for the floating case.

Fixes: e979ce7bced2 ("s390/pci: provide support for CPU directed interrupts")
Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/pci/pci_irq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -115,7 +115,6 @@ static struct irq_chip zpci_irq_chip = {
 	.name = "PCI-MSI",
 	.irq_unmask = pci_msi_unmask_irq,
 	.irq_mask = pci_msi_mask_irq,
-	.irq_set_affinity = zpci_set_irq_affinity,
 };
 
 static void zpci_handle_cpu_local_irq(bool rescan)
@@ -276,7 +275,9 @@ int arch_setup_msi_irqs(struct pci_dev *
 		rc = -EIO;
 		if (hwirq - bit >= msi_vecs)
 			break;
-		irq = __irq_alloc_descs(-1, 0, 1, 0, THIS_MODULE, msi->affinity);
+		irq = __irq_alloc_descs(-1, 0, 1, 0, THIS_MODULE,
+				(irq_delivery == DIRECTED) ?
+				msi->affinity : NULL);
 		if (irq < 0)
 			return -ENOMEM;
 		rc = irq_set_msi_desc(irq, msi);


