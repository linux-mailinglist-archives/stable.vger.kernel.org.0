Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B6D2479F6
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 00:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbgHQWHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 18:07:42 -0400
Received: from mail-eopbgr690087.outbound.protection.outlook.com ([40.107.69.87]:27081
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729822AbgHQWHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 18:07:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuQNlg3plPVIBP1oPdQuJc4pk6V52vw7MY289C/LJCwclqO5RUeOK8kpSptzCXYjvBEx6BEY8Wp9XtsQtI/tYhiEiIpr7LP3FlFbRPs7lbxTb6uztkyTD9whQwx1RPqgh1lO2YY3Lc+4M/rDOW/Dg8a5cLSJ4s2ob2zaV579rrBzoPspYd1qRt16fGYjTY2mI4WpFc4nKWkLsnZ7qxQxsdl7+Izk9W8DxZ6jsSAiJ5CWl6Gk9SaP7MTphI1pjVBOuZKAXVdIzl9bfpFqwcWD4ZVELN3RUQDfuetaSYC48qtRJhLAlxmCs4UzG3NVGTtYzPRcvB7TRVm4q+Ie+XdPFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnEj/O8CSdwM2zZoXD++68K0jVVhG2Uo4qgTREfzwAg=;
 b=UIsnrAW0I+1GgZQ7VESTofZRNb5k6xz5a5/tS+UwZhkXNP+zbjcSdPtqmDpI0ykzT924ieCpz5XU/sr3GKM/0ZHNzkPIy9VXiGJASJRqPf5bVOftynISs1F/DdVV4jGOUCQQmJq4n0gV64nG5dhB3ajTxl1Xv7RPMxuytncqo9Nqa29lZxlxZcVzpSYfEptGugjurg8uZ3AuYWf0hVOrnOkbv0k6E8BLb2CI426pDLFIUSCVG8vz0C5+hQ/oQaxJzASkBvzKhu+zyL1Tk5NlSUFKdE7H/36bmMi7XtWE/llj8uHuH+EtgZGJYFO+KjQeiN1UM5fcPsc67rIWmxj46w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnEj/O8CSdwM2zZoXD++68K0jVVhG2Uo4qgTREfzwAg=;
 b=dWd51KClfexS1bOiaxAq63QfHHDgeoV0sWtu/uaPld9ofpWZjqu4H7mYa8Kw560O8UdkY9CtZ0fn9ajCmK4E4GpqzeyMMyINVEHQXq/cNyv76zzX8EBFZUrAtD9JcMBqxrmu8RdhZg3r9SQxKwMx0JFfgoVhMST67dO3QPi1mGI=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN6PR12MB1652.namprd12.prod.outlook.com (2603:10b6:405:6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Mon, 17 Aug
 2020 22:07:30 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::ac22:9457:4d25:5ff0]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::ac22:9457:4d25:5ff0%5]) with mapi id 15.20.3283.024; Mon, 17 Aug 2020
 22:07:30 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Kim Phillips <kim.phillips@amd.com>
Cc:     Stephane Eranian <stephane.eranian@google.com>,
        Stephane Eranian <eranian@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 5/7] perf/x86/amd/ibs: Fix raw sample data accumulation
Date:   Mon, 17 Aug 2020 17:06:26 -0500
Message-Id: <20200817220628.7604-5-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200817220628.7604-1-kim.phillips@amd.com>
References: <20200817220628.7604-1-kim.phillips@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:806:d3::19) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (70.114.200.6) by SA0PR11CA0014.namprd11.prod.outlook.com (2603:10b6:806:d3::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20 via Frontend Transport; Mon, 17 Aug 2020 22:07:28 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [70.114.200.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ccdde95-f71d-467c-da5a-08d842f9ef0e
X-MS-TrafficTypeDiagnostic: BN6PR12MB1652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR12MB16521DEB166004C1BCDAE950875F0@BN6PR12MB1652.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LKQ1grIbGP3/BkfRnW9e+Zsc2Tz6zTironKY1wxO432BZ96F8+UYCJHuxbGg3/SNXTOLxQC1mrXjB9SntZ9lVhgC0lTK+1+1k2kUmQRwKJXSEpemw9M1pNVX9Kw1cXVdLIkeshx2oiFeRTNw/Jtsazn96DpkLnXE4KTQFqeMKCUaCc4oFlz3xmIDj2Hs75O6bbreF8vUBRijzFjHHkuNo7pkdnNku8s9UUbe14czBRT9/AN0+MzvMoY1/C+aHEoBhSW2cF1W9+SR3drF0HB1zDavPLmtBCivCJ0Vp67xBr8Yay8LRAeev+qmUQB35xluVEG1jOsmfAJ1UVodsv8PFbdg1W/MWUdtjeG0/Rcgmcd688V9224AvSIJlw256xUw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(110136005)(86362001)(6506007)(4326008)(956004)(16526019)(36756003)(44832011)(2616005)(5660300002)(186003)(83380400001)(7049001)(66946007)(7416002)(2906002)(6486002)(6512007)(8936002)(52116002)(69590400007)(66556008)(54906003)(66476007)(316002)(1076003)(478600001)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BX2xXOMkUvDvn0XTytPFdvgrP/GXwstfgCIe5pcqpvfYiqLMLled75w0hVzn+YoVW7oyUUcluz7rhOkIOE2l2rUfbKlblp0bBrM1wYDcJbxUtAP/UXa3Jp7NKotrrT4mAXc9u5/hD4c6K8qGlZr3aoUR91a6ZMTj1ZnJVZITOgfuu6lrkV5F5SGYLl6wGmGB17Z5s5BSHTwpdqLxu7stygzxuJbs7qv8WqCo4m7uIkR9r/jtrxCCYNQtXhBN9Vs+JV5iZ8R0LEtYs8uqsGJZpfvKqmqL3HxOgA4YSG0gPcvXyUqOJYf3Xe5WWRA8sicM/BSdzIT6Rcom3RRW5T4XMYWTsD1a9pKfIYixBJG5snrvWcLHFBI9tbueWik0lEP8sMEeW8HwM42hAWvZEq8PYFiFZ3n5RKconNbhZuEIvzW9zzv/JnKo7YznDavfNvdUl0nmByHq8EpeYa6DjpByNblvmUPYYtH6MpZPAHwjelQboQFtksUzq0fgM9a4hlPaf5NxrMtb8rVhVxnU7clr8u3c2JOE6QLk36OkwD3am3oUnJWpPvEz2czKKUTN3HE+OBuaugMl0eCQva8OHd8B+aU4DhOFB9Alhm5ff6JHWHVPebmqHgZ2snfZimds0cHf/Q8b6AcR7x3bID4qfoNdMA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ccdde95-f71d-467c-da5a-08d842f9ef0e
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 22:07:29.9612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BSjQAD9SpPemP6Jzzfy3gBoVnB2JsHIyRn/PKehojUf8mc9idrVRHtikDhRu7Pq0+fNdUbbgmHbLF+1sSYOc5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1652
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Neither IbsBrTarget nor OPDATA4 are populated in IBS Fetch mode.
Don't accumulate them into raw sample user data in that case.

Also, in Fetch mode, add saving the IBS Fetch Control Extended MSR.

Technically, there is an ABI change here with respect to the IBS raw
sample data format. I don't see any perf driver version information
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
 arch/x86/events/amd/ibs.c        | 26 ++++++++++++++++----------
 arch/x86/include/asm/msr-index.h |  1 +
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index ffeb24d31c3d..609ae7d165c1 100644
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

