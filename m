Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD9756C7E0
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 10:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiGIIOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 04:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiGIIOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 04:14:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AAB7479E
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 01:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1939DB810C5
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 08:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E95FC3411C;
        Sat,  9 Jul 2022 08:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657354471;
        bh=2Vf4BKodY1tbuAy+w8RrXIxFeBRROFpn0ZPm08yVWq0=;
        h=Subject:To:Cc:From:Date:From;
        b=Umy2B/S6nWuE1elIwF2dkj6K5F5m4+e6WI+Mvi9B0hyNVlOJq0VKD6KMAsig1qSaO
         NtUW3lSE4DqZTNmhRQrRpyozmkfAkinojxeoxq6YDRDAL9xUPnD5gk3YO5P0x/yKG1
         zId8WGb488f1CadcLbEycX0t16VcR9Vzq6SLm4Xs=
Subject: FAILED: patch "[PATCH] iommu/vt-d: Fix RID2PASID setup/teardown failure" failed to apply to 5.4-stable tree
To:     baolu.lu@linux.intel.com, chenyi.qiang@intel.com,
        haifeng.zhao@linux.intel.com, jroedel@suse.de, kevin.tian@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 09 Jul 2022 10:14:14 +0200
Message-ID: <16573544542069@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4140d77a022101376bbfa3ec3e3da5063455c60e Mon Sep 17 00:00:00 2001
From: Lu Baolu <baolu.lu@linux.intel.com>
Date: Sat, 25 Jun 2022 21:34:30 +0800
Subject: [PATCH] iommu/vt-d: Fix RID2PASID setup/teardown failure

The IOMMU driver shares the pasid table for PCI alias devices. When the
RID2PASID entry of the shared pasid table has been filled by the first
device, the subsequent device will encounter the "DMAR: Setup RID2PASID
failed" failure as the pasid entry has already been marked as present.
As the result, the IOMMU probing process will be aborted.

On the contrary, when any alias device is hot-removed from the system,
for example, by writing to /sys/bus/pci/devices/.../remove, the shared
RID2PASID will be cleared without any notifications to other devices.
As the result, any DMAs from those rest devices are blocked.

Sharing pasid table among PCI alias devices could save two memory pages
for devices underneath the PCIe-to-PCI bridges. Anyway, considering that
those devices are rare on modern platforms that support VT-d in scalable
mode and the saved memory is negligible, it's reasonable to remove this
part of immature code to make the driver feasible and stable.

Fixes: ef848b7e5a6a0 ("iommu/vt-d: Setup pasid entry for RID2PASID support")
Reported-by: Chenyi Qiang <chenyi.qiang@intel.com>
Reported-by: Ethan Zhao <haifeng.zhao@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Ethan Zhao <haifeng.zhao@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220623065720.727849-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20220625133430.2200315-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 44016594831d..5c0dce78586a 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -320,30 +320,6 @@ EXPORT_SYMBOL_GPL(intel_iommu_gfx_mapped);
 DEFINE_SPINLOCK(device_domain_lock);
 static LIST_HEAD(device_domain_list);
 
-/*
- * Iterate over elements in device_domain_list and call the specified
- * callback @fn against each element.
- */
-int for_each_device_domain(int (*fn)(struct device_domain_info *info,
-				     void *data), void *data)
-{
-	int ret = 0;
-	unsigned long flags;
-	struct device_domain_info *info;
-
-	spin_lock_irqsave(&device_domain_lock, flags);
-	list_for_each_entry(info, &device_domain_list, global) {
-		ret = fn(info, data);
-		if (ret) {
-			spin_unlock_irqrestore(&device_domain_lock, flags);
-			return ret;
-		}
-	}
-	spin_unlock_irqrestore(&device_domain_lock, flags);
-
-	return 0;
-}
-
 const struct iommu_ops intel_iommu_ops;
 
 static bool translation_pre_enabled(struct intel_iommu *iommu)
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index cb4c1d0cf25c..17cad7c1f62d 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -86,54 +86,6 @@ void vcmd_free_pasid(struct intel_iommu *iommu, u32 pasid)
 /*
  * Per device pasid table management:
  */
