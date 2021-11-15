Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBB5452092
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344199AbhKPAzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245736AbhKOTVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B0466328C;
        Mon, 15 Nov 2021 18:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001624;
        bh=qoemVxa7ZJJA84I2qEwqFTIIScJkbLpfTVZa4Wcglc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqlkUIfYwsK6DEgTOjlpAuIRybVNBeJY+vfDSQW/r7lGPLQM7NAL1SbB25Lf5haEV
         2DJQjmnwZFNr24/9Uswb1h+skpyo6MpwU/S+44yZliIy18kwhKEFfMzwmn8i8ily6q
         BHNUnTduYidtQryidkbTTRpnJcXRUHevzv6eCMKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuanzheng Song <songyuanzheng@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 260/917] thermal/core: Fix null pointer dereference in thermal_release()
Date:   Mon, 15 Nov 2021 17:55:55 +0100
Message-Id: <20211115165437.605126352@linuxfoundation.org>
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

From: Yuanzheng Song <songyuanzheng@huawei.com>

[ Upstream commit 1dd7128b839f631b31a9e9dce3aaf639bef74e9d ]

If both dev_set_name() and device_register() failed, then null pointer
dereference occurs in thermal_release() which will use strncmp() to
compare the name.

So fix it by adding dev_set_name() return value check.

Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
Link: https://lore.kernel.org/r/20211015083230.67658-1-songyuanzheng@huawei.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 51374f4e1ccaf..d094ebbde0ed7 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -902,6 +902,10 @@ __thermal_cooling_device_register(struct device_node *np,
 		goto out_kfree_cdev;
 	cdev->id = ret;
 
+	ret = dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
+	if (ret)
+		goto out_ida_remove;
+
 	cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
 	if (!cdev->type) {
 		ret = -ENOMEM;
@@ -916,7 +920,6 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->device.class = &thermal_class;
 	cdev->devdata = devdata;
 	thermal_cooling_device_setup_sysfs(cdev);
-	dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
 	ret = device_register(&cdev->device);
 	if (ret)
 		goto out_kfree_type;
@@ -1227,6 +1230,10 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 	tz->id = id;
 	strlcpy(tz->type, type, sizeof(tz->type));
 
+	result = dev_set_name(&tz->device, "thermal_zone%d", tz->id);
+	if (result)
+		goto remove_id;
+
 	if (!ops->critical)
 		ops->critical = thermal_zone_device_critical;
 
@@ -1248,7 +1255,6 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 	/* A new thermal zone needs to be updated anyway. */
 	atomic_set(&tz->need_update, 1);
 
-	dev_set_name(&tz->device, "thermal_zone%d", tz->id);
 	result = device_register(&tz->device);
 	if (result)
 		goto release_device;
-- 
2.33.0



