Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84A36AA193
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbjCCVlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbjCCVlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:41:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2434C62DA7;
        Fri,  3 Mar 2023 13:41:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3FA461910;
        Fri,  3 Mar 2023 21:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3402DC433A0;
        Fri,  3 Mar 2023 21:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879671;
        bh=yU2Kns+nfberkrKPELqHy6W980G/yiYouKTOPDsATi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=of2gZftlC1CQJhqrINqrGCMm4Fnb0FyA4rbCJxR6JYpgRon5ktuSqDZXGmQaINnvp
         4M2HaHHQ9jQDtOq3ZqfUaIGjVGkMh5sBzClPDc2es8zNRVXAXyvnD7O1sSsKSCbHFh
         ZIFNIE6FSn/5ckg63ExkH9TMls0/jT5R6Ara1DbH4QSER+rpEmSEdHc9OvrW/Kw4H8
         9HZ9Bz6yKMUokqzC2fZYLP60+Ruv5FfRH08nwP1Auh5hDsQkMsmSfs3joVx1fWjDPR
         7gSsFl4GCSxJr3n6cakjwM0/144xB9q6jkKOXL1CZDQpGpJYbIfZw6gjvzoW0O+5WL
         0ZBU8699F0NYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, joro@8bytes.org,
        will@kernel.org, iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.2 02/64] iommu: Remove deferred attach check from __iommu_detach_device()
Date:   Fri,  3 Mar 2023 16:40:04 -0500
Message-Id: <20230303214106.1446460-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit dd8a25c557e109f868430bd2e3e8f394cb40eaa7 ]

At the current moment, __iommu_detach_device() is only called via call
chains that are after the device driver is attached - eg via explicit
attach APIs called by the device driver.

Commit bd421264ed30 ("iommu: Fix deferred domain attachment") has removed
deferred domain attachment check from __iommu_attach_device() path, so it
should just unconditionally work in the __iommu_detach_device() path.

It actually looks like a bug that we were blocking detach on these paths
since the attach was unconditional and the caller is going to free the
(probably) UNAMANGED domain once this returns.

The only place we should be testing for deferred attach is during the
initial point the dma device is linked to the group, and then again
during the dma api calls.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20230110025408.667767-5-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 70 ++++++++++++++++++++++---------------------
 include/linux/iommu.h |  2 ++
 2 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 5f6a85aea501e..54e1306a99a47 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -371,6 +371,30 @@ static int __iommu_probe_device(struct device *dev, struct list_head *group_list
 	return ret;
 }
 
+static bool iommu_is_attach_deferred(struct device *dev)
+{
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+
+	if (ops->is_attach_deferred)
+		return ops->is_attach_deferred(dev);
+
+	return false;
+}
+
+static int iommu_group_do_dma_first_attach(struct device *dev, void *data)
+{
+	struct iommu_domain *domain = data;
+
+	lockdep_assert_held(&dev->iommu_group->mutex);
+
+	if (iommu_is_attach_deferred(dev)) {
+		dev->iommu->attach_deferred = 1;
+		return 0;
+	}
+
+	return __iommu_attach_device(domain, dev);
+}
+
 int iommu_probe_device(struct device *dev)
 {
 	const struct iommu_ops *ops;
@@ -401,7 +425,7 @@ int iommu_probe_device(struct device *dev)
 	 * attach the default domain.
 	 */
 	if (group->default_domain && !group->owner) {
-		ret = __iommu_attach_device(group->default_domain, dev);
+		ret = iommu_group_do_dma_first_attach(dev, group->default_domain);
 		if (ret) {
 			mutex_unlock(&group->mutex);
 			iommu_group_put(group);
@@ -947,16 +971,6 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
 	return ret;
 }
 
-static bool iommu_is_attach_deferred(struct device *dev)
-{
-	const struct iommu_ops *ops = dev_iommu_ops(dev);
-
-	if (ops->is_attach_deferred)
-		return ops->is_attach_deferred(dev);
-
-	return false;
-}
-
 /**
  * iommu_group_add_device - add a device to an iommu group
  * @group: the group into which to add the device (reference should be held)
@@ -1009,8 +1023,8 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
 
 	mutex_lock(&group->mutex);
 	list_add_tail(&device->list, &group->devices);
-	if (group->domain  && !iommu_is_attach_deferred(dev))
-		ret = __iommu_attach_device(group->domain, dev);
+	if (group->domain)
+		ret = iommu_group_do_dma_first_attach(dev, group->domain);
 	mutex_unlock(&group->mutex);
 	if (ret)
 		goto err_put_group;
@@ -1776,21 +1790,10 @@ static void probe_alloc_default_domain(struct bus_type *bus,
 
 }
 
-static int iommu_group_do_dma_attach(struct device *dev, void *data)
-{
-	struct iommu_domain *domain = data;
-	int ret = 0;
-
-	if (!iommu_is_attach_deferred(dev))
-		ret = __iommu_attach_device(domain, dev);
-
-	return ret;
-}
-
-static int __iommu_group_dma_attach(struct iommu_group *group)
+static int __iommu_group_dma_first_attach(struct iommu_group *group)
 {
 	return __iommu_group_for_each_dev(group, group->default_domain,
-					  iommu_group_do_dma_attach);
+					  iommu_group_do_dma_first_attach);
 }
 
 static int iommu_group_do_probe_finalize(struct device *dev, void *data)
@@ -1855,7 +1858,7 @@ int bus_iommu_probe(struct bus_type *bus)
 
 		iommu_group_create_direct_mappings(group);
 
-		ret = __iommu_group_dma_attach(group);
+		ret = __iommu_group_dma_first_attach(group);
 
 		mutex_unlock(&group->mutex);
 
@@ -1987,9 +1990,11 @@ static int __iommu_attach_device(struct iommu_domain *domain,
 		return -ENODEV;
 
 	ret = domain->ops->attach_dev(domain, dev);
-	if (!ret)
-		trace_attach_device_to_domain(dev);
-	return ret;
+	if (ret)
+		return ret;
+	dev->iommu->attach_deferred = 0;
+	trace_attach_device_to_domain(dev);
+	return 0;
 }
 
 /**
@@ -2034,7 +2039,7 @@ EXPORT_SYMBOL_GPL(iommu_attach_device);
 
 int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 {
-	if (iommu_is_attach_deferred(dev))
+	if (dev->iommu && dev->iommu->attach_deferred)
 		return __iommu_attach_device(domain, dev);
 
 	return 0;
@@ -2043,9 +2048,6 @@ int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 static void __iommu_detach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
-	if (iommu_is_attach_deferred(dev))
-		return;
-
 	domain->ops->detach_dev(domain, dev);
 	trace_detach_device_from_domain(dev);
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 46e1347bfa228..7695d9e14277f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -401,6 +401,7 @@ struct iommu_fault_param {
  * @iommu_dev:	 IOMMU device this device is linked to
  * @priv:	 IOMMU Driver private data
  * @max_pasids:  number of PASIDs this device can consume
+ * @attach_deferred: the dma domain attachment is deferred
  *
  * TODO: migrate other per device data pointers under iommu_dev_data, e.g.
  *	struct iommu_group	*iommu_group;
@@ -413,6 +414,7 @@ struct dev_iommu {
 	struct iommu_device		*iommu_dev;
 	void				*priv;
 	u32				max_pasids;
+	u32				attach_deferred:1;
 };
 
 int iommu_device_register(struct iommu_device *iommu,
-- 
2.39.2

