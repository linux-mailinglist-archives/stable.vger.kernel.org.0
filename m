Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0211821A3
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 20:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbgCKTNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 15:13:42 -0400
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:6625
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730705AbgCKTNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 15:13:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uz+imgwfXy+lNdUBJ/eavGkZ75ePszGepQU4NKzPW4Iu5Xxb3OWR9LbZdoCu2G3FBx2t+36ACoDxDpUmblid/RrnDvwPUtKP1GtkJHEcMM07kxIYJ6sECP7D/D9lFvcbve2IbHWGUGtcQPWRskjvTuo0CRwAsjctAeaQN5g6KIUsXzeKy74Tpb3oMkfFNAG+Tf3xUOV5wbgsfNAVGPFnQ1934IB/zGgRKlJ/etINjGBLqg+HqPChSqOdLTDuPnn/+fqjZ5vQOQIJ+SPmAyd4pRM7APpQLfC57zIGkMmdtjVsBVU/+GPH1efKvYpGa5yZwtoqOpXOK1bf8r+rYM+6cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k62kN9OcmFsC9ZPnWFWWW0UlGqwjxjbjZ+WbIuWGYy4=;
 b=G8UjiyPMDAgYKZfKbUXJif7+dMglheXZSNcxTVfOdDSoxXMT373SG4BKeiC0V5CuBP/21L+/1wiHrv3Zi/yXPXr42kdVnhZC1Pd2NAOoZ1eF20lz/Y1NyRR0cdvznbNvNlRSQBPEyCmBLmNyyUlPHxPjw0VOtRXfjl8CO0d7+fr4EUc1s+SVMDRHZU9P/PyPGdfgVPib9U/vesVSsHSUFRG0OCsh+LPphTbyXBxkYC8n8pcrJ/pM6mQGk3MfE+IZcb8rj6FhK8lKvvFZqf++rMbxNLULrK3oBL31hE4wQGYCzPSFmJNtq/zdpaoyGLnxlaQlM9XBa2JOuaSJrelLtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k62kN9OcmFsC9ZPnWFWWW0UlGqwjxjbjZ+WbIuWGYy4=;
 b=eADYAC3sbWji4emN9RXzB63ykr43JTlbKI87MmdcFpZ/uYHDdjx8ABf4zyBNRmQXV36E+t33cEKB5HHYWAH9SSH9cxvJH2KvHrsgBcE80K75Lkv8lAXvFUSuOVk0kOGyPbahFNNj43wkf2/Hjj3oNQJikWPOOVyPXP6tphJBvrE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (2603:10b6:805:75::33)
 by SN6PR12MB2830.namprd12.prod.outlook.com (2603:10b6:805:e0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14; Wed, 11 Mar
 2020 19:13:38 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 19:13:38 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, kim.phillips@amd.com
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/3 RESEND] perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT flag
Date:   Wed, 11 Mar 2020 14:13:21 -0500
Message-Id: <20200311191323.13124-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:3:23::21) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fritz.amd.com (165.204.77.1) by DM5PR13CA0011.namprd13.prod.outlook.com (2603:10b6:3:23::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.7 via Frontend Transport; Wed, 11 Mar 2020 19:13:36 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad4de020-bbed-4350-6fdc-08d7c5f04d61
X-MS-TrafficTypeDiagnostic: SN6PR12MB2830:|SN6PR12MB2830:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2830A1C85E5DEDBB420DAE3587FC0@SN6PR12MB2830.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(199004)(2616005)(956004)(6486002)(6666004)(7696005)(316002)(52116002)(8936002)(36756003)(110136005)(44832011)(478600001)(54906003)(26005)(16526019)(186003)(66556008)(66946007)(2906002)(1076003)(86362001)(5660300002)(8676002)(966005)(66476007)(4326008)(81166006)(81156014)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2830;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SoUWURoxP/JVnAE5SlIfpNF8FlaAMIT/QnkIpqEK4Q/3drs/YvFtMyZ3nQy7TOhsF9Rf8IN+il3OSyYX3kwSw0GA9cNqgHdK/ozqVy6aRp8hRb8VEIsgvxKshVLt6RJ+b4E0DNERy9j9qtByRHv01ZnStGzZ3/B/ZUiS3xYYpleeWZYClLJ3AHqle+N+Wq5YS2G6+mai/Hfq6WFm9usR+IAjBN8kXPBOKbY4gk72SOpe4xLzcN8gVLeBssl2rVfcqNi8XAz2QsXyWuuPuEwiiZP6vmZRon13xKfpJPBcXBNqP8a9PuHlv0TChw8swg5JWC6shjyDvnyby5zFEHzzMSGeeoOEWKm2uIupHXWiG0q9BoeB3cebUC6ANmTBs446VdIgO1KhqqFNeE3bn1ozuBnwIVF8t+NQtNrY0aRF53F5E6figWQVS5+po6OvDdoGuRjxI0r/hoiRtomfxQI6hP33xkyMt0+Vy5vgUGB3FUihN2QXJYO1EaLl9VO2ryegyrepDFL/PeHr4v3PJ9brZA==
X-MS-Exchange-AntiSpam-MessageData: WR8ty9svt5XZkjJtg64qkSZensEogRERvV9vzUBkpTRG7Zm9skYVujc9/3GmO3ZdNOY+eyvXOZmsmUJgE5XnzYRmHvR32kNZc2IcddEpSxUWpvZgEAd6HPc0RenHGGI/qRCZFRw0ZVHJLrT3feialg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4de020-bbed-4350-6fdc-08d7c5f04d61
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 19:13:37.8707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3p9Ys8cTQjubdsKw+R0JTS05HSlS5MBclwpeGuEQlvPKHU0Vo5JLeAwYSv3rvFWXAIZ5WOn3xWvDsRZ1qzK2+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2830
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This enables the sampling check in kernel/events/core.c's
perf_event_open, which returns the more appropriate -EOPNOTSUPP.

BEFORE:

$ sudo perf record -a -e instructions,l3_request_g1.caching_l3_cache_accesses true
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (l3_request_g1.caching_l3_cache_accesses).
/bin/dmesg | grep -i perf may provide additional information.

With nothing relevant in dmesg.

AFTER:

$ sudo perf record -a -e instructions,l3_request_g1.caching_l3_cache_accesses true
Error:
l3_request_g1.caching_l3_cache_accesses: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
Fixes: c43ca5091a37 ("perf/x86/amd: Add support for AMD NB and L2I "uncore" counters")
---
RESEND.  No changes since original submission 19 Feb 2020:

https://lkml.org/lkml/2020/2/19/1194

 arch/x86/events/amd/uncore.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index a6ea07f2aa84..4d867a752f0e 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -190,15 +190,12 @@ static int amd_uncore_event_init(struct perf_event *event)
 
 	/*
 	 * NB and Last level cache counters (MSRs) are shared across all cores
-	 * that share the same NB / Last level cache. Interrupts can be directed
-	 * to a single target core, however, event counts generated by processes
-	 * running on other cores cannot be masked out. So we do not support
-	 * sampling and per-thread events.
+	 * that share the same NB / Last level cache.  On family 16h and below,
+	 * Interrupts can be directed to a single target core, however, event
+	 * counts generated by processes running on other cores cannot be masked
+	 * out. So we do not support sampling and per-thread events via
+	 * CAP_NO_INTERRUPT, and we do not enable counter overflow interrupts:
 	 */
-	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
-		return -EINVAL;
-
-	/* and we do not enable counter overflow interrupts */
 	hwc->config = event->attr.config & AMD64_RAW_EVENT_MASK_NB;
 	hwc->idx = -1;
 
@@ -306,7 +303,7 @@ static struct pmu amd_nb_pmu = {
 	.start		= amd_uncore_start,
 	.stop		= amd_uncore_stop,
 	.read		= amd_uncore_read,
-	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 static struct pmu amd_llc_pmu = {
@@ -317,7 +314,7 @@ static struct pmu amd_llc_pmu = {
 	.start		= amd_uncore_start,
 	.stop		= amd_uncore_stop,
 	.read		= amd_uncore_read,
-	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 static struct amd_uncore *amd_uncore_alloc(unsigned int cpu)
-- 
2.25.1

