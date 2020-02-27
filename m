Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54CD171C73
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388785AbgB0OMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:12:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388052AbgB0OMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:12:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3C3824697;
        Thu, 27 Feb 2020 14:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812726;
        bh=63t+dcbRQP2Tl3GMNI+Ooh16wCL0rbWIF1ffSXgbeIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjocaSb/0yQirVVCHFGln3VQzdgMm2yavZIjq1k1qGkwhICVBn6QwUF4kDTACqTgf
         pPCVbPqckVvsbNojnIMaHAJcgGwvXGlIx6BMqpL+kLneb8Ove2+yaH1auJDWBQmxTj
         CI5kGkBmO9eRUsjJ+17cUUmVFFVYOcDYekjlO424=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 128/135] ata: ahci: Add shutdown to freeze hardware resources of ahci
Date:   Thu, 27 Feb 2020 14:37:48 +0100
Message-Id: <20200227132248.298321023@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prabhakar Kushwaha <pkushwaha@marvell.com>

commit 10a663a1b15134a5a714aa515e11425a44d4fdf7 upstream.

device_shutdown() called from reboot or power_shutdown expect
all devices to be shutdown. Same is true for even ahci pci driver.
As no ahci shutdown function is implemented, the ata subsystem
always remains alive with DMA & interrupt support. File system
related calls should not be honored after device_shutdown().

So defining ahci pci driver shutdown to freeze hardware (mask
interrupt, stop DMA engine and free DMA resources).

Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c        |    7 +++++++
 drivers/ata/libata-core.c |   21 +++++++++++++++++++++
 include/linux/libata.h    |    1 +
 3 files changed, 29 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -80,6 +80,7 @@ enum board_ids {
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void ahci_remove_one(struct pci_dev *dev);
+static void ahci_shutdown_one(struct pci_dev *dev);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_avn_hardreset(struct ata_link *link, unsigned int *class,
@@ -593,6 +594,7 @@ static struct pci_driver ahci_pci_driver
 	.id_table		= ahci_pci_tbl,
 	.probe			= ahci_init_one,
 	.remove			= ahci_remove_one,
+	.shutdown		= ahci_shutdown_one,
 	.driver = {
 		.pm		= &ahci_pci_pm_ops,
 	},
@@ -1864,6 +1866,11 @@ static int ahci_init_one(struct pci_dev
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
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6762,6 +6762,26 @@ void ata_pci_remove_one(struct pci_dev *
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
@@ -7382,6 +7402,7 @@ EXPORT_SYMBOL_GPL(ata_timing_cycle2mode)
 
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(pci_test_config_bits);
+EXPORT_SYMBOL_GPL(ata_pci_shutdown_one);
 EXPORT_SYMBOL_GPL(ata_pci_remove_one);
 #ifdef CONFIG_PM
 EXPORT_SYMBOL_GPL(ata_pci_device_do_suspend);
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1220,6 +1220,7 @@ struct pci_bits {
 };
 
 extern int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits);
+extern void ata_pci_shutdown_one(struct pci_dev *pdev);
 extern void ata_pci_remove_one(struct pci_dev *pdev);
 
 #ifdef CONFIG_PM


