Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CBA60FE8B
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbiJ0RGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236968AbiJ0RGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:06:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB28917D290
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:06:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AECD623F4
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F56C433C1;
        Thu, 27 Oct 2022 17:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890369;
        bh=g3pnC9z6OukzWkozPxgvM1OacDMIW+IhDPNB5OZHA30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ebraf7OVw8AXjKkvFYpMDkS33djkOcngP1OvJ9+/jk1luOvZnqKYy+Pk7fmnje6fx
         IkDjEo6IAuuCL0I8RjD3qZRG8WRd6AhH9DYuqeJob+r8xpGq9koYBL6Tp05LHA8Ekq
         iFzzEc3tbL6xkdQ+jz7uE9fSXmWUy3bAm+gFj+MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Serge Semin <fancer.lancer@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/79] nvme-hwmon: consistently ignore errors from nvme_hwmon_init
Date:   Thu, 27 Oct 2022 18:55:54 +0200
Message-Id: <20221027165055.843291337@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6b8cf94005187952f794c0c4ed3920a1e8accfa3 ]

An NVMe controller works perfectly fine even when the hwmon
initialization fails.  Stop returning errors that do not come from a
controller reset from nvme_hwmon_init to handle this case consistently.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Stable-dep-of: c94b7f9bab22 ("nvme-hwmon: kmalloc the NVME SMART log buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c  |  6 +++++-
 drivers/nvme/host/hwmon.c | 13 ++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 51e5c12988fe..3f106771d15b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3232,8 +3232,12 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
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



