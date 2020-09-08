Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B8E262216
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 23:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgIHVsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 17:48:30 -0400
Received: from mail-dm6nam10on2042.outbound.protection.outlook.com ([40.107.93.42]:11413
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726434AbgIHVs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 17:48:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0+kdfpI44gSckbFRRhIyMjNIN/sDrmpqFDH93iYKuTsun+84ZEIvF93uMK2dFfqjU0Piu/HE5i8q95IrNlQPS/KyjLVH2ZfLAx3ZuA//keh+T4qc2J3G+qWbzv4hoyPqYAL3hha9x+rD/PWmDl9kOrDugJIgClEJiL8RJUC52c7rKpCdJF+1BimEtg/rRJq4dQJRvo4X1Mm+OQZ4+VbaZNmcJQTqpvZpvNWmJBwEe64AbMwq+cK1A4lugcC08636zHyh+TKqjbd3rYmiNmiTSWr6vXksqM0DmHcJqgtPIhUUSMnDF4+/78IfX3TYOc/jpP+kHpIitdNtgJYET0Jrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UMGXByaI63Zp/lQ+cKYoZZE3Ksc3eNyEMbnenRZnnA=;
 b=UDBsm6PG/3LwFBiCrP1vvpqodnWV5QdpyD/WytlP0li3uJmNBCl2HbXj0K6TTqVIXEq05nWqTVmdMCGLVh+Vl2Fb92Y5nyhoDY2SDWfEm57Dxigi7sIcxavJiMmMV/sb2+JVpWVAlYoytbkceMqSe0fS1guGLz4qG/HKGm4zeLWJuJqFl+KJs51zMH5EcbYiLCNLSkVpnVambbnh0Ilq8I5HsN+0jsZqb31SdS679EmMuSAFhPVYDtXD4WrfXel0vrGFJ7qb5ZZXfYMmIebyBPmOM2SQWD5JqVd85e/TFngoapgHGHMIDjBP6L5wiZmXYu3YORLHG4g4zaRI5S2N9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UMGXByaI63Zp/lQ+cKYoZZE3Ksc3eNyEMbnenRZnnA=;
 b=xGl+aYKbCcV+C1p08KkB8E50+rFA6sdkJTBExj7IXPXLG0nOv7TxkWgRJVw+mOrKOiUGHHg3m2nHusAddPlw8xjE7SXJ7w8ynPmAZTgIlIkPzMssLR0J76w1+spDjHE5ozgAkpGH/P5REqd7MuGB0fZ1WfCCst4a7wqfufK7JIE=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN8PR12MB2882.namprd12.prod.outlook.com (2603:10b6:408:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 8 Sep
 2020 21:48:20 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 21:48:20 +0000
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
Subject: [PATCH v2 2/7] perf/x86/amd: Fix sampling Large Increment per Cycle events
Date:   Tue,  8 Sep 2020 16:47:35 -0500
Message-Id: <20200908214740.18097-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908214740.18097-1-kim.phillips@amd.com>
References: <20200908214740.18097-1-kim.phillips@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR12CA0060.namprd12.prod.outlook.com
 (2603:10b6:3:103::22) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fritz.amd.com (165.204.77.11) by DM5PR12CA0060.namprd12.prod.outlook.com (2603:10b6:3:103::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 21:48:17 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7677255e-58eb-4a98-cddf-08d85440e6a4
X-MS-TrafficTypeDiagnostic: BN8PR12MB2882:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB288265690F56A9FA3485DB5087290@BN8PR12MB2882.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UHdFaXgkR1/DNQ6lqoxMgTeXXdACBhHTjnFthJKEQtDjO+oHevWSQdUw/2hcFsJ1Qbo21v2p0GoCasgkZALFMw0caFEoTcRZ31HEbZjOUBFlWnh2yjNm/+4DZRPlVG7XdTcUUNkFkRHE5LZsq3Qj8xhV9LVwm88x6vUWGj8h0+MgrYhZJwF2Li67VxfbKZXrXzK2TnGLsg0aR4pPwq1DZqbRSl6hZCGsC97f34lFRjdL/QrEwmiSLaizfae/EV0j/d9clquVD+fX8mfg5xmORwOuvUK5rtNYfoUXllyW8d99DE4ssuRMiZfheJM4WnU6aXyYQxKwYuhTz7zSpYVuAJUKEWGzFgKLSUuR0Pz1JWnmH+ny2c/J3iycW/MTc2aP4vAPcK2jytlH0IIIc/auMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(54906003)(52116002)(7696005)(4326008)(26005)(186003)(110136005)(66556008)(66476007)(66946007)(5660300002)(2906002)(1076003)(36756003)(86362001)(6666004)(966005)(316002)(16526019)(44832011)(6486002)(478600001)(2616005)(8936002)(956004)(8676002)(83380400001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8VrGMdvs6MCVt35gA8f3ZYRYfpw++B0zqGQXEfyjVywxsi5cG39ycy0G1OjSKOH+R5K+06dOpUPXqEfWkFtjSdx98F9uiBZYYaoK0FVYXNcC+1307yHjXHUfaGnbuy4jNgJ8jfebexJWI3t/zo/PIgetpo+cKOlDFQyuWCrLUbF9Jk553iHWWgDMCsBSVb8QTN1uGD6a2hbnA0/5I8oOD/vzr7PMYDm1GcLi7fQ9ayJG2k8XRLQ/tRuYBFyoK/lPnImDlSsFSVOcohdDYtE6ye0LzGbitywMcE+McY0tDvxB8iISUZIAME0Wtsiez6CcKO+gXfJGENDa6M1X89P9MZeXfWRLMX/z5yCQaCGN5UUorvfwz0OHNKPH2e+E7/bxNNQvofVOxUMrM2YJaJHRutPnSTsWZBfQEgwZjpa9ku+HbGomvv1HMNgiMlAKbaSmyq6wQeHvQFYhFWCw5TA4hvV1yxVVxjOqJN2D8a806lBkM7uTbewrlURMgJdi/6B+fjMHzwP2JBFP8NIuek+1dVxBAmvTH1h0Ox+bpkXzQM9ceXfU8uIISgeA8zYTVLierBJ6vpvRp/n7zIMIrJezSKhL1MuIG81Cjs9JOiS7rkEENvadS91zu7VKp0E6J0rc1iR2Fn9f0whp4EYf5gUHPQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7677255e-58eb-4a98-cddf-08d85440e6a4
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 21:48:19.9224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gemmEf7IpNM4ii/q1eBq72V2P6OFuxftXa56OeqIk9Xu1bk4lDcTFo1CYSN26cPbIzJsjHhG+LorIRg4cf1NMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2882
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 5738891229a2 ("perf/x86/amd: Add support for Large Increment
per Cycle Events") mistakenly zeroes the upper 16 bits of the count
in set_period().  That's fine for counting with perf stat, but not
sampling with perf record when only Large Increment events are being
sampled.  To enable sampling, we sign extend the upper 16 bits of the
merged counter pair as described in the Family 17h PPRs:

"Software wanting to preload a value to a merged counter pair writes the
high-order 16-bit value to the low-order 16 bits of the odd counter and
then writes the low-order 48-bit value to the even counter. Reading the
even counter of the merged counter pair returns the full 64-bit value."

Fixes: 5738891229a2 ("perf/x86/amd: Add support for Large Increment per Cycle Events")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
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

 arch/x86/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 1cbf57dc2ac8..2fdc211e3e56 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1284,11 +1284,11 @@ int x86_perf_event_set_period(struct perf_event *event)
 	wrmsrl(hwc->event_base, (u64)(-left) & x86_pmu.cntval_mask);
 
 	/*
-	 * Clear the Merge event counter's upper 16 bits since
+	 * Sign extend the Merge event counter's upper 16 bits since
 	 * we currently declare a 48-bit counter width
 	 */
 	if (is_counter_pair(hwc))
-		wrmsrl(x86_pmu_event_addr(idx + 1), 0);
+		wrmsrl(x86_pmu_event_addr(idx + 1), 0xffff);
 
 	/*
 	 * Due to erratum on certan cpu we need
-- 
2.27.0

