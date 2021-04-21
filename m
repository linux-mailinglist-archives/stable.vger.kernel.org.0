Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563353663C5
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 04:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbhDUCi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 22:38:57 -0400
Received: from mail-eopbgr760078.outbound.protection.outlook.com ([40.107.76.78]:38516
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234004AbhDUCi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 22:38:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXDLPrjjLnAbWYKd/oPdYsrFocDTK5zypBfCesc/QyohHe58JJgYHkxvIb5KgBFVOZjO1G9hIhoYpZ9ZzV/YfV602fzo9wMm2O1SifGmoKfJPIv9OE8ehtmoam5IL8ODB/VDRkqhtHCCP8Gqc1nEHOrU0SCjIofho3QCl3xLc1iZmp+MmR6BwkwXqZNA0qAV1XT+twt5flbL4kUfwA1mc00rRa6Y+MbujurHiELV8dVkTcfCa1nSYwTBdhWu6OjmpU+Ijofeb/iCbB67swhxebVKiwYxV/mbp++I15+GST4YC+as953qfz/faQUYrwJ2EcalqfhCbs+DrOh0V6wZ6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOJEuwiCa0aZEKGIWBNfLSQkXqIfPkaOdeHSIxCn5zI=;
 b=ZBnmgH1CQ10E4lqr8aMc1+DUklebQzq3L68MeJrVtBIr8bGf68E9khMxo3iZGCo11h8BrAyZptJVjmaS7QQnk3n883Wkbx8vS8chX4R3fsh9wALqjfk8yWpdQi/Q0SrCu9WU3/J7RpWFDLTCp0YWQScZReHzumyutvgerhnVWepwV0OYLOxOTcKNeT0AmE63HxM6vSC2wMluQOaXF4hfRyeW38i3WmSodwCu6/s2ucaB+PqzFoWf/HXskbxXmgSnyd9HDDzHnCd1PgTpFYVoYFQuRPHKEk7zSV2VclHJmUxoLXwwvvGyO0L1cbC1cReDD3bHB7k6Bx8BEMN4rr3gZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOJEuwiCa0aZEKGIWBNfLSQkXqIfPkaOdeHSIxCn5zI=;
 b=ttA2aA4OEtVSIfX9lzYoESj/64Bvc8QZXAMXWG5iyxc/Mua/QWQnVPQGx0f7Tr1ngLz5JkVdhy5Z/8gRp/UMBBsKpF6g7srhQHgC9H5VwTxlnZ8exFXlcc0b+IgSRw5lf4ZNZ/gY4CQP5jNqeW+8+uVK54vPMHW+btnbS8l7GEw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR12MB1375.namprd12.prod.outlook.com (2603:10b6:300:10::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 02:38:22 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4065.020; Wed, 21 Apr 2021
 02:38:22 +0000
From:   Huang Rui <ray.huang@amd.com>
To:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Huang Rui <ray.huang@amd.com>,
        Nathan Fontenot <nathan.fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] x86, sched: Fix the AMD CPPC maximum perf on some specific generations
Date:   Wed, 21 Apr 2021 10:38:06 +0800
Message-Id: <20210421023807.1540290-1-ray.huang@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HK2PR04CA0046.apcprd04.prod.outlook.com
 (2603:1096:202:14::14) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd.amd.com (58.247.170.245) by HK2PR04CA0046.apcprd04.prod.outlook.com (2603:1096:202:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 21 Apr 2021 02:38:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d41bd1d-a823-4974-098d-08d9046e8802
X-MS-TrafficTypeDiagnostic: MWHPR12MB1375:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB13753E28339886EE024FB2E4EC479@MWHPR12MB1375.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6qFUgVUw7ZNxZEkwvhXezKp4s1T2RVyCS3CHhnEX1Pkt99UG22G2U0KT+O90BII5q53CEeOp2Sq8yydJACj+/0LKOns5LVJVXyuG6UOztcUq0yVu5J1ZAYNyy6IjaNbnXv8Uqi6WHPTnRjTEthu0Q2BjRyZ6dwSKGjR/HzXYehJJzF/dNVoJ3qrwdG2M+J2Axc9ti/LrcIKYSl+s+LZClb2Kbs0VumnRqWe8RTRyoVQYDO3AvMmDh1BR9LZnI3pcGELSauAAXvFpI6xhGK7nzvHVuGHxFwDf+H/hT+/5H2IlaXw/l/EmiRyzwjQj8SG5kYR2lh7oSspsVcxPfrZ0q9bsw+KIh/FZLyWUYlBrIJvBjhhQhRShUXlDnbdTbte0fOZHe59x9Sp4ma9Y0IdW2oDjTVvZlC+z8fpg6GHAdc5UjZ1AOdPlQrzfFjFLigdBKRbqZfyBzxslAlR5Bd1jbWt3Mf1Y51G2oqVBHATU5y7Gupc+NtsE+PwzruBTrCQwCTpggosjjtlmD6c/bqUaLPBcgPmpouDK0DPt6iuOxt7qJme5sA3ksuF4QEqh5WuuemN05gVx/9m+WbwdtSZnn4+CF0lSPzrbzO5xZKth/aoaiZkWbfKkBkK4FWWYgaA3sLNbMQFLFf3lORWCCKFgaAY/cXbE+33rkfWUESC+RyfAUMJZIep4JO2yUJhB7b/wWl0Qcsyjs0dl6jKBX9yZsdTjEWKQxDcU5VEty4L6lxJOUgKIa73Yi2uKhoh2MS0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(54906003)(7696005)(956004)(83380400001)(186003)(38100700002)(16526019)(66476007)(316002)(8936002)(5660300002)(1076003)(66556008)(8676002)(86362001)(38350700002)(2906002)(2616005)(26005)(36756003)(478600001)(66946007)(6486002)(52116002)(4326008)(966005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZDBYT0RpcG5UVVQwMWRMNzF6dURqenhyVk1IL0RjVm9iRkFuRHQ2U2dEdjRs?=
 =?utf-8?B?TEFBSmJnSzNkU0JwVHVSbE9wN0VvTDBlTEN0MWlJcExVdUsyeGZ4SVBNbURl?=
 =?utf-8?B?d3k2SXZsc0pIdll6aS9hMzZWa296Y1NaLzgvVDdUbGJaaFE3L2dHSGgyNTl0?=
 =?utf-8?B?NU5BQkxLS2dQSjZmV1pZRWxLVzVEOHZnUzN3bDlSM0t3b3BwK1lLWGxRWHlm?=
 =?utf-8?B?N3lLdXh5TUZxN0V3NGtFYitRcHRmYkhmRGQwN3JIUjE4dHRVcXdhNi90eU9T?=
 =?utf-8?B?N2RpQ3A1bmt4Y0kxZEp3NHpqY09xNCtHTFkzdnVmQitLM1dvWXd6ZTJoYnc5?=
 =?utf-8?B?cnJvTjZpcE9MVERLR0V4THR1eDBsMktWSU5SZ3dZeW51TGthMzc0SDlhZDNJ?=
 =?utf-8?B?ZHRHVHJqNzBTN04raitpRURTdXBwaVp2Sy8yUEhrakhrMnI2anNObDcxVys4?=
 =?utf-8?B?aXRYbXdWMVBCMEdGeUd4U2kzN2Nra3J2UDE4TTdlS2VoS0ViTUVSbWNLS1hy?=
 =?utf-8?B?TW1saXJQRFBJeDlNSWZ3cXlHOGtubmZ4TGU5djM5VWRQUWVMd0xHTEh1UXlx?=
 =?utf-8?B?QytzRnZDT1VUUE1abHRGVnNINzZRRURwb2llK3FpVUFwR1dFY09XN3lQSFFF?=
 =?utf-8?B?SHBZYndkRkZVc1F2T2cyNndXWlNCbDBWVFpOd3hWSk9KMUYxeDlWOTFYcGdS?=
 =?utf-8?B?YUFqVjNYSWV6U1FrcWNRaGFxaXlZRDNwTnlBR0xvR1oyKytlakNROFBMT3pq?=
 =?utf-8?B?OFpVa1lOMy85UVBFUTh1RkNsd0dwNjMrcDAwTG1EMVBnQXA2T1hPSnQxVlU0?=
 =?utf-8?B?RDlxMjQyVm9rSU5YTUJUWTZsMjUvNHFjSEN4UUxTdzlUSndIejJabWJjdFo5?=
 =?utf-8?B?UTVoNzIrbXhJMWZ1SjkySkg4YTVJbTlXSUthK1BsZSsrL1Z1MXZnVE9VejdT?=
 =?utf-8?B?cCtwZUc1a01Sc3MreFlzbzZJdjBxMXVCVkZKa1RBZVNzblVIRlU1MDdHSHB1?=
 =?utf-8?B?YVNFRFZraXl5bjBheVJSL0FsQ0hpakZTbmErOEFDS29pN3c3TnBQMGhJdi9R?=
 =?utf-8?B?N3doeStadUo5Ykx5SHdXSFFLb08yTE01UVJMa0syYTZFVnhOS0xRMTMzZ2tQ?=
 =?utf-8?B?OHljaUp0TXlhNm4rRURWWFpsQ29GaTZzNkROaEgrM1g2aWNuTjNwU1lnVmhk?=
 =?utf-8?B?endLM2s1UThlakFLWkdhR1JpbHQwM2JqanFWOEw1TTBFYktuNTRLVHJydUR6?=
 =?utf-8?B?eWNwc0dObDN1RXNlc1dFdFBiM0xSalpseXdDbmlRaVcvYjVZSmcrbzRJR2Nx?=
 =?utf-8?B?VU9jc1V0YVNheG5DVW9UdnVCZmJjN1V4Z24rRmNsdm9mMlQrM2xjKzNrTXJt?=
 =?utf-8?B?ZVJSWkNLNEphbWxWeUZCT0pwZnVCWU9HU0V0bHgxbWkyM2ZYWTJBZ3R1TmRi?=
 =?utf-8?B?OTdhMW9abHRsM2RMODFabzQ4R2dpTHJmR1NoMXRKWGlhVUFkZTM4MzAyOGty?=
 =?utf-8?B?VS80U1A2Zlk2K1lQU0NPamdCTjlscXgrbHdiSm1tVzlpa0NPSFpLWWM5SWVo?=
 =?utf-8?B?Mm9SR2FIUWMzb0hqbXNWY0JPdjJYVkhkZ3VUUlFrSWcvM3ozRXgvV0NkM2Ux?=
 =?utf-8?B?Z2FDbUZLenpHT0tsLy9xOUJNejJLWWJWcVhua01PRDc0cjhZME10eE5wSkNM?=
 =?utf-8?B?ZUlZdWtFUHRFckhaTmtNdVM3RGZUSTk0azFGT1ZRa2VsajNoTUxHTWhNTEdR?=
 =?utf-8?Q?AvMgbAm/xS7sdal9OLQnbDPIQW9bnz9UV7GSxWd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d41bd1d-a823-4974-098d-08d9046e8802
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 02:38:22.6813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDN6usyJvtu/YCPH5KBo2kNYbolywknNBNMqKDSmlBKJYnnekeSpzyBuyB6e6tEfyl0BOqab3BLIlpwaeuhjnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1375
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some AMD Ryzen generations has different calculation method on maximum
perf. 255 is not for all asics, some specific generations should use 166
as the maximum perf. Otherwise, it will report incorrect frequency value
like below:

~ → lscpu | grep MHz
CPU MHz:                         3400.000
CPU max MHz:                     7228.3198
CPU min MHz:                     2200.0000

Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")

Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211791
Signed-off-by: Huang Rui <ray.huang@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Nathan Fontenot <nathan.fontenot@amd.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
---

Changes from V1 -> V2:
- Enhance the commit message.
- Move amd_get_highest_perf() into amd.c.
- Refine the implementation of switch-case.
- Cc stable mail list.

---
 arch/x86/include/asm/processor.h |  2 ++
 arch/x86/kernel/cpu/amd.c        | 22 ++++++++++++++++++++++
 arch/x86/kernel/smpboot.c        |  2 +-
 drivers/cpufreq/acpi-cpufreq.c   | 19 +++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index f1b9ed5efaa9..908bcaea1361 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -804,8 +804,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_shadow);
 
 #ifdef CONFIG_CPU_SUP_AMD
 extern u32 amd_get_nodes_per_socket(void);
+extern u32 amd_get_highest_perf(void);
 #else
 static inline u32 amd_get_nodes_per_socket(void)	{ return 0; }
+static inline u32 amd_get_highest_perf(void)		{ return 0; }
 #endif
 
 static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 347a956f71ca..aadb691d9357 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1170,3 +1170,25 @@ void set_dr_addr_mask(unsigned long mask, int dr)
 		break;
 	}
 }
