Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226BC638CF0
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 16:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiKYPGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 10:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiKYPGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 10:06:34 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612814047A;
        Fri, 25 Nov 2022 07:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388793; x=1700924793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HOdj0oUK3WbeLxjf51f9tIDc5rxKdwxZGte7o/oQccQ=;
  b=UnY5/AwL9H6LKT/z4LyqjENRgq8ulnB5WfF7p+5g56S9X88TBWJeR6f+
   cDqcGUvP7oM6aFMzgRI2v5/L5+M1ma3YrYzNMbBRjTvLJKLa9cIiBrg1d
   9EAGCEYhhclO0QMYjBeyL/WVLk5ssVnHHzO4dsyMbefZJQlyMz3Ejd8Lr
   d6eLM70GKbaoXU7Q6/fMrY4YkOw1WDF7HvVPsMt7x/aQPBzylMWFb1rHG
   z0gd0xcQcN6QdbuG4+HQ987Mlc7nsoKhge7QQ1d6fmP4AI5rJRdJwsj+y
   hgVxcZ2b6URAAKZQSA18eoVSYBma6wOBVRHSFXeuy+M/TtA2ZNP0hjRHc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="294880995"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294880995"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="593240249"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="593240249"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:30 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, stable@vger.kernel.org
Subject: [PATCH V2 04/12] vDPA/ifcvf: decouple vq IRQ releasers from the adapter
Date:   Fri, 25 Nov 2022 22:57:16 +0800
Message-Id: <20221125145724.1129962-5-lingshan.zhu@intel.com>
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

This commit decouples the IRQ releasers from the
adapter, so that these functions could be
safely invoked once probe

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 306a57c05509..7dac0285b71d 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -69,10 +69,9 @@ static void ifcvf_free_irq_vectors(void *data)
 	pci_free_irq_vectors(data);
 }
 
-static void ifcvf_free_per_vq_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_per_vq_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i;
 
 	for (i = 0; i < vf->nr_vring; i++) {
@@ -83,10 +82,9 @@ static void ifcvf_free_per_vq_irq(struct ifcvf_adapter *adapter)
 	}
 }
 
-static void ifcvf_free_vqs_reused_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_vqs_reused_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 
 	if (vf->vqs_reused_irq != -EINVAL) {
 		devm_free_irq(&pdev->dev, vf->vqs_reused_irq, vf);
@@ -95,14 +93,12 @@ static void ifcvf_free_vqs_reused_irq(struct ifcvf_adapter *adapter)
 
 }
 
-static void ifcvf_free_vq_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_vq_irq(struct ifcvf_hw *vf)
 {
-	struct ifcvf_hw *vf = &adapter->vf;
-
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
-		ifcvf_free_per_vq_irq(adapter);
+		ifcvf_free_per_vq_irq(vf);
 	else
-		ifcvf_free_vqs_reused_irq(adapter);
+		ifcvf_free_vqs_reused_irq(vf);
 }
 
 static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
@@ -126,8 +122,9 @@ static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
 static void ifcvf_free_irq(struct ifcvf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
 
-	ifcvf_free_vq_irq(adapter);
+	ifcvf_free_vq_irq(vf);
 	ifcvf_free_config_irq(adapter);
 	ifcvf_free_irq_vectors(pdev);
 }
-- 
2.31.1

