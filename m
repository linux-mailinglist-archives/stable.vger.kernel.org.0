Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8FD2E39D0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389952AbgL1N2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:28:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389949AbgL1N2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC5902076D;
        Mon, 28 Dec 2020 13:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162073;
        bh=BiX6m5qkHd34IylteFKAGiblInlUoRrYwRmQxHqlfXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akQ+4D9+d9hC/6PWhDxiUTH02kSw+QPcH1tWnl70uV5wictK52T68+CSukMyj83CE
         Zq8o+PfufTaWS5469huEfCLW0nRsL3MLK2+jUTfGmWFBrkAMrY/CjZvKjN79KJhuf8
         F8rJMa+F7uvHlnW/y1hsX4mjFPMhwfjraOF99ghE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 178/346] power: supply: bq24190_charger: fix reference leak
Date:   Mon, 28 Dec 2020 13:48:17 +0100
Message-Id: <20201228124928.392985464@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index b58df04d03b33..863208928cf0b 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -446,8 +446,10 @@ static ssize_t bq24190_sysfs_show(struct device *dev,
 		return -EINVAL;
 
 	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(bdi->dev);
 		return ret;
+	}
 
 	ret = bq24190_read_mask(bdi, info->reg, info->mask, info->shift, &v);
 	if (ret)
@@ -1092,8 +1094,10 @@ static int bq24190_charger_get_property(struct power_supply *psy,
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
 	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(bdi->dev);
 		return ret;
+	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_CHARGE_TYPE:
@@ -1164,8 +1168,10 @@ static int bq24190_charger_set_property(struct power_supply *psy,
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
 	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(bdi->dev);
 		return ret;
+	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
@@ -1425,8 +1431,10 @@ static int bq24190_battery_get_property(struct power_supply *psy,
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
 	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(bdi->dev);
 		return ret;
+	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
@@ -1471,8 +1479,10 @@ static int bq24190_battery_set_property(struct power_supply *psy,
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



