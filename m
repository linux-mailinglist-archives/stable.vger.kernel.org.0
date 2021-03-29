Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D1834C65C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhC2IGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232289AbhC2IGG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:06:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6058961959;
        Mon, 29 Mar 2021 08:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005165;
        bh=m5Wk5tBfABEkkMFBb/GMdpxP32+hQC7kv5XguCzEq58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlRcx7/eklIOFbyY5A9+0iFpzk7avF7XIhN9klgo17E0qfADD5/MZh10Bwvh5lXkZ
         9i5M6mjQ0R/hD+wjoEHYiLkX7Z+ukDYX+6ExDqMGSAQVXrs+Y+dyqDC1IbRQdNtUo0
         61kWIU+vo1N5Pdxqv7uHysTQ/9p+mrkWzIx9IaDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/59] ACPI: scan: Rearrange memory allocation in acpi_device_add()
Date:   Mon, 29 Mar 2021 09:58:28 +0200
Message-Id: <20210329075610.459964138@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit c1013ff7a5472db637c56bb6237f8343398c03a7 ]

The upfront allocation of new_bus_id is done to avoid allocating
memory under acpi_device_lock, but it doesn't really help,
because (1) it leads to many unnecessary memory allocations for
_ADR devices, (2) kstrdup_const() is run under that lock anyway and
(3) it complicates the code.

Rearrange acpi_device_add() to allocate memory for a new struct
acpi_device_bus_id instance only when necessary, eliminate a redundant
local variable from it and reduce the number of labels in there.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 57 +++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index bd58f0743cfc..9ec463da9a50 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -622,12 +622,23 @@ void acpi_bus_put_acpi_device(struct acpi_device *adev)
 	put_device(&adev->dev);
 }
 
+static struct acpi_device_bus_id *acpi_device_bus_id_match(const char *dev_id)
+{
+	struct acpi_device_bus_id *acpi_device_bus_id;
+
+	/* Find suitable bus_id and instance number in acpi_bus_id_list. */
+	list_for_each_entry(acpi_device_bus_id, &acpi_bus_id_list, node) {
+		if (!strcmp(acpi_device_bus_id->bus_id, dev_id))
+			return acpi_device_bus_id;
+	}
+	return NULL;
+}
+
 int acpi_device_add(struct acpi_device *device,
 		    void (*release)(struct device *))
 {
+	struct acpi_device_bus_id *acpi_device_bus_id;
 	int result;
-	struct acpi_device_bus_id *acpi_device_bus_id, *new_bus_id;
-	int found = 0;
 
 	if (device->handle) {
 		acpi_status status;
@@ -653,38 +664,26 @@ int acpi_device_add(struct acpi_device *device,
 	INIT_LIST_HEAD(&device->del_list);
 	mutex_init(&device->physical_node_lock);
 
-	new_bus_id = kzalloc(sizeof(struct acpi_device_bus_id), GFP_KERNEL);
-	if (!new_bus_id) {
-		pr_err(PREFIX "Memory allocation error\n");
-		result = -ENOMEM;
-		goto err_detach;
-	}
-
 	mutex_lock(&acpi_device_lock);
-	/*
-	 * Find suitable bus_id and instance number in acpi_bus_id_list
-	 * If failed, create one and link it into acpi_bus_id_list
-	 */
-	list_for_each_entry(acpi_device_bus_id, &acpi_bus_id_list, node) {
-		if (!strcmp(acpi_device_bus_id->bus_id,
-			    acpi_device_hid(device))) {
-			acpi_device_bus_id->instance_no++;
-			found = 1;
-			kfree(new_bus_id);
-			break;
+
+	acpi_device_bus_id = acpi_device_bus_id_match(acpi_device_hid(device));
+	if (acpi_device_bus_id) {
+		acpi_device_bus_id->instance_no++;
+	} else {
+		acpi_device_bus_id = kzalloc(sizeof(*acpi_device_bus_id),
+					     GFP_KERNEL);
+		if (!acpi_device_bus_id) {
+			result = -ENOMEM;
+			goto err_unlock;
 		}
-	}
-	if (!found) {
-		acpi_device_bus_id = new_bus_id;
 		acpi_device_bus_id->bus_id =
 			kstrdup_const(acpi_device_hid(device), GFP_KERNEL);
 		if (!acpi_device_bus_id->bus_id) {
-			pr_err(PREFIX "Memory allocation error for bus id\n");
+			kfree(acpi_device_bus_id);
 			result = -ENOMEM;
-			goto err_free_new_bus_id;
+			goto err_unlock;
 		}
 
-		acpi_device_bus_id->instance_no = 0;
 		list_add_tail(&acpi_device_bus_id->node, &acpi_bus_id_list);
 	}
 	dev_set_name(&device->dev, "%s:%02x", acpi_device_bus_id->bus_id, acpi_device_bus_id->instance_no);
@@ -719,13 +718,9 @@ int acpi_device_add(struct acpi_device *device,
 		list_del(&device->node);
 	list_del(&device->wakeup_list);
 
- err_free_new_bus_id:
-	if (!found)
-		kfree(new_bus_id);
-
+ err_unlock:
 	mutex_unlock(&acpi_device_lock);
 
- err_detach:
 	acpi_detach_data(device->handle, acpi_scan_drop_device);
 	return result;
 }
-- 
2.30.1



