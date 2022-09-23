Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72B55E7E8F
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 17:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiIWPib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 11:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIWPi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 11:38:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1951B14597B;
        Fri, 23 Sep 2022 08:38:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4BB9nlYD1dASQgheQN3f+2t0ug9ZNE+Mj2O622Mjiupi3g78NyN52I8bL44PTh4p0aXnjVQSSeVyhZf83W1kOpESwD7s2aF3SADY7pox0ILAW232xTQaSGCwVF2Vhz5CRDrLRfV42mz2e/O3J4Y6NICaAJDt1OGOrJ0S0Oe1D/7mpHlGk06RNlvrNEiqt2M5XKn9YFyi3aQ7wA+DCNjzKmpoYUArTD16Sfb4KRCQhx8zW44uZyfAB4ONICsSN/WXTpJVHcKB3nIgIjhSINl8J8LS5Gzex2oDGh/1wC9ODEyBZvEjrsjVxRyR6B4sb2QvsTFAX+PHiK7J+dzMMnjUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaDOp18KZgjGCatwH/nGibVybsVFQicr0BZkwpxA2ZM=;
 b=JZQQjMtmN5siPVhLeiIl2U/ns99/03rIoBrOrwuLpWxl0m2QngY3HeqLAesqFlCJP/0wKU4NE111B2N+oit9EsKjW4gUTvsd4gskpinCxq57VUEzI7SJYb+PRZVLLuIqOQNCYioEP7loGsEwfjH4cyr6eCEumQ1oY5zAM/O3M/C7PRE+sBRxjNcTplUdZmrItsFruxvIF7gfbywGsziU5fMo2yQwc8EhRMQOB8RLH0BMSgxbM8vf5HAxSxhs0eZfHoMCcymV3sNPC1J2mXuFi2C4hX4MVZjfi/up3LkRurVSzMbX1Y0Ie0nn2XZNCNUshAwFXiMN7AfdXABtFRdC3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaDOp18KZgjGCatwH/nGibVybsVFQicr0BZkwpxA2ZM=;
 b=p4ZrM55sB2bHADC2rRTBNDRZbcVnT154NEaxuVy5YBAvprnryCb4TteuiF7gAK/4JM08qW1KfvkGWqRGe8MdDF2a1vfX1icHqkuqCYZRE3Gi09hKn7JggccFCHB8lKCq2V3MkN8SnihCrwbOnz6bbXSpmEOC9JydX7wfwRXdrfk=
Received: from BN9PR03CA0358.namprd03.prod.outlook.com (2603:10b6:408:f6::33)
 by DM6PR12MB4044.namprd12.prod.outlook.com (2603:10b6:5:21d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:38:25 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::8b) by BN9PR03CA0358.outlook.office365.com
 (2603:10b6:408:f6::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20 via Frontend
 Transport; Fri, 23 Sep 2022 15:38:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Fri, 23 Sep 2022 15:38:24 +0000
Received: from BLR5CG134614W.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 10:38:15 -0500
From:   K Prateek Nayak <kprateek.nayak@amd.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <rafael@kernel.org>, <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <dave.hansen@linux.intel.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <andi@lisas.de>, <puwen@hygon.cn>,
        <mario.limonciello@amd.com>, <peterz@infradead.org>,
        <rui.zhang@intel.com>, <gpiccoli@igalia.com>,
        <daniel.lezcano@linaro.org>, <ananth.narayan@amd.com>,
        <gautham.shenoy@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
        "Calvin Ong" <calvin.ong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] x86,acpi: Limit "Dummy wait" workaround to older AMD and Intel processors