-static inline void
-device_attach_pasid_table(struct device_domain_info *info,
-			  struct pasid_table *pasid_table)
-{
-	info->pasid_table = pasid_table;
-	list_add(&info->table, &pasid_table->dev);
-}
-
-static inline void
-device_detach_pasid_table(struct device_domain_info *info,
-			  struct pasid_table *pasid_table)
-{
-	info->pasid_table = NULL;
-	list_del(&info->table);
-}
-
-struct pasid_table_opaque {
-	struct pasid_table	**pasid_table;
-	int			segment;
-	int			bus;
-	int			devfn;
-};
-
-static int search_pasid_table(struct device_domain_info *info, void *opaque)
-{
-	struct pasid_table_opaque *data = opaque;
-
-	if (info->iommu->segment == data->segment &&
-	    info->bus == data->bus &&
-	    info->devfn == data->devfn &&
-	    info->pasid_table) {
-		*data->pasid_table = info->pasid_table;
-		return 1;
-	}
-
-	return 0;
-}
-
-static int get_alias_pasid_table(struct pci_dev *pdev, u16 alias, void *opaque)
-{
-	struct pasid_table_opaque *data = opaque;
-
-	data->segment = pci_domain_nr(pdev->bus);
-	data->bus = PCI_BUS_NUM(alias);
-	data->devfn = alias & 0xff;
-
-	return for_each_device_domain(&search_pasid_table, data);
-}
 
 /*
  * Allocate a pasid table for @dev. It should be called in a
@@ -143,28 +95,18 @@ int intel_pasid_alloc_table(struct device *dev)
 {
 	struct device_domain_info *info;
 	struct pasid_table *pasid_table;
-	struct pasid_table_opaque data;
 	struct page *pages;
 	u32 max_pasid = 0;
-	int ret, order;
-	int size;
+	int order, size;
 
 	might_sleep();
 	info = dev_iommu_priv_get(dev);
 	if (WARN_ON(!info || !dev_is_pci(dev) || info->pasid_table))
 		return -EINVAL;
 
-	/* DMA alias device already has a pasid table, use it: */
-	data.pasid_table = &pasid_table;
-	ret = pci_for_each_dma_alias(to_pci_dev(dev),
-				     &get_alias_pasid_table, &data);
-	if (ret)
-		goto attach_out;
-
 	pasid_table = kzalloc(sizeof(*pasid_table), GFP_KERNEL);
 	if (!pasid_table)
 		return -ENOMEM;
-	INIT_LIST_HEAD(&pasid_table->dev);
 
 	if (info->pasid_supported)
 		max_pasid = min_t(u32, pci_max_pasids(to_pci_dev(dev)),
@@ -182,9 +124,7 @@ int intel_pasid_alloc_table(struct device *dev)
 	pasid_table->table = page_address(pages);
 	pasid_table->order = order;
 	pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
-
-attach_out:
-	device_attach_pasid_table(info, pasid_table);
+	info->pasid_table = pasid_table;
 
 	return 0;
 }
@@ -202,10 +142,7 @@ void intel_pasid_free_table(struct device *dev)
 		return;
 
 	pasid_table = info->pasid_table;
-	device_detach_pasid_table(info, pasid_table);
-
-	if (!list_empty(&pasid_table->dev))
-		return;
+	info->pasid_table = NULL;
 
 	/* Free scalable mode PASID directory tables: */
 	dir = pasid_table->table;
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 583ea67fc783..bf5b937848b4 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -74,7 +74,6 @@ struct pasid_table {
 	void			*table;		/* pasid table pointer */
 	int			order;		/* page order of pasid table */
 	u32			max_pasid;	/* max pasid */
-	struct list_head	dev;		/* device list */
 };
 
 /* Get PRESENT bit of a PASID directory entry. */
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 4f29139bbfc3..5fcf89faa31a 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -612,7 +612,6 @@ struct intel_iommu {
 struct device_domain_info {
 	struct list_head link;	/* link to domain siblings */
 	struct list_head global; /* link to global list */
-	struct list_head table;	/* link to pasid table */
 	u32 segment;		/* PCI segment number */
 	u8 bus;			/* PCI bus number */
 	u8 devfn;		/* PCI devfn number */
@@ -729,8 +728,6 @@ extern int dmar_ir_support(void);
 void *alloc_pgtable_page(int node);
 void free_pgtable_page(void *vaddr);
 struct intel_iommu *domain_get_iommu(struct dmar_domain *domain);
-int for_each_device_domain(int (*fn)(struct device_domain_info *info,
-				     void *data), void *data);
 void iommu_flush_write_buffer(struct intel_iommu *iommu);
 int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct device *dev);
 struct intel_iommu *device_to_iommu(struct device *dev, u8 *bus, u8 *devfn);

