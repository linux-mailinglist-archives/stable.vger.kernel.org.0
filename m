Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879633B4CDE
	for <lists+stable@lfdr.de>; Sat, 26 Jun 2021 07:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhFZFns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Jun 2021 01:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhFZFns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Jun 2021 01:43:48 -0400
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4B9C061574;
        Fri, 25 Jun 2021 22:41:26 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id F1E9441AC8;
        Sat, 26 Jun 2021 05:41:19 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Jean Delvare <jdelvare@suse.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        stable@vger.kernel.org
Subject: [PATCH v3] i2c: i801: Safely share SMBus with BIOS/ACPI
Date:   Sat, 26 Jun 2021 14:41:13 +0900
Message-Id: <20210626054113.246309-1-marcan@marcan.st>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The i801 controller provides a locking mechanism that the OS is supposed
to use to safely share the SMBus with ACPI AML or other firmware.

Previously, Linux attempted to get out of the way of ACPI AML entirely,
but left the bus locked if it used it before the first AML access. This
causes AML implementations that *do* attempt to safely share the bus
to time out if Linux uses it first; notably, this regressed ACPI video
backlight controls on 2015 iMacs after 01590f361e started instantiating
SPD EEPROMs on boot.

Commit 065b6211a8 fixed the immediate problem of leaving the bus locked,
but we can do better. The controller does have a proper locking mechanism,
so let's use it as intended. Since we can't rely on the BIOS doing this
properly, we implement the following logic:

- If ACPI AML uses the bus at all, we make a note and disable power
  management. The latter matches already existing behavior.
- When we want to use the bus, we attempt to lock it first. If the
  locking attempt times out, *and* ACPI hasn't tried to use the bus at
  all yet, we cautiously go ahead and assume the BIOS forgot to unlock
  the bus after boot. This preserves existing behavior.
- We always unlock the bus after a transfer.
- If ACPI AML tries to use the bus (except trying to lock it) while
  we're in the middle of a transfer, or after we've determined
  locking is broken, we know we cannot safely share the bus and give up.

Upon first usage of SMBus by ACPI AML, if nothing has gone horribly
wrong so far, users will see:

i801_smbus 0000:00:1f.4: SMBus controller is shared with ACPI AML. This seems safe so far.

If locking the SMBus times out, users will see:

i801_smbus 0000:00:1f.4: BIOS left SMBus locked

And if ACPI AML tries to use the bus concurrently with Linux, or it
previously used the bus and we failed to subsequently lock it as
above, the driver will give up and users will get:

i801_smbus 0000:00:1f.4: BIOS uses SMBus unsafely
i801_smbus 0000:00:1f.4: Driver SMBus register access inhibited

This fixes the regression introduced by 01590f361e, and further allows
safely sharing the SMBus on 2015 iMacs. Tested by running `i2cdump` in a
loop while changing backlight levels via the ACPI video device.

Fixes: 01590f361e ("i2c: i801: Instantiate SPD EEPROMs automatically")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/i2c/busses/i2c-i801.c | 96 ++++++++++++++++++++++++++++-------
 1 file changed, 79 insertions(+), 17 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 04a1e38f2a6f..03be6310d6d7 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -287,11 +287,18 @@ struct i801_priv {
 #endif
 	struct platform_device *tco_pdev;
 
+	/* BIOS left the controller marked busy. */
+	bool inuse_stuck;
 	/*
-	 * If set to true the host controller registers are reserved for
-	 * ACPI AML use. Protected by acpi_lock.
+	 * If set to true, ACPI AML uses the host controller registers.
+	 * Protected by acpi_lock.
 	 */
-	bool acpi_reserved;
+	bool acpi_usage;
+	/*
+	 * If set to true, ACPI AML uses the host controller registers in an
+	 * unsafe way. Protected by acpi_lock.
+	 */
+	bool acpi_unsafe;
 	struct mutex acpi_lock;
 };
 
