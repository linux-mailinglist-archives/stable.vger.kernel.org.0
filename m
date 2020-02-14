Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE52B15F796
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgBNUSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:18:21 -0500
Received: from mail-bn8nam12on2049.outbound.protection.outlook.com ([40.107.237.49]:6231
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725932AbgBNUSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 15:18:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdlPXZoCRQshof855KrAbRdXOe0BBjcT1UlYikT2QkESuzJ2wnZx6RZOS3zWHCf73YcVUpCjG9ebEuxSjSo1D+j/HDmE6orijsSd5U1IVbc1XksJmIsb/kf3xUBvYfGbbmv+w4PFoUX6Rb/q6BC41w6SGCrYFiYMM5YH2GivB3SAIx5PbzjGmKHrcZJ6za8EP9tsJgipHceFcmLj0Ug/BxsRdQRzhyQeB9cFDjVHCYi88SQzKfLDHViwKXPO+bhxUokniNj/ZJWtfDXOsyisVKyeWz3KsTT3W8/tR0aEj5dv0mj9pJ0Wq++78hRSd5IQKn2Eb78GPA8BMQJUZPrFmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AN0DV+/ZLZD5ghIpF4dnqKP4KWABZo7JdPDV5vZtQFk=;
 b=YDgd5WdwyTeeWNKpKx4Rz7j9VVkF0Up3LFehsEmK7oO4EPlw7JdNadgtdELk93po2bFntALQDVwzQ9HHVq0waAcPRDP3I3XpxACcpQBauFQ+O8NyeADyOMuOhu8Sfe/EdVqx90rJKq1iEQiWvdRTcP51VsqXDH9GNN9Mk3zQrqZG7G8b+GrsJbGOG8HRfteM7Qug33XxCfVzBNAW3myU/RuIcS11HuIoa5FEN81Ja9q9W3WWflQKA2XV3AFHBlneaAmcNkcaQ1U39LOda4TBEuAUkx2M6DTcpmuYeIiyn6YT64v8OnfT2m/WTEOEaWVcfAG2AT9WdfZH9Zf4rCjbAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AN0DV+/ZLZD5ghIpF4dnqKP4KWABZo7JdPDV5vZtQFk=;
 b=jDGp5etZfl0NIzfScDTOXk35kYho/EBduSE8rvg4Jlo/HZn9Is1nSiUAng0G9JZ+sUYNz54t+r1hwLWOeL8XAdKkhhHOGGszmWrORseGy+0Gky1AzMY1We3LVIftM7MGPRAEzUwXjZAoAukmOuuM64NGij3VbFfM2ku6ZqOJU0M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2688.namprd12.prod.outlook.com (52.135.103.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.24; Fri, 14 Feb 2020 20:18:14 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 20:18:14 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, kim.phillips@amd.com
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Babu Moger <babu.moger@amd.com>,
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
Subject: [PATCH v3] x86/cpu/amd: Enable the fixed Instructions Retired counter IRPERF
Date:   Fri, 14 Feb 2020 14:18:05 -0600
Message-Id: <20200214201805.13830-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.25.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:805:66::26) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from fritz.amd.com (165.204.77.1) by SN6PR08CA0013.namprd08.prod.outlook.com (2603:10b6:805:66::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Fri, 14 Feb 2020 20:18:13 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 33a1e85d-db57-4772-bc61-08d7b18b052d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:|SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26888DAB863AA6CEA9CFAA2687150@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 03137AC81E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(199004)(189003)(2906002)(66476007)(86362001)(52116002)(6486002)(478600001)(1076003)(36756003)(66574012)(7696005)(7416002)(6666004)(81156014)(81166006)(186003)(316002)(2616005)(956004)(5660300002)(8676002)(966005)(44832011)(66946007)(110136005)(54906003)(8936002)(16526019)(26005)(66556008)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2688;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qk0ZrazXEaqYhaIyVZIme/cTDZKxhS523d5/Bew5q7UC8PuTJgV0MHuflap9tyZ+SqXp3yu+/9hTa0fJGKCLrmgp8O20ZcNLF25m5YNDWko9sfj6+Dpd3+8kz45Fnh9ONVKqa1hvKxUoMk7Iv886CX8lg/CqpxgF4ZrC9+F/caobpyV+tFdCXWXpQM62UtoVziH0PMi/walFIKzK8doRK+ywiegbOUnrl0zjCsSyC4f9q9nthzkIuVn3P0uPg7yRM+jojARThtRLkE/maT7Kpfv+gKNlrDC1bqtJiv++Q39o4nAagVndMrSQdrFMRgnolCBvzTR77G3hyw28LvovulkhvYWvr9kcAklreGsrCY7yMr6UCn8eKhmCbdDJoaaGsAdxA3IjCQQ9bTGBACr7h6Q8ci1f/vpZdus68NmB4cX6es+C/2TGRYkSCRXm4q9H3Ks0oOvz90wk6xF5cH3CT9JSiDkm8cyukp1tJ3xDoKe1VdOWeVqxyjVlhg8KEJRBLW+sHXJmBurRGZdPV07PxQ==
X-MS-Exchange-AntiSpam-MessageData: s4pXM8zz+4XbOXAx/AlHUOVeFfkx3QNmhr2V8jOwiRm2T8o9oT5q1tVc7h/2zdDhgGRMSZsXUqI1YN+yxdDKmuOvd6dVe0pjnYUqC2EGLoZMIPQfKAK9+P39kddJCbTzIZ5L576UEnqXCTl3kDEmpQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a1e85d-db57-4772-bc61-08d7b18b052d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 20:18:14.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jypQ9pCIyJGCPsyVDS1FQ9x6ziK7yjYapVzEnY2tg6plD5TlIIXzgzjPaPCE2/I1oIBuhMYr9rTJ6f/mvRSVhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit aaf248848db50 ("perf/x86/msr: Add AMD IRPERF (Instructions
Retired) performance counter") added support for access to the
free-running counter via 'perf -e msr/irperf/', but when exercised,
we always get a 0 count:

BEFORE:

$ sudo perf stat -e instructions,msr/irperf/ true

 Performance counter stats for 'true':

           624,833      instructions
                 0      msr/irperf/

Simply set its enable bit - HWCR bit 30 - to make it start counting.

Enablement is restricted to all machines advertising IRPERF capability,
except those susceptible to an erratum that makes the IRPERF return
bad values.

That erratum occurs in Family 17h models 00-1fh [1], but not in F17h
models 20h and above [2].

AFTER (on a family 17h model 31h machine):

$ sudo perf stat -e instructions,msr/irperf/ true

 Performance counter stats for 'true':

           621,690      instructions
           622,490      msr/irperf/

[1] Revision Guide for AMD Family 17h Models 00h-0Fh Processors
[2] Revision Guide for AMD Family 17h Models 30h-3Fh Processors

The revision guides are available from the bugzilla Link below.

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
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Fixes: aaf248848db50 ("perf/x86/msr: Add AMD IRPERF (Instructions Retired) performance counter")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
v3: Removed null stalled cycles per insn from perf example output,
    since it got fixed, also address comments from Borislav Petkov:

    https://lkml.org/lkml/2020/2/11/395

    - rephrase commit text to not say "this patch".
    - uploaded both rev. guides (and all public F17h PPRs)
      to a new "Add AMD x86 documents for future reference"
      bug, and reference that in a Link: tag.
    - rename X86_BUG_AMD_E1054 -> X86_BUG_IRPERF
    - add a full stop to a sentence in a comment

v2 got resent, adding Michael Petlan to cc. Original v2:

    https://lore.kernel.org/lkml/20200121171232.28839-2-kim.phillips@amd.com/

v2: Based on Andi Kleen's review:

    https://lore.kernel.org/lkml/20200116040324.GI302770@tassilo.jf.intel.com/

    Add an amd_erratum_1054 and use cpu_has_bug infrastructure
    instead of open-coding the {family,model} check.

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/msr-index.h   |  2 ++
 arch/x86/kernel/cpu/amd.c          | 17 +++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index f3327cb56edf..8979d6fcc79c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -404,5 +404,6 @@
 #define X86_BUG_SWAPGS			X86_BUG(21) /* CPU is affected by speculation through SWAPGS */
 #define X86_BUG_TAA			X86_BUG(22) /* CPU is affected by TSX Async Abort(TAA) */
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
+#define X86_BUG_IRPERF			X86_BUG(24) /* CPU is affected by Instructions Retired counter Erratum 1054 */
 
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
index ac83a0fef628..deebc728e2aa 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -28,6 +28,7 @@
 
 static const int amd_erratum_383[];
 static const int amd_erratum_400[];
+static const int amd_erratum_1054[];
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum);
 
 /*
@@ -694,6 +695,9 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 	if (cpu_has_amd_erratum(c, amd_erratum_400))
 		set_cpu_bug(c, X86_BUG_AMD_E400);
 
+	if (cpu_has_amd_erratum(c, amd_erratum_1054))
+		set_cpu_bug(c, X86_BUG_IRPERF);
+
 	early_detect_mem_encrypt(c);
 
 	/* Re-enable TopologyExtensions if switched off by BIOS */
@@ -972,6 +976,15 @@ static void init_amd(struct cpuinfo_x86 *c)
 	/* AMD CPUs don't reset SS attributes on SYSRET, Xen does. */
 	if (!cpu_has(c, X86_FEATURE_XENPV))
 		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
+
+	/*
+	 * Turn on the Instructions Retired free counter on machines not
+	 * susceptible to erratum #1054 "Instructions Retired Performance
+	 * Counter May Be Inaccurate".
+	 */
+	if (cpu_has(c, X86_FEATURE_IRPERF) &&
+	    !cpu_has_bug(c, X86_BUG_IRPERF))
+		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
 }
 
 #ifdef CONFIG_X86_32
@@ -1099,6 +1112,10 @@ static const int amd_erratum_400[] =
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

