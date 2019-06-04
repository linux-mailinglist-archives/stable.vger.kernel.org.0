Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0779535374
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfFDXZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbfFDXZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:25:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D8BE20862;
        Tue,  4 Jun 2019 23:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690713;
        bh=1mQ78j/lwtdNlqWmt1ua9gt6Sp3K5cKZWp50KPsWDUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwwziJG+hnlgw8U7cOvPcgOME5FP6dS3OZsp9EgIix2AmMCP6e2uNTJ4N6IMgqauq
         j/BE9D4Y9w6H6Dp0EiN6lZlEn2kDjh38aQntjHB9pKTAL7t0T1HqhuLQrb9TSSFy2Q
         9D3anF60VFAIp2aWWP1bi5ugV69gi6K45rKsb8Bo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 06/17] driver core: platform: Fix the usage of platform device name(pdev->name)
Date:   Tue,  4 Jun 2019 19:24:47 -0400
Message-Id: <20190604232459.7745-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232459.7745-1-sashal@kernel.org>
References: <20190604232459.7745-1-sashal@kernel.org>
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
index 14ff40371f01..ffa77b3df4ba 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -845,7 +845,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
 	if (len != -ENODEV)
 		return len;
 
-	len = snprintf(buf, PAGE_SIZE, "platform:%s\n", pdev->name);
+	len = snprintf(buf, PAGE_SIZE, "platform:%s\n", dev_name(&pdev->dev));
 
 	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
 }
@@ -921,7 +921,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 		return rc;
 
 	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
-			pdev->name);
+			dev_name(&pdev->dev));
 	return 0;
 }
 
@@ -930,7 +930,7 @@ static const struct platform_device_id *platform_match_id(
 			struct platform_device *pdev)
 {
 	while (id->name[0]) {
-		if (strcmp(pdev->name, id->name) == 0) {
+		if (strcmp(dev_name(&pdev->dev), id->name) == 0) {
 			pdev->id_entry = id;
 			return id;
 		}
@@ -974,7 +974,7 @@ static int platform_match(struct device *dev, struct device_driver *drv)
 		return platform_match_id(pdrv->id_table, pdev) != NULL;
 
 	/* fall-back to driver name match */
-	return (strcmp(pdev->name, drv->name) == 0);
+	return (strcmp(dev_name(&pdev->dev), drv->name) == 0);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.20.1

