Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A3C491582
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343647AbiARC2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:28:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43700 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245528AbiARC0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF5276111D;
        Tue, 18 Jan 2022 02:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6870AC36AEB;
        Tue, 18 Jan 2022 02:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472792;
        bh=liI5oHo+hy1bS9c8mmeSTwJK7B/DrVx+fsHTX63n/SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEPOgSaA5lATNLEEo78tdl7CgKpjl9Ba7S3V11d6jev22jE1iBWUB5Ax4tXm+gA3m
         xjvaTi+OfT9rlwdUvnZSnHrU36TpD5BsJSy77Ix9sSv3rDH3JZretkVt6csXbJF/Kx
         M7mujfm7WDMM3PHESKHOUDGvhyQ8qRyUY5dE6V9wkKCh/9bRtxMXq5KMuqfEv2IE2z
         cqOnBbzcUlFTmeVA+lRIA33v7S9R4YUhJgjjkWShD6HX+3ErRR2rtqcF1FZ0v8OdOx
         JMr9K+YqmcKz7HJmDod8sI8myd5wWYyrcEydDNlrJ3CUArf4bQtXEQCYHWElYigph0
         GM9ydAjvbVqXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alistair Francis <alistair@alistair23.me>,
        Rob Herring <robh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dmitry.torokhov@gmail.com,
        robh+dt@kernel.org, jikos@kernel.org,
        andriy.shevchenko@linux.intel.com, dianders@chromium.org,
        hdegoede@redhat.com, johnny.chuang.emc@gmail.com,
        jbroadus@gmail.com, mka@chromium.org, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 133/217] HID: i2c-hid-of: Expose the touchscreen-inverted properties
Date:   Mon, 17 Jan 2022 21:18:16 -0500
Message-Id: <20220118021940.1942199-133-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Francis <alistair@alistair23.me>

[ Upstream commit b60d3c803d7603432a08aeaf988aff53b3a5ec64 ]

Allow the touchscreen-inverted-x/y device tree properties to control the
HID_QUIRK_X_INVERT/HID_QUIRK_Y_INVERT quirks for the hid-input device.

Signed-off-by: Alistair Francis <alistair@alistair23.me>
Acked-by: Rob Herring <robh@kernel.org>
[bentiss: silence checkpatch warnings]
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211208124045.61815-3-alistair@alistair23.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/input/hid-over-i2c.txt         |  2 ++
 drivers/hid/i2c-hid/i2c-hid-acpi.c                     |  2 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                     |  4 +++-
 drivers/hid/i2c-hid/i2c-hid-of-goodix.c                |  2 +-
 drivers/hid/i2c-hid/i2c-hid-of.c                       | 10 +++++++++-
 drivers/hid/i2c-hid/i2c-hid.h                          |  2 +-
 6 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/hid-over-i2c.txt b/Documentation/devicetree/bindings/input/hid-over-i2c.txt
index c76bafaf98d2f..34c43d3bddfd1 100644
--- a/Documentation/devicetree/bindings/input/hid-over-i2c.txt
+++ b/Documentation/devicetree/bindings/input/hid-over-i2c.txt
@@ -32,6 +32,8 @@ device-specific compatible properties, which should be used in addition to the
 - vdd-supply: phandle of the regulator that provides the supply voltage.
 - post-power-on-delay-ms: time required by the device after enabling its regulators
   or powering it on, before it is ready for communication.
+- touchscreen-inverted-x: See touchscreen.txt
+- touchscreen-inverted-y: See touchscreen.txt
 
 Example:
 
