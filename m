Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931E4354790
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbhDEU3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbhDEU3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:29:11 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFF8C061793
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:29:03 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b8-20020a17090a5508b029014d0fbe9b64so2670547pji.5
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tJGCCDpGp9fHrgO/mO0ByWA2nRfA494q9Fa0gNN88DQ=;
        b=XM26bs7XzjQZBLDccBKgY+vm7htF07BFCLzq+J+veCfqbLWLo3yFV0fcG80Gg3pe16
         JBBz2UbHj9FSsjK6d4FN74LeNwZUoodnhtWlSz0A+Vd/hufkAKzKVE2brKDweAMDDOhF
         nTEUZ8SiSI33q7RYLf2qR8W+vnbgOMBEZiLrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tJGCCDpGp9fHrgO/mO0ByWA2nRfA494q9Fa0gNN88DQ=;
        b=QVUUOvSrV0GwUCkxYuRMEmbug2oLawa53KaTFs5hvc0nfHjXeYsR9vG7X8Ykd4y15T
         PV1KRA7V33SJFVPBMIIW5K2ZoIax+pX+URSNYuOQVPTgErMPO9xWw8csYID7X7wTNh2k
         c9p7GZ/DuIcX4ZKo7CEJxC96jstCfMvh3qOims0j97nyFT5YO+hhyrrtf7Uw3RVmVP9R
         KFrpvABVU93gonNpzlzeShsD4LAsI+EClXyIpgEwXiB0axtoyeFCdFlDfX7JkXK2l++a
         l82eA93KQq5IBTssjYFnMtzJAMFb1cgb0mSGROal4GfAKetKLMNKgfrzPcdbtOviK1+0
         9V9w==
X-Gm-Message-State: AOAM532VhG6IsRoSMlXyM+ov0zjNOwGtchdGqi9ihT5OtBeJkICsn+KK
        GLSctQcbE1I4ECkM06QXYrpnKA==
X-Google-Smtp-Source: ABdhPJw9RG1kOWvLn4ei8G39MCKUirGG6er17zPRvrUBWpi6Z+B0xEbkB+Js7ASNmmnqCYXBl1Zd1w==
X-Received: by 2002:a17:90a:5d8f:: with SMTP id t15mr897524pji.28.1617654543049;
        Mon, 05 Apr 2021 13:29:03 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:2926:73d2:2f29:3222])
        by smtp.gmail.com with UTF8SMTPSA id d11sm270446pjz.47.2021.04.05.13.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 13:29:02 -0700 (PDT)
From:   Gwendal Grignou <gwendal@chromium.org>
X-Google-Original-From: Gwendal Grignou <gwendal@google.com>
To:     bleung@chromium.org, enric.balletbo@collabora.com,
        groeck@chromium.org
Cc:     linux-kernel@vger.kernel.org, Gwendal Grignou <gwendal@google.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] platform/chrome: Update cros_ec sysfs attributes on sensors discovery
Date:   Mon,  5 Apr 2021 13:28:57 -0700
Message-Id: <20210405202857.1265308-3-gwendal@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
In-Reply-To: <20210405202857.1265308-1-gwendal@google.com>
References: <20210405202857.1265308-1-gwendal@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When cros_ec_sysfs probe is called before cros_ec_sensorhub probe
routine, the |kb_wake_angle| attribute will not be displayed, even if
there are two accelerometers in the chromebook.

Call sysfs_update_groups() when accelerometers are enumerated if the
cros_ec sysfs attributes groups have already been created.

Fixes: d60ac88a62df ("mfd / platform / iio: cros_ec: Register sensor through sensorhub")
Cc: stable@vger.kernel.org
Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 Changes in v2:
 Rebase after .dev_groups is used.

 drivers/platform/chrome/cros_ec_sensorhub.c |  6 +++++-
 drivers/platform/chrome/cros_ec_sysfs.c     | 10 ++++++++++
 include/linux/platform_data/cros_ec_proto.h |  2 ++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_sensorhub.c b/drivers/platform/chrome/cros_ec_sensorhub.c
index 9c4af76a9956e..c69fec935fb50 100644
--- a/drivers/platform/chrome/cros_ec_sensorhub.c
+++ b/drivers/platform/chrome/cros_ec_sensorhub.c
@@ -106,8 +106,11 @@ static int cros_ec_sensorhub_register(struct device *dev,
 		sensor_type[sensorhub->resp->info.type]++;
 	}
 
-	if (sensor_type[MOTIONSENSE_TYPE_ACCEL] >= 2)
+	if (sensor_type[MOTIONSENSE_TYPE_ACCEL] >= 2) {
 		ec->has_kb_wake_angle = true;
+		if (ec->groups && sysfs_update_groups(&ec->class_dev.kobj, ec->groups))
+			dev_warn(dev, "Unable to update cros-ec-sysfs");
+	}
 
 	if (cros_ec_check_features(ec,
 				   EC_FEATURE_REFINED_TABLET_MODE_HYSTERESIS)) {
diff --git a/drivers/platform/chrome/cros_ec_sysfs.c b/drivers/platform/chrome/cros_ec_sysfs.c
index 114b9dbe981e7..b363f70270a38 100644
--- a/drivers/platform/chrome/cros_ec_sysfs.c
+++ b/drivers/platform/chrome/cros_ec_sysfs.c
@@ -340,11 +340,21 @@ static const struct attribute_group *cros_ec_attr_groups[] = {
 	NULL,
 };
 
+static int cros_ec_sysfs_probe(struct platform_device *pd)
+{
+	struct cros_ec_dev *ec_dev = dev_get_drvdata(pd->dev.parent);
+
+	ec_dev->groups = cros_ec_attr_groups;
+
+	return 0;
+}
+
 static struct platform_driver cros_ec_sysfs_driver = {
 	.driver = {
 		.name = DRV_NAME,
 		.dev_groups = cros_ec_attr_groups,
 	},
+	.probe = cros_ec_sysfs_probe,
 };
 
 module_platform_driver(cros_ec_sysfs_driver);
diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
index 02599687770c5..de940112f53ae 100644
--- a/include/linux/platform_data/cros_ec_proto.h
+++ b/include/linux/platform_data/cros_ec_proto.h
@@ -191,6 +191,7 @@ struct cros_ec_platform {
 /**
  * struct cros_ec_dev - ChromeOS EC device entry point.
  * @class_dev: Device structure used in sysfs.
+ * @groups: sysfs attributes groups for this EC.
  * @ec_dev: cros_ec_device structure to talk to the physical device.
  * @dev: Pointer to the platform device.
  * @debug_info: cros_ec_debugfs structure for debugging information.
@@ -200,6 +201,7 @@ struct cros_ec_platform {
  */
 struct cros_ec_dev {
 	struct device class_dev;
+	const struct attribute_group **groups;
 	struct cros_ec_device *ec_dev;
 	struct device *dev;
 	struct cros_ec_debugfs *debug_info;
-- 
2.31.0.208.g409f899ff0-goog

