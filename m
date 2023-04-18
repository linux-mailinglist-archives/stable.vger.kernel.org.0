Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3B06E64CD
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjDRMwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjDRMwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:52:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059AE13C38
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADB8263432
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF74CC433D2;
        Tue, 18 Apr 2023 12:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822336;
        bh=OdXT5sRbrc2E28mPDHb4YEnv6+ZmVGqouxzMZZu68ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dobcuCflhb8RPVJ/MEM62osu20Rf9mpsBDWOFMuh7kKlKtRvkcZXG24uyL99XNdx3
         pqXAFkNDLXKpPPujh26+OHI6J1e+aawGlB//o2tiFkXwv0uF9HGkfIdHo4ru8bIoEI
         TVjsw+LIc9MwAqKUU+d4YfeN6s1MHm09ojeykKxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rui Salvaterra <rsalvaterra@gmail.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "6 . 2+" <stable@kernel.org>
Subject: [PATCH 6.2 112/139] thermal: intel: Avoid updating unsupported THERM_STATUS_CLEAR mask bits
Date:   Tue, 18 Apr 2023 14:22:57 +0200
Message-Id: <20230418120317.972014393@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 117e4e5bd9d47b89777dbf6b37a709dcfe59520f upstream.

Some older processors don't allow BIT(13) and BIT(15) in the current
mask set by "THERM_STATUS_CLEAR_CORE_MASK". This results in:

unchecked MSR access error: WRMSR to 0x19c (tried to
write 0x000000000000aaa8) at rIP: 0xffffffff816f66a6
(throttle_active_work+0xa6/0x1d0)

To avoid unchecked MSR issues, check CPUID for each relevant feature and
use that information to set the supported feature bits only in the
"clear" mask for cores. Do the same for the analogous package mask set
by "THERM_STATUS_CLEAR_PKG_MASK".

Introduce functions thermal_intr_init_core_clear_mask() and
thermal_intr_init_pkg_clear_mask() to set core and package mask bits,
respectively. These functions are called during initialization.

Fixes: 6fe1e64b6026 ("thermal: intel: Prevent accidental clearing of HFI status")
Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Link: https://lore.kernel.org/lkml/cdf43fb423368ee3994124a9e8c9b4f8d00712c6.camel@linux.intel.com/T/
Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 6.2+ <stable@kernel.org> # 6.2+
[ rjw: Renamed 2 funtions and 2 static variables, edited subject and
  changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/therm_throt.c |   73 ++++++++++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 7 deletions(-)

--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -193,8 +193,67 @@ static const struct attribute_group ther
 #define THERM_THROT_POLL_INTERVAL	HZ
 #define THERM_STATUS_PROCHOT_LOG	BIT(1)
 
-#define THERM_STATUS_CLEAR_CORE_MASK (BIT(1) | BIT(3) | BIT(5) | BIT(7) | BIT(9) | BIT(11) | BIT(13) | BIT(15))
-#define THERM_STATUS_CLEAR_PKG_MASK  (BIT(1) | BIT(3) | BIT(5) | BIT(7) | BIT(9) | BIT(11))
+static u64 therm_intr_core_clear_mask;
+static u64 therm_intr_pkg_clear_mask;
+
+static void thermal_intr_init_core_clear_mask(void)
+{
+	if (therm_intr_core_clear_mask)
+		return;
+
+	/*
+	 * Reference: Intel SDM  Volume 4
+	 * "Table 2-2. IA-32 Architectural MSRs", MSR 0x19C
+	 * IA32_THERM_STATUS.
+	 */
+
+	/*
+	 * Bit 1, 3, 5: CPUID.01H:EDX[22] = 1. This driver will not
+	 * enable interrupts, when 0 as it checks for X86_FEATURE_ACPI.
+	 */
+	therm_intr_core_clear_mask = (BIT(1) | BIT(3) | BIT(5));
+
+	/*
+	 * Bit 7 and 9: Thermal Threshold #1 and #2 log
+	 * If CPUID.01H:ECX[8] = 1
+	 */
+	if (boot_cpu_has(X86_FEATURE_TM2))
+		therm_intr_core_clear_mask |= (BIT(7) | BIT(9));
+
+	/* Bit 11: Power Limitation log (R/WC0) If CPUID.06H:EAX[4] = 1 */
+	if (boot_cpu_has(X86_FEATURE_PLN))
+		therm_intr_core_clear_mask |= BIT(11);
+
+	/*
+	 * Bit 13: Current Limit log (R/WC0) If CPUID.06H:EAX[7] = 1
+	 * Bit 15: Cross Domain Limit log (R/WC0) If CPUID.06H:EAX[7] = 1
+	 */
+	if (boot_cpu_has(X86_FEATURE_HWP))
+		therm_intr_core_clear_mask |= (BIT(13) | BIT(15));
+}
+
+static void thermal_intr_init_pkg_clear_mask(void)
+{
+	if (therm_intr_pkg_clear_mask)
+		return;
+
+	/*
+	 * Reference: Intel SDM  Volume 4
+	 * "Table 2-2. IA-32 Architectural MSRs", MSR 0x1B1
+	 * IA32_PACKAGE_THERM_STATUS.
+	 */
+
+	/* All bits except BIT 26 depend on CPUID.06H: EAX[6] = 1 */
+	if (boot_cpu_has(X86_FEATURE_PTS))
+		therm_intr_pkg_clear_mask = (BIT(1) | BIT(3) | BIT(5) | BIT(7) | BIT(9) | BIT(11));
+
+	/*
+	 * Intel SDM Volume 2A: Thermal and Power Management Leaf
+	 * Bit 26: CPUID.06H: EAX[19] = 1
+	 */
+	if (boot_cpu_has(X86_FEATURE_HFI))
+		therm_intr_pkg_clear_mask |= BIT(26);
+}
 
 /*
  * Clear the bits in package thermal status register for bit = 1
@@ -207,13 +266,10 @@ void thermal_clear_package_intr_status(i
 
 	if (level == CORE_LEVEL) {
 		msr  = MSR_IA32_THERM_STATUS;
-		msr_val = THERM_STATUS_CLEAR_CORE_MASK;
+		msr_val = therm_intr_core_clear_mask;
 	} else {
 		msr  = MSR_IA32_PACKAGE_THERM_STATUS;
-		msr_val = THERM_STATUS_CLEAR_PKG_MASK;
-		if (boot_cpu_has(X86_FEATURE_HFI))
-			msr_val |= BIT(26);
-
+		msr_val = therm_intr_pkg_clear_mask;
 	}
 
 	msr_val &= ~bit_mask;
@@ -708,6 +764,9 @@ void intel_init_thermal(struct cpuinfo_x
 	h = THERMAL_APIC_VECTOR | APIC_DM_FIXED | APIC_LVT_MASKED;
 	apic_write(APIC_LVTTHMR, h);
 
+	thermal_intr_init_core_clear_mask();
+	thermal_intr_init_pkg_clear_mask();
+
 	rdmsr(MSR_IA32_THERM_INTERRUPT, l, h);
 	if (cpu_has(c, X86_FEATURE_PLN) && !int_pln_enable)
 		wrmsr(MSR_IA32_THERM_INTERRUPT,