Date:   Fri, 23 Sep 2022 21:08:01 +0530
Message-ID: <20220923153801.9167-1-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT050:EE_|DM6PR12MB4044:EE_
X-MS-Office365-Filtering-Correlation-Id: d3ef8b6c-2281-47ab-aeab-08da9d79a733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XSsr5Ru4gijz6wsHkTTtpjNDNTZrGTqvXOgkUYPj6ov5zPUvgeCH9/4QJSt5EnMEQ0YZ5uJifY4tza1vIfHaVXqqccuWcS04X/SboimKUD+UgXOrZbzEJBvrgeLceV4l/Rhck+uDS6d/I3iw8ntVpsaPs52g8A+ZJCltBELhQZceiKpRJ871E03VA0BgYhpGnxtB4QxLdaaqkrrFbPwDhbjuD2c+itHQxwJWtUT458CqrY0mI0eO7KlyaHmlY60kUcRpvTqJD9/hpHvKusdYdc6WQp7I/9KtuzWbGm0NG7G7dnHNb/1o7B/5+diBQkcS/HplJuAjE3GKY/u25f8UW/Rrwvi0HJ48Ns0bkVXa+xyc7jTT0mPrYSStQqIrKPUNicKLY1o8PDR3Aom2e+wyZXe0dhtfKisZAErI068GySn4vGPL9NWkVR35jo04qL3BMc4DJ8ydfqYavgpVg34fJLCRjZy4i7U5C0MHVzf1BTu9HXfWE2Gg7pLVLF7atJFFjeQHwOuZ8Ykh4nB1T+LZoo1eKULblFgfsolmlRZAhnuPRWDtgjbzIRWIOLSWsUJ22Fc/luWyl5ZZjwlXDxEmeTCe8pFQFTkdKFJxXj2RXdCbKdScvwR06nCnv9XDDexKP6K93mULsOOIZBXiWQzoSP4I8L0z9JhgKdcQRx7iV5kGhN97rzv0+L0jHjQL6h7OR7nUUb+CUZ+J2YGUWkEo8V9fb9N7+NPBmu27OkivhrRodLocSv+bYOOvv34mhElkzpxoF25sJY0B+9LSWkUrH9ZmyQuPO/a8RMM43j9pn2DX3RbXkdA7P5v6fV2gBwT+TcOi+oSpYzJCygYgiukFL7qZ7+xfcxEdjk3RSQ6D3QvmFZCmuHBSxBP7gZxckZgq
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(26005)(966005)(6916009)(2906002)(6666004)(7696005)(36756003)(54906003)(1076003)(16526019)(186003)(2616005)(86362001)(70206006)(70586007)(83380400001)(4326008)(47076005)(426003)(336012)(36860700001)(316002)(40480700001)(41300700001)(8936002)(8676002)(5660300002)(7416002)(81166007)(82310400005)(478600001)(40460700003)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:38:24.7507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ef8b6c-2281-47ab-aeab-08da9d79a733
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4044
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Processors based on the Zen microarchitecture support IOPORT based deeper
C-states. The ACPI idle driver reads the
acpi_gbl_FADT.xpm_timer_block.address in the IOPORT based C-state exit
path which is claimed to be a "Dummy wait op" and has been around since
ACPI's introduction to Linux dating back to Andy Grover's Mar 14, 2002
posting [1].

