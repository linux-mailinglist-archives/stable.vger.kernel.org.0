Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA703D61CC
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhGZPdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232977AbhGZPax (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B03A260F6E;
        Mon, 26 Jul 2021 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315881;
        bh=Q2wZfKYnOvNv7D+xsxyCsV1Ukb51gEDgIhuXtUavpNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z33l99/SzBIQ8pHPmraofxC8HSFAYk0P1h5nktS72JR3DoX22jhtVlFiR4wAPbSmz
         BNgmBkNDeaMwx4o1USdxGqXABYAtNkjqQFquGPzYGEIn91sCsgWbhPxsEEi74RQxiu
         SwgJ9W4oJPOJqy8YbkDtEEjlThH35Oq4hqSe1ON4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 102/223] efi/dev-path-parser: Switch to use for_each_acpi_dev_match()
Date:   Mon, 26 Jul 2021 17:38:14 +0200
Message-Id: <20210726153849.608375092@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit edbd1bc4951eff8da65732dbe0d381e555054428 ]

Switch to use for_each_acpi_dev_match() instead of home grown analogue.
No functional change intended.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/dev-path-parser.c | 49 ++++++++++----------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/firmware/efi/dev-path-parser.c b/drivers/firmware/efi/dev-path-parser.c
index 5c9625e552f4..10d4457417a4 100644
--- a/drivers/firmware/efi/dev-path-parser.c
+++ b/drivers/firmware/efi/dev-path-parser.c
@@ -12,52 +12,39 @@
 #include <linux/efi.h>
 #include <linux/pci.h>
 
-struct acpi_hid_uid {
-	struct acpi_device_id hid[2];
-	char uid[11]; /* UINT_MAX + null byte */
-};
-
-static int __init match_acpi_dev(struct device *dev, const void *data)
-{
-	struct acpi_hid_uid hid_uid = *(const struct acpi_hid_uid *)data;
-	struct acpi_device *adev = to_acpi_device(dev);
-
-	if (acpi_match_device_ids(adev, hid_uid.hid))
-		return 0;
-
-	if (adev->pnp.unique_id)
-		return !strcmp(adev->pnp.unique_id, hid_uid.uid);
-	else
-		return !strcmp("0", hid_uid.uid);
-}
-
 static long __init parse_acpi_path(const struct efi_dev_path *node,
 				   struct device *parent, struct device **child)
 {
-	struct acpi_hid_uid hid_uid = {};
+	char hid[ACPI_ID_LEN], uid[11]; /* UINT_MAX + null byte */
+	struct acpi_device *adev;
 	struct device *phys_dev;
 
 	if (node->header.length != 12)
 		return -EINVAL;
 
-	sprintf(hid_uid.hid[0].id, "%c%c%c%04X",
+	sprintf(hid, "%c%c%c%04X",
 		'A' + ((node->acpi.hid >> 10) & 0x1f) - 1,
 		'A' + ((node->acpi.hid >>  5) & 0x1f) - 1,
 		'A' + ((node->acpi.hid >>  0) & 0x1f) - 1,
 			node->acpi.hid >> 16);
-	sprintf(hid_uid.uid, "%u", node->acpi.uid);
-
-	*child = bus_find_device(&acpi_bus_type, NULL, &hid_uid,
-				 match_acpi_dev);
-	if (!*child)
+	sprintf(uid, "%u", node->acpi.uid);
+
+	for_each_acpi_dev_match(adev, hid, NULL, -1) {
+		if (adev->pnp.unique_id && !strcmp(adev->pnp.unique_id, uid))
+			break;
+		if (!adev->pnp.unique_id && node->acpi.uid == 0)
+			break;
+		acpi_dev_put(adev);
+	}
+	if (!adev)
 		return -ENODEV;
 
-	phys_dev = acpi_get_first_physical_node(to_acpi_device(*child));
+	phys_dev = acpi_get_first_physical_node(adev);
 	if (phys_dev) {
-		get_device(phys_dev);
-		put_device(*child);
-		*child = phys_dev;
-	}
+		*child = get_device(phys_dev);
+		acpi_dev_put(adev);
+	} else
+		*child = &adev->dev;
 
 	return 0;
 }
-- 
2.30.2



