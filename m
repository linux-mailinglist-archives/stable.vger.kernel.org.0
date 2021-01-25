Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1723A303327
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbhAZErQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:47:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbhAYSnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDD392083E;
        Mon, 25 Jan 2021 18:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600198;
        bh=Q4um/mPmFlhHEcZTIbeme6olhiiq6rbGgcy8LRTLgUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuxqJ8Q4SFGXMsnMub1YQgEoy7TfXYwy0P6/ZaevGks5FVmgT9LleY4coXKyjzRv2
         rEkPl8C91W+35Oay1ARt28zbsMQHLieNQO7D4yvaM1RC4yIo7VuaklJhtESWSd5VMD
         s02338AbYmYmGTN14KHhL6+dweVDqAq6FgLuVjfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moody Salem <moody@uniswap.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.4 02/86] platform/x86: i2c-multi-instantiate: Dont create platform device for INT3515 ACPI nodes
Date:   Mon, 25 Jan 2021 19:38:44 +0100
Message-Id: <20210125183201.138705731@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 9bba96275576da0cf78ede62aeb2fc975ed8a32d upstream.

There are several reports about the tps6598x causing
interrupt flood on boards with the INT3515 ACPI node, which
then causes instability. There appears to be several
problems with the interrupt. One problem is that the
I2CSerialBus resources do not always map to the Interrupt
resource with the same index, but that is not the only
problem. We have not been able to come up with a solution
for all the issues, and because of that disabling the device
for now.

The PD controller on these platforms is autonomous, and the
purpose for the driver is primarily to supply status to the
userspace, so this will not affect any functionality.

Reported-by: Moody Salem <moody@uniswap.org>
Fixes: a3dd034a1707 ("ACPI / scan: Create platform device for INT3515 ACPI nodes")
Cc: stable@vger.kernel.org
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1883511
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20201223143644.33341-1-heikki.krogerus@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/i2c-multi-instantiate.c |   31 ++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/platform/x86/i2c-multi-instantiate.c
+++ b/drivers/platform/x86/i2c-multi-instantiate.c
@@ -166,13 +166,29 @@ static const struct i2c_inst_data bsg215
 	{}
 };
 
-static const struct i2c_inst_data int3515_data[]  = {
-	{ "tps6598x", IRQ_RESOURCE_APIC, 0 },
-	{ "tps6598x", IRQ_RESOURCE_APIC, 1 },
-	{ "tps6598x", IRQ_RESOURCE_APIC, 2 },
-	{ "tps6598x", IRQ_RESOURCE_APIC, 3 },
-	{}
-};
+/*
+ * Device with _HID INT3515 (TI PD controllers) has some unresolved interrupt
+ * issues. The most common problem seen is interrupt flood.
+ *
+ * There are at least two known causes. Firstly, on some boards, the
+ * I2CSerialBus resource index does not match the Interrupt resource, i.e. they
+ * are not one-to-one mapped like in the array below. Secondly, on some boards
+ * the IRQ line from the PD controller is not actually connected at all. But the
+ * interrupt flood is also seen on some boards where those are not a problem, so
+ * there are some other problems as well.
+ *
+ * Because of the issues with the interrupt, the device is disabled for now. If
+ * you wish to debug the issues, uncomment the below, and add an entry for the
+ * INT3515 device to the i2c_multi_instance_ids table.
+ *
+ * static const struct i2c_inst_data int3515_data[]  = {
+ *	{ "tps6598x", IRQ_RESOURCE_APIC, 0 },
+ *	{ "tps6598x", IRQ_RESOURCE_APIC, 1 },
+ *	{ "tps6598x", IRQ_RESOURCE_APIC, 2 },
+ *	{ "tps6598x", IRQ_RESOURCE_APIC, 3 },
+ *	{ }
+ * };
+ */
 
 /*
  * Note new device-ids must also be added to i2c_multi_instantiate_ids in
@@ -181,7 +197,6 @@ static const struct i2c_inst_data int351
 static const struct acpi_device_id i2c_multi_inst_acpi_ids[] = {
 	{ "BSG1160", (unsigned long)bsg1160_data },
 	{ "BSG2150", (unsigned long)bsg2150_data },
-	{ "INT3515", (unsigned long)int3515_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, i2c_multi_inst_acpi_ids);


