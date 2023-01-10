Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72713664B57
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbjAJSmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbjAJSlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:41:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0443EA2AB1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:35:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D517BB818E0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3864FC433EF;
        Tue, 10 Jan 2023 18:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375718;
        bh=S79YePNNZE7sjQ99uP7RBFXaEPQrSy3DVtQEB5vP0jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0x72E7lGW7flSstW7UWz6zM3ViikOe11jcwsYSb3kG2KL1hwaTmpYW3C8IW3uO2kF
         b7Qz5AJP6X+folSMNAmzCXdsyDOem2I5M6W5B8uAXmw+i+Fv7tnI5Br7dZoKExUloy
         MAcLYetwIw7/WkhOdaop+/FT40DgcBNtMa7qGAS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 280/290] Revert "ACPI: PM: Add support for upcoming AMD uPEP HID AMDI007"
Date:   Tue, 10 Jan 2023 19:06:12 +0100
Message-Id: <20230110180041.580194598@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

A number of AMD based Rembrandt laptops are not working properly in
suspend/resume.  This has been root caused to be from the BIOS
implementation not populating code for the AMD GUID in uPEP, but
instead only the Microsoft one.

In later kernels this has been fixed by using the Microsoft GUID
instead.

The following series of patches has fixed it in newer kernels:

commit ed470febf837 ("ACPI: PM: s2idle: Add support for upcoming AMD uPEP HID AMDI008")
commit 1a2dcab517cb ("ACPI: PM: s2idle: Use LPS0 idle if ACPI_FADT_LOW_POWER_S0 is unset")
commit 100a57379380 ("ACPI: x86: s2idle: Move _HID handling for AMD systems into structures")
commit fd894f05cf30 ("ACPI: x86: s2idle: If a new AMD _HID is missing assume Rembrandt")
commit a0bc002393d4 ("ACPI: x86: s2idle: Add module parameter to prefer Microsoft GUID")
commit d0f61e89f08d ("ACPI: x86: s2idle: Add a quirk for ASUS TUF Gaming A17 FA707RE")
commit ddeea2c3cb88 ("ACPI: x86: s2idle: Add a quirk for ASUS ROG Zephyrus G14")
commit 888ca9c7955e ("ACPI: x86: s2idle: Add a quirk for Lenovo Slim 7 Pro 14ARH7")
commit 631b54519e8e ("ACPI: x86: s2idle: Add a quirk for ASUSTeK COMPUTER INC. ROG Flow X13")
commit 39f81776c680 ("ACPI: x86: s2idle: Fix a NULL pointer dereference")
commit 54bd1e548701 ("ACPI: x86: s2idle: Add another ID to s2idle_dmi_table")
commit 577821f756cf ("ACPI: x86: s2idle: Force AMD GUID/_REV 2 on HP Elitebook 865")
commit e6d180a35bc0 ("ACPI: x86: s2idle: Stop using AMD specific codepath for Rembrandt+")

This is needlessly complex for 5.15.y though.  To accomplish the same
effective result revert commit f0c6225531e4 ("ACPI: PM: Add support for
upcoming AMD uPEP HID AMDI007") instead.

Link: https://lore.kernel.org/stable/MN0PR12MB61015DB3D6EDBFD841157918E2F59@MN0PR12MB6101.namprd12.prod.outlook.com/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/x86/s2idle.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -378,16 +378,13 @@ static int lps0_device_attach(struct acp
 		 * AMDI0006:
 		 * - should use rev_id 0x0
 		 * - function mask = 0x3: Should use Microsoft method
-		 * AMDI0007:
-		 * - Should use rev_id 0x2
-		 * - Should only use AMD method
 		 */
 		const char *hid = acpi_device_hid(adev);
-		rev_id = strcmp(hid, "AMDI0007") ? 0 : 2;
+		rev_id = 0;
 		lps0_dsm_func_mask = validate_dsm(adev->handle,
 					ACPI_LPS0_DSM_UUID_AMD, rev_id, &lps0_dsm_guid);
 		lps0_dsm_func_mask_microsoft = validate_dsm(adev->handle,
-					ACPI_LPS0_DSM_UUID_MICROSOFT, 0,
+					ACPI_LPS0_DSM_UUID_MICROSOFT, rev_id,
 					&lps0_dsm_guid_microsoft);
 		if (lps0_dsm_func_mask > 0x3 && (!strcmp(hid, "AMD0004") ||
 						 !strcmp(hid, "AMD0005") ||
@@ -395,9 +392,6 @@ static int lps0_device_attach(struct acp
 			lps0_dsm_func_mask = (lps0_dsm_func_mask << 1) | 0x1;
 			acpi_handle_debug(adev->handle, "_DSM UUID %s: Adjusted function mask: 0x%x\n",
 					  ACPI_LPS0_DSM_UUID_AMD, lps0_dsm_func_mask);
-		} else if (lps0_dsm_func_mask_microsoft > 0 && !strcmp(hid, "AMDI0007")) {
-			lps0_dsm_func_mask_microsoft = -EINVAL;
-			acpi_handle_debug(adev->handle, "_DSM Using AMD method\n");
 		}
 	} else {
 		rev_id = 1;


