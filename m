Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D6A68D81B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjBGNFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjBGNFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:05:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A3B2B2BE
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:05:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D27C761405
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D8EC433D2;
        Tue,  7 Feb 2023 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775107;
        bh=2Fgl7Pz2suVL3UgWIwFZjZk3AjTS970fthOHWrqveBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxqkUgGhIN00PZoF88Ba6cYnS7j21xpPL78/sEzb8gfzWcHCChOq1PKMMpFj1lQXS
         gzJp/qpp+MSrdPDOitjxMq51dncs5/yQCaTjUQGgY3CvvelT6jZTgyeK/gQxM/O1Wh
         xk2Xg4c4C+yMAWo7b7Q9u3yLWLzRchPal6aj3lMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wahaj <wahajaved@protonmail.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 138/208] iio: light: cm32181: Fix PM support on system with 2 I2C resources
Date:   Tue,  7 Feb 2023 13:56:32 +0100
Message-Id: <20230207125640.684243553@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit ee3c5b644a0fdcfed27515a39fb2dd3a016704c1 upstream.

Commit c1e62062ff54 ("iio: light: cm32181: Handle CM3218 ACPI devices
with 2 I2C resources") creates a second client for the actual I2C
address, but the "struct device" passed to PM ops is the first I2C
client that can't talk to the sensor.

That means the I2C transfers in both suspend and resume routines can
fail and blocking the whole suspend process.

Instead of using the first client for I2C transfer, use the I2C client
stored in the cm32181 private struct so the PM ops can get the correct
I2C client to really talk to the sensor device.

Fixes: 68c1b3dd5c48 ("iio: light: cm32181: Add PM support")
BugLink: https://bugs.launchpad.net/bugs/1988346
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2152281
Tested-by: Wahaj <wahajaved@protonmail.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230118170422.339619-1-kai.heng.feng@canonical.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/cm32181.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/light/cm32181.c b/drivers/iio/light/cm32181.c
index 001055d09750..b1674a5bfa36 100644
--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -440,6 +440,8 @@ static int cm32181_probe(struct i2c_client *client)
 	if (!indio_dev)
 		return -ENOMEM;
 
+	i2c_set_clientdata(client, indio_dev);
+
 	/*
 	 * Some ACPI systems list 2 I2C resources for the CM3218 sensor, the
 	 * SMBus Alert Response Address (ARA, 0x0c) and the actual I2C address.
@@ -460,8 +462,6 @@ static int cm32181_probe(struct i2c_client *client)
 			return PTR_ERR(client);
 	}
 
-	i2c_set_clientdata(client, indio_dev);
-
 	cm32181 = iio_priv(indio_dev);
 	cm32181->client = client;
 	cm32181->dev = dev;
@@ -490,7 +490,8 @@ static int cm32181_probe(struct i2c_client *client)
 
 static int cm32181_suspend(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct cm32181_chip *cm32181 = iio_priv(dev_get_drvdata(dev));
+	struct i2c_client *client = cm32181->client;
 
 	return i2c_smbus_write_word_data(client, CM32181_REG_ADDR_CMD,
 					 CM32181_CMD_ALS_DISABLE);
@@ -498,8 +499,8 @@ static int cm32181_suspend(struct device *dev)
 
 static int cm32181_resume(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
 	struct cm32181_chip *cm32181 = iio_priv(dev_get_drvdata(dev));
+	struct i2c_client *client = cm32181->client;
 
 	return i2c_smbus_write_word_data(client, CM32181_REG_ADDR_CMD,
 					 cm32181->conf_regs[CM32181_REG_ADDR_CMD]);
-- 
2.39.1



