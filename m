Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B110B451F16
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355502AbhKPAi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344467AbhKOTYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD7AD6367A;
        Mon, 15 Nov 2021 18:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002679;
        bh=lNJJ4LLDUiLKVW/5v5gpbEQBxQxQemHk4xMZ9dWm7a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDgF0iXDh3eppD9qodnZGdgfN1zsTJRilv61kRUmCRu1wkOSLJNBCKTtDuyg5zo6p
         yZYTrhvKe268SKIK0b1yFyJO89+J5qtDcivkZzmkTkztBG6DdZQnStX0wii04YY00X
         pNzd6CFXfUBSWxDQk/zjUmlsDvilZnRLfUiz6Jhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 630/917] staging: most: dim2: do not double-register the same device
Date:   Mon, 15 Nov 2021 18:02:05 +0100
Message-Id: <20211115165450.173452861@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

[ Upstream commit 2ab189164056b05474275bb40caa038a37713061 ]

Commit 723de0f9171e ("staging: most: remove device from interface
structure") moved registration of driver-provided struct device to
the most subsystem.

Dim2 used to register the same struct device to provide a custom device
attribute. This causes double-registration of the same struct device.

Fix that by moving the custom attribute to driver's dev_groups.
This moves attribute to the platform_device object, which is a better
location for platform-specific attributes anyway.

Fixes: 723de0f9171e ("staging: most: remove device from interface structure")
Acked-by: Christian Gromm <christian.gromm@microchip.com>
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Link: https://lore.kernel.org/r/20211011061117.21435-1-nikita.yoush@cogentembedded.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/most/dim2/Makefile |  2 +-
 drivers/staging/most/dim2/dim2.c   | 24 ++++++++-------
 drivers/staging/most/dim2/sysfs.c  | 49 ------------------------------
 drivers/staging/most/dim2/sysfs.h  | 11 -------
 4 files changed, 14 insertions(+), 72 deletions(-)
 delete mode 100644 drivers/staging/most/dim2/sysfs.c

diff --git a/drivers/staging/most/dim2/Makefile b/drivers/staging/most/dim2/Makefile
index 861adacf6c729..5f9612af3fa3c 100644
--- a/drivers/staging/most/dim2/Makefile
+++ b/drivers/staging/most/dim2/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MOST_DIM2) += most_dim2.o
 
-most_dim2-objs := dim2.o hal.o sysfs.o
+most_dim2-objs := dim2.o hal.o
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/dim2.c
index 093ef9a2b2919..b72d7b9b45ea9 100644
--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -117,7 +117,8 @@ struct dim2_platform_data {
 	(((p)[1] == 0x18) && ((p)[2] == 0x05) && ((p)[3] == 0x0C) && \
 	 ((p)[13] == 0x3C) && ((p)[14] == 0x00) && ((p)[15] == 0x0A))
 
-bool dim2_sysfs_get_state_cb(void)
+static ssize_t state_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
 {
 	bool state;
 	unsigned long flags;
@@ -126,9 +127,18 @@ bool dim2_sysfs_get_state_cb(void)
 	state = dim_get_lock_state();
 	spin_unlock_irqrestore(&dim_lock, flags);
 
-	return state;
+	return sysfs_emit(buf, "%s\n", state ? "locked" : "");
 }
 
+static DEVICE_ATTR_RO(state);
+
+static struct attribute *dim2_attrs[] = {
+	&dev_attr_state.attr,
+	NULL,
+};
+
+ATTRIBUTE_GROUPS(dim2);
+
 /**
  * dimcb_on_error - callback from HAL to report miscommunication between
  * HDM and HAL
@@ -866,16 +876,8 @@ static int dim2_probe(struct platform_device *pdev)
 		goto err_stop_thread;
 	}
 
-	ret = dim2_sysfs_probe(&dev->dev);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to create sysfs attribute\n");
-		goto err_unreg_iface;
-	}
-
 	return 0;
 
-err_unreg_iface:
-	most_deregister_interface(&dev->most_iface);
 err_stop_thread:
 	kthread_stop(dev->netinfo_task);
 err_shutdown_dim:
@@ -898,7 +900,6 @@ static int dim2_remove(struct platform_device *pdev)
 	struct dim2_hdm *dev = platform_get_drvdata(pdev);
 	unsigned long flags;
 
-	dim2_sysfs_destroy(&dev->dev);
 	most_deregister_interface(&dev->most_iface);
 	kthread_stop(dev->netinfo_task);
 
@@ -1082,6 +1083,7 @@ static struct platform_driver dim2_driver = {
 	.driver = {
 		.name = "hdm_dim2",
 		.of_match_table = dim2_of_match,
+		.dev_groups = dim2_groups,
 	},
 };
 
diff --git a/drivers/staging/most/dim2/sysfs.c b/drivers/staging/most/dim2/sysfs.c
deleted file mode 100644
index c85b2cdcdca3d..0000000000000
--- a/drivers/staging/most/dim2/sysfs.c
+++ /dev/null
@@ -1,49 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * sysfs.c - MediaLB sysfs information
- *
- * Copyright (C) 2015, Microchip Technology Germany II GmbH & Co. KG
- */
-
-/* Author: Andrey Shvetsov <andrey.shvetsov@k2l.de> */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/kernel.h>
-#include "sysfs.h"
-#include <linux/device.h>
-
-static ssize_t state_show(struct device *dev, struct device_attribute *attr,
-			  char *buf)
-{
-	bool state = dim2_sysfs_get_state_cb();
-
-	return sprintf(buf, "%s\n", state ? "locked" : "");
-}
-
-static DEVICE_ATTR_RO(state);
-
-static struct attribute *dev_attrs[] = {
-	&dev_attr_state.attr,
-	NULL,
-};
-
-static struct attribute_group dev_attr_group = {
-	.attrs = dev_attrs,
-};
-
-static const struct attribute_group *dev_attr_groups[] = {
-	&dev_attr_group,
-	NULL,
-};
-
-int dim2_sysfs_probe(struct device *dev)
-{
-	dev->groups = dev_attr_groups;
-	return device_register(dev);
-}
-
-void dim2_sysfs_destroy(struct device *dev)
-{
-	device_unregister(dev);
-}
diff --git a/drivers/staging/most/dim2/sysfs.h b/drivers/staging/most/dim2/sysfs.h
index 24277a17cff3d..09115cf4ed00e 100644
--- a/drivers/staging/most/dim2/sysfs.h
+++ b/drivers/staging/most/dim2/sysfs.h
@@ -16,15 +16,4 @@ struct medialb_bus {
 	struct kobject kobj_group;
 };
 
-struct device;
-
-int dim2_sysfs_probe(struct device *dev);
-void dim2_sysfs_destroy(struct device *dev);
-
-/*
- * callback,
- * must deliver MediaLB state as true if locked or false if unlocked
- */
-bool dim2_sysfs_get_state_cb(void);
-
 #endif	/* DIM2_SYSFS_H */
-- 
2.33.0



