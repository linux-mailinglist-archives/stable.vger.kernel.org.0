Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6F8461E2D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350804AbhK2Sdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:33:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35938 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350853AbhK2SbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:31:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB286B815CE;
        Mon, 29 Nov 2021 18:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09873C53FCD;
        Mon, 29 Nov 2021 18:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210480;
        bh=E+9/uCIvHvVX0sRPngQUfzWnF8OBWQwEKUkOM2e4U60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wacsMKtFoWNbba+e1XiB32Z2cfAyBYiGat78pWJ5Fuv2og1M4Qcgnkwqhi+J4rX1R
         HLVSJLVERkwhN7cPEAi5j52jQHrCsgU4JQGc7+rXfw0b6+NBwp3RwdiAZl1p3J7esu
         inJ5QMhmiB9UnNMxC1DT957tBcJjZL94+iTFOXgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 002/121] ACPI: Get acpi_devices parent from the parent field
Date:   Mon, 29 Nov 2021 19:17:13 +0100
Message-Id: <20211129181711.725459260@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
@@ -1110,15 +1110,10 @@ struct fwnode_handle *acpi_node_get_pare
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


