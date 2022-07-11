Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF0C56FBA6
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiGKJde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbiGKJdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:33:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F57A537;
        Mon, 11 Jul 2022 02:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F41CBB80D2C;
        Mon, 11 Jul 2022 09:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207EAC34115;
        Mon, 11 Jul 2022 09:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531072;
        bh=RYid31WpNmRGIPa8flzGgo//b6LZ8YhVCis19SygF2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmhvgD5EbCcN5FUdgge8GrqujycKoBvvpmDsTeeZhb4TRbSXe56V4QxCHajRSt6Jd
         39vAJRandymSKYNbWTN7GpYLfT6MrBhjF5vtDqjppjN0tdx+Z558Q0y45E03/co/H9
         f4f/emBKjKngHPlMISvg/w+6VhaGvZI/XIxCME9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, CUI Hao <cuihao.leo@gmail.com>,
        maxim.novozhilov@gmail.com, lethe.tree@protonmail.com,
        garystephenwright@gmail.com, galaxyking0419@gmail.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 087/112] ACPI: CPPC: Only probe for _CPC if CPPC v2 is acked
Date:   Mon, 11 Jul 2022 11:07:27 +0200
Message-Id: <20220711090552.041370592@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 7feec7430edddb87c24b0a86b08a03d0b496a755 ]

Previously the kernel used to ignore whether the firmware masked CPPC
or CPPCv2 and would just pretend that it worked.

When support for the USB4 bit in _OSC was introduced from commit
9e1f561afb ("ACPI: Execute platform _OSC also with query bit clear")
the kernel began to look at the return when the query bit was clear.

This caused regressions that were misdiagnosed and attempted to be solved
as part of commit 2ca8e6285250 ("Revert "ACPI: Pass the same capabilities
to the _OSC regardless of the query flag""). This caused a different
regression where non-Intel systems weren't able to negotiate _OSC
properly.

This was reverted in commit 2ca8e6285250 ("Revert "ACPI: Pass the same
capabilities to the _OSC regardless of the query flag"") and attempted to
be fixed by commit c42fa24b4475 ("ACPI: bus: Avoid using CPPC if not
supported by firmware") but the regression still returned.

These systems with the regression only load support for CPPC from an SSDT
dynamically when _OSC reports CPPC v2.  Avoid the problem by not letting
CPPC satisfy the requirement in `acpi_cppc_processor_probe`.

Reported-by: CUI Hao <cuihao.leo@gmail.com>
Reported-by: maxim.novozhilov@gmail.com
Reported-by: lethe.tree@protonmail.com
Reported-by: garystephenwright@gmail.com
Reported-by: galaxyking0419@gmail.com
Fixes: c42fa24b4475 ("ACPI: bus: Avoid using CPPC if not supported by firmware")
Fixes: 2ca8e6285250 ("Revert "ACPI Pass the same capabilities to the _OSC regardless of the query flag"")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=213023
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2075387
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: CUI Hao <cuihao.leo@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c       | 11 +++++------
 drivers/acpi/cppc_acpi.c |  4 +++-
 include/linux/acpi.h     |  2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 1fc24f4fbcb4..6c735cfa7d43 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -298,7 +298,7 @@ EXPORT_SYMBOL_GPL(osc_cpc_flexible_adr_space_confirmed);
 bool osc_sb_native_usb4_support_confirmed;
 EXPORT_SYMBOL_GPL(osc_sb_native_usb4_support_confirmed);
 
-bool osc_sb_cppc_not_supported;
+bool osc_sb_cppc2_support_acked;
 
 static u8 sb_uuid_str[] = "0811B06E-4A27-44F9-8D60-3CBBC22E7B48";
 static void acpi_bus_osc_negotiate_platform_control(void)
@@ -358,11 +358,6 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 		return;
 	}
 
-#ifdef CONFIG_ACPI_CPPC_LIB
-	osc_sb_cppc_not_supported = !(capbuf_ret[OSC_SUPPORT_DWORD] &
-			(OSC_SB_CPC_SUPPORT | OSC_SB_CPCV2_SUPPORT));
-#endif
-
 	/*
 	 * Now run _OSC again with query flag clear and with the caps
 	 * supported by both the OS and the platform.
@@ -376,6 +371,10 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 
 	capbuf_ret = context.ret.pointer;
 	if (context.ret.length > OSC_SUPPORT_DWORD) {
+#ifdef CONFIG_ACPI_CPPC_LIB
+		osc_sb_cppc2_support_acked = capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_CPCV2_SUPPORT;
+#endif
+
 		osc_sb_apei_support_acked =
 			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
 		osc_pc_lpi_support_confirmed =
diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 840223c12540..6aff8019047b 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -666,8 +666,10 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 	acpi_status status;
 	int ret = -ENODATA;
 
-	if (osc_sb_cppc_not_supported)
+	if (!osc_sb_cppc2_support_acked) {
+		pr_debug("CPPC v2 _OSC not acked\n");
 		return -ENODEV;
+	}
 
 	/* Parse the ACPI _CPC table for this CPU. */
 	status = acpi_evaluate_object_typed(handle, "_CPC", NULL, &output,
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 03465db16b68..cf1f770208da 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -581,7 +581,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 extern bool osc_sb_apei_support_acked;
 extern bool osc_pc_lpi_support_confirmed;
 extern bool osc_sb_native_usb4_support_confirmed;
-extern bool osc_sb_cppc_not_supported;
+extern bool osc_sb_cppc2_support_acked;
 extern bool osc_cpc_flexible_adr_space_confirmed;
 
 /* USB4 Capabilities */
-- 
2.35.1



