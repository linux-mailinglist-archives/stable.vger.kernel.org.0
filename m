Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDE92E1D7A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgLWOie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:38:34 -0500
Received: from mga07.intel.com ([134.134.136.100]:6845 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgLWOie (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 09:38:34 -0500
IronPort-SDR: cE9gPum3hjrLaW3aw04/mqq+GLL+zYpD4id0TAHsHnAl/56TsSL0LIesbSdvryYUhrLaV8bbtU
 r0jSUUuK5jEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9843"; a="240105442"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="240105442"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2020 06:36:47 -0800
IronPort-SDR: 80K/mTCNmPhhIRSC7EIJV9oNpwHZLirsQPx/xvUJ/YSMvnnwUp3UW0UW40pcsRRFePhHaIa4i2
 lC5eSRmZimwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="457991758"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2020 06:36:45 -0800
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moody Salem <moody@uniswap.org>, stable@vger.kernel.org
Subject: [PATCH] ACPI / scan: Don't create platform device for INT3515 ACPI nodes
Date:   Wed, 23 Dec 2020 17:36:44 +0300
Message-Id: <20201223143644.33341-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1883511
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/platform/x86/i2c-multi-instantiate.c | 31 +++++++++++++++-----
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/i2c-multi-instantiate.c b/drivers/platform/x86/i2c-multi-instantiate.c
index 6acc8457866e1..e1df665d3ad31 100644
--- a/drivers/platform/x86/i2c-multi-instantiate.c
+++ b/drivers/platform/x86/i2c-multi-instantiate.c
@@ -166,13 +166,29 @@ static const struct i2c_inst_data bsg2150_data[]  = {
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
+ * the irq line from the PD controller is not actually connected at all. But the
+ * interrupt flood is also seen on some boards where those are not a problem, so
+ * there are some other problems as well.
+ *
+ * Because of the issues with the interrupt, the device is disabled for now. If
+ * you wish to debug the issues, uncomment the below, and add an entry for the
+ * INT3515 device to the i2c_multi_instance__ids table.
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
@@ -181,7 +197,6 @@ static const struct i2c_inst_data int3515_data[]  = {
 static const struct acpi_device_id i2c_multi_inst_acpi_ids[] = {
 	{ "BSG1160", (unsigned long)bsg1160_data },
 	{ "BSG2150", (unsigned long)bsg2150_data },
-	{ "INT3515", (unsigned long)int3515_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, i2c_multi_inst_acpi_ids);
-- 
2.29.2

