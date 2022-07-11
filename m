Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B23C56FBA8
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiGKJdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbiGKJdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:33:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FDA7AB14;
        Mon, 11 Jul 2022 02:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 281DB612B8;
        Mon, 11 Jul 2022 09:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8BDC36AE7;
        Mon, 11 Jul 2022 09:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531075;
        bh=WewbxobdXy3VRk5+aYIVvs3YD7Yl6NReJmWuY9HmJdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1R6MsxSBbw/cOsTCQhdHVgNM796dT6yzN/wZHAzGIyrmPEjUqQSEh0VlBoh3HL9o7
         EqzQoUN+tREajs49jdKJOLfzzlIgHu7WZRcg4Gd8tc7H39r0BKVZQ3wvxAZHvrLhT/
         hUXOj9s90beQWOGLemkXRfn42zMAgS0a8cYTscs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Perry Yuan <perry.yuan@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 088/112] ACPI: CPPC: Dont require _OSC if X86_FEATURE_CPPC is supported
Date:   Mon, 11 Jul 2022 11:07:28 +0200
Message-Id: <20220711090552.069300240@linuxfoundation.org>
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

[ Upstream commit 8b356e536e69f3a4d6778ae9f0858a1beadabb1f ]

commit 72f2ecb7ece7 ("ACPI: bus: Set CPPC _OSC bits for all and
when CPPC_LIB is supported") added support for claiming to
support CPPC in _OSC on non-Intel platforms.

This unfortunately caused a regression on a vartiety of AMD
platforms in the field because a number of AMD platforms don't set
the `_OSC` bit 5 or 6 to indicate CPPC or CPPC v2 support.

As these AMD platforms already claim CPPC support via a dedicated
MSR from `X86_FEATURE_CPPC`, use this enable this feature rather
than requiring the `_OSC` on platforms with a dedicated MSR.

If there is additional breakage on the shared memory designs also
missing this _OSC, additional follow up changes may be needed.

Fixes: 72f2ecb7ece7 ("Set CPPC _OSC bits for all and when CPPC_LIB is supported")
Reported-by: Perry Yuan <perry.yuan@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/acpi/cppc.c | 10 ++++++++++
 drivers/acpi/cppc_acpi.c    | 16 +++++++++++++++-
 include/acpi/cppc_acpi.h    |  1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/cppc.c b/arch/x86/kernel/acpi/cppc.c
index df1644d9b3b6..3677df836e91 100644
--- a/arch/x86/kernel/acpi/cppc.c
+++ b/arch/x86/kernel/acpi/cppc.c
@@ -11,6 +11,16 @@
 
 /* Refer to drivers/acpi/cppc_acpi.c for the description of functions */
 
+bool cpc_supported_by_cpu(void)
+{
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+	case X86_VENDOR_HYGON:
+		return boot_cpu_has(X86_FEATURE_CPPC);
+	}
+	return false;
+}
+
 bool cpc_ffh_supported(void)
 {
 	return true;
diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 6aff8019047b..57ca7aa0e169 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -559,6 +559,19 @@ bool __weak cpc_ffh_supported(void)
 	return false;
 }
 
+/**
+ * cpc_supported_by_cpu() - check if CPPC is supported by CPU
+ *
+ * Check if the architectural support for CPPC is present even
+ * if the _OSC hasn't prescribed it
+ *
+ * Return: true for supported, false for not supported
+ */
+bool __weak cpc_supported_by_cpu(void)
+{
+	return false;
+}
+
 /**
  * pcc_data_alloc() - Allocate the pcc_data memory for pcc subspace
  *
@@ -668,7 +681,8 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 
 	if (!osc_sb_cppc2_support_acked) {
 		pr_debug("CPPC v2 _OSC not acked\n");
-		return -ENODEV;
+		if (!cpc_supported_by_cpu())
+			return -ENODEV;
 	}
 
 	/* Parse the ACPI _CPC table for this CPU. */
diff --git a/include/acpi/cppc_acpi.h b/include/acpi/cppc_acpi.h
index 92b7ea8d8f5e..181907349b49 100644
--- a/include/acpi/cppc_acpi.h
+++ b/include/acpi/cppc_acpi.h
@@ -144,6 +144,7 @@ extern bool acpi_cpc_valid(void);
 extern int acpi_get_psd_map(unsigned int cpu, struct cppc_cpudata *cpu_data);
 extern unsigned int cppc_get_transition_latency(int cpu);
 extern bool cpc_ffh_supported(void);
+extern bool cpc_supported_by_cpu(void);
 extern int cpc_read_ffh(int cpunum, struct cpc_reg *reg, u64 *val);
 extern int cpc_write_ffh(int cpunum, struct cpc_reg *reg, u64 val);
 #else /* !CONFIG_ACPI_CPPC_LIB */
-- 
2.35.1



