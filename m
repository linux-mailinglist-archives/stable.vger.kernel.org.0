Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479AF461EB9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379474AbhK2Sjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:39:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54162 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353086AbhK2Shj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:37:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67B38CE12FD;
        Mon, 29 Nov 2021 18:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10804C53FC7;
        Mon, 29 Nov 2021 18:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210858;
        bh=wcg78qYmOusY32y9oa97IojzYLm872NFQRhDzeh1FZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sk00732k8GSQVT5lO0GAkWWuqkN1t6eKCkleyHCa6PyxbJrxCS/5h3k3c1nUPwiig
         Bg7srQ3FUk8LGelX6UOupeW07JNuZnq55O6Ihj4v090XLz0+9zGKVOKivf9V4rebfj
         /38EyEIve8J/y+cIlouP1zy9b5ZIqHqKAQhmBo1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 002/179] ACPI: Get acpi_devices parent from the parent field
Date:   Mon, 29 Nov 2021 19:16:36 +0100
Message-Id: <20211129181718.995029825@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 9054fc6d57e80c27c0b0632966416144f2092c2b upstream.

Printk modifier %pfw is used to print the full path of the device name.
This is obtained device by device until a device no longer has a parent.

On ACPI getting the parent fwnode is done by calling acpi_get_parent()
which tries to down() a semaphore. But local IRQs are now disabled in
vprintk_store() before the mutex is acquired. This is obviously a problem.

Luckily struct device, embedded in struct acpi_device, has a parent field
already. Use that field to get the parent instead of relying on
acpi_get_parent().

Fixes: 3bd32d6a2ee6 ("lib/vsprintf: Add %pfw conversion specifier for printing fwnode names")
Cc: 5.5+ <stable@vger.kernel.org> # 5.5+
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/property.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1090,15 +1090,10 @@ struct fwnode_handle *acpi_node_get_pare
 		/* All data nodes have parent pointer so just return that */
 		return to_acpi_data_node(fwnode)->parent;
 	} else if (is_acpi_device_node(fwnode)) {
-		acpi_handle handle, parent_handle;
+		struct device *dev = to_acpi_device_node(fwnode)->dev.parent;
 
-		handle = to_acpi_device_node(fwnode)->handle;
-		if (ACPI_SUCCESS(acpi_get_parent(handle, &parent_handle))) {
-			struct acpi_device *adev;
-
-			if (!acpi_bus_get_device(parent_handle, &adev))
-				return acpi_fwnode_handle(adev);
-		}
+		if (dev)
+			return acpi_fwnode_handle(to_acpi_device(dev));
 	}
 
 	return NULL;


