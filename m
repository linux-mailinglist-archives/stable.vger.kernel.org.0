Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476BE36A58F
	for <lists+stable@lfdr.de>; Sun, 25 Apr 2021 09:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhDYHgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 03:36:02 -0400
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:27745
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229825AbhDYHgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Apr 2021 03:36:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlSe0rfYMPeF7hFDuYKMRBwFDdmhYp0iGCNdp+gMdiDb/4eXioTVYaOeUDbtx60/LZAn7ZYog7AyV2m+dT/PvIZS8R34N0GZNxDVY4zezTbiEzZ6BSjvzjusm9n1tJjuqy97n19x0D4mE/usjOqNVWlbW72J6jFzqRuHeSF9/NXw+KPrhfNXTsE3QQlbpVuOwP06tPK0r3cwUu2B10S6jrkDdTIE8qCOYRKrrHPH9MNP+WGd2gEq9NxK3YObuO4TbVQl8a1AMQta0RUqd4EMtWWfxa9P1HSyuzcIBIlR3GPkHZgvVuBRjhC/pW66WvzEoCgsmN4FgOlKlpN1A3MKbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuV48UUGLL07Rz//MN0owB9QArFy9i84KG+c4sxnVq4=;
 b=lyhuWwNHJeo3SYlziGF6k7fQ3GBF2BRkZpiLTCrZLYu/unEz5VeeGjJP6LWTW0DfMxsEFKFW7Oa7/4VIxQy93DcXcEqogf1FHAR2nCObWqzSu5yoQAM+bScHrie6OmkEUb5WIElKB6iqAk8oRMjM9MHdNXeNNdTAm7HDYSf/6We/9mbgqN/kFojhZ+55GHWlupb/o8uviz1GUTS6WKCLWg8iWfVgWUuC5+h8dA9yKn3pBIWBsbpIdJ+zLGA1tpcrlVehzU1+AaL+x1KyCX9zdarSDA6i6hKrAMA37cs+yfIo9CTLPEHv7zpWoijgH23yJRahgWUwg9QLao74gbD4PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuV48UUGLL07Rz//MN0owB9QArFy9i84KG+c4sxnVq4=;
 b=SsMXYAnTfEN+VZcbHBEGMnQNfawa4c9eNhhPjWo18qRWaOTvxaivBRWMZnxMD/GNPgBxYgoqWt6+fsyX/LonUIKgB8u9jltt8chxdJwjATxUapasfzhjHNpu5J0CfBGYlvAN8U+HX2fZzErRvWfrPPcjKcF/TXAKfeHD6okn0Ck=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR1201MB0176.namprd12.prod.outlook.com (2603:10b6:301:59::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Sun, 25 Apr
 2021 07:35:15 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4065.026; Sun, 25 Apr 2021
 07:35:15 +0000
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
Subject: [PATCH v4] x86, sched: Fix the AMD CPPC maximum perf on some specific generations
Date:   Sun, 25 Apr 2021 15:34:51 +0800
Message-Id: <20210425073451.2557394-1-ray.huang@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HK2PR0401CA0018.apcprd04.prod.outlook.com
 (2603:1096:202:2::28) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd.amd.com (58.247.170.245) by HK2PR0401CA0018.apcprd04.prod.outlook.com (2603:1096:202:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sun, 25 Apr 2021 07:35:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48fbeaa4-6323-4361-a73e-08d907bcaaeb
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0176:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0176CA4D88F154101CA910A1EC439@MWHPR1201MB0176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RHY5V1vKq3+ZYmQZeDO1hw2XVPxHpWUOtrC1RWKa2hlKIOiaFbue4IR13fOtBLPN2dBQseVJ4RGaxpmk+dRw9EVAxOtl9fLHr2uCAoJqcAYARgDTlCslybB8bdkwZ3Qe0qvmbYaDqhilHTZLzN4OPbVJsiZEegiQmmLoHF/88oy5m8wf6Gy3O9EvEIC3v4wJlYkaVmIhy/hQtY8rYmAAtpgOweg3gsj32xjR8kN1u0X98RaTN6fjugWj3FLwXyCeZJ3fky3EB+RZGGri9TkNpxOxsFbX0h2ybhWT5r4jATTl1me+s/UCN4CZaOOndvp+YSv2h/EgeuL+DRHvDkR219l7S55aXJWLjYX8sWBPWlLBU88WRcynYwNAZVFxchogUFaEu4Z/AGXTwVunBv4UA3bDNp3gYX2iXPt933gmJx7DKL6tyKUj7md92xpoRMZP+eO3avrEwc0/sIU0USyU4mLxlj9/yVTuxRTsBvehnQ484eQt6O9HjR+XrlSNy2RsKp23v7RPaDlnYttMpg+QVoJyK9cJzO+fl/7xw7JmQvVtxNg4eiK3jzl4OhXprghRV3/tDE+s07QuHaoZpvRzZHU5j1fVdhTpsKpLYa241jCsSIBKon04r6DkhN7cUuOxRom5Rvd83P7s0wojWNTPBecxn3Y3FKPsbulERRmwAHkCzZIolU5vxYaAUgcSppLh4gPJ+3YOgxuYzDSLtPwksoXoRTpHwqAEmqRC2Usr9+Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(366004)(376002)(316002)(2906002)(966005)(52116002)(7696005)(4326008)(54906003)(6666004)(186003)(38100700002)(83380400001)(2616005)(956004)(1076003)(8676002)(36756003)(5660300002)(16526019)(38350700002)(66476007)(66946007)(86362001)(478600001)(6486002)(8936002)(66556008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MU9nRkVDZnBaY2ZYV2d1NFRqN3E2NnNKSU43b1JDZmtlbkx0ckNFZHRlVldl?=
 =?utf-8?B?dFpxTjdUb2J4TSt6TEQydnZwWGlVak1heEFLQmdQUTFWQVJjQkVQMkZkcW01?=
 =?utf-8?B?cDBUNEJqMnQ3S3Z6bHFRU0RJVHNMS1lvWkVqZ0tNM09hcHJmYkZKNEIveHNr?=
 =?utf-8?B?cWZSSmxsR0hnOHEvTWViWFlDUzA5MGZpempNbGovdk8yakZYQ21nd2JlaDVj?=
 =?utf-8?B?WHpPekNCMm4zemRRODZGRW53UUM0bU5WQ2ZNMkdqS0JtR1hpOHdGcWZYSTlh?=
 =?utf-8?B?SjVqdEJrODVBSm56TUovSnlwa0RKZTh6MjBSS3JjSm13cUt0emk5aGc4WS9n?=
 =?utf-8?B?b2JXSU9kTW14WEdiUWdQSXBoenJYZ2dyTkV4YXJnVTNxQXhwYTEvb1ovRk9P?=
 =?utf-8?B?WkJiSVRka1IwZUIyM25rMGFVd0NRRjl2dFYwR1ZXQUprWE85OEphZ1RlKzVk?=
 =?utf-8?B?NFFqWkVDaTBDWDhIek9CdzdXR3dPZjYzeHkxYWVkYlhjZkF2cm1HM0RFdU1v?=
 =?utf-8?B?ZDhmZ0pXeGxHdnZsVmg2U2JaazZacU5NWmhGMXRnSmtFTG1abTVQd3RNSUpz?=
 =?utf-8?B?RHN4QnNxWEMwSkNrQnZsV05ON2lINTVwR05xUTBrTEp5SnkyRkhrSGlsODM0?=
 =?utf-8?B?MGx3NWNVenE3cFVBelE1T0tqNlZnaDhQSFZENUZ4a0VIZllrQVhjZUljQXR4?=
 =?utf-8?B?UkJtaFFYSnVmZTVISElaSS9UWWovQXM1QzBWV3FrOWc3cS82KytkcEs1RjZo?=
 =?utf-8?B?bFVUaXZUelNobkRsUS9rVk41Vm1CdnVZZXFSRWJVNzRlUER3bTBJNHdWWlYr?=
 =?utf-8?B?TVhWbEtuNWg4NkhGLzJOVk9Ya0NlZmNCSVl3ODlOdnQwRlFCbEpuRThDc1By?=
 =?utf-8?B?dVBTVGZ6bWRoKzNVcnZZWThYeUtLcDBhbzVUSW9LRytCU1lYMm5XVlVhY2xl?=
 =?utf-8?B?NmRSbytzTlVDNlRtdDN4TU1NZ01HOW5LMHc1YlVLY0ZwUTNNOHA0ZDAxSTVh?=
 =?utf-8?B?UlBxWjNacVU3RVFFQUVFTzNBTVdXUEU1VEsxY1V0eWNxQlc4T3hsVUJiQ1ND?=
 =?utf-8?B?MVVjWXlId2NrUThvNjUra1NiQ1dCaVI4OCt2eUlyQi9BYUs5UEVub3NyOEpD?=
 =?utf-8?B?UzY4c0JSZEpOdzhCU1UwUWhxZ01FUkV2S0pSWjNuU215cFJvOUVFRStlUWJN?=
 =?utf-8?B?Q2dneEg3TmQ5VzhtSVZpc1E3Mjd6L0VzNjBRdEdHTjFyZlIzSFlPK0lOazcv?=
 =?utf-8?B?bk95d25XSGlUWEJrUnJ0V1MyVDhnS3R1MXNlRjdsODc2Q0NUNEhESVBud2dN?=
 =?utf-8?B?YWczSHd6NGdEMzVtUlhrVEpGVDFiWTJ6QnMvZTA3WHVkc08zTEMvcUNPaU83?=
 =?utf-8?B?Y0hZaFdjM3hNY2RXZkpVc1hQcWRHWlBOaHNDc0pHSnVEY2dwRHhpZHBqRFdY?=
 =?utf-8?B?VTlwSElUekhNU2xQeE1mZVd5N2p4dlJDL0FvaVhhZ3FLMWpkMmN2MGkrZlha?=
 =?utf-8?B?ZzFMUmlTZjJTbHc2Z0pTQTAxLzhxL3gzR3I2SXp5Mi8ybmp1Z2s0d2xzd1pT?=
 =?utf-8?B?V1d3R3MwQTh4TlhtZDRueTUyUEdYNzgxOElXcW9mMVhtNlZmdGFad0UzYmVK?=
 =?utf-8?B?RU1XYU9BUEtmT3ZQMjBRTktKeDlxQWhRQW1TTXo5bHR5Z1RjaExsRVlmald2?=
 =?utf-8?B?NkVYZUp3R1Q0Q080TzNhMldNN3hXa3RZY1YxTVB4a0gyT3JXQ3owZmpwUGF0?=
 =?utf-8?Q?teqX2b/+X0xq6WEJ8cqmAsjgDzPLlWb5AUbdaba?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48fbeaa4-6323-4361-a73e-08d907bcaaeb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2021 07:35:15.3971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QezhHS7UKqyAfdcTz1vVvMuIz8uUgd/dKlM7TtpT4X4uz1Ex27JL0t37gKCSydYmOqzihsUMdzZJNgBhs75x3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0176
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

Changes from V2 -> V3:
- Move the update into cppc_get_perf_caps() to correct the highest perf value in
  the API.

Changes from V3 -> V4:
- Rollback to V2 implementation because acpi_cppc.c will be used by ARM as well.
  It's not good to add x86-specific calling there.
- Simplify the implementation of the functions.

---
 arch/x86/include/asm/processor.h |  2 ++
 arch/x86/kernel/cpu/amd.c        | 16 ++++++++++++++++
 arch/x86/kernel/smpboot.c        |  2 +-
 drivers/cpufreq/acpi-cpufreq.c   |  6 +++++-
 4 files changed, 24 insertions(+), 2 deletions(-)

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
index 347a956f71ca..bc3496669def 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1170,3 +1170,19 @@ void set_dr_addr_mask(unsigned long mask, int dr)
 		break;
 	}
 }
+
+u32 amd_get_highest_perf(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
+			       (c->x86_model >= 0x70 && c->x86_model < 0x80)))
+	    return 166;
+
+	if (c->x86 == 0x19 && ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
+			       (c->x86_model >= 0x40 && c->x86_model < 0x70)))
+	    return 166;
+
+	return 225;
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
index d1bbc16fba4b..7e7450453714 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -646,7 +646,11 @@ static u64 get_max_boost_ratio(unsigned int cpu)
 		return 0;
 	}
 
-	highest_perf = perf_caps.highest_perf;
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		highest_perf = amd_get_highest_perf();
+	else
+		highest_perf = perf_caps.highest_perf;
+
 	nominal_perf = perf_caps.nominal_perf;
 
 	if (!highest_perf || !nominal_perf) {
-- 
2.25.1

