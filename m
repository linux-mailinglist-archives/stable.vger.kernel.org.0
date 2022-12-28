Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD7F657BF9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiL1P1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbiL1P10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:27:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B56A14038
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:27:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E092B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C324C433EF;
        Wed, 28 Dec 2022 15:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241243;
        bh=r0oDJP/VvgWbOLRfHCpUr0l20Al1OnSvQYWkabodOYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IH9ae0RAbrtDs11FP1p0cIFpCS7eDqLHiLkh8lMZi1FBk+EGBqey8s5GY/+XmytCZ
         ZAABEYQ2IvFDddY8be8icVg5ng0iDcxy5XAlc4mC9S6rWDZsgksok2lSjfG3ceWiHD
         BrjfC0gcn2c0Z0GdYZHm4a/v7dTJpBPE4VC882T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0257/1073] dw9768: Enable low-power probe on ACPI
Date:   Wed, 28 Dec 2022 15:30:45 +0100
Message-Id: <20221228144334.999733671@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 5f9a089b6de34655318afe8e544d9a9cc0fc1d29 ]

Add support for low-power probe to the driver. Also fix runtime PM API
usage in the driver.

Much of the hassle comes from different factors affecting device power
states during probe for ACPI and DT.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Fixes: 859891228e56 ("media: i2c: dw9768: Add DW9768 VCM driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/dw9768.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/dw9768.c b/drivers/media/i2c/dw9768.c
index c086580efac7..60ae0adf5174 100644
--- a/drivers/media/i2c/dw9768.c
+++ b/drivers/media/i2c/dw9768.c
@@ -414,6 +414,7 @@ static int dw9768_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct dw9768 *dw9768;
+	bool full_power;
 	unsigned int i;
 	int ret;
 
@@ -469,13 +470,23 @@ static int dw9768_probe(struct i2c_client *client)
 
 	dw9768->sd.entity.function = MEDIA_ENT_F_LENS;
 
+	/*
+	 * Figure out whether we're going to power up the device here. Generally
+	 * this is done if CONFIG_PM is disabled in a DT system or the device is
+	 * to be powered on in an ACPI system. Similarly for power off in
+	 * remove.
+	 */
 	pm_runtime_enable(dev);
-	if (!pm_runtime_enabled(dev)) {
+	full_power = (is_acpi_node(dev_fwnode(dev)) &&
+		      acpi_dev_state_d0(dev)) ||
+		     (is_of_node(dev_fwnode(dev)) && !pm_runtime_enabled(dev));
+	if (full_power) {
 		ret = dw9768_runtime_resume(dev);
 		if (ret < 0) {
 			dev_err(dev, "failed to power on: %d\n", ret);
 			goto err_clean_entity;
 		}
+		pm_runtime_set_active(dev);
 	}
 
 	ret = v4l2_async_register_subdev(&dw9768->sd);
@@ -484,14 +495,17 @@ static int dw9768_probe(struct i2c_client *client)
 		goto err_power_off;
 	}
 
+	pm_runtime_idle(dev);
+
 	return 0;
 
 err_power_off:
-	if (pm_runtime_enabled(dev))
-		pm_runtime_disable(dev);
-	else
+	if (full_power) {
 		dw9768_runtime_suspend(dev);
+		pm_runtime_set_suspended(dev);
+	}
 err_clean_entity:
+	pm_runtime_disable(dev);
 	media_entity_cleanup(&dw9768->sd.entity);
 err_free_handler:
 	v4l2_ctrl_handler_free(&dw9768->ctrls);
@@ -503,14 +517,17 @@ static int dw9768_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct dw9768 *dw9768 = sd_to_dw9768(sd);
+	struct device *dev = &client->dev;
 
 	v4l2_async_unregister_subdev(&dw9768->sd);
 	v4l2_ctrl_handler_free(&dw9768->ctrls);
 	media_entity_cleanup(&dw9768->sd.entity);
-	pm_runtime_disable(&client->dev);
-	if (!pm_runtime_status_suspended(&client->dev))
-		dw9768_runtime_suspend(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
+	if ((is_acpi_node(dev_fwnode(dev)) && acpi_dev_state_d0(dev)) ||
+	    (is_of_node(dev_fwnode(dev)) && !pm_runtime_enabled(dev))) {
+		dw9768_runtime_suspend(dev);
+		pm_runtime_set_suspended(dev);
+	}
+	pm_runtime_disable(dev);
 
 	return 0;
 }
-- 
2.35.1



