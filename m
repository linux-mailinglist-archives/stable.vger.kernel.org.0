Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220A326221D
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 23:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIHVtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 17:49:09 -0400
Received: from mail-dm6nam08on2042.outbound.protection.outlook.com ([40.107.102.42]:3041
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730136AbgIHVtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 17:49:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgIrk0GUve37BHkvCnTasv6U9U4/XcqfEuGpbzTUnAHyOq053GefZZBH11wkxR7s1AMKhmuxDmqL6Qb8NNVOToEuWBxBI68E+X1+PhjqMYHJux07zDyH1jRviViPTMj9jUjy6zwSX8c+RgVSx6HK/weyhDT2C4ETNjqpn9+i5Rk0Qw/PrGx93h6o5vK41S6NuCK2XQgsmGpqFQT0+jLNL4UUy5o8YOU7KVUlIKCYMlTlRaiYY4Ox7Dk7JWLRGQdpPm0cCyPCTkFm9k4jV1o2Sa5r5tQiLK6o4yRW+es7XZzIzxNWLVB5NrzkFoaMklJXVhT1SKsVPDo7wfFAV+s4/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wQty5KOW7ZcWvb/8JM/wQfWUXNSwh4q5Qg7UxChJ8U=;
 b=BAv1Y39XcqzgWuLTXGdeUiN9QFe7cLPxyJRxEKe61ZFvrPzGaiGUgQQ58gUdFpiLOKP06XCAqrTerHFBsyJ9U/THMr1rNLGR1Pclhg3yHcf5ErAhXTbZX2k6sfFSt3RbgHeFuss9WsPOLlNrRPCUf19jip7BI2WCC3RdK4X98SbiHP8HNzzyCEKZeK+E0kiLORqNDhRYNVTGcX/uNNs3NVWsUggR7Tr0+6DO/geHtxLhooYXu9KmnbLa1OQnl3wGXcc54ZRpN/PICcCptHihE7KIs2AZoLA0uEF85NDCYbpfAxfnXtqh4Q2ymgI2dUEBKZoZA7z9/fZBIP4SV6Obng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wQty5KOW7ZcWvb/8JM/wQfWUXNSwh4q5Qg7UxChJ8U=;
 b=bvw5sBCcv6wmlj2qT2g7fLEEYrjF3rN+D05Icv/UaSclyg4xPbDfSpLCAXTgqAnB7ppjK4ntmKImyd0+W7YAz5m4AdsMdEx9EROcwc7wEzRKrpzp/q/yz3F31okE38EwuXwRJcFKebQQbWfaGo3LsojhA+2TWsCCt/hxxrB4Jms=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN8PR12MB2882.namprd12.prod.outlook.com (2603:10b6:408:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 8 Sep
 2020 21:49:03 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 21:49:03 +0000
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
        Stephane Eranian <stephane.eranian@google.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 5/7] perf/x86/amd/ibs: Fix raw sample data accumulation
Date:   Tue,  8 Sep 2020 16:47:38 -0500
Message-Id: <20200908214740.18097-6-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908214740.18097-1-kim.phillips@amd.com>
References: <20200908214740.18097-1-kim.phillips@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR16CA0033.namprd16.prod.outlook.com
 (2603:10b6:4:15::19) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fritz.amd.com (165.204.77.11) by DM5PR16CA0033.namprd16.prod.outlook.com (2603:10b6:4:15::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 21:49:00 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d637c6b-2862-45d5-4c05-08d854410085
X-MS-TrafficTypeDiagnostic: BN8PR12MB2882:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB2882D191A6534AA7AE2CF3B387290@BN8PR12MB2882.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhSOAa+bg06MvNs0Tx7i2OHdP2USlViPa83WosRx4q43sCIhQYpzNsGaHgBlpH0vUEZlI8+/R1CHNx9cRgCSuTdpYaCXz+FN5MHEP9ovzRaqn6RgssXtN0P5R4Ym5b7ueuNHjjjnMXEipqZZf2FAqIv6NBaN3kmuwQZgdgOaYAoySqkQMyc6JuXsHdrgSYqPjTP2dyKrcAQQWZMNYmnS5g2ZgvNlJUE0SQ5DNzmvOqqvFtvjDF0Ak31Amf3uiFP7m7H86kBoAHxkEOAkvyXfe6++qCA/aHtppQU3FYo7B4M5VPScLhp2u7GCninGztoN7QyQKIqhcE99yBYB3jVwBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(54906003)(52116002)(7696005)(4326008)(26005)(186003)(110136005)(66556008)(66476007)(66946007)(5660300002)(2906002)(1076003)(36756003)(86362001)(6666004)(316002)(16526019)(44832011)(6486002)(478600001)(2616005)(8936002)(956004)(8676002)(83380400001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ynTrfuvzMaFshkT8PQu+QDqIjuuOXFduLnnZrKmzku9+mkD0QxXEyCCqaKTbImQtX4VU0cI4geoFMXhBTtTYEEu7qIygb+mfph4reavM7nLgAIoRX5oJgjoG6l9yIn8unZk33ck4SBEEoaQo8iJuS4bL1gD9CDh05GqTjGP9GWa1S4GVtqDwXstCB7iLwEWZ1o9wzbH7aKtHxQM3rTAhpu92yqgovcTVxRLIkOn5iHFNGtHZIN3Z2oNVsTZnvkDmFpm5Q1lyCsuRD9hoSdByPBB+g7VnmKHJm/R0azD1LYzWrPLGncpHePq6bCB8iv8pj+HqqCA/Mg0aqrDkPYwp303WWvLAj6cP8l6ilnAXR/ezsjCMWKO+Rj0GN8NUxaMwJ8RG1TCRJ7DUmB6NJtfrIMTh3GY9rXlNOvm/a1JQOXdGNsZKUdVcnNow9ztC4qplqHyqZWaa2x1Fvd+13rGORUgr7RQYopbcz9KkaxzCVcYN3v3Cl/69iyP+37T09fSyRPddXJvYdzSiYB1CvvWGEz4xa//dPVVmAxtdJJRqAHdiRc+qxPj3ZeySzkw6mx306sGwBJGpzMecWuPYJnQxqT3rf2CGHGGt3aOPvzjuBP35nkZ81zeK2XmD2PHsTC/ItQkEl7g6Pl8hkB+NJkCKAw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d637c6b-2862-45d5-4c05-08d854410085
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 21:49:03.3407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euIG7QxHCvh8EaxZjtjVq9CFhNxLac6FJOEZSIAc7UfqGX7/8xFAMGHyVO2xFFQCRrtquV3++KZLusPUh48L5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2882
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Neither IbsBrTarget nor OPDATA4 are populated in IBS Fetch mode.
Don't accumulate them into raw sample user data in that case.

Also, in Fetch mode, add saving the IBS Fetch Control Extended MSR.

Technically, there is an ABI change here with respect to the IBS raw
sample data format, but I don't see any perf driver version information
being included in perf.data file headers, but, existing users can detect
whether the size of the sample record has reduced by 8 bytes to
determine whether the IBS driver has this fix.

Reported-by: Stephane Eranian <stephane.eranian@google.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Fixes: 904cb3677f3a ("perf/x86/amd/ibs: Update IBS MSRs and feature definitions")
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

 arch/x86/events/amd/ibs.c        | 26 ++++++++++++++++----------
 arch/x86/include/asm/msr-index.h |  1 +
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 68776cc291a6..ace28be4cbda 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -637,18 +637,24 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 				       perf_ibs->offset_max,
 				       offset + 1);
 	} while (offset < offset_max);
+	/*
+	 * Read IbsBrTarget, IbsOpData4, and IbsExtdCtl separately
+	 * depending on their availability.
+	 * Can't add to offset_max as they are staggered
+	 */
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
-		/*
-		 * Read IbsBrTarget and IbsOpData4 separately
-		 * depending on their availability.
-		 * Can't add to offset_max as they are staggered
-		 */
-		if (ibs_caps & IBS_CAPS_BRNTRGT) {
-			rdmsrl(MSR_AMD64_IBSBRTARGET, *buf++);
-			size++;
+		if (perf_ibs == &perf_ibs_op) {
+			if (ibs_caps & IBS_CAPS_BRNTRGT) {
+				rdmsrl(MSR_AMD64_IBSBRTARGET, *buf++);
+				size++;
+			}
+			if (ibs_caps & IBS_CAPS_OPDATA4) {
+				rdmsrl(MSR_AMD64_IBSOPDATA4, *buf++);
+				size++;
+			}
 		}
-		if (ibs_caps & IBS_CAPS_OPDATA4) {
-			rdmsrl(MSR_AMD64_IBSOPDATA4, *buf++);
+		if (perf_ibs == &perf_ibs_fetch && (ibs_caps & IBS_CAPS_FETCHCTLEXTD)) {
+			rdmsrl(MSR_AMD64_ICIBSEXTDCTL, *buf++);
 			size++;
 		}
 	}
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2859ee4f39a8..b08c8a2afc0e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -464,6 +464,7 @@
 #define MSR_AMD64_IBSOP_REG_MASK	((1UL<<MSR_AMD64_IBSOP_REG_COUNT)-1)
 #define MSR_AMD64_IBSCTL		0xc001103a
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
+#define MSR_AMD64_ICIBSEXTDCTL		0xc001103c
 #define MSR_AMD64_IBSOPDATA4		0xc001103d
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
 #define MSR_AMD64_SEV			0xc0010131
-- 
2.27.0

