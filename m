Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5C03C4D34
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245366AbhGLHMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244427AbhGLHKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CA6C610A6;
        Mon, 12 Jul 2021 07:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073683;
        bh=iB29kZfknqzhKLSLWe4r0bv0OZYuxoCvV+dI0hPjsv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p78nXqKEPVBHYQ8m6zmQQoroxGkuoBlM03DYfD8w5f/PszOREXvgu5O9ALvLuJgZ/
         /0Fm6F6oziIBimSI0b/lGZrlvvCL8ybCLek7Ob2QcelamI+o5/yPiTheFnvyvodR3w
         +h2a6XJBDAPU7S9KaM//d9wRjMB4lnBCbJuZCGDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 324/700] ACPI: PM / fan: Put fan device IDs into separate header file
Date:   Mon, 12 Jul 2021 08:06:47 +0200
Message-Id: <20210712061010.830496981@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit b9370dceabb7841c5e65ce4ee4405b9db5231fc4 ]

The ACPI fan device IDs are shared between the fan driver and the
device power management code.  The former is modular, so it needs
to include the table of device IDs for module autoloading and the
latter needs that list to avoid attaching the generic ACPI PM domain
to fan devices (which doesn't make sense) possibly before the fan
driver module is loaded.

Unfortunately, that requires the list of fan device IDs to be
updated in two places which is prone to mistakes, so put it into
a symbol definition in a separate header file so there is only one
copy of it in case it needs to be updated again in the future.

Fixes: b9ea0bae260f ("ACPI: PM: Avoid attaching ACPI PM domain to certain devices")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_pm.c |  6 ++----
 drivers/acpi/fan.c       |  7 +++----
 drivers/acpi/fan.h       | 13 +++++++++++++
 3 files changed, 18 insertions(+), 8 deletions(-)
 create mode 100644 drivers/acpi/fan.h

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 58876248b192..a63dd10d9aa9 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -20,6 +20,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
 
+#include "fan.h"
 #include "internal.h"
 
 /**
@@ -1307,10 +1308,7 @@ int acpi_dev_pm_attach(struct device *dev, bool power_on)
 	 * with the generic ACPI PM domain.
 	 */
 	static const struct acpi_device_id special_pm_ids[] = {
-		{"PNP0C0B", }, /* Generic ACPI fan */
-		{"INT3404", }, /* Fan */
-		{"INTC1044", }, /* Fan for Tiger Lake generation */
-		{"INTC1048", }, /* Fan for Alder Lake generation */
+		ACPI_FAN_DEVICE_IDS,
 		{}
 	};
 	struct acpi_device *adev = ACPI_COMPANION(dev);
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 66c3983f0ccc..5cd0ceb50bc8 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -16,6 +16,8 @@
 #include <linux/platform_device.h>
 #include <linux/sort.h>
 
+#include "fan.h"
+
 MODULE_AUTHOR("Paul Diefenbaugh");
 MODULE_DESCRIPTION("ACPI Fan Driver");
 MODULE_LICENSE("GPL");
@@ -24,10 +26,7 @@ static int acpi_fan_probe(struct platform_device *pdev);
 static int acpi_fan_remove(struct platform_device *pdev);
 
 static const struct acpi_device_id fan_device_ids[] = {
-	{"PNP0C0B", 0},
-	{"INT3404", 0},
-	{"INTC1044", 0},
-	{"INTC1048", 0},
+	ACPI_FAN_DEVICE_IDS,
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, fan_device_ids);
diff --git a/drivers/acpi/fan.h b/drivers/acpi/fan.h
new file mode 100644
index 000000000000..dc9a6efa514b
--- /dev/null
+++ b/drivers/acpi/fan.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+/*
+ * ACPI fan device IDs are shared between the fan driver and the device power
+ * management code.
+ *
+ * Add new device IDs before the generic ACPI fan one.
+ */
+#define ACPI_FAN_DEVICE_IDS	\
+	{"INT3404", }, /* Fan */ \
+	{"INTC1044", }, /* Fan for Tiger Lake generation */ \
+	{"INTC1048", }, /* Fan for Alder Lake generation */ \
+	{"PNP0C0B", } /* Generic ACPI fan */
-- 
2.30.2



