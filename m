Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F7E6582D3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiL1Qmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiL1Qlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:41:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DD71F2D0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:36:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DB8BB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE02C433D2;
        Wed, 28 Dec 2022 16:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245340;
        bh=nhikWAwj5FeueVMWraRDqHfOxJVsytxlgYdJ4Mmhqso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=om+VMj7P99+28aRpb1oLuCmRzsPMerP7sM6Yj/HN0FwIuewKx0SLCKu4eomwe9x80
         b2WduM0mA81FqhqDMTn7hNTV63tboOPVPeG/zKRVbuDtaG+CKw9nGlKBLGPclep91J
         7VmlK4ndR/CNVOvfFh1Cey6FGbUlLEGJaa1oCo2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Norris <briannorris@chromium.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0842/1146] iommu: Avoid races around device probe
Date:   Wed, 28 Dec 2022 15:39:41 +0100
Message-Id: <20221228144353.026684981@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 01657bc14a3990c665375f77978631fee77b1fce ]

We currently have 3 different ways that __iommu_probe_device() may be
called, but no real guarantee that multiple callers can't tread on each
other, especially once asynchronous driver probe gets involved. It would
likely have taken a fair bit of luck to hit this previously, but commit
57365a04c921 ("iommu: Move bus setup to IOMMU device registration") ups
the odds since now it's not just omap-iommu that may trigger multiple
bus_iommu_probe() calls in parallel if probing asynchronously.

Add a lock to ensure we can't try to double-probe a device, and also
close some possible race windows to make sure we're truly robust against
trying to double-initialise a group via two different member devices.

Reported-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Brian Norris <briannorris@chromium.org>
Fixes: 57365a04c921 ("iommu: Move bus setup to IOMMU device registration")
Link: https://lore.kernel.org/r/1946ef9f774851732eed78760a78ec40dbc6d178.1667591503.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 65a3b3d886dc..959d895fc1df 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -283,13 +283,23 @@ static int __iommu_probe_device(struct device *dev, struct list_head *group_list
 	const struct iommu_ops *ops = dev->bus->iommu_ops;
 	struct iommu_device *iommu_dev;
 	struct iommu_group *group;
+	static DEFINE_MUTEX(iommu_probe_device_lock);
 	int ret;
 
 	if (!ops)
 		return -ENODEV;
-
-	if (!dev_iommu_get(dev))
-		return -ENOMEM;
+	/*
+	 * Serialise to avoid races between IOMMU drivers registering in
+	 * parallel and/or the "replay" calls from ACPI/OF code via client
+	 * driver probe. Once the latter have been cleaned up we should
+	 * probably be able to use device_lock() here to minimise the scope,
+	 * but for now enforcing a simple global ordering is fine.
+	 */
+	mutex_lock(&iommu_probe_device_lock);
+	if (!dev_iommu_get(dev)) {
+		ret = -ENOMEM;
+		goto err_unlock;
+	}
 
 	if (!try_module_get(ops->owner)) {
 		ret = -EINVAL;
@@ -309,11 +319,14 @@ static int __iommu_probe_device(struct device *dev, struct list_head *group_list
 		ret = PTR_ERR(group);
 		goto out_release;
 	}
-	iommu_group_put(group);
 
+	mutex_lock(&group->mutex);
 	if (group_list && !group->default_domain && list_empty(&group->entry))
 		list_add_tail(&group->entry, group_list);
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
 
+	mutex_unlock(&iommu_probe_device_lock);
 	iommu_device_link(iommu_dev, dev);
 
 	return 0;
@@ -328,6 +341,9 @@ static int __iommu_probe_device(struct device *dev, struct list_head *group_list
 err_free:
 	dev_iommu_free(dev);
 
+err_unlock:
+	mutex_unlock(&iommu_probe_device_lock);
+
 	return ret;
 }
 
@@ -1799,11 +1815,11 @@ int bus_iommu_probe(struct bus_type *bus)
 		return ret;
 
 	list_for_each_entry_safe(group, next, &group_list, entry) {
+		mutex_lock(&group->mutex);
+
 		/* Remove item from the list */
 		list_del_init(&group->entry);
 
-		mutex_lock(&group->mutex);
-
 		/* Try to allocate default domain */
 		probe_alloc_default_domain(bus, group);
 
-- 
2.35.1



