Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E3261109D
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiJ1MHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJ1MHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:07:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91468190E54
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A522B829BE
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927D3C433C1;
        Fri, 28 Oct 2022 12:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958833;
        bh=L+L7DKFBTs4WzsdcVIj/6n9M+x+AORuu7uofg6c0OpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpn0+eI+lyhFHjvwAuKkBVNQBjbEVSj/weGhsa4b/s+ZrGqeLTOn4/+SpkA1ruT9g
         qpLiforCHC1vj7TFc9o0YDT3lqv/oRELHo0KpOkIPYA80eINSFu3A6CkQh+mX8Ndy5
         b5GqDtjqdbOCUtl3/yQK39IH3bAHgEtsIh8PojQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/73] nvme-hwmon: kmalloc the NVME SMART log buffer
Date:   Fri, 28 Oct 2022 14:03:36 +0200
Message-Id: <20221028120234.081656492@linuxfoundation.org>
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

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit c94b7f9bab22ac504f9153767676e659988575ad ]

Recent commit 52fde2c07da6 ("nvme: set dma alignment to dword") has
caused a regression on our platform.

It turned out that the nvme_get_log() method invocation caused the
nvme_hwmon_data structure instance corruption.  In particular the
nvme_hwmon_data.ctrl pointer was overwritten either with zeros or with
garbage.  After some research we discovered that the problem happened
even before the actual NVME DMA execution, but during the buffer mapping.
Since our platform is DMA-noncoherent, the mapping implied the cache-line
invalidations or write-backs depending on the DMA-direction parameter.
In case of the NVME SMART log getting the DMA was performed
from-device-to-memory, thus the cache-invalidation was activated during
the buffer mapping.  Since the log-buffer isn't cache-line aligned, the
cache-invalidation caused the neighbour data to be discarded.  The
neighbouring data turned to be the data surrounding the buffer in the
framework of the nvme_hwmon_data structure.

In order to fix that we need to make sure that the whole log-buffer is
defined within the cache-line-aligned memory region so the
cache-invalidation procedure wouldn't involve the adjacent data. One of
the option to guarantee that is to kmalloc the DMA-buffer [1]. Seeing the
rest of the NVME core driver prefer that method it has been chosen to fix
this problem too.

Note after a deeper researches we found out that the denoted commit wasn't
a root cause of the problem. It just revealed the invalidity by activating
the DMA-based NVME SMART log getting performed in the framework of the
NVME hwmon driver. The problem was here since the initial commit of the
driver.

[1] Documentation/core-api/dma-api-howto.rst

Fixes: 400b6a7b13a3 ("nvme: Add hardware monitoring support")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/hwmon.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/hwmon.c b/drivers/nvme/host/hwmon.c
index 23918bb7bdca..9e6e56c20ec9 100644
--- a/drivers/nvme/host/hwmon.c
+++ b/drivers/nvme/host/hwmon.c
@@ -12,7 +12,7 @@
 
 struct nvme_hwmon_data {
 	struct nvme_ctrl *ctrl;
-	struct nvme_smart_log log;
+	struct nvme_smart_log *log;
 	struct mutex read_lock;
 };
 
@@ -60,14 +60,14 @@ static int nvme_set_temp_thresh(struct nvme_ctrl *ctrl, int sensor, bool under,
 static int nvme_hwmon_get_smart_log(struct nvme_hwmon_data *data)
 {
 	return nvme_get_log(data->ctrl, NVME_NSID_ALL, NVME_LOG_SMART, 0,
-			   NVME_CSI_NVM, &data->log, sizeof(data->log), 0);
+			   NVME_CSI_NVM, data->log, sizeof(*data->log), 0);
 }
 
 static int nvme_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			   u32 attr, int channel, long *val)
 {
 	struct nvme_hwmon_data *data = dev_get_drvdata(dev);
-	struct nvme_smart_log *log = &data->log;
+	struct nvme_smart_log *log = data->log;
 	int temp;
 	int err;
 
@@ -163,7 +163,7 @@ static umode_t nvme_hwmon_is_visible(const void *_data,
 	case hwmon_temp_max:
 	case hwmon_temp_min:
 		if ((!channel && data->ctrl->wctemp) ||
-		    (channel && data->log.temp_sensor[channel - 1])) {
+		    (channel && data->log->temp_sensor[channel - 1])) {
 			if (data->ctrl->quirks &
 			    NVME_QUIRK_NO_TEMP_THRESH_CHANGE)
 				return 0444;
@@ -176,7 +176,7 @@ static umode_t nvme_hwmon_is_visible(const void *_data,
 		break;
 	case hwmon_temp_input:
 	case hwmon_temp_label:
-		if (!channel || data->log.temp_sensor[channel - 1])
+		if (!channel || data->log->temp_sensor[channel - 1])
 			return 0444;
 		break;
 	default:
@@ -232,13 +232,19 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 	if (!data)
 		return -ENOMEM;
 
+	data->log = kzalloc(sizeof(*data->log), GFP_KERNEL);
+	if (!data->log) {
+		err = -ENOMEM;
+		goto err_free_data;
+	}
+
 	data->ctrl = ctrl;
 	mutex_init(&data->read_lock);
 
 	err = nvme_hwmon_get_smart_log(data);
 	if (err) {
 		dev_warn(dev, "Failed to read smart log (error %d)\n", err);
-		goto err_free_data;
+		goto err_free_log;
 	}
 
 	hwmon = hwmon_device_register_with_info(dev, "nvme",
@@ -247,11 +253,13 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 	if (IS_ERR(hwmon)) {
 		dev_warn(dev, "Failed to instantiate hwmon device\n");
 		err = PTR_ERR(hwmon);
-		goto err_free_data;
+		goto err_free_log;
 	}
 	ctrl->hwmon_device = hwmon;
 	return 0;
 
+err_free_log:
+	kfree(data->log);
 err_free_data:
 	kfree(data);
 	return err;
@@ -265,6 +273,7 @@ void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
 
 		hwmon_device_unregister(ctrl->hwmon_device);
 		ctrl->hwmon_device = NULL;
+		kfree(data->log);
 		kfree(data);
 	}
 }
-- 
2.35.1



