Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4952C20108F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404840AbgFSPb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393831AbgFSPb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCC0520734;
        Fri, 19 Jun 2020 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580687;
        bh=833kXZhkHWjAmy2q4N3E99e/5HVlUHcfQIWFmZ+wuUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3Uz6LR4fuD1qs/alyYWWisK62yBnTEkXoRiH0Pia4jYmgGDwOGRGsnJ2Ppi32IVY
         fMsJs0eqRlLdNu3O071q8zAFDthXQaBSP222fRNGCwiZwgEv2LQwCEjTbM9gHoABeG
         oiuPbLUthS9qCxWxVmcGZOBiMVrc5P8nIc3Vgegw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.7 314/376] iommu/vt-d: Allocate domain info for real DMA sub-devices
Date:   Fri, 19 Jun 2020 16:33:52 +0200
Message-Id: <20200619141725.201170207@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit 4fda230ecddc2573ed88632e98b69b0b9b68c0ad upstream.

Sub-devices of a real DMA device might exist on a separate segment than
the real DMA device and its IOMMU. These devices should still have a
valid device_domain_info, but the current dma alias model won't
allocate info for the subdevice.

This patch adds a segment member to struct device_domain_info and uses
the sub-device's BDF so that these sub-devices won't alias to other
devices.

Fixes: 2b0140c69637e ("iommu/vt-d: Use pci_real_dma_dev() for mapping")
Cc: stable@vger.kernel.org # v5.6+
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20200527165617.297470-3-jonathan.derrick@intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   19 +++++++++++++++----
 include/linux/intel-iommu.h |    1 +
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2545,7 +2545,7 @@ dmar_search_domain_by_dev_info(int segme
 	struct device_domain_info *info;
 
 	list_for_each_entry(info, &device_domain_list, global)
-		if (info->iommu->segment == segment && info->bus == bus &&
+		if (info->segment == segment && info->bus == bus &&
 		    info->devfn == devfn)
 			return info;
 
@@ -2602,8 +2602,18 @@ static struct dmar_domain *dmar_insert_o
 	if (!info)
 		return NULL;
 
-	info->bus = bus;
-	info->devfn = devfn;
+	if (!dev_is_real_dma_subdevice(dev)) {
+		info->bus = bus;
+		info->devfn = devfn;
+		info->segment = iommu->segment;
+	} else {
+		struct pci_dev *pdev = to_pci_dev(dev);
+
+		info->bus = pdev->bus->number;
+		info->devfn = pdev->devfn;
+		info->segment = pci_domain_nr(pdev->bus);
+	}
+
 	info->ats_supported = info->pasid_supported = info->pri_supported = 0;
 	info->ats_enabled = info->pasid_enabled = info->pri_enabled = 0;
 	info->ats_qdep = 0;
@@ -2643,7 +2653,8 @@ static struct dmar_domain *dmar_insert_o
 
 	if (!found) {
 		struct device_domain_info *info2;
-		info2 = dmar_search_domain_by_dev_info(iommu->segment, bus, devfn);
+		info2 = dmar_search_domain_by_dev_info(info->segment, info->bus,
+						       info->devfn);
 		if (info2) {
 			found      = info2->domain;
 			info2->dev = dev;
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -571,6 +571,7 @@ struct device_domain_info {
 	struct list_head auxiliary_domains; /* auxiliary domains
 					     * attached to this device
 					     */
+	u32 segment;		/* PCI segment number */
 	u8 bus;			/* PCI bus number */
 	u8 devfn;		/* PCI devfn number */
 	u16 pfsid;		/* SRIOV physical function source ID */


