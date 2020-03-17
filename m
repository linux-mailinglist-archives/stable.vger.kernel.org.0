Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EA9187D96
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 10:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgCQJ5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 05:57:34 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:45794 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgCQJ5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 05:57:34 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02H9vPUX102623;
        Tue, 17 Mar 2020 04:57:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584439045;
        bh=6DPCQb5gnHUagCHjkwvxLKMIM/+htnKM5PjHBAvyfes=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=GxBhbvkmrHZzf5YgL+hwLkN2ISuz4NI4ARYucNHNRz8ZXeMeUN+wVt92uCtX9WxGA
         wGVRa9GcWzXAICNOClokKsBdFEKVSof4+ijAgwwDpH5VTAgqO6n+u4nJyGXqsQoZXS
         LFqSSUnWI2Yt9WLVenujueHJ6KbMbq8JdUv/VQpM=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02H9vPN5039826
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Mar 2020 04:57:25 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Mar 2020 04:57:24 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Mar 2020 04:57:24 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02H9vIKS095155;
        Tue, 17 Mar 2020 04:57:22 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/5] misc: pci_endpoint_test: Avoid using module parameter to determine irqtype
Date:   Tue, 17 Mar 2020 15:31:54 +0530
Message-ID: <20200317100158.4692-2-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317100158.4692-1-kishon@ti.com>
References: <20200317100158.4692-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e03327122e2c ("pci_endpoint_test: Add 2 ioctl commands")
uses module parameter 'irqtype' in pci_endpoint_test_set_irq()
to check if irq vectors of a particular type (MSI or MSI-X or
LEGACY) is already allocated. However with multi-function devices,
'irqtype' will not correctly reflect the irq type of the PCI device.
Fix it here by adding 'irqtype' for each PCI device to show the
irq type of a particular PCI device.

Fixes: e03327122e2c ("pci_endpoint_test: Add 2 ioctl commands")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/misc/pci_endpoint_test.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 8682867ac14a..ca680635d7a9 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -103,6 +103,7 @@ struct pci_endpoint_test {
 	struct completion irq_raised;
 	int		last_irq;
 	int		num_irqs;
+	int		irq_type;
 	/* mutex to protect the ioctls */
 	struct mutex	mutex;
 	struct miscdevice miscdev;
@@ -162,6 +163,7 @@ static void pci_endpoint_test_free_irq_vectors(struct pci_endpoint_test *test)
 	struct pci_dev *pdev = test->pdev;
 
 	pci_free_irq_vectors(pdev);
+	test->irq_type = IRQ_TYPE_UNDEFINED;
 }
 
 static bool pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
@@ -196,6 +198,8 @@ static bool pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
 		irq = 0;
 		res = false;
 	}
+
+	test->irq_type = type;
 	test->num_irqs = irq;
 
 	return res;
@@ -340,6 +344,7 @@ static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
 	dma_addr_t orig_dst_phys_addr;
 	size_t offset;
 	size_t alignment = test->alignment;
+	int irq_type = test->irq_type;
 	u32 src_crc32;
 	u32 dst_crc32;
 	int err;
@@ -473,6 +478,7 @@ static bool pci_endpoint_test_write(struct pci_endpoint_test *test,
 	dma_addr_t orig_phys_addr;
 	size_t offset;
 	size_t alignment = test->alignment;
+	int irq_type = test->irq_type;
 	size_t size;
 	u32 crc32;
 	int err;
@@ -571,6 +577,7 @@ static bool pci_endpoint_test_read(struct pci_endpoint_test *test,
 	dma_addr_t orig_phys_addr;
 	size_t offset;
 	size_t alignment = test->alignment;
+	int irq_type = test->irq_type;
 	u32 crc32;
 	int err;
 
@@ -656,7 +663,7 @@ static bool pci_endpoint_test_set_irq(struct pci_endpoint_test *test,
 		return false;
 	}
 
-	if (irq_type == req_irq_type)
+	if (test->irq_type == req_irq_type)
 		return true;
 
 	pci_endpoint_test_release_irq(test);
@@ -668,12 +675,10 @@ static bool pci_endpoint_test_set_irq(struct pci_endpoint_test *test,
 	if (!pci_endpoint_test_request_irq(test))
 		goto err;
 
-	irq_type = req_irq_type;
 	return true;
 
 err:
 	pci_endpoint_test_free_irq_vectors(test);
-	irq_type = IRQ_TYPE_UNDEFINED;
 	return false;
 }
 
@@ -753,6 +758,7 @@ static int pci_endpoint_test_probe(struct pci_dev *pdev,
 	test->test_reg_bar = 0;
 	test->alignment = 0;
 	test->pdev = pdev;
+	test->irq_type = IRQ_TYPE_UNDEFINED;
 
 	if (no_msi)
 		irq_type = IRQ_TYPE_LEGACY;
-- 
2.17.1

