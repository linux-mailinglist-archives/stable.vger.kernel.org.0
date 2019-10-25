Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB539E4D73
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389701AbfJYN6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410382AbfJYN6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:58:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCAC42245A;
        Fri, 25 Oct 2019 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011926;
        bh=1B0Z3Z+ZgrnSvkongENlGpPWgEZtMXO/WX3vBpiNpwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPuBnQ3WZHnt+xyDVOMyIyOFzLZQI+ybYko7N7N2tgWlqmw6xmkSnacpLEXxAJDTT
         jP19axB7q2Lrkqys8lnsCSQL5EMnhIY1Vm5Gwywthu3o0DLG5B8Zidi2QvE8EqgQYK
         XpLW4i3kclivmsNmjeX7cGC7D7JVKm5RV2T5M+is=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 03/16] driver core: platform: Fix the usage of platform device name(pdev->name)
Date:   Fri, 25 Oct 2019 09:58:27 -0400
Message-Id: <20191025135842.25977-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135842.25977-1-sashal@kernel.org>
References: <20191025135842.25977-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>

[ Upstream commit edb16da34b084c66763f29bee42b4e6bb33c3d66 ]

Platform core is using pdev->name as the platform device name to do
the binding of the devices with the drivers. But, when the platform
driver overrides the platform device name with dev_set_name(),
the pdev->name is pointing to a location which is freed and becomes
an invalid parameter to do the binding match.

use-after-free instance:

[   33.325013] BUG: KASAN: use-after-free in strcmp+0x8c/0xb0
[   33.330646] Read of size 1 at addr ffffffc10beae600 by task modprobe
[   33.339068] CPU: 5 PID: 518 Comm: modprobe Tainted:
			G S      W  O      4.19.30+ #3
[   33.346835] Hardware name: MTP (DT)
[   33.350419] Call trace:
[   33.352941]  dump_backtrace+0x0/0x3b8
[   33.356713]  show_stack+0x24/0x30
[   33.360119]  dump_stack+0x160/0x1d8
[   33.363709]  print_address_description+0x84/0x2e0
[   33.368549]  kasan_report+0x26c/0x2d0
[   33.372322]  __asan_report_load1_noabort+0x2c/0x38
[   33.377248]  strcmp+0x8c/0xb0
[   33.380306]  platform_match+0x70/0x1f8
[   33.384168]  __driver_attach+0x78/0x3a0
[   33.388111]  bus_for_each_dev+0x13c/0x1b8
[   33.392237]  driver_attach+0x4c/0x58
[   33.395910]  bus_add_driver+0x350/0x560
[   33.399854]  driver_register+0x23c/0x328
[   33.403886]  __platform_driver_register+0xd0/0xe0

So, use dev_name(&pdev->dev), which fetches the platform device name from
the kobject(dev->kobj->name) of the device instead of the pdev->name.

Signed-off-by: Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 065fcc4be263a..071dd053a917b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -796,7 +796,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
 	if (len != -ENODEV)
 		return len;
 
-	len = snprintf(buf, PAGE_SIZE, "platform:%s\n", pdev->name);
+	len = snprintf(buf, PAGE_SIZE, "platform:%s\n", dev_name(&pdev->dev));
 
 	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
 }
@@ -872,7 +872,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 		return rc;
 
 	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
-			pdev->name);
+			dev_name(&pdev->dev));
 	return 0;
 }
 
@@ -881,7 +881,7 @@ static const struct platform_device_id *platform_match_id(
 			struct platform_device *pdev)
 {
 	while (id->name[0]) {
-		if (strcmp(pdev->name, id->name) == 0) {
+		if (strcmp(dev_name(&pdev->dev), id->name) == 0) {
 			pdev->id_entry = id;
 			return id;
 		}
@@ -925,7 +925,7 @@ static int platform_match(struct device *dev, struct device_driver *drv)
 		return platform_match_id(pdrv->id_table, pdev) != NULL;
 
 	/* fall-back to driver name match */
-	return (strcmp(pdev->name, drv->name) == 0);
+	return (strcmp(dev_name(&pdev->dev), drv->name) == 0);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.20.1

