Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394196B4227
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCJOAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjCJOAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:00:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD68112A6C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97DC6B822BA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EC7C4339C;
        Fri, 10 Mar 2023 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456809;
        bh=Y3pN0w1O2a3aFOcYxVhlTjd273zONYfeq6yPvxEfHFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvskQlYHjqcUekxQPuDq/mG7S+TX5qstSf2IhwMQOOQADjJRQXh5hDjyoj5okByBK
         J2CEfYkqP4RLJxgeGaD1Ue6FZVodabxaMqwKiViwl+ImClTXSMiR6PC8LfsH/qZz0x
         kEzuOtR3gfjrOBvXECgOjz/MKXBMFBDIIo7y9cyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 131/211] iommu: Remove deferred attach check from __iommu_detach_device()
Date:   Fri, 10 Mar 2023 14:38:31 +0100
Message-Id: <20230310133722.719895460@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 50d858f36a81b..f8100067502fb 100644
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
@@ -951,16 +975,6 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
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
@@ -1013,8 +1027,8 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
 
 	mutex_lock(&group->mutex);
 	list_add_tail(&device->list, &group->devices);
-	if (group->domain  && !iommu_is_attach_deferred(dev))
-		ret = __iommu_attach_device(group->domain, dev);
+	if (group->domain)
+		ret = iommu_group_do_dma_first_attach(dev, group->domain);
 	mutex_unlock(&group->mutex);
 	if (ret)
 		goto err_put_group;
@@ -1780,21 +1794,10 @@ static void probe_alloc_default_domain(struct bus_type *bus,
 
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
@@ -1859,7 +1862,7 @@ int bus_iommu_probe(struct bus_type *bus)
 
 		iommu_group_create_direct_mappings(group);
 
-		ret = __iommu_group_dma_attach(group);
+		ret = __iommu_group_dma_first_attach(group);
 
 		mutex_unlock(&group->mutex);
 
@@ -1991,9 +1994,11 @@ static int __iommu_attach_device(struct iommu_domain *domain,
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
@@ -2038,7 +2043,7 @@ EXPORT_SYMBOL_GPL(iommu_attach_device);
 
 int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 {
-	if (iommu_is_attach_deferred(dev))
+	if (dev->iommu && dev->iommu->attach_deferred)
 		return __iommu_attach_device(domain, dev);
 
 	return 0;
@@ -2047,9 +2052,6 @@ int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
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



