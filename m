Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5960326221B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 23:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgIHVtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 17:49:00 -0400
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:25313
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbgIHVs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 17:48:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+5ejuVWZ1YwRyPNDCiwwiBGfckn9PEn+8KmEuje0wHDTeETXf3qS8MCjQo9WwtQPwScug/DiDjKp26ArDkJNdYg2QfUVAFsGINIRiynJFiDHszK0oeQ+AKLn0wJSpqJ4fm0fiT8K7sFs+KAGXrd+zOxwrrW28NibtI+Xd1l2qQQwB4y1RnP2gsxWmVwz2TD7EeMTxfWx+XqrPVleCyr9Si7dktG0uq4PSjSJEuBdc4BKAeQntZhTWHhw+hkDhcZOFIi3kvDaA0ZsR0ZH8mIVp8Le8S1mVAqVIzk7Z6vfh/OWTbvsrjRWXqFUwItfOOv+DEtYH35FmB6bpvgLYkjyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QymA0A6hFn18OmOxIqC2ul5GhRuudv6fv86ljluMhok=;
 b=ddfcy/sT+9agkB0VefJl6W4EVgM4sjUqEIPtWwZvH/T/z/62tp/1RiG7yPQrmQCNtmK54IN/Ws1DGDc6EmgMEHEBNBgnpTZXuLbiT9kUNllumn1chC05I1rAQ1lfzOq/VC6iCxNICeV+mP+JU9WSiNDQSPi312gQRU0bV4KsUOn0Kudu3tNMQMdafh92p+acKmxjsEDDdBE8NIMgnV1kTLiRyKmmQXDlvYWVt+JTbJ2fSRyBVgUat3VlqaVqUkmVE/xdl8imoZjctWzOuYOYoWjB3mU4FK6vaHPTczludOzN2s+EjuFJ3aUb2VU7N3RIIpYSqjV3KoDXvZvtQDvGFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QymA0A6hFn18OmOxIqC2ul5GhRuudv6fv86ljluMhok=;
 b=F0CY9KTzwsKL6npoo6uJrn2cPL3XGaGO+sOAcWYGctJRFkxrMF9yMAQpIenrh/zU3skfM52dqXMH11Gg+OmPzvPO91N9TOsTSZPLC+m67c4htG92XPkel0ts7tj1dgdd9JT8cHcSsCPTICGY0ieAWvMyRPXSdf1K0sAiftIZ6Ws=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN8PR12MB2881.namprd12.prod.outlook.com (2603:10b6:408:9d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 8 Sep
 2020 21:48:48 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 21:48:48 +0000
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
Subject: [PATCH v2 4/7] perf/x86/amd/ibs: Don't include randomized bits in get_ibs_op_count()
Date:   Tue,  8 Sep 2020 16:47:37 -0500
Message-Id: <20200908214740.18097-5-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908214740.18097-1-kim.phillips@amd.com>
References: <20200908214740.18097-1-kim.phillips@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR13CA0069.namprd13.prod.outlook.com
 (2603:10b6:3:117::31) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fritz.amd.com (165.204.77.11) by DM5PR13CA0069.namprd13.prod.outlook.com (2603:10b6:3:117::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.7 via Frontend Transport; Tue, 8 Sep 2020 21:48:46 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad25a55c-9c7a-4f03-537b-08d85440f78c
X-MS-TrafficTypeDiagnostic: BN8PR12MB2881:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB28813FBDD99BD38A6070DCC587290@BN8PR12MB2881.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Yt2uaTlUQemjqBUCXk6v5ga9stFooWecBULVRwZ3u7YCsDZpZVy59Gcf/iIXr55pElJDAmtLcZ6mWXVtX4YWRad2tj6W1aZtnD95kN7pPDtjf5nCdw4j7El8/w68qIuMfnG1/deTrJGs+4y6ADXwzjsJzs+YevQK2jb4Fo8wr6hK0g1rIGLvMsNx2qZofosC2hN+DLrVfhCxgJG+3OtiFGwGO5ihKUfleFbAvKTsUSYdAoZll8dY29vRreQz8fmiFEwm1DOUCmB0plH70piJ20QfFiCqK/jzbFxuyzDA7iaGcJ2zfhgTOPu4jESry7bG/fa47qlFlAXxVGIhVtMd9PZatd50HHGLUsOmKTpCfkChP/jP7JFQt21iB037cb1INbROJDe0bDrz1epINXFEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(366004)(2616005)(54906003)(110136005)(4326008)(6666004)(36756003)(8676002)(1076003)(966005)(66946007)(66476007)(44832011)(66556008)(6486002)(86362001)(7696005)(52116002)(83380400001)(956004)(316002)(186003)(7416002)(478600001)(26005)(8936002)(2906002)(16526019)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: n77t1MM0o18mjARulMECDc02dY+nvPXqBVPEUZ6+iUKxTsCZHowISn/lx2Vvd0tQgLWFWCKwZfiQc7Uxoas2OTI6dRDuoF8PuMXEYho6RKF9A0Fy9CbKbZc/lT5gTuJkFioo2QrcjNqfc8rCGCuabtm7LXPYmrV5fWZhWJ1ydjHmOJ2U+vggKLNRzbYS32RX06Sl0//q7tweevj9b//fdzf0wTmQFOPt9OeYKwm/3beZYDzsdLcVZGwZuTtgdQrZzhzpBsThzL/tgxKX7H9cz9/8gSH9Wo/jvN44qBQb453cYmWpXPoPCtmuRMLU6CpfJhCvyILk5W8lV7iIy6MzAocTKKUcs1g7jB7+yQu/NryMmMbDAX8ycqG4KlCeHlmpQymS4Us3/jYxlAKBum8R//3pQDDx3ROFtBdmjVd49SUHgRjIHYOgptK8Ym9Kb+2V9nD0PlydNwdA19IevC034Uo7VXc788V+UqbNsqGnbl5TqnBcM98W7GLO8dIjL+0OvmuAlKiG4zUQ9BftVuwqz2TKqc9SYtMsKmj848abwd9TPQj8NVBzT4a1cP4tyXYdjOeZEd9cxGwdrPiTobIJ7f4HUZ0LALvbLNOB1cfTS+VxRzP4JJOx3u9VfO7Pp04eaE3dO6tog5BjimHNB9YmkQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad25a55c-9c7a-4f03-537b-08d85440f78c
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 21:48:48.2752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxLL7NNHF7jBWrom3NBGOm4Vr3AEpj2ndthPCFtbMKKURQaFXJ5+Fz1um+ogKURFgT6ukPVzmwR/sWkjy4VbaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2881
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

get_ibs_op_count() adds hardware's current count (IbsOpCurCnt) bits
to its count regardless of hardware's valid status.

According to the PPR for AMD Family 17h Model 31h B0 55803 Rev 0.54,
if the counter rolls over, valid status is set, and the lower 7 bits
of IbsOpCurCnt are randomized by hardware.

Don't include those bits in the driver's event count.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Fixes: 8b1e13638d46 ("perf/x86-ibs: Fix usage of IBS op current count")
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

 arch/x86/events/amd/ibs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 3eb9a55e998c..68776cc291a6 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -334,11 +334,15 @@ static u64 get_ibs_op_count(u64 config)
 {
 	u64 count = 0;
 
+	/*
+	 * If the internal 27-bit counter rolled over, the count is MaxCnt
+	 * and the lower 7 bits of CurCnt are randomized.
+	 * Otherwise CurCnt has the full 27-bit current counter value.
+	 */
 	if (config & IBS_OP_VAL)
-		count += (config & IBS_OP_MAX_CNT) << 4; /* cnt rolled over */
-
-	if (ibs_caps & IBS_CAPS_RDWROPCNT)
-		count += (config & IBS_OP_CUR_CNT) >> 32;
+		count = (config & IBS_OP_MAX_CNT) << 4;
+	else if (ibs_caps & IBS_CAPS_RDWROPCNT)
+		count = (config & IBS_OP_CUR_CNT) >> 32;
 
 	return count;
 }
-- 
2.27.0

