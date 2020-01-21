Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F711442E6
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 18:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgAURMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 12:12:46 -0500
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:64576
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729127AbgAURMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 12:12:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzhNxmvmeNeb8AtTH5Cpn7AaohHWwGVZLiASDOYDbZAZIohSK0fA6QajSznCnR/q4oNCoYdJwFapyyqmOwjNtMZIMqEp8B+xmD4FkSHbGsmUqvi8lAuuBtrn95n1g5+hLfuJp5AkyZEke1LHTcB1E0vVk/dU6SUuvjDjx/dtrKthbfHC7ZQhtkO5EDCUKLCk566E+la25ZL0gdHoD6M6RJfb3bjtsWvwCf1IZcqX04IdKoegstaJkHQ74MH8nKZw0wLK6HMtxL8YLtGQu8NA8epg56+ViZjv3EIRaucymrh41HTFXMjawisUNVXrIkLZJEJ2rbKpjQiQq/pHq8jcAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQ9jl3gHkbXi56OnUNwvi82DsVWIu32UcC5tbtDrXGo=;
 b=R3mVXkWobxao0ztVQ1MQnVpqCw74gVBe1EGkeOcLT9d3AoBzpR1Jf35BIuyv87xKDrYQfCypqDuq0e+v5ViWMEOtuzOX+GJQR8sFMWQB6uxFf2X9kJdOxR10uHhDnRg3Oh79I7TuZCIf1q0XLCKTHctX0BxS6loTFX3Dii8L2/3wI2c3u4SETt913erExZU0/THxDosnya7WsUxfBGq/E31DUapGnTvnI8cXbYU0BHS0C5I/11nQYbb2Ey+EZIjI76xTI9n2O2dt9RAF66whegbrClopuZjn0fN7YTjk/Ef9+yFS8uj7dhNdQt2gH46eG5ngdLH2RVRMBYOqdX6ATA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQ9jl3gHkbXi56OnUNwvi82DsVWIu32UcC5tbtDrXGo=;
 b=v5n8SDqsg/7YtBi+ExVdDEXh2o0dVqtxh06FzMs1pRPhd0wApWCponpUAryypblheyTIyQSZ8/NA9SGbba3rn5SgtGNx1ALbI1gckhWzgT2r5gT6YTLClQ6n31lW/FOVvkgKdThTSBP73BFHp9i5XZPTaiTvF8tiApN9zCXBqEU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2735.namprd12.prod.outlook.com (52.135.100.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Tue, 21 Jan 2020 17:12:42 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc%7]) with mapi id 15.20.2644.026; Tue, 21 Jan 2020
 17:12:42 +0000
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
Subject: [PATCH 1/2 v2] perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's event map
Date:   Tue, 21 Jan 2020 11:12:31 -0600
Message-Id: <20200121171232.28839-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.25.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from fritz.amd.com (165.204.77.1) by DM6PR17CA0022.namprd17.prod.outlook.com (2603:10b6:5:1b3::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Tue, 21 Jan 2020 17:12:40 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1a87a5d-007e-464a-a8ba-08d79e952047
X-MS-TrafficTypeDiagnostic: SN6PR12MB2735:|SN6PR12MB2735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27357795DA2FA75C94DFC49A870D0@SN6PR12MB2735.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0289B6431E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(189003)(199004)(54906003)(26005)(478600001)(66946007)(66556008)(36756003)(956004)(110136005)(8936002)(186003)(16526019)(66476007)(6666004)(81166006)(316002)(81156014)(86362001)(966005)(8676002)(1076003)(44832011)(4326008)(5660300002)(2616005)(52116002)(7696005)(2906002)(7416002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2735;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pm4y4RsGgWYD/9xnzLj2fkS1Zrr7/uLXMRuJ1p3glE8hIJriwzhmvinPsBnZtxL+hl3TOMLlG4F+RF319o5/2qP4qMWHI7Gym1iOU3qXNosGF7W6R5NEqQ8NDrx/wX/G70DN7ontR8KRgJatpsPifVOt1t2poV1UcBRwcsVCKB7+FhWAvxThpXmzqksyp0AWB0IDz8uq47/OsPcROUdEa/zhFtH75PboUlLGscnW26BiKOdOnV50AVQLhtlFza+R0xBd+VUnk7j+Tac/CEV+tADb+/Cg/uuUcf/Q4rS+WUeerbj3ChS6ZiNOK1tSXMwIXyUIEgp8dZ6WjhvBOmDvSCsclC+AON9hhqJV6/zG6nkHzVxNwaCVYnWJVhMgwSDBHCjIPaigcJohecohZRLSs2wp8buNr3A79UfXzu2U/Yk70FnrBpi7VUPyw+MAABryhFPsxan/yJRObArKMGWtsy9w2pdFGrJulUWVwGwWulQTlEhkyjI7tftWvt3uKQfwsGr5owDE7YVPGSgcJ2xDUw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a87a5d-007e-464a-a8ba-08d79e952047
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2020 17:12:42.6686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1nmD7zJDoqRB8TdUR56LcIhSmK973ofd1g2T0ZxXNrWAQgjFZUOP+Gj3itHzHFe0vjC67aj3tau2uJ7Tq2uQTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2735
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
v2: no changes.

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
2.25.0

