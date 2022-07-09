Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B4356C7FB
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 10:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiGIIXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 04:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGIIXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 04:23:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A1C77480
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 01:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01D2460EB4
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 08:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C577C3411C;
        Sat,  9 Jul 2022 08:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657354994;
        bh=dITREP42vcZmvM5M7k8ut6oG4AgeM6imLgjK/FkUF3U=;
        h=Subject:To:Cc:From:Date:From;
        b=kq9qmn6i9Ly2QTRHdRlw4oAeo9flcpwfZoUbQk3hI2tqZM0DvriHYeo3VM8qgPqgG
         HUeZ068+HV8YdoZ6hK9WTJ4TtSNaaSGHdQSwTKi4LAtzKgfjprjTJVOeX9ULt36TUk
         eFrwxgv7OU1zTP6XOaZ07TbrmeWESgDMDX/mcTTk=
Subject: FAILED: patch "[PATCH] ACPI: CPPC: Only probe for _CPC if CPPC v2 is acked" failed to apply to 5.15-stable tree
To:     mario.limonciello@amd.com, cuihao.leo@gmail.com,
        mika.westerberg@linux.intel.com, rafael.j.wysocki@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 09 Jul 2022 10:23:11 +0200
Message-ID: <1657354991205140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7feec7430edddb87c24b0a86b08a03d0b496a755 Mon Sep 17 00:00:00 2001
From: Mario Limonciello <mario.limonciello@amd.com>
Date: Tue, 5 Jul 2022 13:29:14 -0500
Subject: [PATCH] ACPI: CPPC: Only probe for _CPC if CPPC v2 is acked

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

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 86fa61a21826..e2db1bdd9dd2 100644
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
index 903528f7e187..d64facbda0fb 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -684,8 +684,10 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
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
index 4f82a5bc6d98..44975c1bbe12 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -584,7 +584,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 extern bool osc_sb_apei_support_acked;
 extern bool osc_pc_lpi_support_confirmed;
 extern bool osc_sb_native_usb4_support_confirmed;
-extern bool osc_sb_cppc_not_supported;
+extern bool osc_sb_cppc2_support_acked;
 extern bool osc_cpc_flexible_adr_space_confirmed;
 
 /* USB4 Capabilities */

