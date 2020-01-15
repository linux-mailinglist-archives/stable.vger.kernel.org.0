Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38D013CE5D
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 21:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgAOU5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 15:57:01 -0500
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:13732
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbgAOU5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 15:57:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPXdiRNq90ZQ2NhRVJq76nj4Lp60NFIG0CaNtA6PAORX8c+WNMwrqDZl6+1kPgRYKDsIHlE0IY6UqFn6Tn5fxBM1BUXdAM0ZHoMlKruRZVCL+A7ebsgxB8ia7Q3Dx/N1Cp7e8PWDsIdHRt3eDSmYlILPwS4ogtwMDUZAI52v29uNJ3hE3xyXWDUMHA6WjLeBWXEOxWuz8zxO+hTmipqUv/PfnDVM8ILdyhMRT2asxZEomQr1bg/15Z6vj4H2Q2ziA70LC2qbwhYBB9fcojvFRx7ucYLiD0hpiGA8ISv+2zCvjUf8DnunnSl07wyXCP60ikkFxm5HcxThN0CpEfa73A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pH4gLbyDBq+mXreWpBp3+hZYozepLeXik/FCwinlK1M=;
 b=bE6wnG48o45UZNUpRPnv7FXQdxwBPNuDoOoDBwcqXddeDxUBifvGlFy3fVV9aTiur2BjWVgzj2tPaFMiVT9VSAH5i5+G+ZEj5IzshyrTHeJ9PxThRybtUZyY2q1IOo1WJ5bl0/js0HR6PHCVnR4lQCUGzWX6Fslgl/vswbUKkoxqrZ01/JEw/7AtaoNDoSQDehN4VjtHpBTe9ZvwyVST7CeC2qCs0vGF8CTplm5nGkj44MTPPkeyhJwNbzeoX75kieOQ2zyhqUqJr+PPLYHYWRegktPh4MgjcN0iw64EX8QLYIAzd0o0NFGda/jGupIUZPMj4annkIVWwIOd+bzm4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pH4gLbyDBq+mXreWpBp3+hZYozepLeXik/FCwinlK1M=;
 b=TXLO99myy+jjEY/6iRdXcNc7WRQiwkeYk3CyMQMZMXyGfJo5CKFJOX8VOVP+juL7s/BZnKUgnhpYye0MjctcpyG03A8TbYEpyUntuN4R3lc3xPqqtrTBhZRUXtvo8Q5+TUvyZ+7rS09ySni/arsY7b3Zy/SD6vSWmNwsbLKCKMg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2814.namprd12.prod.outlook.com (52.135.104.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 20:56:57 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc%7]) with mapi id 15.20.2644.015; Wed, 15 Jan 2020
 20:56:56 +0000
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
Subject: [PATCH 1/2 RESEND] perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's event map
Date:   Wed, 15 Jan 2020 14:56:45 -0600
Message-Id: <20200115205646.10678-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.24.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0201CA0066.namprd02.prod.outlook.com
 (2603:10b6:803:20::28) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from fritz.amd.com (165.204.77.1) by SN4PR0201CA0066.namprd02.prod.outlook.com (2603:10b6:803:20::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.13 via Frontend Transport; Wed, 15 Jan 2020 20:56:55 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f2ef0e9d-cc8f-455e-94cb-08d799fd750c
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:|SN6PR12MB2814:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2814341FA5D015F4F10B45D687370@SN6PR12MB2814.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02830F0362
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(189003)(199004)(6486002)(316002)(110136005)(966005)(86362001)(66556008)(66476007)(1076003)(66946007)(54906003)(7416002)(36756003)(6666004)(2906002)(44832011)(5660300002)(2616005)(7696005)(81166006)(16526019)(81156014)(8936002)(4326008)(8676002)(186003)(26005)(956004)(52116002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2814;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SMct4pJdxsR3uwJrocIwtWkNIjmr3eZyYfu54Yea+46T+2nfmNJfR1yl2JBVrHG0X+CmKifT6G0AYujhvXAojzezxEUZz2CDbSBRNYQQft9mSDKEhuHNZmwSTe26P2FNatGIVSyVCd7k4mPhTC2UrQxilsqGJ+jB55pDlzmWi+UbKx9Mqi8YmFDwulxC2q+pG9wTRNb+pCSaw4JyyzQH8+eADOrIzr43PnyaxfDrOIgJ72s8XuUPDPiNoiFJUbk+vcu3mLaADVQXv0CcrQ7RPPfx8B00lVoSaH8rbOmZnSJu4aTr8pSl8T4E61NUkut8Hecz1UuST7nt60VCXQggIxDlmw2bdc3FJjinMMGhrICc76TQklbraH49T5ZSCRGiLGRAQfTyrqIdqJlp5pBI3d8zT+gj0fa1bG8Ij9O/KCn1sO8RJIZQobzsaxpDlAJFyDUig/bW5GTMOVM+Hw/9+t22R1bmsqKsoHI7t1JXVtw=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ef0e9d-cc8f-455e-94cb-08d799fd750c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2020 20:56:56.8237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ih3QdNaqfB1fU90b4uazrSdxb1NP5r3dojvEAtB//jjErneJIRw4S3+7ni7ivRSA6/d0dbszKd5/wNbcrhKXyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2814
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 3fe3331bb285 ("perf/x86/amd: Add event map for AMD Family 17h"),
claimed L2 misses were unsupported, due to them not being found in its
referenced documentation, whose link has now moved [1].

That old documentation listed PMCx064 unit mask bit 3 as:

    "LsRdBlkC: LS Read Block C S L X Change to X Miss."

and bit 0 as:

    "IcFillMiss: IC Fill Miss"

We now have new public documentation [2] with improved descriptions, that
clearly indicate what events those unit mask bits represent:

Bit 3 now clearly states:

    "LsRdBlkC: Data Cache Req Miss in L2 (all types)"

and bit 0 is:

    "IcFillMiss: Instruction Cache Req Miss in L2."

So we can now add support for L2 misses in perf's genericised events as
PMCx064 with both the above unit masks.

[1] The commit's original documentation reference, "Processor Programming
    Reference (PPR) for AMD Family 17h Model 01h, Revision B1 Processors",
    originally available here:

        https://www.amd.com/system/files/TechDocs/54945_PPR_Family_17h_Models_00h-0Fh.pdf

    is now available here:

        https://developer.amd.com/wordpress/media/2017/11/54945_PPR_Family_17h_Models_00h-0Fh.pdf

[2] "Processor Programming Reference (PPR) for Family 17h Model 31h,
    Revision B0 Processors", available here:

	https://developer.amd.com/wp-content/resources/55803_0.54-PUB.pdf

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
Reported-by: Babu Moger <babu.moger@amd.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Fixes: 3fe3331bb285 ("perf/x86/amd: Add event map for AMD Family 17h")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
RESENDing because I wasn't sure if the original version of this patch would get
ignored because it was sent with "[PATCH internal v2]" in the subject line:

	https://lkml.org/lkml/2020/1/8/894

FWIW, I updated the Cc list to merge with those in patch 2/2 of this series.

 arch/x86/events/amd/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 1f22b6bbda68..39eb276d0277 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -250,6 +250,7 @@ static const u64 amd_f17h_perfmon_event_map[PERF_COUNT_HW_MAX] =
 	[PERF_COUNT_HW_CPU_CYCLES]		= 0x0076,
 	[PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
 	[PERF_COUNT_HW_CACHE_REFERENCES]	= 0xff60,
+	[PERF_COUNT_HW_CACHE_MISSES]		= 0x0964,
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
 	[PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= 0x0287,
-- 
2.24.1

