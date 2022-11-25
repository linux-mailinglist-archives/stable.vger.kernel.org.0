Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76C6638CF5
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 16:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiKYPGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 10:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiKYPGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 10:06:40 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19B63D902;
        Fri, 25 Nov 2022 07:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388798; x=1700924798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zqB4VxUbSoa1/R9X/q+uEbSpkhAAKXG6Dh8P3V04QaE=;
  b=PmMGVOGB175mpQSOg7tZ39oTyX78K6NpXozkpRKCM53+EVZTEQmvu3tj
   RAKTirOK4uGvgi8BILQ7UkpNwIUCeCsEncO+zKJOF5ytx+6PBk4iOCUxC
   qLlF2anuK2ZWzmhye9oYcgiINSojMzhqhvq4NXNd0ggjyJ/eOn4g7WEFN
   +ZXt9tGuKt1lsPqMNwevIVIooRAAMnYPC7I6fqMJFe2rAh3M1NFy5g7+l
   rIle/sm3Wz0Uw0f/wpq9ZQvuhJQwaVzoVQhrirDBVasnZh6M35vslCIqh
   cScp5PhhaZqBMqdWXY0bFj2g11BzX3ab94caP5Ucx0G01hIEN1BoJ6JQH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="294881018"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294881018"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="593240265"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="593240265"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:36 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, stable@vger.kernel.org
Subject: [PATCH V2 06/12] vDPA/ifcvf: decouple vq irq requester from the adapter
Date:   Fri, 25 Nov 2022 22:57:18 +0800
Message-Id: <20221125145724.1129962-7-lingshan.zhu@intel.com>
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

This commit decouples the vq irq requester from the adapter,
so that these functions can be invoked since probe.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index c635f78f5c4c..ee9c22975119 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -155,10 +155,9 @@ static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
 	return ret;
 }
 
-static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_per_vq_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vf->vqs_reused_irq = -EINVAL;
@@ -190,10 +189,9 @@ static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
 	return -EFAULT;
 }
 
-static int ifcvf_request_vqs_reused_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_vqs_reused_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vector = 0;
@@ -266,15 +264,14 @@ static int ifcvf_request_dev_irq(struct ifcvf_adapter *adapter)
 
 }
 
-static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_vq_irq(struct ifcvf_hw *vf)
 {
-	struct ifcvf_hw *vf = &adapter->vf;
 	int ret;
 
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
-		ret = ifcvf_request_per_vq_irq(adapter);
+		ret = ifcvf_request_per_vq_irq(vf);
 	else
-		ret = ifcvf_request_vqs_reused_irq(adapter);
+		ret = ifcvf_request_vqs_reused_irq(vf);
 
 	return ret;
 }
@@ -341,7 +338,7 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 		return ret;
 	}
 
-	ret = ifcvf_request_vq_irq(adapter);
+	ret = ifcvf_request_vq_irq(vf);
 	if (ret)
 		return ret;
 
-- 
2.31.1

