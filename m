Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B03E1A0BCB
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgDGKYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbgDGKYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:24:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B61B92078A;
        Tue,  7 Apr 2020 10:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255043;
        bh=hFSSaaFZs7iS34JeOV/LO3xxtt/qCl6SQ6F3A3HPIlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1gdXcWvhkNJyaS5X5117n8a0wL+gWkvAXIBSyiHlRJ+ksDM9Ss6GeXDjppDtz/sZ
         31KsChhaSDsSe8XN1dDRW/YcfrQyUP15hPais8nn+86Rnz9ppsdA+pXd7Jm3Uuvwb+
         eFhICi6Pu+b8FRPfeAT6yMsGtoPS8MEatTnBDwQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 17/36] misc: pci_endpoint_test: Avoid using module parameter to determine irqtype
Date:   Tue,  7 Apr 2020 12:21:50 +0200
Message-Id: <20200407101456.596034502@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101454.281052964@linuxfoundation.org>
References: <20200407101454.281052964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit b2ba9225e0313b1de631a44b7b48c109032bffec upstream.

commit e03327122e2c ("pci_endpoint_test: Add 2 ioctl commands")
uses module parameter 'irqtype' in pci_endpoint_test_set_irq()
to check if IRQ vectors of a particular type (MSI or MSI-X or
LEGACY) is already allocated. However with multi-function devices,
'irqtype' will not correctly reflect the IRQ type of the PCI device.

Fix it here by adding 'irqtype' for each PCI device to show the
IRQ type of a particular PCI device.

Fixes: e03327122e2c ("pci_endpoint_test: Add 2 ioctl commands")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/pci_endpoint_test.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -98,6 +98,7 @@ struct pci_endpoint_test {
 	struct completion irq_raised;
 	int		last_irq;
 	int		num_irqs;
+	int		irq_type;
 	/* mutex to protect the ioctls */
 	struct mutex	mutex;
 	struct miscdevice miscdev;
@@ -157,6 +158,7 @@ static void pci_endpoint_test_free_irq_v
 	struct pci_dev *pdev = test->pdev;
 
 	pci_free_irq_vectors(pdev);
+	test->irq_type = IRQ_TYPE_UNDEFINED;
 }
 
 static bool pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
@@ -191,6 +193,8 @@ static bool pci_endpoint_test_alloc_irq_
 		irq = 0;
 		res = false;
 	}
+
+	test->irq_type = type;
 	test->num_irqs = irq;
 
 	return res;
@@ -330,6 +334,7 @@ static bool pci_endpoint_test_copy(struc
 	dma_addr_t orig_dst_phys_addr;
 	size_t offset;
 	size_t alignment = test->alignment;
+	int irq_type = test->irq_type;
 	u32 src_crc32;
 	u32 dst_crc32;
 
@@ -426,6 +431,7 @@ static bool pci_endpoint_test_write(stru
 	dma_addr_t orig_phys_addr;
 	size_t offset;
 	size_t alignment = test->alignment;
+	int irq_type = test->irq_type;
 	u32 crc32;
 
 	if (size > SIZE_MAX - alignment)
@@ -494,6 +500,7 @@ static bool pci_endpoint_test_read(struc
 	dma_addr_t orig_phys_addr;
 	size_t offset;
 	size_t alignment = test->alignment;
+	int irq_type = test->irq_type;
 	u32 crc32;
 
 	if (size > SIZE_MAX - alignment)
@@ -555,7 +562,7 @@ static bool pci_endpoint_test_set_irq(st
 		return false;
 	}
 
-	if (irq_type == req_irq_type)
+	if (test->irq_type == req_irq_type)
 		return true;
 
 	pci_endpoint_test_release_irq(test);
@@ -567,12 +574,10 @@ static bool pci_endpoint_test_set_irq(st
 	if (!pci_endpoint_test_request_irq(test))
 		goto err;
 
-	irq_type = req_irq_type;
 	return true;
 
 err:
 	pci_endpoint_test_free_irq_vectors(test);
-	irq_type = IRQ_TYPE_UNDEFINED;
 	return false;
 }
 
@@ -652,6 +657,7 @@ static int pci_endpoint_test_probe(struc
 	test->test_reg_bar = 0;
 	test->alignment = 0;
 	test->pdev = pdev;
+	test->irq_type = IRQ_TYPE_UNDEFINED;
 
 	if (no_msi)
 		irq_type = IRQ_TYPE_LEGACY;


