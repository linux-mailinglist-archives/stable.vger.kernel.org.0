Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED6661109A
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiJ1MHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiJ1MHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:07:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D238D73D0
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EF88B829BF
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A49C433C1;
        Fri, 28 Oct 2022 12:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958825;
        bh=5DZpypLfw4oIO/vbZk37tcVmFgXAgqD7CladzK62cQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+xjBZUhvdjDxcy3uN/8mQwpNRh8/A7T6D9C2Wp4fkXxXikjlT8uAm2bwkDu7fBFd
         bqP3nC4udbzfqnSd13mHxsj1+uX8LWiOZZKd4x0LB49PHv1yycJbpqgtjuX7KPulvZ
         H1MgUMCYu7q7d+CewsYyQnVg9RtPzRsqI0CP6gp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guenter Roeck <linux@roeck-us.net>,
        Hannes Reinecke <hare@suse.de>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 36/73] nvme-hwmon: rework to avoid devm allocation
Date:   Fri, 28 Oct 2022 14:03:33 +0200
Message-Id: <20221028120233.951306845@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit ed7770f6628691c13c9423bce7eee7cff2399c12 ]

The original design to use device-managed resource allocation
doesn't really work as the NVMe controller has a vastly different
lifetime than the hwmon sysfs attributes, causing warning about
duplicate sysfs entries upon reconnection.
This patch reworks the hwmon allocation to avoid device-managed
resource allocation, and uses the NVMe controller as parent for
the sysfs attributes.

Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Tested-by: Enzo Matsumiya <ematsumiya@suse.de>
Tested-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: c94b7f9bab22 ("nvme-hwmon: kmalloc the NVME SMART log buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c  |  1 +
 drivers/nvme/host/hwmon.c | 31 +++++++++++++++++++++----------
 drivers/nvme/host/nvme.h  |  8 ++++++++
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e9c13804760e..51e5c12988fe 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4485,6 +4485,7 @@ EXPORT_SYMBOL_GPL(nvme_start_ctrl);
 
 void nvme_uninit_ctrl(struct nvme_ctrl *ctrl)
 {
+	nvme_hwmon_exit(ctrl);
 	nvme_fault_inject_fini(&ctrl->fault_inject);
 	dev_pm_qos_hide_latency_tolerance(ctrl->device);
 	cdev_device_del(&ctrl->cdev, ctrl->device);
diff --git a/drivers/nvme/host/hwmon.c b/drivers/nvme/host/hwmon.c
index 552dbc04567b..8f9e96986780 100644
--- a/drivers/nvme/host/hwmon.c
+++ b/drivers/nvme/host/hwmon.c
@@ -223,12 +223,12 @@ static const struct hwmon_chip_info nvme_hwmon_chip_info = {
 
 int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 {
-	struct device *dev = ctrl->dev;
+	struct device *dev = ctrl->device;
 	struct nvme_hwmon_data *data;
 	struct device *hwmon;
 	int err;
 
-	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return 0;
 
@@ -237,19 +237,30 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 
 	err = nvme_hwmon_get_smart_log(data);
 	if (err) {
-		dev_warn(ctrl->device,
-			"Failed to read smart log (error %d)\n", err);
-		devm_kfree(dev, data);
+		dev_warn(dev, "Failed to read smart log (error %d)\n", err);
+		kfree(data);
 		return err;
 	}
 
-	hwmon = devm_hwmon_device_register_with_info(dev, "nvme", data,
-						     &nvme_hwmon_chip_info,
-						     NULL);
+	hwmon = hwmon_device_register_with_info(dev, "nvme",
+						data, &nvme_hwmon_chip_info,
+						NULL);
 	if (IS_ERR(hwmon)) {
 		dev_warn(dev, "Failed to instantiate hwmon device\n");
-		devm_kfree(dev, data);
+		kfree(data);
 	}
-
+	ctrl->hwmon_device = hwmon;
 	return 0;
 }
+
+void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
+{
+	if (ctrl->hwmon_device) {
+		struct nvme_hwmon_data *data =
+			dev_get_drvdata(ctrl->hwmon_device);
+
+		hwmon_device_unregister(ctrl->hwmon_device);
+		ctrl->hwmon_device = NULL;
+		kfree(data);
+	}
+}
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 58cf9e39d613..abae7ef2ac51 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -257,6 +257,9 @@ struct nvme_ctrl {
 	struct rw_semaphore namespaces_rwsem;
 	struct device ctrl_device;
 	struct device *device;	/* char device */
+#ifdef CONFIG_NVME_HWMON
+	struct device *hwmon_device;
+#endif
 	struct cdev cdev;
 	struct work_struct reset_work;
 	struct work_struct delete_work;
@@ -876,11 +879,16 @@ static inline struct nvme_ns *nvme_get_ns_from_dev(struct device *dev)
 
 #ifdef CONFIG_NVME_HWMON
 int nvme_hwmon_init(struct nvme_ctrl *ctrl);
+void nvme_hwmon_exit(struct nvme_ctrl *ctrl);
 #else
 static inline int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 {
 	return 0;
 }
+
+static inline void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
+{
+}
 #endif
 
 u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-- 
2.35.1



