Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680042E415F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439471AbgL1PFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439092AbgL1OKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0C23207A9;
        Mon, 28 Dec 2020 14:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164602;
        bh=/H0URN6vjAXxVFYXc2J8OtP/uXBDLqmC5M9Wr3X1s7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEPZjLH840Fs3xVefnn0sI2GDtsv+7wpEpZ1mZEooFfu90MFrHeNLYuWCOdNSBZJt
         VbiDUcMNmYq1245UzvbnM4wQO75yC9fdSf7T1//GaXjWSjsb3qzo7jTKcpbmxNli4A
         0YdbBNqnYXIe1gQfyuOvN+KFrIontKZK+0DmbTVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/717] power: supply: bq24190_charger: fix reference leak
Date:   Mon, 28 Dec 2020 13:43:50 +0100
Message-Id: <20201228125032.103817478@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit b2f6cb78eaa1cad57dd3fe11d0458cd4fae9a584 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to call pm_runtime_put_noidle will result
in reference leak in callers(bq24190_sysfs_show,
bq24190_charger_get_property, bq24190_charger_set_property,
bq24190_battery_get_property, bq24190_battery_set_property),
so we should fix it.

Fixes: f385e6e2a1532 ("power: bq24190_charger: Use PM runtime autosuspend")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index d14186525e1e9..845af0f44c022 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -448,8 +448,10 @@ static ssize_t bq24190_sysfs_show(struct device *dev,
 		return -EINVAL;
 
 	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(bdi->dev);
 		return ret;
+	}
 
 	ret = bq24190_read_mask(bdi, info->reg, info->mask, info->shift, &v);
 	if (ret)
@@ -1077,8 +1079,10 @@ static int bq24190_charger_get_property(struct power_supply *psy,
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
 	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(bdi->dev);
 		return ret;
+	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_CHARGE_TYPE:
@@ -1149,8 +1153,10 @@ static int bq24190_charger_set_property(struct power_supply *psy,
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
 	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(bdi->dev);
 		return ret;
+	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
@@ -1410,8 +1416,10 @@ static int bq24190_battery_get_property(struct power_supply *psy,
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
 	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(bdi->dev);
 		return ret;
+	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
@@ -1456,8 +1464,10 @@ static int bq24190_battery_set_property(struct power_supply *psy,
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
 	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(bdi->dev);
 		return ret;
+	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
-- 
2.27.0



