Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E185E161EF4
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 03:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgBRC2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 21:28:11 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40768 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726212AbgBRC2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 21:28:10 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01I2L2pR020852;
        Mon, 17 Feb 2020 18:28:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=9S/62iFbZXQGTKH/5cKgXdmg2Hil7VJZCacZAEe2O7o=;
 b=feb+q9y2yoXxX3pDVfJZSY7fCV+Py2COaAiRpCD7MOruCxVehdEXx8zSRsWmsK+Q8Gvw
 qseTBgrmSG8v66zB8YmBLfLyczQbMg4/r6nhA0WSoNELxTpzbGRlEyrx2n/8AI82SA/3
 B2MAzhf60DblioFkW5z62aoBbDagNoP0MSRMYL8f+XNdBvIRvtkhP6UtHiGbwl/rzX0P
 nq+oYhRQKXauOWJdJaPnWcrjBI62/FI1hmOCbfFKMV/2fbgc9fVrjdQp+p3002ScJgg4
 Hk8NA101JaxrEtBAeOm2gR0f26R0WaGaMgtri8Yh9Qc/BHpZJX32rmC4Sx+QiCwLctZf rw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y6h1t185p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 18:28:08 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 Feb
 2020 18:28:06 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 17 Feb 2020 18:28:07 -0800
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id EEF863F7040;
        Mon, 17 Feb 2020 18:28:06 -0800 (PST)
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <stable@vger.kernel.org>, <axboe@kernel.dk>
CC:     <gkulkarni@marvell.com>, <kamlakantp@marvell.com>,
        <prabhakar.pkin@gmail.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: [RESEND][PATCH] ata: ahci: Add shutdown to freeze hardware resources of ahci
Date:   Mon, 17 Feb 2020 18:28:02 -0800
Message-ID: <1581992882-22134-1-git-send-email-pkushwaha@marvell.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_14:2020-02-17,2020-02-17 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

device_shutdown() called from reboot or power_shutdown expect
all devices to be shutdown. Same is true for even ahci pci driver.
As no ahci shutdown function is implemented, the ata subsystem
always remains alive with DMA & interrupt support. File system
related calls should not be honored after device_shutdown().

So defining ahci pci driver shutdown to freeze hardware (mask
interrupt, stop DMA engine and free DMA resources).

Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---

This problem has also been seen on older kernel. So sending to stable@vger.kernel.org 
Note: It is already applied to git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
with commit id: 10a663a1b151 ("ata: ahci: Add shutdown to freeze hardware resources of ahci")

 drivers/ata/ahci.c        |  7 +++++++
 drivers/ata/libata-core.c | 21 +++++++++++++++++++++
 include/linux/libata.h    |  1 +
 3 files changed, 29 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4bfd1b14b390..11ea1aff40db 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -81,6 +81,7 @@ enum board_ids {
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void ahci_remove_one(struct pci_dev *dev);
+static void ahci_shutdown_one(struct pci_dev *dev);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_avn_hardreset(struct ata_link *link, unsigned int *class,
@@ -606,6 +607,7 @@ static struct pci_driver ahci_pci_driver = {
 	.id_table		= ahci_pci_tbl,
 	.probe			= ahci_init_one,
 	.remove			= ahci_remove_one,
+	.shutdown		= ahci_shutdown_one,
 	.driver = {
 		.pm		= &ahci_pci_pm_ops,
 	},
@@ -1877,6 +1879,11 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 }
 
+static void ahci_shutdown_one(struct pci_dev *pdev)
+{
+	ata_pci_shutdown_one(pdev);
+}
+
 static void ahci_remove_one(struct pci_dev *pdev)
 {
 	pm_runtime_get_noresume(&pdev->dev);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6f4ab5c5b52d..42c8728f6117 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6767,6 +6767,26 @@ void ata_pci_remove_one(struct pci_dev *pdev)
 	ata_host_detach(host);
 }
 
+void ata_pci_shutdown_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = pci_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		ap->pflags |= ATA_PFLAG_FROZEN;
+
+		/* Disable port interrupts */
+		if (ap->ops->freeze)
+			ap->ops->freeze(ap);
+
+		/* Stop the port DMA engines */
+		if (ap->ops->port_stop)
+			ap->ops->port_stop(ap);
+	}
+}
+
 /* move to PCI subsystem */
 int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits)
 {
@@ -7387,6 +7407,7 @@ EXPORT_SYMBOL_GPL(ata_timing_cycle2mode);
 
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(pci_test_config_bits);
+EXPORT_SYMBOL_GPL(ata_pci_shutdown_one);
 EXPORT_SYMBOL_GPL(ata_pci_remove_one);
 #ifdef CONFIG_PM
 EXPORT_SYMBOL_GPL(ata_pci_device_do_suspend);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2dbde119721d..bff539918d82 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1221,6 +1221,7 @@ struct pci_bits {
 };
 
 extern int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits);
+extern void ata_pci_shutdown_one(struct pci_dev *pdev);
 extern void ata_pci_remove_one(struct pci_dev *pdev);
 
 #ifdef CONFIG_PM
-- 
2.17.1

