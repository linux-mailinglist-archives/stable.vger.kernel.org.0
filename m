Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54C56148E3
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiKALbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKALak (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:30:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BEC645E;
        Tue,  1 Nov 2022 04:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EA56B81CCC;
        Tue,  1 Nov 2022 11:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12DCC433D7;
        Tue,  1 Nov 2022 11:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302155;
        bh=B3LbPgQNVizzP/SCpy9m+4Q4ekqHIeBU5u7nK2+lmq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3TW1NFv/svfFF/FwyCX6XJCHKupFWGbDbNfNdye8Ki/8i6aWW0i6kWHvIgZsb8yu
         LDOcAxmpT4WTV7/Zdnk/EaPyzn90OGqQOlA83xDtxdxlIGWoAjJtIkka6IaQlJHSbG
         3d+cSg8BpoQEg70BpbXdV0HtCL3WI8qiPzIqGsLHiAnGeGWuMJXDixiJclBEoVFhwF
         PBAzS632B8JTN6GY7apm+e1THsjZYyQFsaTwHxc6DYVeZ8zN+QjWfk2naS8ptRHhFl
         0wDDljqK+gN5jGHi0XJyYZWcu4SgUTyQE6he+TFr7+bjYysPmfyImNBDQ9Ex/kMMKf
         PkcHulK3vMI8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>,
        Serge Semin <fancer.lancer@gmail.com>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 32/34] nvme-hwmon: consistently ignore errors from nvme_hwmon_init
Date:   Tue,  1 Nov 2022 07:27:24 -0400
Message-Id: <20221101112726.799368-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6b8cf94005187952f794c0c4ed3920a1e8accfa3 ]

An NVMe controller works perfectly fine even when the hwmon
initialization fails.  Stop returning errors that do not come from a
controller reset from nvme_hwmon_init to handle this case consistently.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c  |  6 +++++-
 drivers/nvme/host/hwmon.c | 13 ++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 59e4b188fc71..ed47c256dbd2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3256,8 +3256,12 @@ int nvme_init_ctrl_finish(struct nvme_ctrl *ctrl)
 		return ret;
 
 	if (!ctrl->identified && !nvme_discovery_ctrl(ctrl)) {
+		/*
+		 * Do not return errors unless we are in a controller reset,
+		 * the controller works perfectly fine without hwmon.
+		 */
 		ret = nvme_hwmon_init(ctrl);
-		if (ret < 0)
+		if (ret == -EINTR)
 			return ret;
 	}
 
diff --git a/drivers/nvme/host/hwmon.c b/drivers/nvme/host/hwmon.c
index 0a586d712920..23918bb7bdca 100644
--- a/drivers/nvme/host/hwmon.c
+++ b/drivers/nvme/host/hwmon.c
@@ -230,7 +230,7 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
-		return 0;
+		return -ENOMEM;
 
 	data->ctrl = ctrl;
 	mutex_init(&data->read_lock);
@@ -238,8 +238,7 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 	err = nvme_hwmon_get_smart_log(data);
 	if (err) {
 		dev_warn(dev, "Failed to read smart log (error %d)\n", err);
-		kfree(data);
-		return err;
+		goto err_free_data;
 	}
 
 	hwmon = hwmon_device_register_with_info(dev, "nvme",
@@ -247,11 +246,15 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 						NULL);
 	if (IS_ERR(hwmon)) {
 		dev_warn(dev, "Failed to instantiate hwmon device\n");
-		kfree(data);
-		return PTR_ERR(hwmon);
+		err = PTR_ERR(hwmon);
+		goto err_free_data;
 	}
 	ctrl->hwmon_device = hwmon;
 	return 0;
+
+err_free_data:
+	kfree(data);
+	return err;
 }
 
 void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
-- 
2.35.1

