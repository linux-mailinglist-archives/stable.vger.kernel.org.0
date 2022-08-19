Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AF959A22E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353074AbiHSQdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353417AbiHSQbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:31:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E0F10C83E;
        Fri, 19 Aug 2022 09:05:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39CC3B82819;
        Fri, 19 Aug 2022 16:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7438DC433C1;
        Fri, 19 Aug 2022 16:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925115;
        bh=/ivNho2yQj5sfZqsb19e7z0EQqZ3kGjam/nOnHZWUhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpFi3QsAx2ZSErZ3vZsjoEKSLb3c2Og2cks5V8LmdSou9cLvYdeORxpEXZOT1Pe+D
         dUp8e6iwkA3uexO5wBfo3MI1XYDIq1lNpJuDWuGLXNIqtq5FfdROprKty55QwpWUSy
         gO2LeusPOxCoHeZPU8ZCwZ37CyGFCFQdki5boxmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 389/545] vfio: Remove extra put/gets around vfio_device->group
Date:   Fri, 19 Aug 2022 17:42:39 +0200
Message-Id: <20220819153846.822131744@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit e572bfb2b6a83b05acd30c03010e661b1967960f ]

The vfio_device->group value has a get obtained during
vfio_add_group_dev() which gets moved from the stack to vfio_device->group
in vfio_group_create_device().

The reference remains until we reach the end of vfio_del_group_dev() when
it is put back.

Thus anything that already has a kref on the vfio_device is guaranteed a
valid group pointer. Remove all the extra reference traffic.

It is tricky to see, but the get at the start of vfio_del_group_dev() is
actually pairing with the put hidden inside vfio_device_put() a few lines
below.

A later patch merges vfio_group_create_device() into vfio_add_group_dev()
which makes the ownership and error flow on the create side easier to
follow.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <1-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2151bc7f87ab..e1b6e1b51d41 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -546,14 +546,12 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 
 	kref_init(&device->kref);
 	device->dev = dev;
+	/* Our reference on group is moved to the device */
 	device->group = group;
 	device->ops = ops;
 	device->device_data = device_data;
 	dev_set_drvdata(dev, device);
 
-	/* No need to get group_lock, caller has group reference */
-	vfio_group_get(group);
-
 	mutex_lock(&group->device_lock);
 	list_add(&device->group_next, &group->device_list);
 	group->dev_counter++;
@@ -585,13 +583,11 @@ void vfio_device_put(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
 	kref_put_mutex(&device->kref, vfio_device_release, &group->device_lock);
-	vfio_group_put(group);
 }
 EXPORT_SYMBOL_GPL(vfio_device_put);
 
 static void vfio_device_get(struct vfio_device *device)
 {
-	vfio_group_get(device->group);
 	kref_get(&device->kref);
 }
 
@@ -841,14 +837,6 @@ int vfio_add_group_dev(struct device *dev,
 		vfio_group_put(group);
 		return PTR_ERR(device);
 	}
-
-	/*
-	 * Drop all but the vfio_device reference.  The vfio_device holds
-	 * a reference to the vfio_group, which holds a reference to the
-	 * iommu_group.
-	 */
-	vfio_group_put(group);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_add_group_dev);
@@ -928,12 +916,6 @@ void *vfio_del_group_dev(struct device *dev)
 	unsigned int i = 0;
 	bool interrupted = false;
 
-	/*
-	 * The group exists so long as we have a device reference.  Get
-	 * a group reference and use it to scan for the device going away.
-	 */
-	vfio_group_get(group);
-
 	/*
 	 * When the device is removed from the group, the group suddenly
 	 * becomes non-viable; the device has a driver (until the unbind
@@ -1008,6 +990,7 @@ void *vfio_del_group_dev(struct device *dev)
 	if (list_empty(&group->device_list))
 		wait_event(group->container_q, !group->container);
 
+	/* Matches the get in vfio_group_create_device() */
 	vfio_group_put(group);
 
 	return device_data;
-- 
2.35.1



