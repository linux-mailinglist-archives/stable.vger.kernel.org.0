Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B5040E5E9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244071AbhIPRQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350865AbhIPROI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:14:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09BF661B67;
        Thu, 16 Sep 2021 16:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810368;
        bh=B9bDcts8kdauZRk0oYt86OLn4T1h6FR8OiwgM+xdi6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUEebH4KsXIZyQ1EoX8AvQnuH5d9P2lqG9dy52guWELt6UMo6uF5oDogoJM+ZpwVF
         godd5wpBsAKN6QtxJTnb8rCP1P8ghQeKro0fjlxCFHQKCDolUzVhkMQjze8RfQYlYT
         b+UJKLlimlDAoTzafbPcpg4GznwMpbmUg5J0LSs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 115/432] vfio/mbochs: Fix missing error unwind of mbochs_used_mbytes
Date:   Thu, 16 Sep 2021 17:57:44 +0200
Message-Id: <20210916155814.658427398@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit de5494af4815a4c9328536c72741229b7de88e7f ]

Convert mbochs to use an atomic scheme for this like mtty was changed
into. The atomic fixes various race conditions with probing. Add the
missing error unwind. Also add the missing kfree of mdev_state->pages.

Fixes: 681c1615f891 ("vfio/mbochs: Convert to use vfio_register_group_dev()")
Reported-by: Cornelia Huck <cohuck@redhat.com>
Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/2-v4-9ea22c5e6afb+1adf-vfio_reflck_jgg@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/vfio-mdev/mbochs.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 6c0f229db36a..b4aaeab37754 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -129,7 +129,7 @@ static dev_t		mbochs_devt;
 static struct class	*mbochs_class;
 static struct cdev	mbochs_cdev;
 static struct device	mbochs_dev;
-static int		mbochs_used_mbytes;
+static atomic_t mbochs_avail_mbytes;
 static const struct vfio_device_ops mbochs_dev_ops;
 
 struct vfio_region_info_ext {
@@ -507,18 +507,22 @@ static int mbochs_reset(struct mdev_state *mdev_state)
 
 static int mbochs_probe(struct mdev_device *mdev)
 {
+	int avail_mbytes = atomic_read(&mbochs_avail_mbytes);
 	const struct mbochs_type *type =
 		&mbochs_types[mdev_get_type_group_id(mdev)];
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 	int ret = -ENOMEM;
 
-	if (type->mbytes + mbochs_used_mbytes > max_mbytes)
-		return -ENOMEM;
+	do {
+		if (avail_mbytes < type->mbytes)
+			return -ENOSPC;
+	} while (!atomic_try_cmpxchg(&mbochs_avail_mbytes, &avail_mbytes,
+				     avail_mbytes - type->mbytes));
 
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
-		return -ENOMEM;
+		goto err_avail;
 	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mbochs_dev_ops);
 
 	mdev_state->vconfig = kzalloc(MBOCHS_CONFIG_SPACE_SIZE, GFP_KERNEL);
@@ -549,17 +553,17 @@ static int mbochs_probe(struct mdev_device *mdev)
 	mbochs_create_config_space(mdev_state);
 	mbochs_reset(mdev_state);
 
-	mbochs_used_mbytes += type->mbytes;
-
 	ret = vfio_register_group_dev(&mdev_state->vdev);
 	if (ret)
 		goto err_mem;
 	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
-
 err_mem:
+	kfree(mdev_state->pages);
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
+err_avail:
+	atomic_add(type->mbytes, &mbochs_avail_mbytes);
 	return ret;
 }
 
@@ -567,8 +571,8 @@ static void mbochs_remove(struct mdev_device *mdev)
 {
 	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
 
-	mbochs_used_mbytes -= mdev_state->type->mbytes;
 	vfio_unregister_group_dev(&mdev_state->vdev);
+	atomic_add(mdev_state->type->mbytes, &mbochs_avail_mbytes);
 	kfree(mdev_state->pages);
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
@@ -1355,7 +1359,7 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 {
 	const struct mbochs_type *type =
 		&mbochs_types[mtype_get_type_group_id(mtype)];
-	int count = (max_mbytes - mbochs_used_mbytes) / type->mbytes;
+	int count = atomic_read(&mbochs_avail_mbytes) / type->mbytes;
 
 	return sprintf(buf, "%d\n", count);
 }
@@ -1437,6 +1441,8 @@ static int __init mbochs_dev_init(void)
 {
 	int ret = 0;
 
+	atomic_set(&mbochs_avail_mbytes, max_mbytes);
+
 	ret = alloc_chrdev_region(&mbochs_devt, 0, MINORMASK + 1, MBOCHS_NAME);
 	if (ret < 0) {
 		pr_err("Error: failed to register mbochs_dev, err: %d\n", ret);
-- 
2.30.2



