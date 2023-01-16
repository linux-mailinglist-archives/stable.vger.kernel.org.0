Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FB166C467
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjAPPyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjAPPyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:54:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46F222790
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:54:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5FAFFCE1279
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E0FC433F0;
        Mon, 16 Jan 2023 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884463;
        bh=JHK0/5PQ1LtgKN/mhE//s12DjbXZ0+e5S5tX41GnSSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Winzim4vcGQM0OIJOmvJYsNeBTUhLqji2seQVrxk3MZkhphZeANhdOnY/ARoch7eh
         7yfJ8ScVLXP6xuW9QvR/BmVyWxiQTB8X4ELOtsx3ENOFkIgyPVBMzXY9IWjuR3P+yU
         qVRnB9u/YMtJbWJmj41l8YHtFcdNZfD4W+BEbVv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 016/183] ACPI: Fix selecting wrong ACPI fwnode for the iGPU on some Dell laptops
Date:   Mon, 16 Jan 2023 16:48:59 +0100
Message-Id: <20230116154804.094560622@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit f64e4275ef7407d5c3eca20436519bbd1f796e40 upstream.

The Dell Latitude E6430 both with and without the optional NVidia dGPU
has a bug in its ACPI tables which is causing Linux to assign the wrong
ACPI fwnode / companion to the pci_device for the i915 iGPU.

Specifically under the PCI root bridge there are these 2 ACPI Device()s :

 Scope (_SB.PCI0)
 {
     Device (GFX0)
     {
         Name (_ADR, 0x00020000)  // _ADR: Address
     }

     ...

     Device (VID)
     {
         Name (_ADR, 0x00020000)  // _ADR: Address
         ...

         Method (_DOS, 1, NotSerialized)  // _DOS: Disable Output Switching
         {
             VDP8 = Arg0
             VDP1 (One, VDP8)
         }

         Method (_DOD, 0, NotSerialized)  // _DOD: Display Output Devices
         {
             ...
         }
         ...
     }
 }

The non-functional GFX0 ACPI device is a problem, because this gets
returned as ACPI companion-device by acpi_find_child_device() for the iGPU.

This is a long standing problem and the i915 driver does use the ACPI
companion for some things, but works fine without it.

However since commit 63f534b8bad9 ("ACPI: PCI: Rework acpi_get_pci_dev()")
acpi_get_pci_dev() relies on the physical-node pointer in the acpi_device
and that is set on the wrong acpi_device because of the wrong
acpi_find_child_device() return. This breaks the ACPI video code,
leading to non working backlight control in some cases.

Add a type.backlight flag, mark ACPI video bus devices with this and make
find_child_checks() return a higher score for children with this flag set,
so that it picks the right companion-device.

Fixes: 63f534b8bad9 ("ACPI: PCI: Rework acpi_get_pci_dev()")
Co-developed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: 6.1+ <stable@vger.kernel.org> # 6.1+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/glue.c     | 14 ++++++++++++--
 drivers/acpi/scan.c     |  7 +++++--
 include/acpi/acpi_bus.h |  3 ++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 204fe94c7e45..a194f30876c5 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -75,7 +75,8 @@ static struct acpi_bus_type *acpi_get_bus_type(struct device *dev)
 }
 
 #define FIND_CHILD_MIN_SCORE	1
-#define FIND_CHILD_MAX_SCORE	2
+#define FIND_CHILD_MID_SCORE	2
+#define FIND_CHILD_MAX_SCORE	3
 
 static int match_any(struct acpi_device *adev, void *not_used)
 {
@@ -96,8 +97,17 @@ static int find_child_checks(struct acpi_device *adev, bool check_children)
 		return -ENODEV;
 
 	status = acpi_evaluate_integer(adev->handle, "_STA", NULL, &sta);
-	if (status == AE_NOT_FOUND)
+	if (status == AE_NOT_FOUND) {
+		/*
+		 * Special case: backlight device objects without _STA are
+		 * preferred to other objects with the same _ADR value, because
+		 * it is more likely that they are actually useful.
+		 */
+		if (adev->pnp.type.backlight)
+			return FIND_CHILD_MID_SCORE;
+
 		return FIND_CHILD_MIN_SCORE;
+	}
 
 	if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_ENABLED))
 		return -ENODEV;
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 274344434282..0c6f06abe3f4 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1370,9 +1370,12 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
 		 * Some devices don't reliably have _HIDs & _CIDs, so add
 		 * synthetic HIDs to make sure drivers can find them.
 		 */
-		if (acpi_is_video_device(handle))
+		if (acpi_is_video_device(handle)) {
 			acpi_add_id(pnp, ACPI_VIDEO_HID);
-		else if (acpi_bay_match(handle))
+			pnp->type.backlight = 1;
+			break;
+		}
+		if (acpi_bay_match(handle))
 			acpi_add_id(pnp, ACPI_BAY_HID);
 		else if (acpi_dock_match(handle))
 			acpi_add_id(pnp, ACPI_DOCK_HID);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index cd3b75e08ec3..e44be31115a6 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -230,7 +230,8 @@ struct acpi_pnp_type {
 	u32 hardware_id:1;
 	u32 bus_address:1;
 	u32 platform_id:1;
-	u32 reserved:29;
+	u32 backlight:1;
+	u32 reserved:28;
 };
 
 struct acpi_device_pnp {
-- 
2.39.0



