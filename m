Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559D46AF353
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCGTDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbjCGTDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:03:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784E72595E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:49:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DC9DB819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D899C4339B;
        Tue,  7 Mar 2023 18:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214923;
        bh=kSNXJmxxfKkTzrW2svLlyiqkbdqEYdpCACCoqNOj1PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msaTktvDdA/MV2fdJVcMacmQYRa6iGFm6NM1nToq1drxOCezkHpkuBbQIDYyzLA2W
         8BITQ39vRXMdQs+RLAO7yUUPn6P+UqoodhXT6i72D1uGMgL3oX+YEmBBV0yqQUGC+J
         NtMDcC4KS/1c+5BM1hwYU8O3pLQAfpuKy4V0KgQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/567] ACPICA: Drop port I/O validation for some regions
Date:   Tue,  7 Mar 2023 17:57:02 +0100
Message-Id: <20230307165909.606313589@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e1d9148582ab2c3dada5c5cf8ca7531ca269fee5 ]

Microsoft introduced support in Windows XP for blocking port I/O
to various regions.  For Windows compatibility ACPICA has adopted
the same protections and will disallow writes to those
(presumably) the same regions.

On some systems the AML included with the firmware will issue 4 byte
long writes to 0x80.  These writes aren't making it over because of this
blockage. The first 4 byte write attempt is rejected, and then
subsequently 1 byte at a time each offset is tried. The first at 0x80
works, but then the next 3 bytes are rejected.

This manifests in bizarre failures for devices that expected the AML to
write all 4 bytes.  Trying the same AML on Windows 10 or 11 doesn't hit
this failure and all 4 bytes are written.

Either some of these regions were wrong or some point after Windows XP
some of these regions blocks have been lifted.

In the last 15 years there doesn't seem to be any reports popping up of
this error in the Windows event viewer anymore.  There is no documentation
at Microsoft's developer site indicating that Windows ACPI interpreter
blocks these regions. Between the lack of documentation and the fact that
the writes actually do work in Windows 10 and 11, it's quite likely
Windows doesn't actually enforce this anymore.

So to help the issue, only enforce Windows XP specific entries if the
latest _OSI supported is Windows XP. Continue to enforce the
ALWAYS_ILLEGAL entries.

Link: https://github.com/acpica/acpica/pull/817
Fixes: 7f0719039085 ("ACPICA: New: I/O port protection")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/hwvalid.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/hwvalid.c b/drivers/acpi/acpica/hwvalid.c
index e15badf4077aa..c6716f90e013a 100644
--- a/drivers/acpi/acpica/hwvalid.c
+++ b/drivers/acpi/acpica/hwvalid.c
@@ -23,8 +23,8 @@ acpi_hw_validate_io_request(acpi_io_address address, u32 bit_width);
  *
  * The table is used to implement the Microsoft port access rules that
  * first appeared in Windows XP. Some ports are always illegal, and some
- * ports are only illegal if the BIOS calls _OSI with a win_XP string or
- * later (meaning that the BIOS itelf is post-XP.)
+ * ports are only illegal if the BIOS calls _OSI with nothing newer than
+ * the specific _OSI strings.
  *
  * This provides ACPICA with the desired port protections and
  * Microsoft compatibility.
@@ -145,7 +145,8 @@ acpi_hw_validate_io_request(acpi_io_address address, u32 bit_width)
 
 			/* Port illegality may depend on the _OSI calls made by the BIOS */
 
-			if (acpi_gbl_osi_data >= port_info->osi_dependency) {
+			if (port_info->osi_dependency == ACPI_ALWAYS_ILLEGAL ||
+			    acpi_gbl_osi_data == port_info->osi_dependency) {
 				ACPI_DEBUG_PRINT((ACPI_DB_VALUES,
 						  "Denied AML access to port 0x%8.8X%8.8X/%X (%s 0x%.4X-0x%.4X)\n",
 						  ACPI_FORMAT_UINT64(address),
-- 
2.39.2



