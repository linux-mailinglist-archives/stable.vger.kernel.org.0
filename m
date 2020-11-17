Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8890D2B64DC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbgKQNch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:32:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732050AbgKQNbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:31:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F3252078E;
        Tue, 17 Nov 2020 13:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619894;
        bh=0kalvLJ1E8/bfqGdTkFmYlRCb6jsNrUuzy5oOrOawig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnXhcnJ+99gFCOzfvmWez/IaKb6djomy/tGP9NSCOeIqYKSCWzKOhiasupT5GIPfJ
         6bYpa7BaHH17OaIKQ2uiNbZd+a5REA9Sn8XtmXTUFX3W5zEHUGIS/IKQhKvwUfs23M
         jRLsFi/u84NZ/h57khm5aj194Cv1YNgNrmKuyUyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Yi L <yi.l.liu@intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 040/255] iommu/vt-d: Fix sid not set issue in intel_svm_bind_gpasid()
Date:   Tue, 17 Nov 2020 14:03:00 +0100
Message-Id: <20201117122140.898809357@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

[ Upstream commit eea4e29ab8bef254b228d6e1e3de188087b2c7d0 ]

Should get correct sid and set it into sdev. Because we execute
'sdev->sid != req->rid' in the loop of prq_event_thread().

Fixes: eb8d93ea3c1d ("iommu/vt-d: Report page request faults for guest SVA")
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/1604025444-6954-2-git-send-email-yi.y.sun@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/svm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 95c3164a2302f..a71fbbddaa66e 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -278,6 +278,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	struct intel_iommu *iommu = device_to_iommu(dev, NULL, NULL);
 	struct intel_svm_dev *sdev = NULL;
 	struct dmar_domain *dmar_domain;
+	struct device_domain_info *info;
 	struct intel_svm *svm = NULL;
 	int ret = 0;
 
@@ -302,6 +303,10 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	if (data->hpasid <= 0 || data->hpasid >= PASID_MAX)
 		return -EINVAL;
 
+	info = get_domain_info(dev);
+	if (!info)
+		return -EINVAL;
+
 	dmar_domain = to_dmar_domain(domain);
 
 	mutex_lock(&pasid_mutex);
@@ -349,6 +354,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 		goto out;
 	}
 	sdev->dev = dev;
+	sdev->sid = PCI_DEVID(info->bus, info->devfn);
 
 	/* Only count users if device has aux domains */
 	if (iommu_dev_feature_enabled(dev, IOMMU_DEV_FEAT_AUX))
-- 
2.27.0



