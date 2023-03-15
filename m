Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FC46BB068
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbjCOMSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjCOMRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D062893853
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60D5A61ABD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74132C4339B;
        Wed, 15 Mar 2023 12:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882664;
        bh=LrHvDUEyQ4Y6Mmnru21kjjexq3B4FWirhy5VAWsbcAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MN/g2evUk7VhBwUgeXybXIpQQw07Jo3bKmi7YvRsNk4fOVRjq5XzTZj79Spyp4Odt
         EGfVnuABeGrHTyA5HKJ61CDxCUdL+kF9Op2JR67reTPXx8I9VEJRVzTa4wQcItDhZu
         ySffi1smCfLEKNt80W0jmRsdUSg7Jgle23c2M1V8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/68] iommu/vt-d: Fix PASID directory pointer coherency
Date:   Wed, 15 Mar 2023 13:12:18 +0100
Message-Id: <20230315115727.039525836@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit 194b3348bdbb7db65375c72f3f774aee4cc6614e ]

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

 DMAR: DRHD: handling fault status reg 3
 DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault addr 0x1026a4000
       [fault reason 0x51] SM: Present bit in Directory Entry is clear
 DMAR: Dump dmar1 table entries for IOVA 0x1026a4000
 DMAR: scalable mode root entry: hi 0x0000000102448001, low 0x0000000101b3e001
 DMAR: context entry: hi 0x0000000000000000, low 0x0000000101b4d401
 DMAR: pasid dir entry: 0x0000000101b4e001
 DMAR: pasid table entry[0]: 0x0000000000000109
 DMAR: pasid table entry[1]: 0x0000000000000001
 DMAR: pasid table entry[2]: 0x0000000000000000
 DMAR: pasid table entry[3]: 0x0000000000000000
 DMAR: pasid table entry[4]: 0x0000000000000000
 DMAR: pasid table entry[5]: 0x0000000000000000
 DMAR: pasid table entry[6]: 0x0000000000000000
 DMAR: pasid table entry[7]: 0x0000000000000000
 DMAR: PTE not present at level 4

Cc: <stable@vger.kernel.org>
Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: Sukumar Ghorai <sukumar.ghorai@intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Link: https://lore.kernel.org/r/20230209212843.1788125-1-jacob.jun.pan@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-pasid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/intel-pasid.c b/drivers/iommu/intel-pasid.c
index e7cb0b8a73327..58f060006ba31 100644
--- a/drivers/iommu/intel-pasid.c
+++ b/drivers/iommu/intel-pasid.c
@@ -166,6 +166,9 @@ int intel_pasid_alloc_table(struct device *dev)
 attach_out:
 	device_attach_pasid_table(info, pasid_table);
 
+	if (!ecap_coherent(info->iommu->ecap))
+		clflush_cache_range(pasid_table->table, size);
+
 	return 0;
 }
 
@@ -250,6 +253,10 @@ struct pasid_entry *intel_pasid_get_entry(struct device *dev, int pasid)
 
 		WRITE_ONCE(dir[dir_index].val,
 			   (u64)virt_to_phys(entries) | PASID_PTE_PRESENT);
+		if (!ecap_coherent(info->iommu->ecap)) {
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
+		}
 	}
 	spin_unlock(&pasid_lock);
 
-- 
2.39.2



