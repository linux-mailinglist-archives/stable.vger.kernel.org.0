Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D3B65827F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiL1QhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbiL1QgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:36:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579FA15FF9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:32:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1835B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615A4C433D2;
        Wed, 28 Dec 2022 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245164;
        bh=9PRQxaxbqSB2q5bDkJnQmXFkJCuAIYr0IKxrlRWnCz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWnuYx7YqCz/gdSUdoUOwRHCt0pmpkFSLCLg1KHzKBDNjZM+jo+SIeAnDeK/CWWyP
         mAVmWEETRvQOviSQmCuifJ1O4xIjxVqKkSbLU05RG7rs/Qch4mWM3tsZqyUO/Xk3dK
         OwpgIyW/9MAoIPzjKW07fS5jajsimzPI/8674EO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0808/1146] iommu/s390: Fix duplicate domain attachments
Date:   Wed, 28 Dec 2022 15:39:07 +0100
Message-Id: <20221228144352.099991654@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit bf8d2dd2ed0825a58f31cc510245a1eb46f8a87e ]

Since commit fa7e9ecc5e1c ("iommu/s390: Tolerate repeat attach_dev
calls") we can end up with duplicates in the list of devices attached to
a domain. This is inefficient and confusing since only one domain can
actually be in control of the IOMMU translations for a device. Fix this
by detaching the device from the previous domain, if any, on attach.
Add a WARN_ON() in case we still have attached devices on freeing the
domain. While here remove the re-attach on failure dance as it was
determined to be unlikely to help and may confuse debug and recovery.

Fixes: fa7e9ecc5e1c ("iommu/s390: Tolerate repeat attach_dev calls")
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Link: https://lore.kernel.org/r/20221025115657.1666860-2-schnelle@linux.ibm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/s390-iommu.c | 106 ++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 61 deletions(-)

diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 3c071782f6f1..c2e5e81d609e 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -79,10 +79,36 @@ static void s390_domain_free(struct iommu_domain *domain)
 {
 	struct s390_domain *s390_domain = to_s390_domain(domain);
 
+	WARN_ON(!list_empty(&s390_domain->devices));
 	dma_cleanup_tables(s390_domain->dma_table);
 	kfree(s390_domain);
 }
 
+static void __s390_iommu_detach_device(struct zpci_dev *zdev)
+{
+	struct s390_domain *s390_domain = zdev->s390_domain;
+	struct s390_domain_device *domain_device, *tmp;
+	unsigned long flags;
+
+	if (!s390_domain)
+		return;
+
+	spin_lock_irqsave(&s390_domain->list_lock, flags);
+	list_for_each_entry_safe(domain_device, tmp, &s390_domain->devices,
+				 list) {
+		if (domain_device->zdev == zdev) {
+			list_del(&domain_device->list);
+			kfree(domain_device);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&s390_domain->list_lock, flags);
+
+	zpci_unregister_ioat(zdev, 0);
+	zdev->s390_domain = NULL;
+	zdev->dma_table = NULL;
+}
+
 static int s390_iommu_attach_device(struct iommu_domain *domain,
 				    struct device *dev)
 {
@@ -90,7 +116,7 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	struct zpci_dev *zdev = to_zpci_dev(dev);
 	struct s390_domain_device *domain_device;
 	unsigned long flags;
-	int cc, rc;
+	int cc, rc = 0;
 
 	if (!zdev)
 		return -ENODEV;
@@ -99,24 +125,18 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	if (!domain_device)
 		return -ENOMEM;
 
-	if (zdev->dma_table && !zdev->s390_domain) {
-		cc = zpci_dma_exit_device(zdev);
-		if (cc) {
-			rc = -EIO;
-			goto out_free;
-		}
-	}
-
 	if (zdev->s390_domain)
-		zpci_unregister_ioat(zdev, 0);
+		__s390_iommu_detach_device(zdev);
+	else if (zdev->dma_table)
+		zpci_dma_exit_device(zdev);
 
-	zdev->dma_table = s390_domain->dma_table;
 	cc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
-				virt_to_phys(zdev->dma_table));
+				virt_to_phys(s390_domain->dma_table));
 	if (cc) {
 		rc = -EIO;
-		goto out_restore;
+		goto out_free;
 	}
+	zdev->dma_table = s390_domain->dma_table;
 
 	spin_lock_irqsave(&s390_domain->list_lock, flags);
 	/* First device defines the DMA range limits */
@@ -127,9 +147,9 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	/* Allow only devices with identical DMA range limits */
 	} else if (domain->geometry.aperture_start != zdev->start_dma ||
 		   domain->geometry.aperture_end != zdev->end_dma) {
-		rc = -EINVAL;
 		spin_unlock_irqrestore(&s390_domain->list_lock, flags);
-		goto out_restore;
+		rc = -EINVAL;
+		goto out_unregister;
 	}
 	domain_device->zdev = zdev;
 	zdev->s390_domain = s390_domain;
