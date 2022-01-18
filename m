Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC80491A8A
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352684AbiARDAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345190AbiARCtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:49:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89383C0613E8;
        Mon, 17 Jan 2022 18:42:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46390B81132;
        Tue, 18 Jan 2022 02:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EF3C36AEB;
        Tue, 18 Jan 2022 02:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473720;
        bh=YnzVyzVF2gyXnAhBU7QgCxTIBetL5S/Hebevk1xn7XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+omVfOQxIv8w65gRL7N4ZBnZYlhZSQqQ2zmvb+tpFM/qHxMCByCT6Bgp7G1dTwcZ
         1q2xFmvDu31HW/TJkXPWMbye9xmEVJ30+215Ha4CP0bbYD5g/GymiOAIUEOE8RrQ6g
         Z/KtLJkrVOTM7DrO/HufheyXyI08FVUvm6MJRcGsRU6vUJknRFPPcJJQ0tcx3xE2UM
         gaBUPj/CgMi4s7OjGdcqzrXhvzg4avQvXQPGHn2dUSWONc7YeAH5yMvUAbbbTepqpY
         zYv1LLDYU+Q6DXxPWZ3OfvBclLijvAAQ/ZG13a583tRKyYH/7Ir301ciCULoz9SGXQ
         gCtqFGl3kPjgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        mario.limonciello@amd.com, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 039/116] ACPI / x86: Add not-present quirk for the PCI0.SDHB.BRC1 device on the GPD win
Date:   Mon, 17 Jan 2022 21:38:50 -0500
Message-Id: <20220118024007.1950576-39-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 91bbc4b6b8035..3f9a162be84e3 100644
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

