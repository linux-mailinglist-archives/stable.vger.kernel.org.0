Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789AA489207
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241455AbiAJHhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42676 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241051AbiAJHei (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:34:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EC1C60C07;
        Mon, 10 Jan 2022 07:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61561C36AED;
        Mon, 10 Jan 2022 07:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800074;
        bh=MCsFaAiWm6my6sUnZa4K4kkGh4YU1t59pdeAwZ6QeJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0s75Qs2/v/hVUtW3oWfUSTWNpTcAPBKbWNEPcP2uPVPOeikv/BMZ3/4JttY+p0JI
         4TIz72/4RMIponQ0X1qonkAlVzY7wDsOO3ycUuqRYbsq1ByqQmdNTn5g7YI+9W5vMv
         y/qQ55ILmE7hQ3Y8WqbRGPsRyKk6eENJVieL307U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Tareque Md.Hanif" <tarequemd.hanif@yahoo.com>,
        Konstantin Kharlamov <hi-angel@yandex.ru>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 38/72] Revert "i2c: core: support bus regulator controlling in adapter"
Date:   Mon, 10 Jan 2022 08:23:15 +0100
Message-Id: <20220110071822.844018002@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa@kernel.org>

commit a19f75de73c220b4496d2aefb7a605dd032f7c01 upstream.

This largely reverts commit 5a7b95fb993ec399c8a685552aa6a8fc995c40bd. It
breaks suspend with AMD GPUs, and we couldn't incrementally fix it. So,
let's remove the code and go back to the drawing board. We keep the
header extension to not break drivers already populating the regulator.
We expect to re-add the code handling it soon.

Fixes: 5a7b95fb993e ("i2c: core: support bus regulator controlling in adapter")
Reported-by: "Tareque Md.Hanif" <tarequemd.hanif@yahoo.com>
Link: https://lore.kernel.org/r/1295184560.182511.1639075777725@mail.yahoo.com
Reported-by: Konstantin Kharlamov <hi-angel@yandex.ru>
Link: https://lore.kernel.org/r/7143a7147978f4104171072d9f5225d2ce355ec1.camel@yandex.ru
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1850
Tested-by: "Tareque Md.Hanif" <tarequemd.hanif@yahoo.com>
Tested-by: Konstantin Kharlamov <hi-angel@yandex.ru>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |   95 --------------------------------------------
 1 file changed, 95 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -466,14 +466,12 @@ static int i2c_smbus_host_notify_to_irq(
 static int i2c_device_probe(struct device *dev)
 {
 	struct i2c_client	*client = i2c_verify_client(dev);
-	struct i2c_adapter	*adap;
 	struct i2c_driver	*driver;
 	int status;
 
 	if (!client)
 		return 0;
 
-	adap = client->adapter;
 	client->irq = client->init_irq;
 
 	if (!client->irq) {
@@ -539,14 +537,6 @@ static int i2c_device_probe(struct devic
 
 	dev_dbg(dev, "probe\n");
 
-	if (adap->bus_regulator) {
-		status = regulator_enable(adap->bus_regulator);
-		if (status < 0) {
-			dev_err(&adap->dev, "Failed to enable bus regulator\n");
-			goto err_clear_wakeup_irq;
-		}
-	}
-
 	status = of_clk_set_defaults(dev->of_node, false);
 	if (status < 0)
 		goto err_clear_wakeup_irq;
@@ -604,10 +594,8 @@ put_sync_adapter:
 static void i2c_device_remove(struct device *dev)
 {
 	struct i2c_client	*client = to_i2c_client(dev);
-	struct i2c_adapter      *adap;
 	struct i2c_driver	*driver;
 
-	adap = client->adapter;
 	driver = to_i2c_driver(dev->driver);
 	if (driver->remove) {
 		int status;
@@ -622,8 +610,6 @@ static void i2c_device_remove(struct dev
 	devres_release_group(&client->dev, client->devres_group_id);
 
 	dev_pm_domain_detach(&client->dev, true);
-	if (!pm_runtime_status_suspended(&client->dev) && adap->bus_regulator)
-		regulator_disable(adap->bus_regulator);
 
 	dev_pm_clear_wake_irq(&client->dev);
 	device_init_wakeup(&client->dev, false);
@@ -633,86 +619,6 @@ static void i2c_device_remove(struct dev
 		pm_runtime_put(&client->adapter->dev);
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int i2c_resume_early(struct device *dev)
-{
-	struct i2c_client *client = i2c_verify_client(dev);
-	int err;
-
-	if (!client)
-		return 0;
-
-	if (pm_runtime_status_suspended(&client->dev) &&
-		client->adapter->bus_regulator) {
-		err = regulator_enable(client->adapter->bus_regulator);
-		if (err)
-			return err;
-	}
-
-	return pm_generic_resume_early(&client->dev);
-}
-
-static int i2c_suspend_late(struct device *dev)
-{
-	struct i2c_client *client = i2c_verify_client(dev);
-	int err;
-
-	if (!client)
-		return 0;
-
-	err = pm_generic_suspend_late(&client->dev);
-	if (err)
-		return err;
-
-	if (!pm_runtime_status_suspended(&client->dev) &&
-		client->adapter->bus_regulator)
-		return regulator_disable(client->adapter->bus_regulator);
-
-	return 0;
-}
-#endif
-
-#ifdef CONFIG_PM
-static int i2c_runtime_resume(struct device *dev)
-{
-	struct i2c_client *client = i2c_verify_client(dev);
-	int err;
-
-	if (!client)
-		return 0;
-
-	if (client->adapter->bus_regulator) {
-		err = regulator_enable(client->adapter->bus_regulator);
-		if (err)
-			return err;
-	}
-
-	return pm_generic_runtime_resume(&client->dev);
-}
-
-static int i2c_runtime_suspend(struct device *dev)
-{
-	struct i2c_client *client = i2c_verify_client(dev);
-	int err;
-
-	if (!client)
-		return 0;
-
-	err = pm_generic_runtime_suspend(&client->dev);
-	if (err)
-		return err;
-
-	if (client->adapter->bus_regulator)
-		return regulator_disable(client->adapter->bus_regulator);
-	return 0;
-}
-#endif
-
-static const struct dev_pm_ops i2c_device_pm = {
-	SET_LATE_SYSTEM_SLEEP_PM_OPS(i2c_suspend_late, i2c_resume_early)
-	SET_RUNTIME_PM_OPS(i2c_runtime_suspend, i2c_runtime_resume, NULL)
-};
-
 static void i2c_device_shutdown(struct device *dev)
 {
 	struct i2c_client *client = i2c_verify_client(dev);
@@ -772,7 +678,6 @@ struct bus_type i2c_bus_type = {
 	.probe		= i2c_device_probe,
 	.remove		= i2c_device_remove,
 	.shutdown	= i2c_device_shutdown,
-	.pm		= &i2c_device_pm,
 };
 EXPORT_SYMBOL_GPL(i2c_bus_type);
 


