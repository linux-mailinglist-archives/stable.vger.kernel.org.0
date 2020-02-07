Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C52B156171
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 00:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBGXFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 18:05:06 -0500
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:6160
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727048AbgBGXFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 18:05:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+2Km6GPpNMu3BekRwCGpzbiNt3V7HUVoVp+WwlzpPPtO7wzgRG9v1gUKTRUadaNUyY66ATJffR/sVp5dXlWGiE/Y2HYWPTQnkhphnU/WJBNtXSNwIqwAljLRWgPUFjaSK0aT8ZseGsPnivgPFiA21f2eE4B40n/ujmeFsFyC+xrRpqnDKgb61IMeduELnVicw+4PeQHMi87mFrdE/37uLAiuePBlxbPjr1Flg3vyM8jyrPIoUOdGBA7fmbFOegaq5j8dNdO9w5Z6/GW9ZwJYX2IVN6w6L5ArJwqKSGNkj2TdBlllpX8NtZ61AnwHyWPQWPSKfN6I5q7lknjj9Syzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeWjg0lnQEjYm5zU6y/Cj/4HuDPQeBT7r6AJqgZAerc=;
 b=OxfMPDn/Pv3EWt3CrrrNToDMJN+p/2oFJzAHVTevouZV0ef8CtiytONS4wbmv1u0x0uYwD6weYnA+768ZA03GGw3Y6xROUcp88F1knCEF3C0DDEu2WQ9b5hbJlbmNs1G2IG4S7Mvno52L0j4O42nbnVlt5jifpUAn1Gl+XK9oSRP8ftslJii3w4vw0T9uN+7L8FHYsynHPFyzbvcz+k3IiIJkhd3COdLznf1Ba7QR8S/73sXaIrALuTHvAbxoaoYAkOllMZzdedZUmYRaAXrMujtFuJK5y1Pgtf81YLXlcS/VXJxblt3FWhm3tWPE3Giu8ojlPPfoWJz5ohldivCaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeWjg0lnQEjYm5zU6y/Cj/4HuDPQeBT7r6AJqgZAerc=;
 b=3Xccu/SQEmhU70X49Ztv/r6/FEyQrSNjQbKe2DX4/aZVxNd5rpliqzfERvIS7dyqW223lEV1++NdlAm2Z9kI2Nxg5UlWOs8EGhhecWHFg2sNSGCT73u4mC7crI2SPk/F6Ano5GXqjJpEIoKDq4Ztey4gEsI/TkiDPf8+yxyeS9A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2766.namprd12.prod.outlook.com (52.135.107.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Fri, 7 Feb 2020 23:05:00 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b%7]) with mapi id 15.20.2707.024; Fri, 7 Feb 2020
 23:05:00 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
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
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/2 v2 RESEND] x86/cpu/amd: Enable the fixed intructions retired free counter IRPERF
Date:   Fri,  7 Feb 2020 17:04:27 -0600
Message-Id: <20200207230427.26515-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200207230427.26515-1-kim.phillips@amd.com>
References: <20200207230427.26515-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:805:66::15) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from fritz.amd.com (165.204.77.1) by SN6PR08CA0002.namprd08.prod.outlook.com (2603:10b6:805:66::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Fri, 7 Feb 2020 23:04:58 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 91a98ae9-0eec-45cf-4d8c-08d7ac222826
X-MS-TrafficTypeDiagnostic: SN6PR12MB2766:|SN6PR12MB2766:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27666C7F2678EA3570C4CD1D871C0@SN6PR12MB2766.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0306EE2ED4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(199004)(189003)(16526019)(186003)(81156014)(66476007)(81166006)(26005)(7696005)(8676002)(478600001)(4326008)(1076003)(966005)(2906002)(52116002)(66946007)(7416002)(66556008)(5660300002)(6666004)(316002)(110136005)(956004)(36756003)(54906003)(44832011)(2616005)(8936002)(86362001)(66574012)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2766;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iuw3YGdSxq+BIZjXIzjmrM1ZgsxBQoAPYh5jQ20aM5lurqIcz0XJEW0Gsp4ZQ/vvoQfsrS3roE0S/yyUd9voxFE5Ef0BPH5SlJYGwGyoePxTVPUUc/fpCFzCpe203y0wju0ArK4pATjnjUw8jFyqULtJVdo3qGficCItFOB4Chx+2wzP5zr1yLt+qtbhkX4PeFM+WPQwTxNeQhb+e2k05nVkSm/IvhLoH1SMWUPREK6LvgloB+lm4fSaEkoD++iqb5H4TCJ/sVu6Jws+7Fpu71BMJP6YjCHE8VrjHUWOkZVuHM4T74R4D665frMWolV+M65aBQWfTTWKQBl15LtLmap9Rdf58wLvyTrFYSzCC8VN/zFgszy0kTdoQLUFNHR0I865YOeQ2DoO1EuCAUe84IohpvR41iwvQlGInNipG8cr4mnkGEyL/23/AV39gU1AnqicZaO050Y4cbYM5zjaEXsEJbmjzXiBqP+neYXXWkxXUC7scGi9Bbl8lMD8ozxak5By5qcpU8NbFB4TfG0TtQ==
X-MS-Exchange-AntiSpam-MessageData: C7CqDADjdx2Ttc7+kc5sgliwza2LiJyorCWVBNRkIZUYEcGmKMgYehX5IHGa4IWckCQJHs+siD/FsAZW24q6jhk4XlWhVgR50i+F1yhWAll+CgiNQMH1vXuf8xW7uXJCHFhSXI68caiMAC/IVCdjeQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a98ae9-0eec-45cf-4d8c-08d7ac222826
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2020 23:05:00.1417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 762vCZ2/h/qRQ9X9v5vaXAWDTwgzVVFn4A24B88yPJbjG29k3Lzwrqzsfrt3bn1lzdCPXz91BykjV3vgJrjccA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2766
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
Cc: Michael Petlan <mpetlan@redhat.com>
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
RESEND, adding Michael Petlan to cc. Original v2:

https://lore.kernel.org/lkml/20200121171232.28839-2-kim.phillips@amd.com/

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

