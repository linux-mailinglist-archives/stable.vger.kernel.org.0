Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A92C638CED
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKYPGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 10:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiKYPG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 10:06:29 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5921E31DE7;
        Fri, 25 Nov 2022 07:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388788; x=1700924788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NGYzFwtP4Q2IeOFdkbC+DFqWio0Q5Y8YrDc4RNGvhPo=;
  b=Smif7umKlskwTJH1z/YEn1z7IP6r9PnAI/oW3l5clCCY4O+nvLowNBYS
   Tids7Joo4AysrVRTx7ho2hfyUUZrE9gcdH10xyLm6Zt+wzq+R/Gz/xAyf
   nHXI1Sn1t6dxI620e4jqP7izXVQjPFF+bKiE7JTWmZqH5Fcoc5PANPg+Y
   CBF9utsKvTGd9yAsMdFzKi+XzJ6GUkoqWPMDgj8Wo9tOfUqWHctuvCG1V
   bH05ikZX93DthAzZhYx/ElB7tWCU4baBlvT64hcnsi9DrXoteTgh9mcy5
   BIQWath9Rzg2n7LndPNgfktY7s+ensY0VX4NU76nttDw1rDQH7PtBPZSl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="302069166"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="302069166"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="593240215"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="593240215"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:25 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, stable@vger.kernel.org
Subject: [PATCH V2 02/12] vDPA/ifcvf: decouple config space ops from the adapter
Date:   Fri, 25 Nov 2022 22:57:14 +0800
Message-Id: <20221125145724.1129962-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221125145724.1129962-1-lingshan.zhu@intel.com>
References: <20221125145724.1129962-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This commit decopules the config space ops from the
adapter layer, so these functions can be invoked
once the device is probed.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 7a7e6ba66f88..3ec5ca3aefe1 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -10,11 +10,6 @@
 
 #include "ifcvf_base.h"
 
-struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
-{
-	return container_of(hw, struct ifcvf_adapter, vf);
-}
-
 u16 ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector)
 {
 	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
@@ -37,8 +32,6 @@ u16 ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector)
 static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
 				  struct virtio_pci_cap *cap)
 {
-	struct ifcvf_adapter *ifcvf;
-	struct pci_dev *pdev;
 	u32 length, offset;
 	u8 bar;
 
@@ -46,17 +39,14 @@ static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
 	offset = le32_to_cpu(cap->offset);
 	bar = cap->bar;
 
-	ifcvf= vf_to_adapter(hw);
-	pdev = ifcvf->pdev;
-
 	if (bar >= IFCVF_PCI_MAX_RESOURCE) {
-		IFCVF_DBG(pdev,
+		IFCVF_DBG(hw->pdev,
 			  "Invalid bar number %u to get capabilities\n", bar);
 		return NULL;
 	}
 
-	if (offset + length > pci_resource_len(pdev, bar)) {
-		IFCVF_DBG(pdev,
+	if (offset + length > pci_resource_len(hw->pdev, bar)) {
+		IFCVF_DBG(hw->pdev,
 			  "offset(%u) + len(%u) overflows bar%u's capability\n",
 			  offset, length, bar);
 		return NULL;
@@ -92,6 +82,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 		IFCVF_ERR(pdev, "Failed to read PCI capability list\n");
 		return -EIO;
 	}
+	hw->pdev = pdev;
 
 	while (pos) {
 		ret = ifcvf_read_config_range(pdev, (u32 *)&cap,
@@ -230,13 +221,11 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
 
 u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
 {
-	struct ifcvf_adapter *adapter;
 	u32 net_config_size = sizeof(struct virtio_net_config);
 	u32 blk_config_size = sizeof(struct virtio_blk_config);
 	u32 cap_size = hw->cap_dev_config_size;
 	u32 config_size;
 
-	adapter = vf_to_adapter(hw);
 	/* If the onboard device config space size is greater than
 	 * the size of struct virtio_net/blk_config, only the spec
 	 * implementing contents size is returned, this is very
@@ -251,7 +240,7 @@ u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
 		break;
 	default:
 		config_size = 0;
-		IFCVF_ERR(adapter->pdev, "VIRTIO ID %u not supported\n", hw->dev_type);
+		IFCVF_ERR(hw->pdev, "VIRTIO ID %u not supported\n", hw->dev_type);
 	}
 
 	return config_size;
-- 
2.31.1

