Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F203E568CFD
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbiGFPbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbiGFPbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:31:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB7625EA3;
        Wed,  6 Jul 2022 08:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E721E61FDB;
        Wed,  6 Jul 2022 15:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224F1C3411C;
        Wed,  6 Jul 2022 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121461;
        bh=8ZHzkmLK7hTG93tf9ENQrj40e40dnzUne2DsY5NsBh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oG2W8kgW99ZnDqaJ98QlDpQeKFEqCj96WlBnYF6lfMvTxE0CBi1X9sGNEM9rJ2/C7
         7Ik3Bn0PYKz+CKjFWVepdH1QjivKonWBpWBecbbrCcxwXPOqfmGHKL5JFVdZeutEqx
         WRHboCsX+qBDZ6xfXMLJLg1cvlm7N/vwp2bahB943l44EXKd7laP7659U7zSc9+ASU
         hX7sJR3Rr8xNDpvLVHxa6Ie5wN0Ox+N4XpzUOFJLqPDppefq/hJKTRKTMYsqEPc3Py
         296lVjW9RUIng+rU/hwpzYwSfPMnGOL5B6/mWPwQaqGMrZgqPaHhNoO9fW4JX5JB9h
         Ylaz+Y4Z7e+WQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dan.carpenter@oracle.com,
        elic@nvidia.com, gautam.dawar@xilinx.com,
        guanjun@linux.alibaba.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.18 04/22] vduse: Tie vduse mgmtdev and its device
Date:   Wed,  6 Jul 2022 11:30:22 -0400
Message-Id: <20220706153041.1597639-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153041.1597639-1-sashal@kernel.org>
References: <20220706153041.1597639-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 0e0348ac3f0a6e6606f1aa5acb1803ada913aa3d ]

vduse devices are not backed by any real devices such as PCI. Hence it
doesn't have any parent device linked to it.

Kernel driver model in [1] suggests to avoid an empty device
release callback.

Hence tie the mgmtdevice object's life cycle to an allocate dummy struct
device instead of static one.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/core-api/kobject.rst?h=v5.18-rc7#n284

Signed-off-by: Parav Pandit <parav@nvidia.com>
Message-Id: <20220613195223.473966-1-parav@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 60 ++++++++++++++++++------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 160e40d03084..02709f8a78bd 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1475,16 +1475,12 @@ static char *vduse_devnode(struct device *dev, umode_t *mode)
 	return kasprintf(GFP_KERNEL, "vduse/%s", dev_name(dev));
 }
 
-static void vduse_mgmtdev_release(struct device *dev)
-{
-}
-
-static struct device vduse_mgmtdev = {
-	.init_name = "vduse",
-	.release = vduse_mgmtdev_release,
+struct vduse_mgmt_dev {
+	struct vdpa_mgmt_dev mgmt_dev;
+	struct device dev;
 };
 
-static struct vdpa_mgmt_dev mgmt_dev;
+static struct vduse_mgmt_dev *vduse_mgmt;
 
 static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name)
 {
@@ -1509,7 +1505,7 @@ static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name)
 	}
 	set_dma_ops(&vdev->vdpa.dev, &vduse_dev_dma_ops);
 	vdev->vdpa.dma_dev = &vdev->vdpa.dev;
-	vdev->vdpa.mdev = &mgmt_dev;
+	vdev->vdpa.mdev = &vduse_mgmt->mgmt_dev;
 
 	return 0;
 }
@@ -1555,34 +1551,52 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
-static struct vdpa_mgmt_dev mgmt_dev = {
-	.device = &vduse_mgmtdev,
-	.id_table = id_table,
-	.ops = &vdpa_dev_mgmtdev_ops,
-};
+static void vduse_mgmtdev_release(struct device *dev)
+{
+	struct vduse_mgmt_dev *mgmt_dev;
+
+	mgmt_dev = container_of(dev, struct vduse_mgmt_dev, dev);
+	kfree(mgmt_dev);
+}
 
 static int vduse_mgmtdev_init(void)
 {
 	int ret;
 
-	ret = device_register(&vduse_mgmtdev);
-	if (ret)
+	vduse_mgmt = kzalloc(sizeof(*vduse_mgmt), GFP_KERNEL);
+	if (!vduse_mgmt)
+		return -ENOMEM;
+
+	ret = dev_set_name(&vduse_mgmt->dev, "vduse");
+	if (ret) {
+		kfree(vduse_mgmt);
 		return ret;
+	}
 
-	ret = vdpa_mgmtdev_register(&mgmt_dev);
+	vduse_mgmt->dev.release = vduse_mgmtdev_release;
+
+	ret = device_register(&vduse_mgmt->dev);
 	if (ret)
-		goto err;
+		goto dev_reg_err;
 
-	return 0;
-err:
-	device_unregister(&vduse_mgmtdev);
+	vduse_mgmt->mgmt_dev.id_table = id_table;
+	vduse_mgmt->mgmt_dev.ops = &vdpa_dev_mgmtdev_ops;
+	vduse_mgmt->mgmt_dev.device = &vduse_mgmt->dev;
+	ret = vdpa_mgmtdev_register(&vduse_mgmt->mgmt_dev);
+	if (ret)
+		device_unregister(&vduse_mgmt->dev);
+
+	return ret;
+
+dev_reg_err:
+	put_device(&vduse_mgmt->dev);
 	return ret;
 }
 
 static void vduse_mgmtdev_exit(void)
 {
-	vdpa_mgmtdev_unregister(&mgmt_dev);
-	device_unregister(&vduse_mgmtdev);
+	vdpa_mgmtdev_unregister(&vduse_mgmt->mgmt_dev);
+	device_unregister(&vduse_mgmt->dev);
 }
 
 static int vduse_init(void)
-- 
2.35.1

