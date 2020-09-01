Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77D625A10B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 23:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgIAV7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 17:59:16 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:46945
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728254AbgIAV7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 17:59:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dc2+Or+S9qIIBRYhJeOEGztFmXtUgt5fjRrREIUCedqWWaqZOQxKPCelBvRMeJzBrPtlHggUvbkO735vYqTy2hdKX3y2EYmKitQ9/2WrjVGixVqresat4GLHiGoSABcZpCsL1U1tlDyo8DtIND5lyC5QfTTXKzrmUaUGT2EuePuJg69u0X4YXUMac8JdiOT20yQyj0mnpC9dhZZL64U+MkRJk1Eu7qD2Ln4oU84BgIctJKTuj3ovZLCZAxQPdNfdDqw8uPqF0ECeSAvIUkEtyOeSAr353RriAFurR59jxlGcbQianWM7wtMFF6PPCsHt63UsFor7NHTB4PWdcyYxQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y94mrMNxd7KSoxoBqStR/ovsAiSZkUXbO2OGwpJ5ods=;
 b=lNLXihuCUSmuvRyAkazvqtyJ3rGfM++yoIoArC2LcdxLz5WIn7Mfgm9dB+wlF7gg/ompTbJp4BlJkcP2djUmRwFbKoCAMZGdl4OASRCnRYbMerLbsn09XajwmtVL4F5c0kTXlZr0qUE2lB9i4w4Ya0Il48pa3ZcyIMTkVvQ4koh6HB/G8YpniM6eNLIvqDzwc2E+J9etyQF6zauDN6SvppxPd8AmA18sktIusZYKPyS5zNR7SY9xUIi43wHsPS0Q274KC/MMSclOf+Ij+BXKd4pgZmUCkTzcJHw9R2wrDbBQUYeeQEyfv9DWl5pXzikJn2/RnvieXz+mp8wi2+zfIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y94mrMNxd7KSoxoBqStR/ovsAiSZkUXbO2OGwpJ5ods=;
 b=d8kwRe22VxI02R0mEXTLvny+nKrfXWTsIERjhK98RqMQS5oS5qYvzXvHi9h+ls2N2rRQhn4Cx38mEU0uyeVPDwk+UaYvTxW2P3Rl3b4ppVpMKvLOr9SON9lnJcJgmmgqp7DEeteQe3+vgee1DP1K2Z8E2HQ62x2IUoO/c7nJYYs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN6PR1201MB0019.namprd12.prod.outlook.com (2603:10b6:405:4d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Tue, 1 Sep
 2020 21:59:05 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6%6]) with mapi id 15.20.3326.025; Tue, 1 Sep 2020
 21:59:05 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Arnaldo Carvalho de Melo <acme@redhat.com>, kim.phillips@amd.com
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Tony Jones <tonyj@suse.de>, Jin Yao <yao.jin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        "Paul A. Clarke" <pc@us.ibm.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] perf record/stat: Explicitly call out event modifiers in the documentation
Date:   Tue,  1 Sep 2020 16:58:53 -0500
Message-Id: <20200901215853.276234-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0071.namprd05.prod.outlook.com
 (2603:10b6:803:41::48) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN4PR0501CA0071.namprd05.prod.outlook.com (2603:10b6:803:41::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.8 via Frontend Transport; Tue, 1 Sep 2020 21:59:03 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cae1b2fa-94db-4c40-c201-08d84ec23eb9
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0019:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0019B3557E025E30B419A0FE872E0@BN6PR1201MB0019.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fj4l9gZzxNabIAPtKAILYmSCLLMCusm0J6zokuO08FMJCuHXqA59fl6W1tDdZeLDTjjBk6vijs+CCFXKFsYV+i9VSYMM/Tf/sH/ayI4mm4HVwtgEwEcT+TKwvYUe2ewESWh7+X+WkkgNZaNOvCsU/E+CiJF71ONgqcLnK+AtL/bzCvnFYhvCaH4OrWM9ekUD6/gr9Md6wE8oSSVxvvqFORw/VAyX6354yvVWRZe6kSfna89Z02OTkFHAl7xGdVH7+tj7gMkelsDYWdXNcyngm32XEI+m0cqNI4iuyXIbWoWZucd4y9D33h16gpZ46Z61wY6jsOqr7uoB7DCLNINb5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(2616005)(66476007)(66946007)(4326008)(5660300002)(2906002)(186003)(956004)(26005)(16576012)(316002)(1076003)(8936002)(478600001)(52116002)(86362001)(66556008)(6666004)(44832011)(36756003)(8676002)(7416002)(54906003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CgCEz1ZOUa8UDWRPo3UeVWP+fa+l1FIq8czHvK137kIVq0lOiPAk7Ixjer8HNVex3Mlae1LjUh7opUGR2Ao3tD9eYw85z42+wlg9iKUhgu+QuyAkOhgBtWeaRNmPFaSmL3oPBNDMZoLuOHVUspDYiQ8PqpEvgGjY5RHOUPcnt4l08i8UHg9hS3OCSWWVUQO7c79eNhi38/dTTU2HfUOHv97MNZOUcsT8sqYovl9VcM42C2GU0Qj9CbakD464QKPHO9oEGOM2JvmZBhRCy6YHTY9JeQLIt/DUkJKjV3QoUtOi1CTHot98fsyteSxLoY4poAVhYfeW64VIZ2PvhL67sTyiw5LPshsCQ+15S7HXdWRWSEFMb3jOSLuJ5XERLM7uKIcL2yZYpF5blbmgwEawezaCY4o/tG2/nGnnuwVfSMQ5O4PWZKzSXkW1PMTD7lhyG2N/A5+6bdvj8BtlloW2u/PFVN1ldMUQs1Udbj5WiSLrRn/2mlcSXEc5eSOluILkcGEKu3hpkBTyDbtZSZ6glqBWuQAR3QAJQHfkkeWrZkrpzJckAv//6L524USpFegQkbw2yNHqxyus1XE4uJPd+ivAaKvVapUPMRv70ze+x+jUfPuRudhcrtpE4rDR+MfvzSXK2RNzskx/eqrh5c2uJg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae1b2fa-94db-4c40-c201-08d84ec23eb9
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2020 21:59:05.7617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UjJvm6SAI9sjvIKHnBr/lO1R/zl49obcvVsmDFJ7/ngWzyfW4xAwV0R8mzrbrNse+tTQ8roYVq9ECf3cAXBfDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0019
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Event modifiers are not mentioned in the perf record or perf stat
manpages.  Add them to orient new users more effectively by pointing
them to the perf list manpage for details.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Fixes: 2055fdaf8703 ("perf list: Document precise event sampling for AMD IBS")
Cc: Peter Zijlstra <peterz@infradead.org> 
Cc: Ingo Molnar <mingo@redhat.com> 
Cc: Arnaldo Carvalho de Melo <acme@kernel.org> 
Cc: Mark Rutland <mark.rutland@arm.com> 
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com> 
Cc: Jiri Olsa <jolsa@redhat.com> 
Cc: Namhyung Kim <namhyung@kernel.org> 
Cc: Adrian Hunter <adrian.hunter@intel.com> 
Cc: Stephane Eranian <eranian@google.com> 
Cc: Alexey Budankov <alexey.budankov@linux.intel.com> 
Cc: Tony Jones <tonyj@suse.de> 
Cc: Jin Yao <yao.jin@linux.intel.com> 
Cc: Ian Rogers <irogers@google.com> 
Cc: "Paul A. Clarke" <pc@us.ibm.com> 
Cc: linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 tools/perf/Documentation/perf-record.txt | 4 ++++
 tools/perf/Documentation/perf-stat.txt   | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 3f72d8e261f3..bd50cdff08a8 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -33,6 +33,10 @@ OPTIONS
         - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
 	  hexadecimal event descriptor.
 
+        - a symbolic or raw PMU event followed by an optional colon
+	  and a list of event modifiers, e.g., cpu-cycles:p.  See the
+	  linkperf:perf-list[1] man page for details on event modifiers.
+
 	- a symbolically formed PMU event like 'pmu/param1=0x3,param2/' where
 	  'param1', 'param2', etc are defined as formats for the PMU in
 	  /sys/bus/event_source/devices/<pmu>/format/*.
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index c9bfefc051fb..a4b1d11fefc8 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -39,6 +39,10 @@ report::
 	- a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
 	  hexadecimal event descriptor.
 
+        - a symbolic or raw PMU event followed by an optional colon
+	  and a list of event modifiers, e.g., cpu-cycles:p.  See the
+	  linkperf:perf-list[1] man page for details on event modifiers.
+
 	- a symbolically formed event like 'pmu/param1=0x3,param2/' where
 	  param1 and param2 are defined as formats for the PMU in
 	  /sys/bus/event_source/devices/<pmu>/format/*
-- 
2.27.0