@@ -854,10 +861,37 @@ static s32 i801_access(struct i2c_adapter *adap, u16 addr,
 	int hwpec;
 	int block = 0;
 	int ret = 0, xact = 0;
+	int timeout = 0;
 	struct i801_priv *priv = i2c_get_adapdata(adap);
 
+	/*
+	 * The controller provides a bit that implements a mutex mechanism
+	 * between users of the bus. First, try to lock the hardware mutex.
+	 * If this doesn't work, we give up trying to do this, but then
+	 * bail if ACPI uses SMBus at all.
+	 */
+	if (!priv->inuse_stuck) {
+		while (inb_p(SMBHSTSTS(priv)) & SMBHSTSTS_INUSE_STS) {
+			if (++timeout >= MAX_RETRIES) {
+				dev_warn(&priv->pci_dev->dev,
+					 "BIOS left SMBus locked\n");
+				priv->inuse_stuck = true;
+				break;
+			}
+			usleep_range(250, 500);
+		}
+	}
+
 	mutex_lock(&priv->acpi_lock);
-	if (priv->acpi_reserved) {
+	if (priv->acpi_usage && priv->inuse_stuck && !priv->acpi_unsafe) {
+		priv->acpi_unsafe = true;
+
+		dev_warn(&priv->pci_dev->dev, "BIOS uses SMBus unsafely\n");
+		dev_warn(&priv->pci_dev->dev,
+			 "Driver SMBus register access inhibited\n");
+	}
+
+	if (priv->acpi_unsafe) {
 		mutex_unlock(&priv->acpi_lock);
 		return -EBUSY;
 	}
@@ -1639,6 +1673,16 @@ static bool i801_acpi_is_smbus_ioport(const struct i801_priv *priv,
 	       address <= pci_resource_end(priv->pci_dev, SMBBAR);
 }
 
+static acpi_status
+i801_acpi_do_access(u32 function, acpi_physical_address address,
+				u32 bits, u64 *value)
+{
+	if ((function & ACPI_IO_MASK) == ACPI_READ)
+		return acpi_os_read_port(address, (u32 *)value, bits);
+	else
+		return acpi_os_write_port(address, (u32)*value, bits);
+}
+
 static acpi_status
 i801_acpi_io_handler(u32 function, acpi_physical_address address, u32 bits,
 		     u64 *value, void *handler_context, void *region_context)
@@ -1648,17 +1692,38 @@ i801_acpi_io_handler(u32 function, acpi_physical_address address, u32 bits,
 	acpi_status status;
 
 	/*
-	 * Once BIOS AML code touches the OpRegion we warn and inhibit any
-	 * further access from the driver itself. This device is now owned
-	 * by the system firmware.
+	 * Non-i801 accesses pass through.
 	 */
-	mutex_lock(&priv->acpi_lock);
+	if (!i801_acpi_is_smbus_ioport(priv, address))
+		return i801_acpi_do_access(function, address, bits, value);
 
-	if (!priv->acpi_reserved && i801_acpi_is_smbus_ioport(priv, address)) {
-		priv->acpi_reserved = true;
+	if (!mutex_trylock(&priv->acpi_lock)) {
+		mutex_lock(&priv->acpi_lock);
+		/*
+		 * This better be a read of the status register to acquire
+		 * the lock...
+		 */
+		if (!priv->acpi_unsafe &&
+			!(address == SMBHSTSTS(priv) &&
+			 (function & ACPI_IO_MASK) == ACPI_READ)) {
+			/*
+			 * Uh-oh, ACPI AML is trying to do something with the
+			 * controller without locking it properly.
+			 */
+			priv->acpi_unsafe = true;
+
+			dev_warn(&pdev->dev, "BIOS uses SMBus unsafely\n");
+			dev_warn(&pdev->dev,
+				 "Driver SMBus register access inhibited\n");
+		}
+	}
 
-		dev_warn(&pdev->dev, "BIOS is accessing SMBus registers\n");
-		dev_warn(&pdev->dev, "Driver SMBus register access inhibited\n");
+	if (!priv->acpi_usage) {
+		priv->acpi_usage = true;
+
+		if (!priv->acpi_unsafe)
+			dev_info(&pdev->dev,
+				 "SMBus controller is shared with ACPI AML. This seems safe so far.\n");
 
 		/*
 		 * BIOS is accessing the host controller so prevent it from
@@ -1667,10 +1732,7 @@ i801_acpi_io_handler(u32 function, acpi_physical_address address, u32 bits,
 		pm_runtime_get_sync(&pdev->dev);
 	}
 
-	if ((function & ACPI_IO_MASK) == ACPI_READ)
-		status = acpi_os_read_port(address, (u32 *)value, bits);
-	else
-		status = acpi_os_write_port(address, (u32)*value, bits);
+	status = i801_acpi_do_access(function, address, bits, value);
 
 	mutex_unlock(&priv->acpi_lock);
 
@@ -1706,7 +1768,7 @@ static void i801_acpi_remove(struct i801_priv *priv)
 		ACPI_ADR_SPACE_SYSTEM_IO, i801_acpi_io_handler);
 
 	mutex_lock(&priv->acpi_lock);
-	if (priv->acpi_reserved)
+	if (priv->acpi_usage)
 		pm_runtime_put(&priv->pci_dev->dev);
 	mutex_unlock(&priv->acpi_lock);
 }
-- 
2.32.0

