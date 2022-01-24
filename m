Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6882C49A38D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368387AbiAXX6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846344AbiAXXPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:15:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9D1C06177D;
        Mon, 24 Jan 2022 13:23:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2453FB8105C;
        Mon, 24 Jan 2022 21:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E40EC340E4;
        Mon, 24 Jan 2022 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059416;
        bh=a3dFkuC1B1onUYYjOCkI8tMCtX9oDS/YpYKObjKeaao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UC6+XVhfuGX/FUZiRCl/hci9Jw8xjCBYSEyVImxP5V8YZktzCRr6+d+JP5u20Wvdv
         WVFqnKzGN4Mt4nhCLP9lvrwpqYn8wz1ooh5a1MAFMSL5F3vH1ZPppMKRSPU9dDxPT9
         HVZo2atsanRPL1OG5secCTR07RfvoPY1sNpM2JCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0608/1039] ACPI / x86: Add not-present quirk for the PCI0.SDHB.BRC1 device on the GPD win
Date:   Mon, 24 Jan 2022 19:39:57 +0100
Message-Id: <20220124184145.772042657@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 57d2dbf710d832841872fb15ebb79429cab90fae ]

The GPD win and its sibling the GPD pocket (99% the same electronics in a
different case) use a PCI wifi card. But the ACPI tables on both variants
contain a bug where the SDIO MMC controller for SDIO wifi cards is enabled
despite this. This SDIO MMC controller has a PCI0.SDHB.BRC1 child-device
which _PS3 method sets a GPIO causing the PCI wifi card to turn off.

At the moment there is a pretty ugly kludge in the sdhci-acpi.c code,
just to work around the bug in the DSDT of this single design. This can
be solved cleaner/simply with a quirk overriding the _STA return of the
broken PCI0.SDHB.BRC1 PCI0.SDHB.BRC1 child with a status value of 0,
so that its power_manageable flag gets cleared, avoiding this problem.

Note that even though it is not used, the _STA method for the MMC
controller is deliberately not overridden. If the status of the MMC
controller were forced to 0 it would never get suspended, which would
cause these mini-laptops to not reach S0i3 level when suspended.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 190bfc2ab3f26..b3fb428461c6f 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -94,9 +94,10 @@ static const struct override_status_id override_status_ids[] = {
 	/*
 	 * The GPD win BIOS dated 20170221 has disabled the accelerometer, the
 	 * drivers sometimes cause crashes under Windows and this is how the
-	 * manufacturer has solved this :| Note that the the DMI data is less
-	 * generic then it seems, a board_vendor of "AMI Corporation" is quite
-	 * rare and a board_name of "Default String" also is rare.
+	 * manufacturer has solved this :|  The DMI match may not seem unique,
+	 * but it is. In the 67000+ DMI decode dumps from linux-hardware.org
+	 * only 116 have board_vendor set to "AMI Corporation" and of those 116
+	 * only the GPD win and pocket entries' board_name is "Default string".
 	 *
 	 * Unfortunately the GPD pocket also uses these strings and its BIOS
 	 * was copy-pasted from the GPD win, so it has a disabled KIOX000A
@@ -120,6 +121,19 @@ static const struct override_status_id override_status_ids[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
 		DMI_MATCH(DMI_BIOS_DATE, "05/25/2017")
 	      }),
+
+	/*
+	 * The GPD win/pocket have a PCI wifi card, but its DSDT has the SDIO
+	 * mmc controller enabled and that has a child-device which _PS3
+	 * method sets a GPIO causing the PCI wifi card to turn off.
+	 * See above remark about uniqueness of the DMI match.
+	 */
+	NOT_PRESENT_ENTRY_PATH("\\_SB_.PCI0.SDHB.BRC1", ATOM_AIRMONT, {
+		DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+		DMI_EXACT_MATCH(DMI_BOARD_NAME, "Default string"),
+		DMI_EXACT_MATCH(DMI_BOARD_SERIAL, "Default string"),
+		DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Default string"),
+	      }),
 };
 
 bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *status)
-- 
2.34.1



