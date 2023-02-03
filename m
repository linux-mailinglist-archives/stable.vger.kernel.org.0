Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0534568A524
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 23:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjBCWDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 17:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbjBCWDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 17:03:42 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEA1945ED;
        Fri,  3 Feb 2023 14:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675461822; x=1706997822;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cskhf8vcDlJ5KLsoC6Xpt8pWGcbFmVNKlwLnbgeY8uI=;
  b=V4bIHfVAugkLqMVD+HNa1mRbMBSxBwPLAGkQImFFInsLPzi+m0H3mZAu
   tB2NAbrFeiHHY8hkpLI71M5YOirbci9s1zSJZpFNOiuvFCTAmtLZ8WS+f
   uf4WBGKvZR1Mxh8Si2mHHql3Abxc8WHb185e/taGgxH6VS2dACs6skE2s
   gDK1HMrVttFiGdwIYePMct/ejAbd2d25De6RSDJ9WKgCChUgBWSSyDEnC
   fq5t9yEl5zKk/yzT3ugVgmXie9L/qAPs8EyW1c6i9/xoI+xNNkg69jHSw
   ORcbUQy4ByUmIk/mH262nbcHvrPszN1bnXtPZIm9FTh1HtXEu+ouGFe1v
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="309202205"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="309202205"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 14:03:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="839742743"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="839742743"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.106])
  by orsmga005.jf.intel.com with ESMTP; 03 Feb 2023 14:03:41 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        stable@vger.kernel.org, Sukumar Ghorai <sukumar.ghorai@intel.com>
Subject: [PATCH] iommu/vt-d: Fix PASID directory pointer coherency
Date:   Fri,  3 Feb 2023 14:07:14 -0800
Message-Id: <20230203220714.1283383-1-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
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

This patch adds a clflush when activating a PASID table directory.
There's no need to do clflush of the PASID directory pointer when we
deactivate a context entry in that IOMMU hardware will not see the old
PASID directory pointer after we clear the context entry.

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
Reported-by: Sukumar Ghorai <sukumar.ghorai@intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/iommu/intel/iommu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 59df7e42fd53..b4878c7ac008 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1976,6 +1976,12 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 		pds = context_get_sm_pds(table);
 		context->lo = (u64)virt_to_phys(table->table) |
 				context_pdts(pds);
+		/*
+		 * Scalable-mode PASID directory pointer is not snooped if the
+		 * coherent bit is not set.
+		 */
+		if (!ecap_coherent(iommu->ecap))
+			clflush_cache_range(table->table, sizeof(void *));
 
 		/* Setup the RID_PASID field: */
 		context_set_sm_rid2pasid(context, PASID_RID2PASID);
-- 
2.25.1

