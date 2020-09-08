Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E8A262214
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 23:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgIHVsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 17:48:11 -0400
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:47904
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726434AbgIHVsJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 17:48:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYzyGyA0OKepqNf9iXGEXtO0MiLWvs2ni1oGeAfrESpda8IS5uswXQ4Tsk2C4jqoGHXZ62guk0InX59CP3uH8EC/9KfupF80thGydQEKl0g/jdbTpe42Ei6Iqmx8ECDxW3Qf8G4LuaqmZ176wfI+uL+4poGD84pesqdYYvxmL+D6n4Qx7eXyIRvCbrH0KrzvupGlqdKvYjdDK57zBPnpqdf8PkiPhWquPwJG7LWn0nY/M5vne/oQ9qQ6/PdgvzHG6pVyZS0Ay3aIXDkLWNyCH7X3w4xPSoh/4zysUXTDVxda96E93YMtSoTWYvQf0j7hTXBdAF4COwG76M50AbImjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtD6j3i3yPYvN10J9b8gvsrT4Oc+1ytHiOk7hxrOPI8=;
 b=W/aJy3fYHEJbbWqmB8A936ch5DovADvipGnoww9h9YtkuL/V7cahPWAdav52pIRCX2hZjVfyrKQ8+JbVaxpvKFEP2JiHE66OpUVdO2ELcZ9mNPZ2Uob+37Z3msVyENCG465xG8kXD61+46LxWH1BLWR+rCRZ51NcHODHKEq8fv//RjOJ+Vq7rh24w7UeKB0338UkkZX87ZwdxcpEeMfGng0/7V9xGAuZexbA+OM/P2OqSChuIberBFuT3d6tjNafCcc5EN7O6cv5ut0J2bQhukDw6Pxuaf8F5Q3sVa8kVp7mWxyZP9YmN9E4O3ckMJg+i1lpdIPEQRp2D0aJttmE3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtD6j3i3yPYvN10J9b8gvsrT4Oc+1ytHiOk7hxrOPI8=;
 b=tVF9cxPaah0SDFtt9OioO6ZxvAAXbxTdtA9u1eXAkS8/SCK3t+qkcPtNTDKKEpaGDgwN4vHYc0zwadyGWnFQR5RpN3/cQ9uUk4JATGSCHykVUXEL25Yj1yBFuCGr+S0JtZdxlRRKvkwmy4cblrNRYedYsK/y9ZQfKbyxjiacIDg=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN7PR12MB2593.namprd12.prod.outlook.com (2603:10b6:408:25::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 8 Sep
 2020 21:48:05 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 21:48:05 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kim.phillips@amd.com
Cc:     Stephane Eranian <eranian@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/7] perf/amd/uncore: Set all slices and threads to restore perf stat -a behaviour
Date:   Tue,  8 Sep 2020 16:47:34 -0500
Message-Id: <20200908214740.18097-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908214740.18097-1-kim.phillips@amd.com>
References: <20200908214740.18097-1-kim.phillips@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0018.namprd06.prod.outlook.com
 (2603:10b6:803:2f::28) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fritz.amd.com (165.204.77.11) by SN4PR0601CA0018.namprd06.prod.outlook.com (2603:10b6:803:2f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Tue, 8 Sep 2020 21:48:03 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b4758c04-e346-4f04-8eab-08d85440de3c
X-MS-TrafficTypeDiagnostic: BN7PR12MB2593:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR12MB259323F3D4765D610C29B1B987290@BN7PR12MB2593.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8DXGx59f6Q47vX2A7lq+2ztaK/FNjzbXmD0zEZhDpT+FDVSEkF7pgPLjETwG+RYuuWgKefgLdxlqc7ffJ/3u7+pbP1EDOFAYsHm6Z0U9vpm4XVBN+sSy7Negb4eCItBoNj3jS6s7Gn6uIsq0vfr0NB9rHrX90DEg62GdhYqjos064dHEHdmdPGAfuFqR+9/Na1vh36pGNlBl1z97euJa26KUrAo8vnqLsbY8AP5UGRv17u5LMxMZcaBDBfH4mcwfseioWE2gwTSfnNqnrscMhaAGDAdYd3/gvidYr/3wTNbkn2a6gk/pivkv84htHjwQ/r3Owt0ZEmqtB8XgSW2aDsZ6MzFif58V0jbUbKjuVU7km5xRtCFAxCtWiwa7tCbsjdgUkDtKZE1qGQcGKPw+RA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(7696005)(52116002)(83380400001)(6486002)(44832011)(956004)(2616005)(86362001)(7416002)(478600001)(66476007)(66556008)(66946007)(186003)(26005)(8936002)(2906002)(4326008)(16526019)(8676002)(966005)(316002)(6666004)(36756003)(5660300002)(54906003)(110136005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: B8i4oxyGizuzAjcALvdW4TiCTICCzWpMCkpxJD5l8l8wwEPg1uZb2Yhr5G0gpGWy4jB+H5azhzd56H/uWosnwUpyIBO8oNc0VpDNlGSdE+R7KqlmBeNs1dQ6fCIoCn+Jyk1lc4Q4M0CHHXjegUhaWThNN8qRmgf0/p6Ysizw6JPqCL8HkHpFnIxDvhU+KZwY+ZvdzUmUx+lW7rhm88MfkBaM022EYPFYN9FrzzCgCORQ4V6GG0t1nylWilYC2OJ7lwnxzLj/0Dky5aGXf3+Jc9X7sGnrWZnTIGvv80Hn6ICyfpAtIURFju17lyTNMKYbkSRe+Xpju6BeIBejt5jXvyjc4qAJ6bf7IOosLe33aqyIos7KfvsKm6AdMXSZEG4Vbegms73DP0f1N/SJ1fKTVNLFfeK/HKkI/3fk/B/8nGkFAvA/lZZ+20VwfVPkmtciHArfGEBlScjEbFYAQ1KWaac/T6kBcgPRLo9yDiTcsmGJlKgxw9KjeYdDorukd7Qs21HLR5LMN4Wrh0Ugu0LHYUjdm32QDJGii4j3+niLTtb04Dnu5Nd6yexJwdYG2+37byvqREvuVFMsOc44VWUM6wGoZeYwJjEYTD8YsSMM1N3JawnkVx0WvJshR62Fh4y75iXJ4gsraYJ0yPxo6KKISg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4758c04-e346-4f04-8eab-08d85440de3c
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 21:48:05.8134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRvWQN2lFx8MFQgqlrQ8NtVemvYG2614mMW+AqWSIa9I9YoDD07mrla4MFAJgAb75WhJjb3TFYH4bQ2wT8e9og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2593
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
v2: no changes.

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