+
+u32 amd_get_highest_perf(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	u32 cppc_max_perf = 225;
+
+	switch (c->x86) {
+	case 0x17:
+		if ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
+		    (c->x86_model >= 0x70 && c->x86_model < 0x80))
+			cppc_max_perf = 166;
+		break;
+	case 0x19:
+		if ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
+		    (c->x86_model >= 0x40 && c->x86_model < 0x70))
+			cppc_max_perf = 166;
+		break;
+	}
+
+	return cppc_max_perf;
+}
+EXPORT_SYMBOL_GPL(amd_get_highest_perf);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 02813a7f3a7c..7bec57d04a87 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -2046,7 +2046,7 @@ static bool amd_set_max_freq_ratio(void)
 		return false;
 	}
 
-	highest_perf = perf_caps.highest_perf;
+	highest_perf = amd_get_highest_perf();
 	nominal_perf = perf_caps.nominal_perf;
 
 	if (!highest_perf || !nominal_perf) {
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index d1bbc16fba4b..3f0a19dd658c 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -630,6 +630,22 @@ static int acpi_cpufreq_blacklist(struct cpuinfo_x86 *c)
 #endif
 
 #ifdef CONFIG_ACPI_CPPC_LIB
+
+static u64 get_amd_max_boost_ratio(unsigned int cpu, u64 nominal_perf)
+{
+	u64 boost_ratio, cppc_max_perf;
+
+	if (!nominal_perf)
+		return 0;
+
+	cppc_max_perf = amd_get_highest_perf();
+
+	boost_ratio = div_u64(cppc_max_perf << SCHED_CAPACITY_SHIFT,
+			      nominal_perf);
+
+	return boost_ratio;
+}
+
 static u64 get_max_boost_ratio(unsigned int cpu)
 {
 	struct cppc_perf_caps perf_caps;
@@ -646,6 +662,9 @@ static u64 get_max_boost_ratio(unsigned int cpu)
 		return 0;
 	}
 
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return get_amd_max_boost_ratio(cpu, perf_caps.nominal_perf);
+
 	highest_perf = perf_caps.highest_perf;
 	nominal_perf = perf_caps.nominal_perf;
 
-- 
2.25.1

