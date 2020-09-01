Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D1C25A12E
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 00:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgIAWKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 18:10:07 -0400
Received: from mail-dm6nam12on2058.outbound.protection.outlook.com ([40.107.243.58]:27794
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726352AbgIAWKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 18:10:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjIyF6RF9/Yhig1i/0JZo6rSSwKH2gPQ68qj7pJ6qbXEiUmFNGpjZ5hvOfc24zjI+o50iZSz8bHF/ukdwY53S0z+pylJF4XotWnOwT89SmO50VHYwpHVRuRVuYp4bxjR88kMYF0mwwUbVe5ASQf6ltuauQshKYg8kMl3r2aHGwAriT+P88KNxzGWX/L/K7zykwpt/HR4Xfgfho9w8p+zTEz4MIiN/ttxx3Q5m7qz0r+4todDBrLeiZLOUoNDATCCaWm80Gv57kscBkTTt5U6oH5KBQx//7ype5cPU8RHPyZnuP8uR3cq/MflyvsHJuMmYYmHqL0Q5qoclVpvJ/B0bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MJLkk/7llZ9T5JWMFMdrD5NRzEziS/BGcyBXM7AWEM=;
 b=d2og5DQYLjRqIwRF/C6l9WmIFYofhBhcIayPEsa44VhQA98LoOhnrKcMlaZZVnX418aKySDx+hu1cfTya+p5xB1PDJa+ZKhR5dvv/HyWqZl8BeASBHowYt750cknagMe1pStJ5oSU6fB+Yol1FFdDk7Vu+PwwydE77alenD+dj5heLUoygxX51LgyGp0gJ2mpRlN/7lJ0+S3cyD1VvUOJ/DZNitcbCZPRMUIaes+9MYuLBf4fW+3GU7vLgcRKwHDmRXiMBRdQG7vJ/a1c6g0wKU9Zt+PBI0WYkfiafIuSFblWgOFYmliQK+Jfayw2upmQTGK7vmztLin64TKc1mvlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MJLkk/7llZ9T5JWMFMdrD5NRzEziS/BGcyBXM7AWEM=;
 b=otkk5rNDKYuHU/SlQSc7KOGUnV88OckpAIByTafDfdvLudo5Vq5REpxhoCmoAfiiSaYxFQREXBzynejOmjp+0u3QQW8PvQWR4bGPXA+aR2+1rMY0+zLwMek0kSKcMxRRPLmPdXh//REYfP3cMzeDtstu3UZKVGd9D0fcHfFrRQk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN8PR12MB3169.namprd12.prod.outlook.com (2603:10b6:408:69::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 1 Sep
 2020 22:10:00 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6%6]) with mapi id 15.20.3326.025; Tue, 1 Sep 2020
 22:10:00 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Arnaldo Carvalho de Melo <acme@redhat.com>, kim.phillips@amd.com
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vijay Thakkar <vijaythakkar@me.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Yunfeng Ye <yeyunfeng@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
        Borislav Petkov <bp@suse.de>, Jon Grimm <jon.grimm@amd.com>,
        Martin Jambor <mjambor@suse.cz>,
        Michael Petlan <mpetlan@redhat.com>,
        William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/4] perf vendor events amd: Add L2 Prefetch events for zen1
