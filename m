Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2D038A1FA
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhETJgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232186AbhETJfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:35:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 300D8613BD;
        Thu, 20 May 2021 09:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502964;
        bh=pzL1qU+2Rr0Nm+QO054FvBXcIonwTHJVm2YLEYIoKR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c02nRaSjLUNyTqiowdNFxKWdUMHw59gtp/JeoJmo1lw4e7Xh1FnN2ElW5okOvN2t0
         z7Fv2Z9igd/Z/aS4H+QoqDyL4K5R30b7jV2YrRKDXctjQbogaMTePIcF3l50WfgnoD
         MAnqcBtE+AQq9iTetjEQt7Y1YszDU097vw2hbUHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/37] Input: silead - add workaround for x86 BIOS-es which bring the chip up in a stuck state
Date:   Thu, 20 May 2021 11:22:36 +0200
Message-Id: <20210520092052.778033835@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e479187748a8f151a85116a7091c599b121fdea5 ]

Some buggy BIOS-es bring up the touchscreen-controller in a stuck
state where it blocks the I2C bus. Specifically this happens on
the Jumper EZpad 7 tablet model.

After much poking at this problem I have found that the following steps
are necessary to unstuck the chip / bus:

1. Turn off the Silead chip.
2. Try to do an I2C transfer with the chip, this will fail in response to
   which the I2C-bus-driver will call: i2c_recover_bus() which will unstuck
   the I2C-bus. Note the unstuck-ing of the I2C bus only works if we first
   drop the chip of the bus by turning it off.
3. Turn the chip back on.

On the x86/ACPI systems were this problem is seen, step 1. and 3. require
making ACPI calls and dealing with ACPI Power Resources. This commit adds
a workaround which runtime-suspends the chip to turn it off, leaving it up
to the ACPI subsystem to deal with all the ACPI specific details.

There is no good way to detect this bug, so the workaround gets activated
by a new "silead,stuck-controller-bug" boolean device-property. Since this
is only used on x86/ACPI, this will be set by model specific device-props
set by drivers/platform/x86/touchscreen_dmi.c. Therefor this new
device-property is not documented in the DT-bindings.

Dmesg will contain the following messages on systems where the workaround
is activated:

[   54.309029] silead_ts i2c-MSSL1680:00: [Firmware Bug]: Stuck I2C bus: please ignore the next 'controller timed out' error
[   55.373593] i2c_designware 808622C1:04: controller timed out
[   55.582186] silead_ts i2c-MSSL1680:00: Silead chip ID: 0x80360000

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210405202745.16777-1-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/silead.c | 44 +++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/silead.c b/drivers/input/touchscreen/silead.c
index ad8b6a2bfd36..c8776146f1d1 100644
--- a/drivers/input/touchscreen/silead.c
+++ b/drivers/input/touchscreen/silead.c
@@ -20,6 +20,7 @@
 #include <linux/input/mt.h>
 #include <linux/input/touchscreen.h>
 #include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/irq.h>
 #include <linux/regulator/consumer.h>
 
@@ -335,10 +336,8 @@ static int silead_ts_get_id(struct i2c_client *client)
 
 	error = i2c_smbus_read_i2c_block_data(client, SILEAD_REG_ID,
 					      sizeof(chip_id), (u8 *)&chip_id);
-	if (error < 0) {
-		dev_err(&client->dev, "Chip ID read error %d\n", error);
+	if (error < 0)
 		return error;
-	}
 
 	data->chip_id = le32_to_cpu(chip_id);
 	dev_info(&client->dev, "Silead chip ID: 0x%8X", data->chip_id);
@@ -351,12 +350,49 @@ static int silead_ts_setup(struct i2c_client *client)
 	int error;
 	u32 status;
 
+	/*
+	 * Some buggy BIOS-es bring up the chip in a stuck state where it
+	 * blocks the I2C bus. The following steps are necessary to
+	 * unstuck the chip / bus:
+	 * 1. Turn off the Silead chip.
+	 * 2. Try to do an I2C transfer with the chip, this will fail in
+	 *    response to which the I2C-bus-driver will call:
+	 *    i2c_recover_bus() which will unstuck the I2C-bus. Note the
+	 *    unstuck-ing of the I2C bus only works if we first drop the
+	 *    chip off the bus by turning it off.
+	 * 3. Turn the chip back on.
+	 *
+	 * On the x86/ACPI systems were this problem is seen, step 1. and
+	 * 3. require making ACPI calls and dealing with ACPI Power
+	 * Resources. The workaround below runtime-suspends the chip to
+	 * turn it off, leaving it up to the ACPI subsystem to deal with
+	 * this.
+	 */
+
+	if (device_property_read_bool(&client->dev,
+				      "silead,stuck-controller-bug")) {
+		pm_runtime_set_active(&client->dev);
+		pm_runtime_enable(&client->dev);
+		pm_runtime_allow(&client->dev);
+
+		pm_runtime_suspend(&client->dev);
+
+		dev_warn(&client->dev, FW_BUG "Stuck I2C bus: please ignore the next 'controller timed out' error\n");
+		silead_ts_get_id(client);
+
+		/* The forbid will also resume the device */
+		pm_runtime_forbid(&client->dev);
+		pm_runtime_disable(&client->dev);
+	}
+
 	silead_ts_set_power(client, SILEAD_POWER_OFF);
 	silead_ts_set_power(client, SILEAD_POWER_ON);
 
 	error = silead_ts_get_id(client);
-	if (error)
+	if (error) {
+		dev_err(&client->dev, "Chip ID read error %d\n", error);
 		return error;
+	}
 
 	error = silead_ts_init(client);
 	if (error)
-- 
2.30.2



