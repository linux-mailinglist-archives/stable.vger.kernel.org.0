Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2AD2638CF9
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 16:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiKYPGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 10:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiKYPGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 10:06:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC413D928;
        Fri, 25 Nov 2022 07:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388796; x=1700924796;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lNFpEw8fOUanfxMRuET0eEJRiZaA7AVu47NX0D5CI2k=;
  b=lo7GVBtoCOCw8Am0s8dbsV7U0YfGoGF5beXTIrLPOXWYngtvubKi5X40
   KHU5zBNNP5AHpMRQI2NdcbROT+haWFfHA33faur7tEqZyU0WAq+nbSGVY
   n7fip5SA1IryLEtQGX/HjPYtTStJrPAJ1Xnl0Oqpb/Xr8Cx1unE9exrw6
   l0BCNSmXznMgi/TiPy2i7PhPr+DL8HxB1PfXNqaZe7CmetCKV7QWdHJuQ
   kmVVJoRPGh4xE6m9Rfrj27XxQ6YuaohZF32EBK8c9nCWxFw3shy2bTZIz
   jiMZ29hf/AwdpMV7zvQDc/70s7Um0wjNRef+zLLGnIanUjFpBjfvKkhIW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="294881008"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294881008"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="593240258"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="593240258"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:32 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, stable@vger.kernel.org
Subject: [PATCH V2 05/12] vDPA/ifcvf: decouple config IRQ releaser from the adapter
Date:   Fri, 25 Nov 2022 22:57:17 +0800
Message-Id: <20221125145724.1129962-6-lingshan.zhu@intel.com>
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

This commit decouples config IRQ releaser from the adapter,
so that it could be invoked once probe or in err handlers.
ifcvf_free_irq() works on ifcvf_hw in this commit

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 7dac0285b71d..c635f78f5c4c 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -101,10 +101,9 @@ static void ifcvf_free_vq_irq(struct ifcvf_hw *vf)
 		ifcvf_free_vqs_reused_irq(vf);
 }
 
-static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_config_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 
 	if (vf->config_irq == -EINVAL)
 		return;
@@ -119,13 +118,12 @@ static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
 	}
 }
 
-static void ifcvf_free_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 
 	ifcvf_free_vq_irq(vf);
-	ifcvf_free_config_irq(adapter);
+	ifcvf_free_config_irq(vf);
 	ifcvf_free_irq_vectors(pdev);
 }
 
@@ -187,7 +185,7 @@ static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
@@ -221,7 +219,7 @@ static int ifcvf_request_vqs_reused_irq(struct ifcvf_adapter *adapter)
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
@@ -262,7 +260,7 @@ static int ifcvf_request_dev_irq(struct ifcvf_adapter *adapter)
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 
@@ -317,7 +315,7 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
@@ -508,7 +506,7 @@ static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
 
 	if (status_old & VIRTIO_CONFIG_S_DRIVER_OK) {
 		ifcvf_stop_datapath(adapter);
-		ifcvf_free_irq(adapter);
+		ifcvf_free_irq(vf);
 	}
 
 	ifcvf_reset_vring(adapter);
-- 
2.31.1