Date:   Tue,  1 Sep 2020 17:09:41 -0500
Message-Id: <20200901220944.277505-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:4:4b::22) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 1 Sep 2020 22:09:57 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0b8635e4-cb26-4a64-a95b-08d84ec3c4fe
X-MS-TrafficTypeDiagnostic: BN8PR12MB3169:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB31692FDF394EEF38E4CCCCD3872E0@BN8PR12MB3169.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxuTo6+zPDcwLKdP9/HQHBCnhZS6icinEVdYJ5DKUOTvG3Fo9hHMtc44BOk+iVna2y2pBiDaZSud04RCXN0HSEUc/iuzNS7i82pgxuWN1OPNixCD6J+Tlm+RHUQPCHMQs3ztSZv03jx2WvWvLKsW+AwV02tQvw5F5X7u0sO1pRe7BlvKfFG+H3v1/fQ5+Wrzldxog2JjUNrBS5a84tX6GBh6kPwrVAY85ky8pF9TT/9hfk6w3ie0uWdGjzrz22ODFbdg1sjbjGzL94Q5/kzvkX5qd1mC4aEIVvdN4tTua5AMkkeWYPzjtgCR+DUf9Xp9jLpGLWTLSfGciDpcbj8a1OWjD8Bvpc1VSUyVqsjmSlbSfbonMd2DCOvEf5GnMiFKEGCrx6VWHTvWk0jHyN1TzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(346002)(39860400002)(956004)(5660300002)(8676002)(26005)(54906003)(83380400001)(66476007)(44832011)(66556008)(4326008)(52116002)(36756003)(86362001)(8936002)(6486002)(316002)(16576012)(186003)(7416002)(966005)(2906002)(2616005)(6666004)(478600001)(66946007)(1076003)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ya9zfJdCXbSDQr6Doz2wjJptaAcqCDZRgHze4aS42QIPSU4bIe714XWDPV7Vo/Ppj0pZwSi+nEvZYG5aJBshNFu4hRHaMEnttFZ/GBlKHXFAQldNC7gZi6EXIZ4TZha/zRUT/voF8PXw+ep4ryjcQcpgofEGsig++t7r4RB13fYtGLNWpOD0bO8AS6Cv70yB6m8plI/YAohMaU2MA2y2c4kwHU4/QW1MFUaHjSd+BVH8rT9mTqBJXHOQABcz9E9s2knn8Mjzclv3jTruqeZKoT1RLLhFKbDdSZ1ssUx9s2VNGMc3Oj6THe+EjWGSoIv7t6D/NVe1fDe2uhmZj5A6hfO1SwsEnvkcdlBOVKOS4LXZuVizqwM7kHqfqUKiS2psBxXDBr9hkJrMk4RRjtp8YpR087Gv70Q2OszEZCT6qNvBv0N3gBOCwXsWqPOI3+XWWmEllqEX2SKI42FOH+FTWIFjYeff+oPpkkKnCr1BRVh2Xfw0tLRdz3V3JNlp6ATKWfkg/rDEyDAJ48nEifgWHj1j9/QUew7C+32uSWTuAqqXxSVhwinjsPjd6BSrYXsiDu7CU+613rc5apmWJiWcbP/zSMBnw70qEotlDUaOCVs8IM+OO9eQgl1SbrPANW5H6k1L1cMll4sPTBeHLNIgsA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8635e4-cb26-4a64-a95b-08d84ec3c4fe
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2020 22:10:00.5077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LJAX90YRG1A9x8msBlZ8RBaEw9k5dvdATK1IJEkxIXXlYUuCXjdHQH4k40dpwpui0TF2rTsvs0P3c5DNN2Brg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3169
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Later revisions of PPRs that post-date the original Family 17h events
submission patch add these events.

Specifically, they were not in this 2017 revision of the F17h PPR:

Processor Programming Reference (PPR) for AMD Family 17h Model 01h, Revision B1 Processors Rev 1.14 - April 15, 2017

But e.g., are included in this 2019 version of the PPR:

Processor Programming Reference (PPR) for AMD Family 17h Model 18h, Revision B1 Processors Rev. 3.14 - Sep 26, 2019

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Fixes: 98c07a8f74f8 ("perf vendor events amd: perf PMU events for AMD Family 17h")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Vijay Thakkar <vijaythakkar@me.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Yunfeng Ye <yeyunfeng@huawei.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: "Martin Liška" <mliska@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jon Grimm <jon.grimm@amd.com>
Cc: Martin Jambor <mjambor@suse.cz>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 .../pmu-events/arch/x86/amdzen1/cache.json     | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json b/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
index 404d4c569c01..695ed3ffa3a6 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
@@ -249,6 +249,24 @@
     "BriefDescription": "Cycles with fill pending from L2. Total cycles spent with one or more fill requests in flight from L2.",
     "UMask": "0x1"
   },
+  {
+    "EventName": "l2_pf_hit_l2",
+    "EventCode": "0x70",
+    "BriefDescription": "L2 prefetch hit in L2.",
+    "UMask": "0xff"
+  },
+  {
+    "EventName": "l2_pf_miss_l2_hit_l3",
+    "EventCode": "0x71",
+    "BriefDescription": "L2 prefetcher hits in L3. Counts all L2 prefetches accepted by the L2 pipeline which miss the L2 cache and hit the L3.",
+    "UMask": "0xff"
+  },
+  {
+    "EventName": "l2_pf_miss_l2_l3",
+    "EventCode": "0x72",
+    "BriefDescription": "L2 prefetcher misses in L3. All L2 prefetches accepted by the L2 pipeline which miss the L2 and the L3 caches.",
+    "UMask": "0xff"
+  },
   {
     "EventName": "l3_request_g1.caching_l3_cache_accesses",
     "EventCode": "0x01",
-- 
2.27.0

