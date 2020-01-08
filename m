Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FE9134B86
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgAHTfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:35:09 -0500
Received: from mail-co1nam11on2045.outbound.protection.outlook.com ([40.107.220.45]:63265
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727247AbgAHTfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 14:35:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxVXu8ty+c1kJnhvD1upBjRXzv4DkT9yqe5UwfkkcfZOvrFl2rCDrhLxnGOhrpRJ47tyXQCf3ggchcdSPqF1GBHGzNW37rOx1CvPWmIsmkl7F/ugPR8wbbPCcpqdxQhPI5ZW42DWlmmJhs9j2MwYZEC17jHyp1nkpaUyPtmfhhym1QvjI6p5XOS32I09Q1mmP8TLcvLozawj7AjKZA0sQ9pBeruIZzis4dgYQpCN82cucXtwNsoNZU4yg7tu51BcM8wCfxKXDOUFl2nOnAkxBWBm9ambL3ZEc4S8QKEqsR8AdEhdk5kLLM5hf5PdoV5HXb/ljREe+YaO9Yi4TOsxnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYWuMYQLPKd241fk1UiHymWpbCWVbL4ODb1O7A3VFrQ=;
 b=SKYWDQzx9Cym204MuThFMHR3XFWXt/0odDnziJTpPqNIZFok10Q/2W6yHwn05yJgLN8ab42wvwqXMV1M37g5l8SDjqhMwcXIjvPCrcNHbbEqmkHae7lN+cJB7nM4GKIe7J74X7zVwBDXFUzI7FomvKPzrnfpzNfMC8veTnv6yWQ50wh5Pj53lgPw2kFXRFjHo6EWMzB/wQYtldYY7rGZH81pg+fbVNkq3uKWc7Qmu9LHlmODmU8OJf3dPHSIOUb5Dm++xQItH3kqiPS298mr2yGdlOKjuyx8jxLKqzTDnMVDozcXh7DKNQMVKJPjlxsokp5zJPwrU42JnxCCSQATKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYWuMYQLPKd241fk1UiHymWpbCWVbL4ODb1O7A3VFrQ=;
 b=Yg+3+rxA2GcWhzv7YsWUi82YdhMPyNGdN6rsE8j6xK31Ddsc27Z+coscDIiBmtcexlWRycJNnxhNQOn+1AyCZvDkcuSEE7xme/v+MgcrZCC5DpSTxkF2GnALkaDhN16qazjAo1H/qUT4T2XgBEmGmta5BijkWBYzxYUGlPxFXNs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2656.namprd12.prod.outlook.com (52.135.99.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 8 Jan 2020 19:35:05 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc%7]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 19:35:04 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Kim Phillips <kim.phillips@amd.com>, stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>
Subject: [PATCH internal v2] perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's event map
Date:   Wed,  8 Jan 2020 13:34:55 -0600
Message-Id: <20200108193455.29834-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.24.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0035.namprd05.prod.outlook.com
 (2603:10b6:803:40::48) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from fritz.amd.com (165.204.77.1) by SN4PR0501CA0035.namprd05.prod.outlook.com (2603:10b6:803:40::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.7 via Frontend Transport; Wed, 8 Jan 2020 19:35:03 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 046e2fdf-964a-4f96-6ca6-08d79471dc59
X-MS-TrafficTypeDiagnostic: SN6PR12MB2656:|SN6PR12MB2656:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26569D1A44534218FA85E090873E0@SN6PR12MB2656.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(199004)(189003)(81156014)(81166006)(316002)(110136005)(6486002)(2906002)(36756003)(7416002)(8936002)(1076003)(966005)(4326008)(478600001)(8676002)(54906003)(6666004)(5660300002)(44832011)(52116002)(26005)(66556008)(66476007)(66946007)(956004)(86362001)(16526019)(2616005)(7696005)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2656;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RmH24K7cW07Vx7N7LmW0lWxLh/DshdA4svi0189+EG8F4fXitQPAwq+ftJ0s8yMkbJuUFJpG9Jkvt3pj+oiTfIBFIx6aiw0+0LfdyPJKW1zXfwhS7AkjFhb57mNgS7I+VOydx0GDVzUiFwYWWH5kdIbNpFd1zmBT0SFGeuEbLxKvERKItTiQoWfSMAavv9jXH5QXiOTS4gmZqL+eh2mm8sd+yPnUxQ9gfH5FPXkv+ApTRqEOccVXxgvPnSlcFr4ptmlnoq62SIKRP6IY25VOLCubVsUVQXGIN7TdqK0BRleKpVYRkWpPgFLCg34YC0++UVblae2pbFgbxkRQwKhTznJBjI0VRrRhSTT3W950scT+JGwoToQEnA9YfPs0+Bg11YGjVpybJY4K+gWPy6TrU5emKjV/AgolAyVadgdjP95EW37HETiA6iUDvWa7+sPxJO2QEV4+yKcdP8LUI5kquODzmkd08N4gXD1gr6xhwOw/FQsKyI5AVbxept6b8cl9aizoXbX/9QpSLfEs7LxV2w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046e2fdf-964a-4f96-6ca6-08d79471dc59
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 19:35:04.7006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5f5w/aULyQNbOaZ3hF+jc4teeU83rJOnfwcJf53urtI1Zn8T5WUiWVVhdw6KdjZ/7tMCZBukLUxabFCh0lfnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2656
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

Cc: <stable@vger.kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Liška <mliska@suse.cz>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Cc: linux-kernel@vger.kernel.org
Reported-by: Babu Moger <babu.moger@amd.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Fixes: 3fe3331bb285 ("perf/x86/amd: Add event map for AMD Family 17h")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/events/amd/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index a7752cd78b89..dede714b46e8 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -246,6 +246,7 @@ static const u64 amd_f17h_perfmon_event_map[PERF_COUNT_HW_MAX] =
 	[PERF_COUNT_HW_CPU_CYCLES]		= 0x0076,
 	[PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
 	[PERF_COUNT_HW_CACHE_REFERENCES]	= 0xff60,
+	[PERF_COUNT_HW_CACHE_MISSES]		= 0x0964,
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
 	[PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= 0x0287,
-- 
2.24.1

