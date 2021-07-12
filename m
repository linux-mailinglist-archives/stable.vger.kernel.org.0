Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F5A3C5333
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347952AbhGLHyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244817AbhGLHsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:48:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5942861955;
        Mon, 12 Jul 2021 07:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075770;
        bh=gXplEzUOyCMiNyG6N2ZSavNxAt8N4u+N6We5ranqKsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbALuFmga9/vfgDwTO8K8/rsf5gQTRmb+b9GUm3q5+cAcUz5XQkNKW/uIBSQStVbG
         urXgJB8SX9DGpdMZVuHQ9muFnN2CWlO55GbJuwaAlAA62QQAsAIKhEsdLvgI5ZaXGG
         YxctwAkLFnSsnObk7f6GcfreRLRYosq+JOAn1/4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 357/800] ACPI: PM / fan: Put fan device IDs into separate header file
Date:   Mon, 12 Jul 2021 08:06:20 +0200
Message-Id: <20210712061005.077238128@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index d260bc1f3e6e..9d2d3b9bb8b5 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -20,6 +20,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
 
+#include "fan.h"
 #include "internal.h"
 
 /**
@@ -1310,10 +1311,7 @@ int acpi_dev_pm_attach(struct device *dev, bool power_on)
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



