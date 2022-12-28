Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7D0658258
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbiL1Qer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbiL1QeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:34:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4E71CB0C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:31:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B5F761562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C497C433F1;
        Wed, 28 Dec 2022 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245088;
        bh=80sPUJKPp03E1ruakYIIwa7Oza+XeI8kmICmIsueIcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bknTOdD/TGjhi4+zoWhYR1k2BGFvQYkIej+nKv7fB9Tg5BISnbJ/TgKuibmMMLcOH
         pWhQ0vQONvPq3HUAAKvPPxW71/uuSL4fZYFrU+UkWfJmXri4V0NGkGjtXhBT9kjeDl
         1IlUEpzAt8Xc6eEl49cnvJ9uI1OSDZAkwm5SbcJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaochen Shen <xiaochen.shen@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0794/1146] dmaengine: idxd: Make max batch size attributes in sysfs invisible for Intel IAA
Date:   Wed, 28 Dec 2022 15:38:53 +0100
Message-Id: <20221228144351.716771499@linuxfoundation.org>
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

From: Xiaochen Shen <xiaochen.shen@intel.com>

[ Upstream commit 91123b37e8a99cc489d5bdcfebd1c25f29382504 ]

In current code, dev.max_batch_size and wq.max_batch_size attributes in
sysfs are exposed to user to show or update the values.

>From Intel IAA spec [1], Intel IAA does not support batch processing. So
these sysfs attributes should not be supported on IAA device.

Fix this issue by making the attributes of max_batch_size invisible in
sysfs through is_visible() filter when the device is IAA.

Add description in the ABI documentation to mention that the attributes
are not visible when the device does not support batch.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/721858

Fixes: e7184b159dd3 ("dmaengine: idxd: add support for configurable max wq batch size")
Fixes: c52ca478233c ("dmaengine: idxd: add configuration component of driver")
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20220930201528.18621-3-xiaochen.shen@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/stable/sysfs-driver-dma-idxd          |  2 ++
 drivers/dma/idxd/sysfs.c                      | 32 +++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-driver-dma-idxd b/Documentation/ABI/stable/sysfs-driver-dma-idxd
index 8e2c2c405db2..69e2d9155e0d 100644
--- a/Documentation/ABI/stable/sysfs-driver-dma-idxd
+++ b/Documentation/ABI/stable/sysfs-driver-dma-idxd
@@ -22,6 +22,7 @@ Date:           Oct 25, 2019
 KernelVersion:  5.6.0
 Contact:        dmaengine@vger.kernel.org
 Description:    The largest number of work descriptors in a batch.
+                It's not visible when the device does not support batch.
 
 What:           /sys/bus/dsa/devices/dsa<m>/max_work_queues_size
 Date:           Oct 25, 2019
@@ -205,6 +206,7 @@ KernelVersion:	5.10.0
 Contact:	dmaengine@vger.kernel.org
 Description:	The max batch size for this workqueue. Cannot exceed device
 		max batch size. Configurable parameter.
+		It's not visible when the device does not support batch.
 
 What:		/sys/bus/dsa/devices/wq<m>.<n>/ats_disable
 Date:		Nov 13, 2020
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 7269bd54554f..7909767e9836 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1233,6 +1233,14 @@ static bool idxd_wq_attr_op_config_invisible(struct attribute *attr,
 	       !idxd->hw.wq_cap.op_config;
 }
 
+static bool idxd_wq_attr_max_batch_size_invisible(struct attribute *attr,
+						  struct idxd_device *idxd)
+{
+	/* Intel IAA does not support batch processing, make it invisible */
+	return attr == &dev_attr_wq_max_batch_size.attr &&
+	       idxd->data->type == IDXD_TYPE_IAX;
+}
+
 static umode_t idxd_wq_attr_visible(struct kobject *kobj,
 				    struct attribute *attr, int n)
 {
@@ -1243,6 +1251,9 @@ static umode_t idxd_wq_attr_visible(struct kobject *kobj,
 	if (idxd_wq_attr_op_config_invisible(attr, idxd))
 		return 0;
 
+	if (idxd_wq_attr_max_batch_size_invisible(attr, idxd))
+		return 0;
+
 	return attr->mode;
 }
 
@@ -1533,6 +1544,26 @@ static ssize_t cmd_status_store(struct device *dev, struct device_attribute *att
 }
 static DEVICE_ATTR_RW(cmd_status);
 
+static bool idxd_device_attr_max_batch_size_invisible(struct attribute *attr,
+						      struct idxd_device *idxd)
+{
+	/* Intel IAA does not support batch processing, make it invisible */
+	return attr == &dev_attr_max_batch_size.attr &&
+	       idxd->data->type == IDXD_TYPE_IAX;
+}
+
+static umode_t idxd_device_attr_visible(struct kobject *kobj,
+					struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct idxd_device *idxd = confdev_to_idxd(dev);
+
+	if (idxd_device_attr_max_batch_size_invisible(attr, idxd))
+		return 0;
+
+	return attr->mode;
+}
+
 static struct attribute *idxd_device_attributes[] = {
 	&dev_attr_version.attr,
 	&dev_attr_max_groups.attr,
@@ -1560,6 +1591,7 @@ static struct attribute *idxd_device_attributes[] = {
 
 static const struct attribute_group idxd_device_attribute_group = {
 	.attrs = idxd_device_attributes,
+	.is_visible = idxd_device_attr_visible,
 };
 
 static const struct attribute_group *idxd_attribute_groups[] = {
-- 
2.35.1



