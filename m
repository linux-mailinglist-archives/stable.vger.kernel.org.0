Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEA34F28EF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiDEIX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237478AbiDEISD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B504B53F2;
        Tue,  5 Apr 2022 01:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C016617EF;
        Tue,  5 Apr 2022 08:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9BDC385A1;
        Tue,  5 Apr 2022 08:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145983;
        bh=9n0s1PVnFShGn2pmObyGWleDrpp43npEIx1yGJvstUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Du952JaCwqdfaPwo72AxWllgpGDk8C3erEaCoKQxQB1LGFpQjd/EcTpVhJ11hPmkD
         8EdtYjsvH+XmV7sfp6BlhaJ1WOMq+PIuJfVXAxP4yxX7DDzCDHyA1YELmEL/HeHBzW
         7tZtIruWUIfEfJcPnQrQC3JUBhTlbhfa+EnDOQVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0601/1126] power: supply: sbs-charger: Dont cancel work that is not initialized
Date:   Tue,  5 Apr 2022 09:22:28 +0200
Message-Id: <20220405070425.275097515@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit de85193cff0d94d030a53656d8fcc41794807bef ]

This driver can use an interrupt or polling in order get the charger's
status.

When using polling, a delayed work is used.

However, the remove() function unconditionally call
cancel_delayed_work_sync(), even if the delayed work is not used and is not
initialized.

In order to fix it, use devm_delayed_work_autocancel() and remove the now
useless remove() function.

Fixes: feb583e37f8a ("power: supply: add sbs-charger driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sbs-charger.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/power/supply/sbs-charger.c b/drivers/power/supply/sbs-charger.c
index 6fa65d118ec1..b08f7d0c4181 100644
--- a/drivers/power/supply/sbs-charger.c
+++ b/drivers/power/supply/sbs-charger.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/regmap.h>
 #include <linux/bitops.h>
+#include <linux/devm-helpers.h>
 
 #define SBS_CHARGER_REG_SPEC_INFO		0x11
 #define SBS_CHARGER_REG_STATUS			0x13
@@ -209,7 +210,12 @@ static int sbs_probe(struct i2c_client *client,
 		if (ret)
 			return dev_err_probe(&client->dev, ret, "Failed to request irq\n");
 	} else {
-		INIT_DELAYED_WORK(&chip->work, sbs_delayed_work);
+		ret = devm_delayed_work_autocancel(&client->dev, &chip->work,
+						   sbs_delayed_work);
+		if (ret)
+			return dev_err_probe(&client->dev, ret,
+					     "Failed to init work for polling\n");
+
 		schedule_delayed_work(&chip->work,
 				      msecs_to_jiffies(SBS_CHARGER_POLL_TIME));
 	}
@@ -220,15 +226,6 @@ static int sbs_probe(struct i2c_client *client,
 	return 0;
 }
 
-static int sbs_remove(struct i2c_client *client)
-{
-	struct sbs_info *chip = i2c_get_clientdata(client);
-
-	cancel_delayed_work_sync(&chip->work);
-
-	return 0;
-}
-
 #ifdef CONFIG_OF
 static const struct of_device_id sbs_dt_ids[] = {
 	{ .compatible = "sbs,sbs-charger" },
@@ -245,7 +242,6 @@ MODULE_DEVICE_TABLE(i2c, sbs_id);
 
 static struct i2c_driver sbs_driver = {
 	.probe		= sbs_probe,
-	.remove		= sbs_remove,
 	.id_table	= sbs_id,
 	.driver = {
 		.name	= "sbs-charger",
-- 
2.34.1