@@ -138,14 +158,9 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 
 	return 0;
 
-out_restore:
-	if (!zdev->s390_domain) {
-		zpci_dma_init_device(zdev);
-	} else {
-		zdev->dma_table = zdev->s390_domain->dma_table;
-		zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
-				   virt_to_phys(zdev->dma_table));
-	}
+out_unregister:
+	zpci_unregister_ioat(zdev, 0);
+	zdev->dma_table = NULL;
 out_free:
 	kfree(domain_device);
 
@@ -155,32 +170,12 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 static void s390_iommu_detach_device(struct iommu_domain *domain,
 				     struct device *dev)
 {
-	struct s390_domain *s390_domain = to_s390_domain(domain);
 	struct zpci_dev *zdev = to_zpci_dev(dev);
-	struct s390_domain_device *domain_device, *tmp;
-	unsigned long flags;
-	int found = 0;
 
-	if (!zdev)
-		return;
+	WARN_ON(zdev->s390_domain != to_s390_domain(domain));
 
-	spin_lock_irqsave(&s390_domain->list_lock, flags);
-	list_for_each_entry_safe(domain_device, tmp, &s390_domain->devices,
-				 list) {
-		if (domain_device->zdev == zdev) {
-			list_del(&domain_device->list);
-			kfree(domain_device);
-			found = 1;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&s390_domain->list_lock, flags);
-
-	if (found && (zdev->s390_domain == s390_domain)) {
-		zdev->s390_domain = NULL;
-		zpci_unregister_ioat(zdev, 0);
-		zpci_dma_init_device(zdev);
-	}
+	__s390_iommu_detach_device(zdev);
+	zpci_dma_init_device(zdev);
 }
 
 static struct iommu_device *s390_iommu_probe_device(struct device *dev)
@@ -198,24 +193,13 @@ static struct iommu_device *s390_iommu_probe_device(struct device *dev)
 static void s390_iommu_release_device(struct device *dev)
 {
 	struct zpci_dev *zdev = to_zpci_dev(dev);
-	struct iommu_domain *domain;
 
 	/*
-	 * This is a workaround for a scenario where the IOMMU API common code
-	 * "forgets" to call the detach_dev callback: After binding a device
-	 * to vfio-pci and completing the VFIO_SET_IOMMU ioctl (which triggers
-	 * the attach_dev), removing the device via
-	 * "echo 1 > /sys/bus/pci/devices/.../remove" won't trigger detach_dev,
-	 * only release_device will be called via the BUS_NOTIFY_REMOVED_DEVICE
-	 * notifier.
-	 *
-	 * So let's call detach_dev from here if it hasn't been called before.
+	 * release_device is expected to detach any domain currently attached
+	 * to the device, but keep it attached to other devices in the group.
 	 */
-	if (zdev && zdev->s390_domain) {
-		domain = iommu_get_domain_for_dev(dev);
-		if (domain)
-			s390_iommu_detach_device(domain, dev);
-	}
+	if (zdev)
+		__s390_iommu_detach_device(zdev);
 }
 
 static int s390_iommu_update_trans(struct s390_domain *s390_domain,
-- 
2.35.1