diff --git a/drivers/hid/i2c-hid/i2c-hid-acpi.c b/drivers/hid/i2c-hid/i2c-hid-acpi.c
index a6f0257a26de3..b96ae15e0ad91 100644
--- a/drivers/hid/i2c-hid/i2c-hid-acpi.c
+++ b/drivers/hid/i2c-hid/i2c-hid-acpi.c
@@ -111,7 +111,7 @@ static int i2c_hid_acpi_probe(struct i2c_client *client)
 	}
 
 	return i2c_hid_core_probe(client, &ihid_acpi->ops,
-				  hid_descriptor_address);
+				  hid_descriptor_address, 0);
 }
 
 static const struct acpi_device_id i2c_hid_acpi_match[] = {
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 517141138b007..4804d71e5293a 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -912,7 +912,7 @@ static void i2c_hid_core_shutdown_tail(struct i2c_hid *ihid)
 }
 
 int i2c_hid_core_probe(struct i2c_client *client, struct i2chid_ops *ops,
-		       u16 hid_descriptor_address)
+		       u16 hid_descriptor_address, u32 quirks)
 {
 	int ret;
 	struct i2c_hid *ihid;
@@ -1009,6 +1009,8 @@ int i2c_hid_core_probe(struct i2c_client *client, struct i2chid_ops *ops,
 		goto err_mem_free;
 	}
 
+	hid->quirks |= quirks;
+
 	return 0;
 
 err_mem_free:
diff --git a/drivers/hid/i2c-hid/i2c-hid-of-goodix.c b/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
index 52674149a2750..b4dad66fa954d 100644
--- a/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
@@ -150,7 +150,7 @@ static int i2c_hid_of_goodix_probe(struct i2c_client *client,
 		goodix_i2c_hid_deassert_reset(ihid_goodix, true);
 	mutex_unlock(&ihid_goodix->regulator_mutex);
 
-	return i2c_hid_core_probe(client, &ihid_goodix->ops, 0x0001);
+	return i2c_hid_core_probe(client, &ihid_goodix->ops, 0x0001, 0);
 }
 
 static const struct goodix_i2c_hid_timing_data goodix_gt7375p_timing_data = {
diff --git a/drivers/hid/i2c-hid/i2c-hid-of.c b/drivers/hid/i2c-hid/i2c-hid-of.c
index 4bf7cea926379..97a27a803f58d 100644
--- a/drivers/hid/i2c-hid/i2c-hid-of.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of.c
@@ -21,6 +21,7 @@
 
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/hid.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -71,6 +72,7 @@ static int i2c_hid_of_probe(struct i2c_client *client,
 	struct device *dev = &client->dev;
 	struct i2c_hid_of *ihid_of;
 	u16 hid_descriptor_address;
+	u32 quirks = 0;
 	int ret;
 	u32 val;
 
@@ -105,8 +107,14 @@ static int i2c_hid_of_probe(struct i2c_client *client,
 	if (ret)
 		return ret;
 
+	if (device_property_read_bool(dev, "touchscreen-inverted-x"))
+		quirks |= HID_QUIRK_X_INVERT;
+
+	if (device_property_read_bool(dev, "touchscreen-inverted-y"))
+		quirks |= HID_QUIRK_Y_INVERT;
+
 	return i2c_hid_core_probe(client, &ihid_of->ops,
-				  hid_descriptor_address);
+				  hid_descriptor_address, quirks);
 }
 
 static const struct of_device_id i2c_hid_of_match[] = {
diff --git a/drivers/hid/i2c-hid/i2c-hid.h b/drivers/hid/i2c-hid/i2c-hid.h
index 05a7827d211af..236cc062d5ef8 100644
--- a/drivers/hid/i2c-hid/i2c-hid.h
+++ b/drivers/hid/i2c-hid/i2c-hid.h
@@ -32,7 +32,7 @@ struct i2chid_ops {
 };
 
 int i2c_hid_core_probe(struct i2c_client *client, struct i2chid_ops *ops,
-		       u16 hid_descriptor_address);
+		       u16 hid_descriptor_address, u32 quirks);
 int i2c_hid_core_remove(struct i2c_client *client);
 
 void i2c_hid_core_shutdown(struct i2c_client *client);
-- 
2.34.1

