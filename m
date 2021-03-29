Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5418734C94B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhC2I3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233391AbhC2IZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F564619B9;
        Mon, 29 Mar 2021 08:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006318;
        bh=rY+5YFDpKMuDRgvs9u29FTM8ifiJUWOzdDt6+CSIXHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2CzrRusj1Ok1bnu/CgzGYU19cFp1VYpUrOT7QBNDVXPJ3TaID09yENcA6MzsxjnC
         G0/YC85jq3sRL1TQTjkd2vK3Q9/ShlNW1zfUu72v07ewoL0YiEM4SXAo4c2nmjIV54
         OdwatpVdqOrIxcw6N8okR7V/23ZHioto6dZx+AEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/221] ACPI: scan: Use unique number for instance_no
Date:   Mon, 29 Mar 2021 09:58:48 +0200
Message-Id: <20210329075635.697080747@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit eb50aaf960e3bedfef79063411ffd670da94b84b ]

The decrementation of acpi_device_bus_id->instance_no
in acpi_device_del() is incorrect, because it may cause
a duplicate instance number to be allocated next time
a device with the same acpi_device_bus_id is added.

Replace above mentioned approach by using IDA framework.

While at it, define the instance range to be [0, 4096).

Fixes: e49bd2dd5a50 ("ACPI: use PNPID:instance_no as bus_id of ACPI device")
Fixes: ca9dc8d42b30 ("ACPI / scan: Fix acpi_bus_id_list bookkeeping")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/internal.h |  6 +++++-
 drivers/acpi/scan.c     | 33 ++++++++++++++++++++++++++++-----
 include/acpi/acpi_bus.h |  1 +
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index aee023ad0237..a958ad60a339 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -9,6 +9,8 @@
 #ifndef _ACPI_INTERNAL_H_
 #define _ACPI_INTERNAL_H_
 
+#include <linux/idr.h>
+
 #define PREFIX "ACPI: "
 
 int early_acpi_osi_init(void);
@@ -96,9 +98,11 @@ void acpi_scan_table_handler(u32 event, void *table, void *context);
 
 extern struct list_head acpi_bus_id_list;
 
+#define ACPI_MAX_DEVICE_INSTANCES	4096
+
 struct acpi_device_bus_id {
 	const char *bus_id;
-	unsigned int instance_no;
+	struct ida instance_ida;
 	struct list_head node;
 };
 
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 27292697d6a5..b47f14ac75ae 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -482,9 +482,8 @@ static void acpi_device_del(struct acpi_device *device)
 	list_for_each_entry(acpi_device_bus_id, &acpi_bus_id_list, node)
 		if (!strcmp(acpi_device_bus_id->bus_id,
 			    acpi_device_hid(device))) {
-			if (acpi_device_bus_id->instance_no > 0)
-				acpi_device_bus_id->instance_no--;
-			else {
+			ida_simple_remove(&acpi_device_bus_id->instance_ida, device->pnp.instance_no);
+			if (ida_is_empty(&acpi_device_bus_id->instance_ida)) {
 				list_del(&acpi_device_bus_id->node);
 				kfree_const(acpi_device_bus_id->bus_id);
 				kfree(acpi_device_bus_id);
@@ -635,6 +634,21 @@ static struct acpi_device_bus_id *acpi_device_bus_id_match(const char *dev_id)
 	return NULL;
 }
 
+static int acpi_device_set_name(struct acpi_device *device,
+				struct acpi_device_bus_id *acpi_device_bus_id)
+{
+	struct ida *instance_ida = &acpi_device_bus_id->instance_ida;
+	int result;
+
+	result = ida_simple_get(instance_ida, 0, ACPI_MAX_DEVICE_INSTANCES, GFP_KERNEL);
+	if (result < 0)
+		return result;
+
+	device->pnp.instance_no = result;
+	dev_set_name(&device->dev, "%s:%02x", acpi_device_bus_id->bus_id, result);
+	return 0;
+}
+
 int acpi_device_add(struct acpi_device *device,
 		    void (*release)(struct device *))
 {
@@ -669,7 +683,9 @@ int acpi_device_add(struct acpi_device *device,
 
 	acpi_device_bus_id = acpi_device_bus_id_match(acpi_device_hid(device));
 	if (acpi_device_bus_id) {
-		acpi_device_bus_id->instance_no++;
+		result = acpi_device_set_name(device, acpi_device_bus_id);
+		if (result)
+			goto err_unlock;
 	} else {
 		acpi_device_bus_id = kzalloc(sizeof(*acpi_device_bus_id),
 					     GFP_KERNEL);
@@ -685,9 +701,16 @@ int acpi_device_add(struct acpi_device *device,
 			goto err_unlock;
 		}
 
+		ida_init(&acpi_device_bus_id->instance_ida);
+
+		result = acpi_device_set_name(device, acpi_device_bus_id);
+		if (result) {
+			kfree(acpi_device_bus_id);
+			goto err_unlock;
+		}
+
 		list_add_tail(&acpi_device_bus_id->node, &acpi_bus_id_list);
 	}
-	dev_set_name(&device->dev, "%s:%02x", acpi_device_bus_id->bus_id, acpi_device_bus_id->instance_no);
 
 	if (device->parent)
 		list_add_tail(&device->node, &device->parent->children);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 6d1879bf9440..37dac195adbb 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -233,6 +233,7 @@ struct acpi_pnp_type {
 
 struct acpi_device_pnp {
 	acpi_bus_id bus_id;		/* Object name */
+	int instance_no;		/* Instance number of this object */
 	struct acpi_pnp_type type;	/* ID type */
 	acpi_bus_address bus_address;	/* _ADR */
 	char *unique_id;		/* _UID */
-- 
2.30.1



