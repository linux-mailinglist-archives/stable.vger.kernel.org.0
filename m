Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A792479EB
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 00:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgHQWG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 18:06:57 -0400
Received: from mail-bn8nam12on2053.outbound.protection.outlook.com ([40.107.237.53]:39554
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729767AbgHQWGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 18:06:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xqr3RCA0oxv1aoHQhvkXMKqz5M+NECFcAmhmpBBibguIf1y7vaZI+Tx4WGiOzUMwksEIsCiqdJsKhl2v/7qcAz2Iy+dQ0/zKwtiAv76BEhvGJafqp0gu2joBO7wopg+4eIrKyCUJ0AOaY9jWKuh0MCHhhH6xW2mACX3RwebMMWfhdngLAPBS1GIzNzn2TlrGjrxIlVss8JegOeHJuHZkA4hzLA47sWa6yhZfUdMZTGNqLc8UkEvRX0fDJ56tN1dQrIfzhwnv+UmZcbN8DJcj3DkcX9tFq3SKElYtP20+UF5anLrS8Bk1OTIe3mevYYEzE52lQ2z/+l8ADw+FXNA3pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmO/aI1NWmHz2oh0VbSJLKm8lAQ4etfNF+EodHjWwwg=;
 b=NdXl66XDUzEr/9c5qgtYtnEoSO2TCw0D/L18+ulVVh/G1Mlk4g8KMwx0qay+Q90QzhjV7umxw1D7scVfIi7OIM0ivBvxrbuB1PdylSa/MVLZIk2FiU4AEyX1ieX5ZO30/yiO5Tr17dUlu1mVJRGAJjNM7byFQbFpCEGX2LBNmhIFbFblX7+UrXkfxFY5NoGrHy4efPZO/gw3QajTkZHmcdQHQG3AFVGTWygw+4kjqOaZQ+8qMYdqWZA+lCUmUq6r7je2QmDHZCLbshzyNsYuyuaW1u9jsmk3ZxU6ww0INV2fWp1t8VXMGAKepP2Zj0m1i4/HYhrIQ5ISZJcpVJBVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmO/aI1NWmHz2oh0VbSJLKm8lAQ4etfNF+EodHjWwwg=;
 b=O/E0mH0z/jAQB4cFVK+xxMCwAPZGn2z8zEj141nKLG1ODUhXaqqqZg8c8qBLC3JIP7YLrULw80JHU8uNJ1Vmh29CrQsVeABrXaUMppZt6uDdKRpsM+moFIs5lpAT7f+UB0Qloo4QkznflKm0QIzAIilNEWtxzQZnsfWAkHNyXao=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN8PR12MB3220.namprd12.prod.outlook.com (2603:10b6:408:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18; Mon, 17 Aug
 2020 22:06:38 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::ac22:9457:4d25:5ff0]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::ac22:9457:4d25:5ff0%5]) with mapi id 15.20.3283.024; Mon, 17 Aug 2020
 22:06:38 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Kim Phillips <kim.phillips@amd.com>
