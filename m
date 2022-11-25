Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7334A638D05
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 16:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiKYPG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 10:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiKYPGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 10:06:48 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2294219C;
        Fri, 25 Nov 2022 07:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388806; x=1700924806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tGKyZdK+/g+LspCoOlXFm4pHY90Rxp2oIWc2gtPMg2Y=;
  b=oF9LM0vGuP9PO2VmagPkN1tlczoCnxSLPoFd2L8KwZtKF+M4mu5Xwxkb
   n5xIWxRlwljyAsephcmPsvEFuCJBbyy64n+I6NF+BJI+w8vP9pUtDwVr+
   PYPooyD7qW6WA+/3sVs0zQqxuOySzrO48JKnVD7OlFnKYR9PS1me4li71
   KUtQpkAYbg1aJMnuo7TwU3snN4synFzVvCxtH8+6kbClVGwXYWOzFUTcx
   72kCNOzjkEHNqSNSbHg+xQW7817rjQmFJy3l8xHuvUJHf2MQ9KR1FKzqd
   liLv4CL43ct1AmYFBfrXynCCBLQmbuEyQf71LMHsv9fG+hdi7p5leg/kw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="294881049"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294881049"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="593240292"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="593240292"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:43 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, stable@vger.kernel.org
Subject: [PATCH V2 09/12] vDPA/ifcvf: manage ifcvf_hw in the mgmt_dev
Date:   Fri, 25 Nov 2022 22:57:21 +0800
Message-Id: <20221125145724.1129962-10-lingshan.zhu@intel.com>
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

This commit allocates the hw structure in the
management device structure. So the hardware
can be initialized once the management device
is allocated in probe.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/vdpa/ifcvf/ifcvf_base.h | 5 +++--
 drivers/vdpa/ifcvf/ifcvf_main.c | 7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index e1fe947d61b7..25bd4e927b27 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -39,7 +39,7 @@
 #define IFCVF_INFO(pdev, fmt, ...)	dev_info(&pdev->dev, fmt, ##__VA_ARGS__)
 
 #define ifcvf_private_to_vf(adapter) \
-	(&((struct ifcvf_adapter *)adapter)->vf)
+	(((struct ifcvf_adapter *)adapter)->vf)
 
 /* all vqs and config interrupt has its own vector */
 #define MSIX_VECTOR_PER_VQ_AND_CONFIG		1
@@ -95,7 +95,7 @@ struct ifcvf_hw {
 struct ifcvf_adapter {
 	struct vdpa_device vdpa;
 	struct pci_dev *pdev;
-	struct ifcvf_hw vf;
+	struct ifcvf_hw *vf;
 };
 
 struct ifcvf_vring_lm_cfg {
@@ -110,6 +110,7 @@ struct ifcvf_lm_cfg {
 
 struct ifcvf_vdpa_mgmt_dev {
 	struct vdpa_mgmt_dev mdev;
+	struct ifcvf_hw vf;
 	struct ifcvf_adapter *adapter;
 	struct pci_dev *pdev;
 };
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index cb3df395d3fb..b6f5f7a3a767 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -402,7 +402,7 @@ static struct ifcvf_hw *vdpa_to_vf(struct vdpa_device *vdpa_dev)
 {
 	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
 
-	return &adapter->vf;
+	return adapter->vf;
 }
 
 static u64 ifcvf_vdpa_get_device_features(struct vdpa_device *vdpa_dev)
@@ -750,7 +750,7 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 		return -EOPNOTSUPP;
 
 	adapter = ifcvf_mgmt_dev->adapter;
-	vf = &adapter->vf;
+	vf = adapter->vf;
 	pdev = adapter->pdev;
 	vdpa_dev = &adapter->vdpa;
 
@@ -838,10 +838,11 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
 	ifcvf_mgmt_dev->adapter = adapter;
 
-	vf = &adapter->vf;
+	vf = &ifcvf_mgmt_dev->vf;
 	vf->dev_type = get_dev_type(pdev);
 	vf->base = pcim_iomap_table(pdev);
 	vf->pdev = pdev;
+	adapter->vf = vf;
 
 	ret = ifcvf_init_hw(vf, pdev);
 	if (ret) {
-- 
2.31.1

