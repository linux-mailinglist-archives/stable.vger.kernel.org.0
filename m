Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6946D8228
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 17:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbjDEPkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 11:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238799AbjDEPku (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 11:40:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2365E64;
        Wed,  5 Apr 2023 08:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680709244; x=1712245244;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nl2OUQ7BdrvxDP7SzGL7J/lTrhswqlssdfXHqoQ7T2Y=;
  b=HNdR/K0UX/H18PtSAXdkH/ZJjp2WKPg7UjIz4ap1BT56TBBmGAz4Am9i
   qlsqCHoSrM+eBMYLCIPrKtTwMYQFT0F7e1j+W6LKBR+ukMv3z8ftkRvTe
   YlZxhqyZd9PeL59lSgbfV9j4rNMkTgRq3BD2RtCrAxUWQ+rHobDm4AHpi
   VIP2YpsT7v/JTyPNcP3MqAAHVYE1d49dB9sGX3l1l1GEpEr7yEFLbLnLs
   eWtEKmHgCqGZWKl07b6yc6urhs5U24ujOrahQKYQMvpRf5ecTqn5MAOtc
   EKN54L+rwqD5fbdmL+yW7KbvXBwPbuO9ZKTIhHyy8ZWK6NuSRS1dfKs7/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="341211063"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="341211063"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 08:40:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="664067673"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="664067673"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.106])
  by orsmga006.jf.intel.com with ESMTP; 05 Apr 2023 08:40:40 -0700
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
Subject: [PATCH v3] iommu/vt-d: Fix PASID directory pointer coherency
Date:   Wed,  5 Apr 2023 08:44:47 -0700
Message-Id: <20230405154447.2436308-1-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.6 required=5.0 tests=AC_FROM_MANY_DOTS,
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
v3: Add clflush after PASID directory allocation to prevent malicious
device attack with unauthorized PASIDs. Also flush all the PASID entries
after directory updates. (Baolu)
v2: Add clflush to PASID directory update case (Baolu, Kevin review)
---
 drivers/iommu/intel/iommu.c | 2 ++
 drivers/iommu/intel/pasid.c | 7 +++++++
 2 files changed, 9 insertions(+)

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