Cc:     Stephane Eranian <eranian@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/7 RESEND] perf/amd/uncore: Set all slices and threads to restore perf stat -a behaviour
Date:   Mon, 17 Aug 2020 17:06:22 -0500
Message-Id: <20200817220628.7604-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0019.namprd07.prod.outlook.com
 (2603:10b6:803:28::29) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (70.114.200.6) by SN4PR0701CA0019.namprd07.prod.outlook.com (2603:10b6:803:28::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Mon, 17 Aug 2020 22:06:37 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [70.114.200.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 27195c5c-cc53-4eec-8ed5-08d842f9d06c
X-MS-TrafficTypeDiagnostic: BN8PR12MB3220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB32202BA59D8237404B0083BF875F0@BN8PR12MB3220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CrWxjsRfOR4FzUkoC77gXrV1UuvMgkY8GdrufxaPNzFH6rhzZjL2XsXYqFvFgQqyLVv6nu2CgPqLnJbZZuqELNUw43I7ZF2jsHTD0vxcC2BGRuBteZyZTIRDYBDmoGGcbHxFZYZnEgOZ8qg8esjvgxbJcXqKgG5Id4GuPuCsjNclnIdapdG6eiahRbJ1sH5uABdzO71qNvQErKMMsCWmVlBg6/HkIfjpY4VvajGWXo22yf6hwZ8b8PyIoBliZMSYUgO0bRBLaYOxaxQHZioZNbRi33Bk6pGGgR4MfXQVns2+XWnyZx4arzRvM40HzpCZW9iDJ6Bz34e2e+TVi5WDgfk/lMQEnSzlqtsCI9LckxQejWjQLjB7dvM/mG27GR9iTKlHcQ9UWNlPZxM5B2cFuJLmHZwkLkHqP1eRaaj0H6Pw8i+S/jLHI1/1mWBVPGXHVOFtvASd+DKNOcnDOZEe8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(36756003)(5660300002)(7049001)(2906002)(6506007)(83380400001)(44832011)(956004)(186003)(52116002)(69590400007)(478600001)(2616005)(16526019)(7416002)(6486002)(4326008)(966005)(6512007)(8676002)(66946007)(1076003)(6666004)(86362001)(26005)(316002)(66556008)(110136005)(8936002)(54906003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZntcP/8HoCDwC8NfJt6yOmu3k2yN4d5ZLja6EJg1pGZCJCgqOgtk+ib0ognkO3IWB/ziowsYfSVExoSQgVOqJHZRMcQIIkUDOx+cgZIbs0pIxd6lJO+D083JjAHkIrYljyPgVZFcmy8ZY6g6rvM97LfBAghMvSLsV1yKkvKawq1B99Sn7wFfUdPOYV3QJ6BlCpLIZ1B1mgF36Myesi29qGFT8V3YpgssO2UU3r7UU+UI9K+YZhEBXfXzCd2d81hX7kdfbM57M4kWwy+3ZvJZUcCcxgA6U2DSW/nLGcttEjGRxDjHY8fCUdlH4D1vmVIYWtNC/Tt8HOqO8TitbR6BHuOC4HIjqNH9qt2u4ujRShPJ+ncmThcTeX2NJh1eHOz071iNiWW/M/tHLI9OdbkmzyOrlam61VCV/ZrMZap39lSygMYIrzzd//wtTDgAEs0dtlRdcnDKfoXkvTyqOEcYTCOkY8Hx2J9mcLasZ7DjfOgKW5fXMews8Thka8xbiE4D+ilo7y2z6xaroHQahua9UJHs1qq4lSV5k83D/vLnMVka/lROCSM5oi++jGaf+4UTL/+zrH3p0AxnR+CcbqLqTWhXzumTWQiZoz+f7OPoe3Bb4wXOHIMKaY9pBaofzoz41mF/KDvA85I2G+ZSRNTz0Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27195c5c-cc53-4eec-8ed5-08d842f9d06c
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 22:06:38.6479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50NtEo0Is1NvEm/8LrHJeQKGyLuJuZMC4Tlm/7IRquA9qI8vgaRiGHhAYxEvYeQxhSixjGLFSvl5c+1UhdQBwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3220
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 2f217d58a8a0 ("perf/x86/amd/uncore: Set the thread mask for
F17h L3 PMCs") inadvertently changed the uncore driver's behaviour
wrt perf tool invocations with or without a CPU list, specified with
-C / --cpu=.

Change the behaviour of the driver to assume the former all-cpu (-a)
case, which is the more commonly desired default.  This fixes
'-a -A' invocations without explicit cpu lists (-C) to not count
L3 events only on behalf of the first thread of the first core
in the L3 domain.

BEFORE:

Activity performed by the first thread of the last core (CPU#43) in
CPU#40's L3 domain is not reported by CPU#40:

sudo perf stat -a -A -e l3_request_g1.caching_l3_cache_accesses taskset -c 43 perf bench mem memcpy -s 32mb -l 100 -f default
...
CPU36                 21,835      l3_request_g1.caching_l3_cache_accesses
CPU40                 87,066      l3_request_g1.caching_l3_cache_accesses
CPU44                 17,360      l3_request_g1.caching_l3_cache_accesses
...

AFTER:

The L3 domain activity is now reported by CPU#40:

sudo perf stat -a -A -e l3_request_g1.caching_l3_cache_accesses taskset -c 43 perf bench mem memcpy -s 32mb -l 100 -f default
...
CPU36                354,891      l3_request_g1.caching_l3_cache_accesses
CPU40              1,780,870      l3_request_g1.caching_l3_cache_accesses
CPU44                315,062      l3_request_g1.caching_l3_cache_accesses
...

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Fixes: 2f217d58a8a0 ("perf/x86/amd/uncore: Set the thread mask for F17h L3 PMCs")
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: x86 <x86@kernel.org>
Cc: stable@vger.kernel.org
---
Original submission:

https://lore.kernel.org/lkml/20200323233159.19601-1-kim.phillips@amd.com/

 arch/x86/events/amd/uncore.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 76400c052b0e..e7e61c8b56bd 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -181,28 +181,16 @@ static void amd_uncore_del(struct perf_event *event, int flags)
 }
 
 /*
- * Convert logical CPU number to L3 PMC Config ThreadMask format
+ * Return a full thread and slice mask until per-CPU is
+ * properly supported.
  */
-static u64 l3_thread_slice_mask(int cpu)
+static u64 l3_thread_slice_mask(void)
 {
-	u64 thread_mask, core = topology_core_id(cpu);
-	unsigned int shift, thread = 0;
+	if (boot_cpu_data.x86 <= 0x18)
+		return AMD64_L3_SLICE_MASK | AMD64_L3_THREAD_MASK;
 
-	if (topology_smt_supported() && !topology_is_primary_thread(cpu))
-		thread = 1;
-
-	if (boot_cpu_data.x86 <= 0x18) {
-		shift = AMD64_L3_THREAD_SHIFT + 2 * (core % 4) + thread;
-		thread_mask = BIT_ULL(shift);
-
-		return AMD64_L3_SLICE_MASK | thread_mask;
-	}
-
-	core = (core << AMD64_L3_COREID_SHIFT) & AMD64_L3_COREID_MASK;
-	shift = AMD64_L3_THREAD_SHIFT + thread;
-	thread_mask = BIT_ULL(shift);
-
-	return AMD64_L3_EN_ALL_SLICES | core | thread_mask;
+	return AMD64_L3_EN_ALL_SLICES | AMD64_L3_EN_ALL_CORES |
+	       AMD64_L3_F19H_THREAD_MASK;
 }
 
 static int amd_uncore_event_init(struct perf_event *event)
@@ -232,7 +220,7 @@ static int amd_uncore_event_init(struct perf_event *event)
 	 * For other events, the two fields do not affect the count.
 	 */
 	if (l3_mask && is_llc_event(event))
-		hwc->config |= l3_thread_slice_mask(event->cpu);
+		hwc->config |= l3_thread_slice_mask();
 
 	uncore = event_to_amd_uncore(event);
 	if (!uncore)
-- 
2.27.0

