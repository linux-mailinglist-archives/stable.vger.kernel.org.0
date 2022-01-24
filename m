Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11910499465
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352391AbiAXUlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387950AbiAXUhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:37:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1E7C02B8E2;
        Mon, 24 Jan 2022 11:51:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68A81B8123A;
        Mon, 24 Jan 2022 19:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8457CC340E8;
        Mon, 24 Jan 2022 19:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053860;
        bh=dew9iB/PSxpZFa7z+LvbEm0R1sFHfkirT3jY0G+NzIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXte4R0tvEQmbEtum+D04DmEqTRgQAsOIigDo96C+s4uy+jjrzdQrd6Lt6hCKYipi
         n+vLRr4VnDnDLSfPyuQyfdV5hS1hTaeCw4V5HzkVq8AxBfvR+iF073q3Tgknsdgzaa
         2mAxLl9VknkPnTdw4f/CWEKjDXdEgzsO5J2ZBBtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/563] ACPI: scan: Create platform device for BCM4752 and LNV4752 ACPI nodes
Date:   Mon, 24 Jan 2022 19:39:25 +0100
Message-Id: <20220124184031.344880300@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f85196bdd5a50da74670250564740fc852b3c239 ]

BCM4752 and LNV4752 ACPI nodes describe a Broadcom 4752 GPS module
attached to an UART of the system.

The GPS modules talk a custom protocol which only works with a closed-
source Android gpsd daemon which knows this protocol.

The ACPI nodes also describe GPIOs to turn the GPS on/off these are
handled by the net/rfkill/rfkill-gpio.c code. This handling predates the
addition of enumeration of ACPI instantiated serdevs to the kernel and
was broken by that addition, because the ACPI scan code now no longer
instantiates platform_device-s for these nodes.

Rename the i2c_multi_instantiate_ids HID list to ignore_serial_bus_ids
and add the BCM4752 and LNV4752 HIDs, so that rfkill-gpio gets
a platform_device to bind to again; and so that a tty cdev for gpsd
gets created for these.

Fixes: e361d1f85855 ("ACPI / scan: Fix enumeration for special UART devices")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index de0533bd4e086..67a5ee2fedfd3 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1577,6 +1577,7 @@ static bool acpi_device_enumeration_by_parent(struct acpi_device *device)
 {
 	struct list_head resource_list;
 	bool is_serial_bus_slave = false;
+	static const struct acpi_device_id ignore_serial_bus_ids[] = {
 	/*
 	 * These devices have multiple I2cSerialBus resources and an i2c-client
 	 * must be instantiated for each, each with its own i2c_device_id.
@@ -1585,11 +1586,18 @@ static bool acpi_device_enumeration_by_parent(struct acpi_device *device)
 	 * drivers/platform/x86/i2c-multi-instantiate.c driver, which knows
 	 * which i2c_device_id to use for each resource.
 	 */
-	static const struct acpi_device_id i2c_multi_instantiate_ids[] = {
 		{"BSG1160", },
 		{"BSG2150", },
 		{"INT33FE", },
 		{"INT3515", },
+	/*
+	 * HIDs of device with an UartSerialBusV2 resource for which userspace
+	 * expects a regular tty cdev to be created (instead of the in kernel
+	 * serdev) and which have a kernel driver which expects a platform_dev
+	 * such as the rfkill-gpio driver.
+	 */
+		{"BCM4752", },
+		{"LNV4752", },
 		{}
 	};
 
@@ -1603,8 +1611,7 @@ static bool acpi_device_enumeration_by_parent(struct acpi_device *device)
 	     fwnode_property_present(&device->fwnode, "baud")))
 		return true;
 
-	/* Instantiate a pdev for the i2c-multi-instantiate drv to bind to */
-	if (!acpi_match_device_ids(device, i2c_multi_instantiate_ids))
+	if (!acpi_match_device_ids(device, ignore_serial_bus_ids))
 		return false;
 
 	INIT_LIST_HEAD(&resource_list);
-- 
2.34.1



