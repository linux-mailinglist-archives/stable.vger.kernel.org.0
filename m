Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF5268E4B9
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 01:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjBHAGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 19:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBHAGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 19:06:10 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B51722DF5;
        Tue,  7 Feb 2023 16:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675814768; x=1707350768;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uSdHRfD6AiZHMGzCoEYInID5tWtuf+3f7a2uyKj5dL4=;
  b=H4GpKNk3umklU1aqTgV+/p23/Y3WazbFmyAsTG5z4UQNaGLkYhqeOZVZ
   wb7s3Yco6sfXYUBSMrC+mXN+/0jvAq5GS4VdLFDcVm7V6CqhOcF0QEbGp
   xFOpr+OH6kYDZctyEJ8ItqvpZjCJ8AGLHbPovN4i8EQI8Zxl0dr1hlgdH
   o+7454deTXfyfLRet27HbSOwyzGOvOHOT0vp+GMB7nTVLnml4VtsBk8Nm
   b6dtP+CQsyMr7Uuno0oJnmncM0DHLqxkU6SkvpITaftLV6cOOhgIcn5Y0
   q5f0sUC65ChkHNcf+OFpuU9e2ahH/a8e9AZUZSxN1y6tsVh9hcGLUEs0c
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="331794383"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="331794383"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 16:06:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="697462684"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="697462684"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.106])
  by orsmga008.jf.intel.com with ESMTP; 07 Feb 2023 16:06:02 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "Robin Murphy" <robin.murphy@arm.com>,
        "Will Deacon" <will@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        stable@vger.kernel.org, Sukumar Ghorai <sukumar.ghorai@intel.com>
Subject: [PATCH v2] iommu/vt-d: Fix PASID directory pointer coherency
Date:   Tue,  7 Feb 2023 16:09:37 -0800
Message-Id: <20230208000938.1527079-1-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On platforms that do not support IOMMU Extended capability bit 0
Page-walk Coherency, CPU caches are not snooped when IOMMU is accessing
any translation structures. IOMMU access goes only directly to
memory. Intel IOMMU code was missing a flush for the PASID table
directory that resulted in the unrecoverable fault as shown below.

This patch adds clflush calls whenever activating and updating
a PASID table directory to ensure cache coherency.

On the reverse direction, there's no need to clflush the PASID directory
pointer when we deactivate a context entry in that IOMMU hardware will
not see the old PASID directory pointer after we clear the context entry.
PASID directory entries are also never freed once allocated.

[    0.555386] DMAR: DRHD: handling fault status reg 3
[    0.555805] DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault addr 0x1026a4000 [fault reason 0x51] SM: Present bit in Directory Entry is clear
[    0.556348] DMAR: Dump dmar1 table entries for IOVA 0x1026a4000
[    0.556348] DMAR: scalable mode root entry: hi 0x0000000102448001, low 0x0000000101b3e001
[    0.556348] DMAR: context entry: hi 0x0000000000000000, low 0x0000000101b4d401
[    0.556348] DMAR: pasid dir entry: 0x0000000101b4e001
[    0.556348] DMAR: pasid table entry[0]: 0x0000000000000109
[    0.556348] DMAR: pasid table entry[1]: 0x0000000000000001
[    0.556348] DMAR: pasid table entry[2]: 0x0000000000000000
[    0.556348] DMAR: pasid table entry[3]: 0x0000000000000000
[    0.556348] DMAR: pasid table entry[4]: 0x0000000000000000
[    0.556348] DMAR: pasid table entry[5]: 0x0000000000000000
[    0.556348] DMAR: pasid table entry[6]: 0x0000000000000000
[    0.556348] DMAR: pasid table entry[7]: 0x0000000000000000
[    0.556348] DMAR: PTE not present at level 4

Cc: <stable@vger.kernel.org>
Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
Reported-by: Sukumar Ghorai <sukumar.ghorai@intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
v2: Add clflush to PASID directory update case (Baolu, Kevin review)
---
 drivers/iommu/intel/iommu.c | 2 ++
 drivers/iommu/intel/pasid.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 59df7e42fd53..161342e7149d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1976,6 +1976,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 		pds = context_get_sm_pds(table);
 		context->lo = (u64)virt_to_phys(table->table) |
 				context_pdts(pds);
+		if (!ecap_coherent(iommu->ecap))
+			clflush_cache_range(table->table, sizeof(u64));
 
 		/* Setup the RID_PASID field: */
 		context_set_sm_rid2pasid(context, PASID_RID2PASID);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index fb3c7020028d..bcb2e6f23742 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -216,6 +216,8 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 			goto retry;
 		}
 	}
+	if (!ecap_coherent(info->iommu->ecap))
+		clflush_cache_range(&dir[dir_index], sizeof(u64));
 
 	return &entries[index];
 }
-- 
2.25.1

