Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22C0658170
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiL1Q2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiL1Q2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BC61AA02
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:24:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1018EB8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A11FC433EF;
        Wed, 28 Dec 2022 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244646;
        bh=GE9Rzqaf8nI9GBASXXYrdaOX/jnBKdBDhuxmyUUQxeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqBYTdDZEa613yB45x1YFZXhcpxNEDJ3nx72lpCd+W2v10yDHDkeJYxktDTLkeRVk
         4SPDb8RKbokf3Kmel6AdoYwSVMC/mdQ9z2mTk8WTK6b7UxVncsWkIKGl1HzWZueh8Y
         Fg6ZKFXeZDl2EZ69b1HV+YNT6qj7kgZQCG2ummUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheyu Ma <zheyuma97@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0747/1073] power: supply: cw2015: Use device managed API to simplify the code
Date:   Wed, 28 Dec 2022 15:38:55 +0100
Message-Id: <20221228144348.312745642@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 0cb172a4918e0b180400c3e1b2894641703eab6d ]

Use devm_delayed_work_autocancel() instead of the INIT_DELAYED_WORK() to
remove the cw_bat_remove() function.

And power_supply_put_battery_info() can also be removed because the
power_supply_get_battery_info() uses device managed memory allocation.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 97f2b4ddb0aa ("power: supply: cw2015: Fix potential null-ptr-deref in cw_bat_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cw2015_battery.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index 728e2a6cc9c3..6d52641151d9 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -21,6 +21,7 @@
 #include <linux/regmap.h>
 #include <linux/time.h>
 #include <linux/workqueue.h>
+#include <linux/devm-helpers.h>
 
 #define CW2015_SIZE_BATINFO		64
 
@@ -698,7 +699,8 @@ static int cw_bat_probe(struct i2c_client *client)
 	}
 
 	cw_bat->battery_workqueue = create_singlethread_workqueue("rk_battery");
-	INIT_DELAYED_WORK(&cw_bat->battery_delay_work, cw_bat_work);
+	devm_delayed_work_autocancel(&client->dev,
+							  &cw_bat->battery_delay_work, cw_bat_work);
 	queue_delayed_work(cw_bat->battery_workqueue,
 			   &cw_bat->battery_delay_work, msecs_to_jiffies(10));
 	return 0;
@@ -725,15 +727,6 @@ static int __maybe_unused cw_bat_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(cw_bat_pm_ops, cw_bat_suspend, cw_bat_resume);
 
-static int cw_bat_remove(struct i2c_client *client)
-{
-	struct cw_battery *cw_bat = i2c_get_clientdata(client);
-
-	cancel_delayed_work_sync(&cw_bat->battery_delay_work);
-	power_supply_put_battery_info(cw_bat->rk_bat, cw_bat->battery);
-	return 0;
-}
-
 static const struct i2c_device_id cw_bat_id_table[] = {
 	{ "cw2015", 0 },
 	{ }
@@ -752,7 +745,6 @@ static struct i2c_driver cw_bat_driver = {
 		.pm = &cw_bat_pm_ops,
 	},
 	.probe_new = cw_bat_probe,
-	.remove = cw_bat_remove,
 	.id_table = cw_bat_id_table,
 };
 
-- 
2.35.1



