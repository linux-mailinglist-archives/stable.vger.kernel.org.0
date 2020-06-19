Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DB920108D
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393824AbgFSPb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404800AbgFSPbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35EB620734;
        Fri, 19 Jun 2020 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580684;
        bh=Y/Lb5lAdvhdVexwD+MUXXAuDp4qFi/nlRnJwPonoEWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOgSIkGIJt/YnW8ihkhCogXvKNBg87CbpVoWWv6yX2axJwzs+hRDkn/sJiocvg+hN
         m1tKxA8KZPcpJzIE4tEJKjoAM4JmEgrCuWrnffZv7s4WaLrow4obVCvXoKAs6yoXg5
         fj2C79V0mRprL0RrpAP3S554DkSuadPLB24MM4w4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.7 313/376] iommu/vt-d: Only clear real DMA devices context entries
Date:   Fri, 19 Jun 2020 16:33:51 +0200
Message-Id: <20200619141725.153453612@linuxfoundation.org>
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

commit 8038bdb8553313ad53bfcffcf8294dd0ab44618f upstream.

Domain context mapping can encounter issues with sub-devices of a real
DMA device. A sub-device cannot have a valid context entry due to it
potentially aliasing another device's 16-bit ID. It's expected that
sub-devices of the real DMA device uses the real DMA device's requester
when context mapping.

This is an issue when a sub-device is removed where the context entry is
cleared for all aliases. Other sub-devices are still valid, resulting in
those sub-devices being stranded without valid context entries.

The correct approach is to use the real DMA device when programming the
context entries. The insertion path is correct because device_to_iommu()
will return the bus and devfn of the real DMA device. The removal path
needs to only operate on the real DMA device, otherwise the entire
context entry would be cleared for all sub-devices of the real DMA
device.

This patch also adds a helper to determine if a struct device is a
sub-device of a real DMA device.

Fixes: 2b0140c69637e ("iommu/vt-d: Use pci_real_dma_dev() for mapping")
Cc: stable@vger.kernel.org # v5.6+
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20200527165617.297470-2-jonathan.derrick@intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2582,6 +2582,12 @@ static int domain_setup_first_level(stru
 					     flags);
 }
 
+static bool dev_is_real_dma_subdevice(struct device *dev)
+{
+	return dev && dev_is_pci(dev) &&
+	       pci_real_dma_dev(to_pci_dev(dev)) != to_pci_dev(dev);
+}
+
 static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 						    int bus, int devfn,
 						    struct device *dev,
@@ -5286,7 +5292,8 @@ static void __dmar_remove_one_dev_info(s
 					PASID_RID2PASID);
 
 		iommu_disable_dev_iotlb(info);
-		domain_context_clear(iommu, info->dev);
+		if (!dev_is_real_dma_subdevice(info->dev))
+			domain_context_clear(iommu, info->dev);
 		intel_pasid_free_table(info->dev);
 	}
 