Old, circa 2002 chipsets have a bug which was elaborated by Andreas Mohr
back in 2006 in commit b488f02156d3d ("ACPI: restore comment justifying
'extra' P_LVLx access") where the commit log claims:
"this dummy read was about: STPCLK# doesn't get asserted in time on
(some) chipsets, which is why we need to have a dummy I/O read to delay
further instruction processing until the CPU is fully stopped."

This workaround is very painful on modern systems with a large number of
cores. The "inl()" can take thousands of cycles. Sampling certain
workloads with IBS on AMD Zen3 system shows that a significant amount of
time is spent in the dummy op, which incorrectly gets accounted as
C-State residency. A large C-State residency value can prime the cpuidle
governor to recommend a deeper C-State during the subsequent idle
instances, starting a vicious cycle, leading to performance degradation
on workloads that rapidly switch between busy and idle phases.
(For the extent of the performance degradation refer link [2])

The dummy wait is unnecessary on processors based on the Zen
microarchitecture (AMD family 17h+ and HYGON). Skip it to prevent
polluting the C-state residency information. Among the pre-family 17h
AMD processors, there has been at least one report of an AMD Athlon on a
VIA chipset (circa 2006) where this this problem was seen (see [3] for
report by Andreas Mohr).

Modern Intel processors use MWAIT based C-States in the intel_idle driver
and are not impacted by this code path. For older Intel processors that
use the acpi_idle driver, a workaround was suggested by Dave Hansen and
Rafael J. Wysocki to regard all Intel chipsets using the IOPORT based
C-state management as being affected by this problem (see [4] for
workaround proposed).

For these reasons, mark all the Intel processors and pre-family 17h
AMD processors with x86_BUG_STPCLK. In the acpi_idle driver, restrict the
dummy wait during IOPORT based C-state transitions to only these
processors.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux-fullhistory.git/commit/?id=972c16130d9dc182cedcdd408408d9eacc7d6a2d [1]
Link: https://lore.kernel.org/lkml/20220921063638.2489-1-kprateek.nayak@amd.com/ [2]
Link: https://lore.kernel.org/lkml/Yyy6l94G0O2B7Yh1@rhlx01.hs-esslingen.de/ [3]
Link: https://lore.kernel.org/lkml/88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com/ [4]

Suggested-by: Calvin Ong <calvin.ong@amd.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
CC: Pu Wen <puwen@hygon.cn>
Cc: stable@vger.kernel.org
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
v1->v2:
o Introduce X86_BUG_STPCLK to mark chipsets as being affected by the
  STPCLK# signal assertion issue.
o Mark all Intel chipsets and pre fam-17h AMD chipsets as being affected
  by the X86_BUG_STPCLK.
o Skip dummy xpm_timer_block read in IOPORT based C-state exit path in
  ACPI processor_idle if chipset is not affected by X86_BUG_STPCLK.
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/amd.c          | 12 ++++++++++++
 arch/x86/kernel/cpu/intel.c        | 12 ++++++++++++
 drivers/acpi/processor_idle.c      |  8 ++++++++
 4 files changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ef4775c6db01..fcd3617ed315 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -460,5 +460,6 @@
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
 #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
 #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
+#define X86_BUG_STPCLK			X86_BUG(29) /* STPCLK# signal does not get asserted in time during IOPORT based C-state entry */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 48276c0e479d..8cb5887a53a3 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -988,6 +988,18 @@ static void init_amd(struct cpuinfo_x86 *c)
 	if (!cpu_has(c, X86_FEATURE_XENPV))
 		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
 
+	/*
+	 * CPUs based on the Zen microarchitecture (Fam 17h onward) can
+	 * guarantee that STPCLK# signal is asserted in time after the
+	 * P_LVL2 read to freeze execution after an IOPORT based C-state
+	 * entry. Among the older AMD processors, there has been at least
+	 * one report of an AMD Athlon processor on a VIA chipset
+	 * (circa 2006) having this issue. Mark all these older AMD
+	 * processor families as being affected.
+	 */
+	if (c->x86 < 0x17)
+		set_cpu_bug(c, X86_BUG_STPCLK);
+
 	/*
 	 * Turn on the Instructions Retired free counter on machines not
 	 * susceptible to erratum #1054 "Instructions Retired Performance
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 2d7ea5480ec3..96fe1320c238 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -696,6 +696,18 @@ static void init_intel(struct cpuinfo_x86 *c)
 		((c->x86_model == INTEL_FAM6_ATOM_GOLDMONT)))
 		set_cpu_bug(c, X86_BUG_MONITOR);
 
+	/*
+	 * Intel chipsets prior to Nehalem used the ACPI processor_idle
+	 * driver for C-state management. Some of these processors that
+	 * used IOPORT based C-states could not guarantee that STPCLK#
+	 * signal gets asserted in time after P_LVL2 read to freeze
+	 * execution properly. Since a clear cut-off point is not known
+	 * as to when this bug was solved, mark all the chipsets as
+	 * being affected. Only the ones that use IOPORT based C-state
+	 * transitions via the acpi_idle driver will be impacted.
+	 */
+	set_cpu_bug(c, X86_BUG_STPCLK);
+
 #ifdef CONFIG_X86_64
 	if (c->x86 == 15)
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 16a1663d02d4..493f9ccdb72d 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -528,6 +528,14 @@ static int acpi_idle_bm_check(void)
 static void wait_for_freeze(void)
 {
 #ifdef	CONFIG_X86
+	/*
+	 * A dummy wait operation is only required for those chipsets
+	 * that cannot assert STPCLK# signal in time after P_LVL2 read.
+	 * If a chipset is not affected by this problem, skip it.
+	 */
+	if (!static_cpu_has_bug(X86_BUG_STPCLK))
+		return;
+
 	/* No delay is needed if we are in guest */
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return;
-- 
2.25.1

