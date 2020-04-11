Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F101A5057
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgDKMQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgDKMQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:16:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BF8A21655;
        Sat, 11 Apr 2020 12:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607409;
        bh=TT64A1W14aMx+C6Ty9ZtW4tzFoenHFEPHktA6n1JgQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2WNqxr7oMCIsG5THAXNBXVd4MosXPKldZmSV8XHgtEyZPeNS3HKgfj2iBQoFzNc2
         LEucWQBYxUNhHI2OWNsvAA7euxvn5IVZxwOnlsp+CRMH5UBglJu4j06P+qzmM7fWbh
         QtavXNzxsbs63mP8JiGTkpIYx1HErBzXRT2f8ejU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.19 16/54] misc: pci_endpoint_test: Avoid using module parameter to determine irqtype
Date:   Sat, 11 Apr 2020 14:08:58 +0200
Message-Id: <20200411115510.027666182@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
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
@@ -104,6 +104,7 @@ struct pci_endpoint_test {
 	struct completion irq_raised;
 	int		last_irq;
 	int		num_irqs;
+	int		irq_type;
 	/* mutex to protect the ioctls */
 	struct mutex	mutex;
 	struct miscdevice miscdev;
@@ -163,6 +164,7 @@ static void pci_endpoint_test_free_irq_v
 	struct pci_dev *pdev = test->pdev;
 
 	pci_free_irq_vectors(pdev);
+	test->irq_type = IRQ_TYPE_UNDEFINED;
 }
 
 static bool pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
@@ -197,6 +199,8 @@ static bool pci_endpoint_test_alloc_irq_
 		irq = 0;
 		res = false;
 	}
+
+	test->irq_type = type;
 	test->num_irqs = irq;
 
 	return res;
@@ -336,6 +340,7 @@ static bool pci_endpoint_test_copy(struc
 	dma_addr_t orig_dst_phys_addr;
 	size_t offset;
 	size_t alignment = test->alignment;
+	int irq_type = test->irq_type;
 	u32 src_crc32;
 	u32 dst_crc32;
 
@@ -432,6 +437,7 @@ static bool pci_endpoint_test_write(stru
 	dma_addr_t orig_phys_addr;
 	size_t offset;
 	size_t alignment = test->alignment;
+	int irq_type = test->irq_type;
 	u32 crc32;
 
 	if (size > SIZE_MAX - alignment)
@@ -500,6 +506,7 @@ static bool pci_endpoint_test_read(struc
 	dma_addr_t orig_phys_addr;
 	size_t offset;
 	size_t alignment = test->alignment;
+	int irq_type = test->irq_type;
 	u32 crc32;
 
 	if (size > SIZE_MAX - alignment)
@@ -561,7 +568,7 @@ static bool pci_endpoint_test_set_irq(st
 		return false;
 	}
 
-	if (irq_type == req_irq_type)
+	if (test->irq_type == req_irq_type)
 		return true;
 
 	pci_endpoint_test_release_irq(test);
@@ -573,12 +580,10 @@ static bool pci_endpoint_test_set_irq(st
 	if (!pci_endpoint_test_request_irq(test))
 		goto err;
 
-	irq_type = req_irq_type;
 	return true;
 
 err:
 	pci_endpoint_test_free_irq_vectors(test);
-	irq_type = IRQ_TYPE_UNDEFINED;
 	return false;
 }
 
@@ -655,6 +660,7 @@ static int pci_endpoint_test_probe(struc
 	test->test_reg_bar = 0;
 	test->alignment = 0;
 	test->pdev = pdev;
+	test->irq_type = IRQ_TYPE_UNDEFINED;
 
 	if (no_msi)
 		irq_type = IRQ_TYPE_LEGACY;


