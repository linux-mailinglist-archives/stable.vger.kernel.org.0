Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021AC2FA8B7
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405563AbhARPHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390785AbhARLmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 328C522D6E;
        Mon, 18 Jan 2021 11:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970136;
        bh=829m9skplpEvLOASKY/h3GNXJNG+KmW0IxGw1D4EQXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRm2Lm+1MxJnm15OHWjoj5ndqbpUnEqr/2wz7lYs5UiGP/RHyPJgEM9MnxHcdSTQx
         rB+6rhmtCpot7ZXl06YREI2AdXvFCzIfDMEeS3x2itMdiyK3sTnwrXlcFMRV3Zybqq
         aFfFv4xE3xOOOMwjVQ+lYozyTWIv/w0oK5yCdkHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 035/152] ACPI: scan: Harden acpi_device_add() against device ID overflows
Date:   Mon, 18 Jan 2021 12:33:30 +0100
Message-Id: <20210118113354.463000985@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit a58015d638cd4e4555297b04bec9b49028369075 upstream.

Linux VM on Hyper-V crashes with the latest mainline:

[    4.069624] detected buffer overflow in strcpy
[    4.077733] kernel BUG at lib/string.c:1149!
..
[    4.085819] RIP: 0010:fortify_panic+0xf/0x11
...
[    4.085819] Call Trace:
[    4.085819]  acpi_device_add.cold.15+0xf2/0xfb
[    4.085819]  acpi_add_single_object+0x2a6/0x690
[    4.085819]  acpi_bus_check_add+0xc6/0x280
[    4.085819]  acpi_ns_walk_namespace+0xda/0x1aa
[    4.085819]  acpi_walk_namespace+0x9a/0xc2
[    4.085819]  acpi_bus_scan+0x78/0x90
[    4.085819]  acpi_scan_init+0xfa/0x248
[    4.085819]  acpi_init+0x2c1/0x321
[    4.085819]  do_one_initcall+0x44/0x1d0
[    4.085819]  kernel_init_freeable+0x1ab/0x1f4

This is because of the recent buffer overflow detection in the
commit 6a39e62abbaf ("lib: string.h: detect intra-object overflow in
fortified string functions")

Here acpi_device_bus_id->bus_id can only hold 14 characters, while the
the acpi_device_hid(device) returns a 22-char string
"HYPER_V_GEN_COUNTER_V1".

Per ACPI Spec v6.2, Section 6.1.5 _HID (Hardware ID), if the ID is a
string, it must be of the form AAA#### or NNNN####, i.e. 7 chars or 8
chars.

The field bus_id in struct acpi_device_bus_id was originally defined as
char bus_id[9], and later was enlarged to char bus_id[15] in 2007 in the
commit bb0958544f3c ("ACPI: use more understandable bus_id for ACPI
devices")

Fix the issue by changing the field bus_id to const char *, and use
kstrdup_const() to initialize it.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Tested-By: Jethro Beekman <jethro@fortanix.com>
[ rjw: Subject change, whitespace adjustment ]
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/internal.h |    2 +-
 drivers/acpi/scan.c     |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -97,7 +97,7 @@ void acpi_scan_table_handler(u32 event,
 extern struct list_head acpi_bus_id_list;
 
 struct acpi_device_bus_id {
-	char bus_id[15];
+	const char *bus_id;
 	unsigned int instance_no;
 	struct list_head node;
 };
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -486,6 +486,7 @@ static void acpi_device_del(struct acpi_
 				acpi_device_bus_id->instance_no--;
 			else {
 				list_del(&acpi_device_bus_id->node);
+				kfree_const(acpi_device_bus_id->bus_id);
 				kfree(acpi_device_bus_id);
 			}
 			break;
@@ -674,7 +675,14 @@ int acpi_device_add(struct acpi_device *
 	}
 	if (!found) {
 		acpi_device_bus_id = new_bus_id;
-		strcpy(acpi_device_bus_id->bus_id, acpi_device_hid(device));
+		acpi_device_bus_id->bus_id =
+			kstrdup_const(acpi_device_hid(device), GFP_KERNEL);
+		if (!acpi_device_bus_id->bus_id) {
+			pr_err(PREFIX "Memory allocation error for bus id\n");
+			result = -ENOMEM;
+			goto err_free_new_bus_id;
+		}
+
 		acpi_device_bus_id->instance_no = 0;
 		list_add_tail(&acpi_device_bus_id->node, &acpi_bus_id_list);
 	}
@@ -709,6 +717,11 @@ int acpi_device_add(struct acpi_device *
 	if (device->parent)
 		list_del(&device->node);
 	list_del(&device->wakeup_list);
+
+ err_free_new_bus_id:
+	if (!found)
+		kfree(new_bus_id);
+
 	mutex_unlock(&acpi_device_lock);
 
  err_detach:


