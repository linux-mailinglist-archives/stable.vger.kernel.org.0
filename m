Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84431635926
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbiKWKHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbiKWKGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D8FB1FF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:56:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 119C961B5F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D49CC433D6;
        Wed, 23 Nov 2022 09:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197404;
        bh=4QEx52f9Bc8PgEJLUxctotmIwR6pQLd0IZ7U23Uu7nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypBqAhBaJRdGCSEkf47tugAXFOZTgSq8PQWCSdefR8lqcO0twkiQTSZvWx6paJO/Z
         xthqPwsXAUhCk7VCLxLDhbvuaEJmbEqh/cuHnUwbTCLrzj+Y7dYqPISRyULqreKaq/
         Cnc+yTGPR2b+A4H8XVQ7/9D/KiDNZ6usfbypB8FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 285/314] vfio: Rename vfio_ioctl_check_extension()
Date:   Wed, 23 Nov 2022 09:52:10 +0100
Message-Id: <20221123084638.451232124@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 1408640d578887d7860737221043d91fc6d5a723 ]

To vfio_container_ioctl_check_extension().

A following patch will turn this into a non-static function, make it clear
it is related to the container.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/6-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Stable-dep-of: 7fdba0011157 ("vfio: Fix container device registration life cycle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7cb56c382c97..c555d497e9e8 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -710,8 +710,9 @@ EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 /*
  * VFIO base fd, /dev/vfio/vfio
  */
-static long vfio_ioctl_check_extension(struct vfio_container *container,
-				       unsigned long arg)
+static long
+vfio_container_ioctl_check_extension(struct vfio_container *container,
+				     unsigned long arg)
 {
 	struct vfio_iommu_driver *driver;
 	long ret = 0;
@@ -868,7 +869,7 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 		ret = VFIO_API_VERSION;
 		break;
 	case VFIO_CHECK_EXTENSION:
-		ret = vfio_ioctl_check_extension(container, arg);
+		ret = vfio_container_ioctl_check_extension(container, arg);
 		break;
 	case VFIO_SET_IOMMU:
 		ret = vfio_ioctl_set_iommu(container, arg);
@@ -1763,8 +1764,8 @@ bool vfio_file_enforced_coherent(struct file *file)
 
 	down_read(&group->group_rwsem);
 	if (group->container) {
-		ret = vfio_ioctl_check_extension(group->container,
-						 VFIO_DMA_CC_IOMMU);
+		ret = vfio_container_ioctl_check_extension(group->container,
+							   VFIO_DMA_CC_IOMMU);
 	} else {
 		/*
 		 * Since the coherency state is determined only once a container
-- 
2.35.1



