Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4F62479ED
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 00:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbgHQWHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 18:07:06 -0400
Received: from mail-bn8nam12on2053.outbound.protection.outlook.com ([40.107.237.53]:39554
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729490AbgHQWG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 18:06:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSsxNiV+B/B57Cr3b43AmcWC/3oTJGjlQW48HIElELbfX1qOLyeJLDT1v7DcFIdzZ3hcICqMJ6IN2EJQ1mmdYQvwR8GsHmZH6x96KyV9YvRGnUqkAGpXXEsSS5nFYAU0cR2m5I9tslvWXo2pWorxdup4Fd7vZI9rlLoW2G0aLhoriNJmXKRp6/kiuTZr3tasCX75yqA2qb/A+nS2ID3FYQ5lw7/RCs8oZX96OWs9AyXdwxVfd2UrJ34B8mPz7YSPgu/M92B20dI846cFHmMjEo5sb+6NLzJd6quPCSDUEPMB9aIQ8tiEuKPEEhrpjx6r93O4cb3ss1E3IP9w0dp6HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vz3l4IMv/eu5lQ+xaLn+lGDhiOJGJG+95W9dQEUlSqQ=;
 b=NC1yl9j4G9g3Clf/VLJ/MrErOIhk8XWjdcxbQoY69YsIwG0pntHYX3mF/rQ2p29yxX/QoW7+waSjU6Qq9NH9Ht3vVcOvmwzxsHpDinlgD6qsDgZob6+jh8/PnuXLb08sQo2UJ5pzo0TRwkVF1o+6PMTIC9H1o+xp8yCTgSjCCh1j/+DEJ82WG+V/9xIlsHaaGL4+TiutCNe/zKagqIZb9c9/hNhAic4tQdaVEGeZ6q6jAnUOt+ARorMM/hERoerdlPX+l23WJRQp5CyvfyIYv8aY3Mu87CokQJ28FD2DShovYTdIJIXtTBa10b90AHKzPMOH/crd4h2N/LNGZt+odw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vz3l4IMv/eu5lQ+xaLn+lGDhiOJGJG+95W9dQEUlSqQ=;
 b=jBMSs0AcFoD32B+23AdptXoCNqzRmklxuOIphRb5ioRkgFSPOmCbZo/pZNsLvOgjisxlfCWpZ1En63jLqGAFACG61RgVHLPbbTFp83tuFr3qKVWn9XPLZWAqAWm/VL7vLSXS2XKzDVsHt+kEIgyd0GiksDLsDYz+95JsPh/ftRw=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN8PR12MB3220.namprd12.prod.outlook.com (2603:10b6:408:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18; Mon, 17 Aug
 2020 22:06:51 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::ac22:9457:4d25:5ff0]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::ac22:9457:4d25:5ff0%5]) with mapi id 15.20.3283.024; Mon, 17 Aug 2020
 22:06:51 +0000
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
Subject: [PATCH 2/7] perf/x86/amd: Fix sampling Large Increment per Cycle events
Date:   Mon, 17 Aug 2020 17:06:23 -0500
Message-Id: <20200817220628.7604-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200817220628.7604-1-kim.phillips@amd.com>
References: <20200817220628.7604-1-kim.phillips@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0025.namprd10.prod.outlook.com
 (2603:10b6:806:a7::30) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (70.114.200.6) by SA9PR10CA0025.namprd10.prod.outlook.com (2603:10b6:806:a7::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20 via Frontend Transport; Mon, 17 Aug 2020 22:06:50 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [70.114.200.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 46a018d7-0712-45eb-cdef-08d842f9d812
X-MS-TrafficTypeDiagnostic: BN8PR12MB3220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB3220FACD9D80781B94863D62875F0@BN8PR12MB3220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0JnPjfRZSMyau1B60HhtCtpIN0GdS29YG5SphI/AWaPKdpGuyN7wuooLIX/v9xdE75GvgIM7oMawgmKjTwXPT4G+/KdraPCCoioMGTN2UrDmkaoJ/yQ7kab2uZLqhxipNEIVWhcGhyCCcT2OZlbud6IArTdSzBx0h0QP+m5fJ6pzKopVRqsK9huMPCxLV50CjwDzLBy+oaVXg7HDEl5Gr4QK0xTk41KPWP1008aLx68rM/KZ99ejvDkNcC/SLCWwL0H0PNd8xqsBcOn079OmTWISAppSkuPWVADP7i5BYyl/OghQKcgf5K6hyRO2sGB7dAyFRZgeI/YbG69+izq+PkDSf+uL1j19tK5tu/OHfWSYiSR8ZlQ6QByOooE4BxXJUuiLyWJU3jl1Yw5cDC0bJqOE7V7dHVQYosQ4oyxvm4cKzMrI3oGygkEY6V7GS+X8DbNPoG3ocTqwAFOYfe2PQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(36756003)(5660300002)(7049001)(2906002)(6506007)(83380400001)(44832011)(956004)(186003)(52116002)(69590400007)(478600001)(2616005)(16526019)(7416002)(6486002)(4326008)(966005)(6512007)(8676002)(66946007)(1076003)(6666004)(86362001)(26005)(316002)(66556008)(110136005)(8936002)(54906003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xlZpAcLhhjVSEHwm+Cmpm2G+RZm6LtZKECtSjOtMdbthXWJX1NMBXa9PZ74W7CIxczXQGTEjZ3CLhc/aeVbfxNSrmNzTT93N0qV07w0vp66np0tyJyfI1YbXpZkbzmX2hVARpOY+ZYA4jXIFd0Gg/BI2GrAHaLozg9GqHw2MaHSGAxVarYkGk1rzpckQBYH25kQgNZfDbxIj8wRGcUqv6V6Dz6FWmvsd11MkxhPJdUYurWYvpF3PV8DKO+v/bUig31fP72xJhPtEE7kCS4iXVPS2DO5lhF3Qhn+ZWtOkuxKmdTGeeMq3yKRcXmqZH1JN8cWVpc90r/g+Nplc4fkCmQ6VN6ODgVyP0u17PWLhOL6jUuhRxLIdhqdXjkUf7UURaJNzDC/l9xUoHKpUxFqFgivsXxmZj4cSCag34geDaf09TQLnaeGupSXf/gOCzf5Ze0JCGO4iNxkcwkKgBKHcNxruRRfxrZHNO2evA+noI3e6T2gSK9BE9VYij/9evmvN9RkWtww7KAKaRZeSdOjddflBC/wyG6+mCUttOAi7cqvQZBUNXr8UlKDD6xhoy0mG59CTuvwdD8c8AFzuqpfxcusDrl1eQ+wtvRPF70GtbJGDqowlfzhrYapLcCl2S5MdepYa2EKGdLxY38HK7tOjPw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46a018d7-0712-45eb-cdef-08d842f9d812
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 22:06:51.4444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vy9TcVR32nAOPpxnWF8qRWottkR+udfDqdX3RCfvrUXdjknwE7sYPWF99wA3nfuJJ9Quf+WwdJWVPOhUlOcoEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3220
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

