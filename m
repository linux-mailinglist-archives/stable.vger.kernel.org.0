Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307961442E8
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 18:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgAURNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 12:13:02 -0500
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:43169
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729127AbgAURNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 12:13:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixL9CLdZHwXAT38QWn9u+WfZBq1EeaCImnr7R28klhXSLN8XVLG+qTrmMXb51WxuiFSUiWthcQEfJks4PNZat3sfDtPdLdnFStj+Y0k+hTpWXBbRdioNZzPmWNXe8sGh0tKF+3A7ugxOibgIS1x+f/UB3SY5EUa3fFPJrCzuUmjCJnOfeA5RrEP8hGn05xdLUtfq9LGds+VCC79f9e5F6uazu/pG7VrPiApDSB/6M6zWkQppmsRfEkwgsfaE4jvMLznC+ZJqW97e1/QclyMtZy62tIzn42Ue8WnYM0j9cHNz8ocuTjFb0EcORQ9oUcBMf/9CQpNyFJO0CPjvzHGTkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1hcWWXjsopH3dd6OiBrCbx8YTvgHq0ZBcaVWbi5ipI=;
 b=MTrueZQP9peGYp3r0hhp9t9cgGRMdtKmQmfMklt4OQRa/wYaha5VVUNW+pwlky+aFhTYO56uUJht+yb+N78T8g4OFBSB/Rqd29z4sn4k0Pzp4qjPqP6m7vnB5qJ37Ron6CEhYQ9LbnPiMR811EjbUW5ONje3ZKrYFb1GmptJtdZdbUDyxvIuDD8wVSsabR5p/czcZ7kCZE772S/j5On07gE1+OZvPKbhQ8Eu6lVzEtEP54spR2e6dgrDashKQTz5BeivEXVxTc5oU47Armwgu0bL2qmHXoAPIdSWpnBdUmt+uz8IzyRiBTP26zUJiGpHiUprJRsBjuGAu7QYzF+FaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1hcWWXjsopH3dd6OiBrCbx8YTvgHq0ZBcaVWbi5ipI=;
 b=2Z2ylBdFQots70XtnMovIfxoXib+87t91CFZdvw1yctdl8K4s+ArzcYb0AA9JQlf8Ppir2jTNG/aW061ei7QkUyYxscWMFfmeEex2dSJc+dh9gUf9mdy48k6qnlxajDD9I8NYkIjFbZRUIzsS9qtCs7qbqYk24Pvtp+wLWzTvGo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2703.namprd12.prod.outlook.com (52.135.106.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Tue, 21 Jan 2020 17:12:56 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc%7]) with mapi id 15.20.2644.026; Tue, 21 Jan 2020
 17:12:56 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        kim.phillips@amd.com
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Babu Moger <babu.moger@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Frank van der Linden <fllinden@amazon.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Huang Rui <ray.huang@amd.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jan Beulich <jbeulich@suse.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luwei Kang <luwei.kang@intel.com>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/2 v2] x86/cpu/amd: Enable the fixed intructions retired free counter IRPERF
Date:   Tue, 21 Jan 2020 11:12:32 -0600
Message-Id: <20200121171232.28839-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200121171232.28839-1-kim.phillips@amd.com>
References: <20200121171232.28839-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::38) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from fritz.amd.com (165.204.77.1) by DM6PR17CA0025.namprd17.prod.outlook.com (2603:10b6:5:1b3::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Tue, 21 Jan 2020 17:12:53 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a10f20cd-1577-4c5c-5f95-08d79e952846
X-MS-TrafficTypeDiagnostic: SN6PR12MB2703:|SN6PR12MB2703:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2703C559DC103FC0ACBD2FDF870D0@SN6PR12MB2703.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0289B6431E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(189003)(199004)(186003)(16526019)(8676002)(26005)(8936002)(478600001)(966005)(81166006)(6486002)(2616005)(81156014)(956004)(2906002)(1076003)(316002)(66574012)(4326008)(36756003)(44832011)(86362001)(5660300002)(7696005)(52116002)(54906003)(7416002)(110136005)(6666004)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2703;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PryH9lGOmhD38Uo3kvM0M6wgTafMoAZj2nccPTfZ5rW+bBfCtuM1ANTIrB6DMje8/aYeP9RebvQbdrdCdnVr4UKHbeDzxP0BvKAv15E/vraGFMK5PNTqnrV1BrAJNzQ3YUB6Q6fWZFW5BJ2ksg4RKjPCm+PVTF8+yrumM6Fw1UV/S0sXP3ZE/jP5MhkVXl/dB/lWiUCLxbDe/hWQn2oFJJb5iXQmdi7ozgULTURScKcMjCRg8CBGzezNufILmm1lh82qSxDdTiayWhp7zTIas4i4rF3n8ZwTDlhgGbW/O2Z86m0EBiI9rJRovWLzB8ceWzBzbZZcuMDV8O3MEOT4cYGg/wofwrpsZvezmG99VolujElB2cJJ+CUFGbF5SIhgjja2KL6HXzXoQ1nMggLhekdx9H68mvAg9UXhBxJM/ws+/tNP6ltXBwD+AEKNUIX9Z7AXnx57gjSV91rvkUf19TV0ZxKwOTRLw13n1DFEAKYa7rUDkxlbdcPAY8jaNeA9vfK4lPLHsSpIOga5KTVXvw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a10f20cd-1577-4c5c-5f95-08d79e952846
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2020 17:12:56.0740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RB1Br0Pv+wFtYAgt0qdOkIaXmsrfQvb9iLa8tbII3mzl/q6rB4kDf2X62lp+8QFh2F5LJAqba03EMQOCQ+GdTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2703
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit aaf248848db50 ("perf/x86/msr: Add AMD IRPERF (Instructions
Retired) performance counter") added support for 'perf -e msr/irperf/',
but when exercised, we always get a 0 count:

BEFORE:

$ sudo perf stat -e instructions,msr/irperf/ true

 Performance counter stats for 'true':

           624,833      instructions
                                                  #    0.00  stalled cycles per insn
                 0      msr/irperf/

It turns out it simply needs its enable bit - HWCR bit 30 - set.  This patch
does just that.

Enablement is restricted to all machines advertising IRPERF capability,
except those susceptible to an erratum that makes the IRPERF return
bad values.

That erratum occurs in Family 17h models 00-1fh [1], but not in F17h
models 20h and above [2].

AFTER (on a family 17h model 31h machine):

$ sudo perf stat -e instructions,msr/irperf/ true

 Performance counter stats for 'true':

           621,690      instructions
                                                  #    0.00  stalled cycles per insn
           622,490      msr/irperf/

[1] "Revision Guide for AMD Family 17h Models 00h-0Fh Processors",
    currently available here:

    https://www.amd.com/system/files/TechDocs/55449_Fam_17h_M_00h-0Fh_Rev_Guide.pdf

[2] "Revision Guide for AMD Family 17h Models 30h-3Fh Processors",
    currently available here:

    https://developer.amd.com/wp-content/resources/56323-PUB_0.74.pdf

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Babu Moger <babu.moger@amd.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Frank van der Linden <fllinden@amazon.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: Jan Beulich <jbeulich@suse.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luwei Kang <luwei.kang@intel.com>
Cc: Martin Liška <mliska@suse.cz>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: aaf248848db50 ("perf/x86/msr: Add AMD IRPERF (Instructions Retired) performance counter")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
v2: Based on Andi Kleen's review:

    https://lore.kernel.org/lkml/20200116040324.GI302770@tassilo.jf.intel.com/

    Add an amd_erratum_1054 and use cpu_has_bug infrastructure instead of
    open-coding the {family,model} check.

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/msr-index.h   |  2 ++
 arch/x86/kernel/cpu/amd.c          | 17 +++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index f3327cb56edf..1c1600e7476b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -404,5 +404,6 @@
 #define X86_BUG_SWAPGS			X86_BUG(21) /* CPU is affected by speculation through SWAPGS */
 #define X86_BUG_TAA			X86_BUG(22) /* CPU is affected by TSX Async Abort(TAA) */
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
+#define X86_BUG_AMD_E1054		X86_BUG(24) /* CPU is among the affected by Erratum 1054 */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ebe1685e92dd..d5e517d1c3dd 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -512,6 +512,8 @@
 #define MSR_K7_HWCR			0xc0010015
 #define MSR_K7_HWCR_SMMLOCK_BIT		0
 #define MSR_K7_HWCR_SMMLOCK		BIT_ULL(MSR_K7_HWCR_SMMLOCK_BIT)
+#define MSR_K7_HWCR_IRPERF_EN_BIT	30
+#define MSR_K7_HWCR_IRPERF_EN		BIT_ULL(MSR_K7_HWCR_IRPERF_EN_BIT)
 #define MSR_K7_FID_VID_CTL		0xc0010041
 #define MSR_K7_FID_VID_STATUS		0xc0010042
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 62c30279be77..c067234a271f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -28,6 +28,7 @@
 
 static const int amd_erratum_383[];
 static const int amd_erratum_400[];
+static const int amd_erratum_1054[];
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum);
 
 /*
@@ -701,6 +702,9 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 	if (cpu_has_amd_erratum(c, amd_erratum_400))
 		set_cpu_bug(c, X86_BUG_AMD_E400);
 
+	if (cpu_has_amd_erratum(c, amd_erratum_1054))
+		set_cpu_bug(c, X86_BUG_AMD_E1054);
+
 	early_detect_mem_encrypt(c);
 
 	/* Re-enable TopologyExtensions if switched off by BIOS */
@@ -978,6 +982,15 @@ static void init_amd(struct cpuinfo_x86 *c)
 	/* AMD CPUs don't reset SS attributes on SYSRET, Xen does. */
 	if (!cpu_has(c, X86_FEATURE_XENPV))
 		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
+
+	/*
+	 * Turn on the Instructions Retired free counter on machines not
+	 * susceptible to erratum #1054 "Instructions Retired Performance
+	 * Counter May Be Inaccurate"
+	 */
+	if (cpu_has(c, X86_FEATURE_IRPERF) &&
+	    !cpu_has_bug(c, X86_BUG_AMD_E1054))
+		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
 }
 
 #ifdef CONFIG_X86_32
@@ -1105,6 +1118,10 @@ static const int amd_erratum_400[] =
 static const int amd_erratum_383[] =
 	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
 
+/* #1054: Instructions Retired Performance Counter May Be Inaccurate */
+static const int amd_erratum_1054[] =
+	AMD_OSVW_ERRATUM(0, AMD_MODEL_RANGE(0x17, 0, 0, 0x2f, 0xf));
+
 
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 {
-- 
2.25.0

