Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4E46BD5DE
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCPQfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjCPQev (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4741CF62;
        Thu, 16 Mar 2023 09:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BDBB62099;
        Thu, 16 Mar 2023 16:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD0BC4339C;
        Thu, 16 Mar 2023 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678984414;
        bh=O60AlAK0dYuFe6kh+EJ3AfCHCZSame9FzEHfiT+hQ9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pje41rRUiL8R2joGSy+WLZ0srd9gXg9nGfvlJsaoMS4y7Oi7sCUAs2FnggGuF3Ljy
         0bSy08TgyBaxUS6waIvK+XBp2D85GpfdbOjZeiAtreaWarVSD2SCbom8jX20Kl0aKZ
         KlhOnKp+7VEiZTS0YEtijs+pAV0mA2TpAgWAwMOzf0bmN6w3vkXD0eEsibqR0EAMs0
         hDg+v+rU3pXDc+fuPiZZFSCJzVO1fs12f+zx/UzPb5MtIZ3IDNTXLkulnUVztZkODa
         SuA9t5mjs6x1ED8R1gJyab1OcngpKWyOMk1EgWaaouwd/3Ko5r+0dlnE3VVYnjXlec
         3/caLF0saZy5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        David Alvarez Lombardi <dqalombardi@proton.me>,
        dbilios@stdio.gr, Elvis Angelaccio <elvis.angelaccio@kde.org>,
        victor.bonnelle@proton.me, hurricanepootis@protonmail.com,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        hdegoede@redhat.com, andriy.shevchenko@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 5/6] ACPI: x86: utils: Add Cezanne to the list for forcing StorageD3Enable
Date:   Thu, 16 Mar 2023 12:33:06 -0400
Message-Id: <20230316163309.708796-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316163309.708796-1-sashal@kernel.org>
References: <20230316163309.708796-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit e2a56364485e7789e7b8f342637c7f3a219f7ede ]

commit 018d6711c26e4 ("ACPI: x86: Add a quirk for Dell Inspiron 14 2-in-1
for StorageD3Enable") introduced a quirk to allow a system with ambiguous
use of _ADR 0 to force StorageD3Enable.

It was reported that several more Dell systems suffered the same symptoms.
As the list is continuing to grow but these are all Cezanne systems,
instead add Cezanne to the CPU list to apply the StorageD3Enable property
and remove the whole list.

It was also reported that an HP system only has StorageD3Enable on the ACPI
device for the first NVME disk, not the second.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217003
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216773
Reported-by: David Alvarez Lombardi <dqalombardi@proton.me>
Reported-by: dbilios@stdio.gr
Reported-and-tested-by: Elvis Angelaccio <elvis.angelaccio@kde.org>
Tested-by: victor.bonnelle@proton.me
Tested-by: hurricanepootis@protonmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 4e816bb402f68..e45285d4e62a4 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -200,39 +200,28 @@ bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *s
  * a hardcoded allowlist for D3 support, which was used for these platforms.
  *
  * This allows quirking on Linux in a similar fashion.
+ *
+ * Cezanne systems shouldn't *normally* need this as the BIOS includes
+ * StorageD3Enable.  But for two reasons we have added it.
+ * 1) The BIOS on a number of Dell systems have ambiguity
+ *    between the same value used for _ADR on ACPI nodes GPP1.DEV0 and GPP1.NVME.
+ *    GPP1.NVME is needed to get StorageD3Enable node set properly.
+ *    https://bugzilla.kernel.org/show_bug.cgi?id=216440
+ *    https://bugzilla.kernel.org/show_bug.cgi?id=216773
+ *    https://bugzilla.kernel.org/show_bug.cgi?id=217003
+ * 2) On at least one HP system StorageD3Enable is missing on the second NVME
+      disk in the system.
  */
 static const struct x86_cpu_id storage_d3_cpu_ids[] = {
 	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 96, NULL),	/* Renoir */
 	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 104, NULL),	/* Lucienne */
-	{}
-};
-
-static const struct dmi_system_id force_storage_d3_dmi[] = {
-	{
-		/*
-		 * _ADR is ambiguous between GPP1.DEV0 and GPP1.NVME
-		 * but .NVME is needed to get StorageD3Enable node
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=216440
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 14 7425 2-in-1"),
-		}
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 16 5625"),
-		}
-	},
+	X86_MATCH_VENDOR_FAM_MODEL(AMD, 25, 80, NULL),	/* Cezanne */
 	{}
 };
 
 bool force_storage_d3(void)
 {
-	const struct dmi_system_id *dmi_id = dmi_first_match(force_storage_d3_dmi);
-
-	return dmi_id || x86_match_cpu(storage_d3_cpu_ids);
+	return x86_match_cpu(storage_d3_cpu_ids);
 }
 
 /*
-- 
2.39.2

