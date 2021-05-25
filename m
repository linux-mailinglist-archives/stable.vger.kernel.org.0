Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD1238FB69
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 09:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhEYHKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 03:10:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:12209 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhEYHKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 03:10:46 -0400
IronPort-SDR: ppO/mFcyW2sChlbr/zJaoEp5rP11h1CKTt2y6iWvE+iFVJDQhFOltO9PNRNmIRQt4tHPiEI44g
 OXWNkYrb0Iug==
X-IronPort-AV: E=McAfee;i="6200,9189,9994"; a="201873219"
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="201873219"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 00:09:15 -0700
IronPort-SDR: iIczQ9IndJwmbqjdm5HijKU5CJYhyV8XEwn94htuR7VMBhW4FAw5eFMricF3xCntkpgrvvGho4
 +rss46TBw1IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="546452789"
Received: from allen-box.sh.intel.com ([10.239.159.105])
  by fmsmga001.fm.intel.com with ESMTP; 25 May 2021 00:09:09 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Rolf Eike Beer <eb@emlix.com>, iommu@lists.linux-foundation.org,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 1/1] iommu/vt-d: Fix sysfs leak in alloc_iommu()
Date:   Tue, 25 May 2021 15:08:02 +0800
Message-Id: <20210525070802.361755-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525070802.361755-1-baolu.lu@linux.intel.com>
References: <20210525070802.361755-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rolf Eike Beer <eb@emlix.com>

iommu_device_sysfs_add() is called before, so is has to be cleaned on subsequent
errors.

Fixes: 39ab9555c2411 ("iommu: Add sysfs bindings for struct iommu_device")
Cc: stable@vger.kernel.org # 4.11.x
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/17411490.HIIP88n32C@mobilepool36.emlix.com
---
 drivers/iommu/intel/dmar.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 1757ac1e1623..84057cb9596c 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1142,7 +1142,7 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 		err = iommu_device_register(&iommu->iommu, &intel_iommu_ops, NULL);
 		if (err)
-			goto err_unmap;
+			goto err_sysfs;
 	}
 
 	drhd->iommu = iommu;
@@ -1150,6 +1150,8 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 	return 0;
 
+err_sysfs:
+	iommu_device_sysfs_remove(&iommu->iommu);
 err_unmap:
 	unmap_iommu(iommu);
 error_free_seq_id:
-- 
2.25.1

