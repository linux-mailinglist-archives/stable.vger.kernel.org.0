Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6F51A5128
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgDKMS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbgDKMS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:18:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4DDF20644;
        Sat, 11 Apr 2020 12:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607508;
        bh=hQq4/2IUwhKsfKjyetL5rzpycBjCErULnw/zE+/xxdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHn4BmV1MqcUMWsa98PiJBHarQKgdeiYU8BCLkpv/tMqOFEhEGaAN937MnXFi0IDU
         Jjmi/+p+OXAqHUjETu+SZ8SYrrsZf7EXruMiZSKkMlKENQP7wEzRV6yHLPXioGJAkA
         NLl+PAEkKHy7xfq2mXV3UHpAtaqFJsMe4MgAvyZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        John Donnelly <john.p.donnelly@oracle.com>
Subject: [PATCH 5.4 41/41] iommu/vt-d: Allow devices with RMRRs to use identity domain
Date:   Sat, 11 Apr 2020 14:09:50 +0200
Message-Id: <20200411115507.145593561@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 9235cb13d7d17baba0b3a9277381258361e95c16 upstream.

Since commit ea2447f700cab ("intel-iommu: Prevent devices with
RMRRs from being placed into SI Domain"), the Intel IOMMU driver
doesn't allow any devices with RMRR locked to use the identity
domain. This was added to to fix the issue where the RMRR info
for devices being placed in and out of the identity domain gets
lost. This identity maps all RMRRs when setting up the identity
domain, so that devices with RMRRs could also use it.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: John Donnelly <john.p.donnelly@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2762,10 +2762,8 @@ static int __init si_domain_init(int hw)
 	}
 
 	/*
-	 * Normally we use DMA domains for devices which have RMRRs. But we
-	 * loose this requirement for graphic and usb devices. Identity map
-	 * the RMRRs for graphic and USB devices so that they could use the
-	 * si_domain.
+	 * Identity map the RMRRs so that devices with RMRRs could also use
+	 * the si_domain.
 	 */
 	for_each_rmrr_units(rmrr) {
 		for_each_active_dev_scope(rmrr->devices, rmrr->devices_cnt,
@@ -2773,9 +2771,6 @@ static int __init si_domain_init(int hw)
 			unsigned long long start = rmrr->base_address;
 			unsigned long long end = rmrr->end_address;
 
-			if (device_is_rmrr_locked(dev))
-				continue;
-
 			if (WARN_ON(end < start ||
 				    end >> agaw_to_width(si_domain->agaw)))
 				continue;
@@ -2914,9 +2909,6 @@ static int device_def_domain_type(struct
 	if (dev_is_pci(dev)) {
 		struct pci_dev *pdev = to_pci_dev(dev);
 
-		if (device_is_rmrr_locked(dev))
-			return IOMMU_DOMAIN_DMA;
-
 		/*
 		 * Prevent any device marked as untrusted from getting
 		 * placed into the statically identity mapping domain.
@@ -2954,9 +2946,6 @@ static int device_def_domain_type(struct
 				return IOMMU_DOMAIN_DMA;
 		} else if (pci_pcie_type(pdev) == PCI_EXP_TYPE_PCI_BRIDGE)
 			return IOMMU_DOMAIN_DMA;
-	} else {
-		if (device_has_rmrr(dev))
-			return IOMMU_DOMAIN_DMA;
 	}
 
 	return (iommu_identity_mapping & IDENTMAP_ALL) ?


