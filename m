Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA21068299A
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjAaJxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjAaJxh (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:53:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32137402C3
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:53:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1A0AB81ACC
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B186C433D2;
        Tue, 31 Jan 2023 09:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158805;
        bh=uXxIVePuNsWFaGH7rsHqcvUXjeFz5uBUf2O+0k91uZE=;
        h=Subject:To:From:Date:From;
        b=yKLxFr3yAT+CwRo0uKxz9UcIR4QunHisqlapyN4WO5ssb0nE3NjkNmHY5Z/naBjd6
         vn9e07NDMNRSSV90Blz3Dt6w7qfTTBc56EfRyKvtEuoRX9FX0KZGS1sreHCpQjwPUE
         2CV8NMq9OyDN1bVNBZkjXHlvB9piSMzeqIeOLxvI=
Subject: patch "iio: light: cm32181: Fix PM support on system with 2 I2C resources" added to char-misc-linus
To:     kai.heng.feng@canonical.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hdegoede@redhat.com,
        wahajaved@protonmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:44 +0100
Message-ID: <167515876482236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: cm32181: Fix PM support on system with 2 I2C resources

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ee3c5b644a0fdcfed27515a39fb2dd3a016704c1 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Thu, 19 Jan 2023 01:04:22 +0800
Subject: iio: light: cm32181: Fix PM support on system with 2 I2C resources

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


