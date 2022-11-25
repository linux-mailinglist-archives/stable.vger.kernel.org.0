Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9CD638CFB
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 16:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiKYPGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 10:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiKYPGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 10:06:43 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57102DA92;
        Fri, 25 Nov 2022 07:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388801; x=1700924801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lRb74Ed4w5JOXpI/O/j8nJXYHPcznwfk4WiJ395xlf8=;
  b=Kum0WM8T6nGfGp57UqNYDr78n3lszXN0TPQFEuuhljQCBtnln2ntl1t6
   EgclUiXBg7n7gWO0A1DZWvDP6kujPrMe2BXLYrP5e49jIpZjhH9GNQ19H
   ZjuXDJtuCsRimsXkUC2ZmbxCd0pXzM9/Mj7hw01SbdPMJrgAa/5RXbCHu
   E9oSOzMWL5SVCfeA1VKeFTdN47KCM0j9fuojge2ZITyV6YCsbzKT6N4Gx
   lgvJ0kRKqCtZJT06MVvnyxpk0XU9fV7Q3g8ytRIXwgVmPGEF9F+Fnbi8v
   HQd2UK84WOgfHF7KQ9o/YD+mlyCy2MQPOYxDwXa85w9MUnA8HFX9oPMp7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="294881026"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294881026"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="593240281"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="593240281"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:38 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, stable@vger.kernel.org
Subject: [PATCH V2 07/12] vDPA/ifcvf: decouple config/dev IRQ requester and vectors allocator from the adapter
Date:   Fri, 25 Nov 2022 22:57:19 +0800
Message-Id: <20221125145724.1129962-8-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221125145724.1129962-1-lingshan.zhu@intel.com>
References: <20221125145724.1129962-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This commit decouples the config irq requester, the device
shared irq requester and the MSI vectors allocator from
the adapter. So they can be safely invoked since probe
before the adapter is allocated.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ee9c22975119..8320bdacace8 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -132,10 +132,9 @@ static void ifcvf_free_irq(struct ifcvf_hw *vf)
  * It returns the number of allocated vectors, negative
  * return value when fails.
  */
-static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
+static int ifcvf_alloc_vectors(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int max_intr, ret;
 
 	/* all queues and config interrupt  */
@@ -222,10 +221,9 @@ static int ifcvf_request_vqs_reused_irq(struct ifcvf_hw *vf)
 	return -EFAULT;
 }
 
-static int ifcvf_request_dev_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_dev_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vector = 0;
@@ -276,10 +274,9 @@ static int ifcvf_request_vq_irq(struct ifcvf_hw *vf)
 	return ret;
 }
 
-static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_config_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int config_vector, ret;
 
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
@@ -322,7 +319,7 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 	struct ifcvf_hw *vf = &adapter->vf;
 	int nvectors, ret, max_intr;
 
-	nvectors = ifcvf_alloc_vectors(adapter);
+	nvectors = ifcvf_alloc_vectors(vf);
 	if (nvectors <= 0)
 		return -EFAULT;
 
@@ -333,7 +330,7 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 
 	if (nvectors == 1) {
 		vf->msix_vector_status = MSIX_VECTOR_DEV_SHARED;
-		ret = ifcvf_request_dev_irq(adapter);
+		ret = ifcvf_request_dev_irq(vf);
 
 		return ret;
 	}
@@ -342,7 +339,7 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 	if (ret)
 		return ret;
 
-	ret = ifcvf_request_config_irq(adapter);
+	ret = ifcvf_request_config_irq(vf);
 
 	if (ret)
 		return ret;
-- 
2.31.1

