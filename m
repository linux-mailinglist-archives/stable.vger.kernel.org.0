Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82CBC15C96
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfEGFeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfEGFeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:34:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1AAF20B7C;
        Tue,  7 May 2019 05:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207258;
        bh=4WDsxqcuvjI5qV+O755VFvUqGwI8cZxOq1FN+sJQFBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKyIU31fuW8MYLVNqcjL9De5+cKCHRMaLt8Exm62W8sshW9IL+Z0CY9+2Tr9YQKPE
         MqwlSQDNw6p5vtLosL3uTgfOX+TnE6fn2ywwmzjEW07Hz0RYtV7MU0SBJd8zewAA7h
         Oz8ioPBcjFXwSyvPBtiruOAU0RrjEKV0Namw/zKI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Matthew Whitehead <tedheadster@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 55/99] scsi: aic7xxx: fix EISA support
Date:   Tue,  7 May 2019 01:31:49 -0400
Message-Id: <20190507053235.29900-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 144ec97493af34efdb77c5aba146e9c7de8d0a06 ]

Instead of relying on the now removed NULL argument to
pci_alloc_consistent, switch to the generic DMA API, and store the struct
device so that we can pass it.

Fixes: 4167b2ad5182 ("PCI: Remove NULL device handling from PCI DMA API")
Reported-by: Matthew Whitehead <tedheadster@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Matthew Whitehead <tedheadster@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic7770_osm.c     |  1 +
 drivers/scsi/aic7xxx/aic7xxx.h         |  1 +
 drivers/scsi/aic7xxx/aic7xxx_osm.c     | 10 ++++------
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |  1 +
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xxx/aic7770_osm.c
index 3d401d02c019..bdd177e3d762 100644
--- a/drivers/scsi/aic7xxx/aic7770_osm.c
+++ b/drivers/scsi/aic7xxx/aic7770_osm.c
@@ -91,6 +91,7 @@ aic7770_probe(struct device *dev)
 	ahc = ahc_alloc(&aic7xxx_driver_template, name);
 	if (ahc == NULL)
 		return (ENOMEM);
+	ahc->dev = dev;
 	error = aic7770_config(ahc, aic7770_ident_table + edev->id.driver_data,
 			       eisaBase);
 	if (error != 0) {
diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index 5614921b4041..88b90f9806c9 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -943,6 +943,7 @@ struct ahc_softc {
 	 * Platform specific device information.
 	 */
 	ahc_dev_softc_t		  dev_softc;
+	struct device		  *dev;
 
 	/*
 	 * Bus specific device information.
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 3c9c17450bb3..d5c4a0d23706 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -860,8 +860,8 @@ int
 ahc_dmamem_alloc(struct ahc_softc *ahc, bus_dma_tag_t dmat, void** vaddr,
 		 int flags, bus_dmamap_t *mapp)
 {
-	*vaddr = pci_alloc_consistent(ahc->dev_softc,
-				      dmat->maxsize, mapp);
+	/* XXX: check if we really need the GFP_ATOMIC and unwind this mess! */
+	*vaddr = dma_alloc_coherent(ahc->dev, dmat->maxsize, mapp, GFP_ATOMIC);
 	if (*vaddr == NULL)
 		return ENOMEM;
 	return 0;
@@ -871,8 +871,7 @@ void
 ahc_dmamem_free(struct ahc_softc *ahc, bus_dma_tag_t dmat,
 		void* vaddr, bus_dmamap_t map)
 {
-	pci_free_consistent(ahc->dev_softc, dmat->maxsize,
-			    vaddr, map);
+	dma_free_coherent(ahc->dev, dmat->maxsize, vaddr, map);
 }
 
 int
@@ -1123,8 +1122,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
 
 	host->transportt = ahc_linux_transport_template;
 
-	retval = scsi_add_host(host,
-			(ahc->dev_softc ? &ahc->dev_softc->dev : NULL));
+	retval = scsi_add_host(host, ahc->dev);
 	if (retval) {
 		printk(KERN_WARNING "aic7xxx: scsi_add_host failed\n");
 		scsi_host_put(host);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index 0fc14dac7070..717d8d1082ce 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -250,6 +250,7 @@ ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 	ahc->dev_softc = pci;
+	ahc->dev = &pci->dev;
 	error = ahc_pci_config(ahc, entry);
 	if (error != 0) {
 		ahc_free(ahc);
-- 
2.20.1

