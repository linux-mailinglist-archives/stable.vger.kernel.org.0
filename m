Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0563F69129A
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 22:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBIVZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 16:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBIVZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 16:25:08 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B227828D28;
        Thu,  9 Feb 2023 13:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675977907; x=1707513907;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N6Ck+USojABOxT9CFzTEfdxuALT4Xbd+KeJGB455nkw=;
  b=GV1Vkces7Ea5HL+w4T7xpxMfsFWu5fYwpOjBqbS+dNZpb+RcLpvvqYfD
   Z/8pFKznBgnUj674iMTD7S/21NdGQJ2gFsQUMUW5BzZA7qTo9Qj83br1q
   xeu5woBw0ZZwABmPKNXg76FHqN0Cq5wOxOL6s4EPvj5pfDmMzwTBYUNjJ
   YL8MXY4+NPCyj9DucKeoQIFJU/KVPXUXS69tPTlTiGt66yOmCNSKLnGCQ
   ahsJskKcYWLIPQQuEMot01DiMzZMzTybOJ8sIFsA4mNxP17P+/Nf+AOeh
   bWhZ9RQqZkSA73V3x700RwruiwGk/78Xz3AWNDchWdZUGaV8AQM7x2fd8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="327943073"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="327943073"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 13:25:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="617678462"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="617678462"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.106])
  by orsmga003.jf.intel.com with ESMTP; 09 Feb 2023 13:25:06 -0800
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
Subject: [PATCH v4] iommu/vt-d: Fix PASID directory pointer coherency
Date:   Thu,  9 Feb 2023 13:28:43 -0800
Message-Id: <20230209212843.1788125-1-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

This patch adds clflush calls whenever allocating and updating
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
v4: Remove clflush PASID dir pointer when programming context entry
v3: Add clflush after PASID directory allocation to prevent malicious
device attack with unauthorized PASIDs. Also flush all the PASID entries
after directory updates. (Baolu)
v2: Add clflush to PASID directory update case (Baolu, Kevin review)
---
 drivers/iommu/intel/pasid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index fb3c7020028d..979f796175b1 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -128,6 +128,9 @@ int intel_pasid_alloc_table(struct device *dev)
 	pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
 	info->pasid_table = pasid_table;
 
+	if (!ecap_coherent(info->iommu->ecap))
+		clflush_cache_range(pasid_table->table, size);
+
 	return 0;
 }
 
@@ -215,6 +218,10 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 			free_pgtable_page(entries);
 			goto retry;
 		}
+		if (!ecap_coherent(info->iommu->ecap)) {
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
+		}
 	}
 
 	return &entries[index];
-- 
2.25.1

