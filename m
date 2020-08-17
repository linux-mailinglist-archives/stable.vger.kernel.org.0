Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475A72479F3
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 00:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgHQWH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 18:07:27 -0400
Received: from mail-eopbgr760059.outbound.protection.outlook.com ([40.107.76.59]:61555
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729822AbgHQWHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 18:07:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmdyaDNLm0TgleXaAqZGxPtbnTLgeHaV2mLJqBdlDj1xhidWH1AK3WOxSgb/iOmxaGkBv30OhlFnmfnEpTleOlqvUfm2WNQEvkZue/RCJIfZiA73dF59wRATiTnaWqaS0M9ym4AuVlLfTUVII1Y75utckJ9LsqpUs4qJNEhLq8gpRJG4VMDeZuvHOMpJ48MMmiMxYydDJkh1yOmmgK5a6oEzENSa9A+/sNGuFPjGR4NroHZsZegDBpwR1yw0yGolUsVo4PVyJrWZA9VL7pX0UZ9HIYKJsPLLEB5F6E9I2atLXs7qSs0IFjRJOmXd4lmZbkSpgww+0aEmf9/g7NXhpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZhWhSoc69fvosto6LnuIa4DzBxnT813N7uDGVWhNJQ=;
 b=nJsSxAzxP3OEOGG7J5LtAtzkvowrHVKvNiNyqooF/DzWUf2tiN+mLnR6NEE5LaIIuhLttD/Ccom/r0+fTsTMV+kH34WM/cuvYtwLOnY4UGPCkXQ0nSy3HCwQy/lEdeFYF+spatKgRI4OSX+Bu3KkwPxlPZe+AKsR17g+PHrTfdutbzlFnnCtQUm/ElAO9sTOX2V6UlAQuSkJRwUhIFO+y4Hy+DlvWRSvJEYFKdQ8TEwr4KUloZ2kWOK7YvlfhDg3AGl/8n+jZSJba6fk8UlnFRXFPEc4GFjSjensVkLFSQTCJjEeMy1By0TtGt/ZOk/qOHEXd3USJvbZVXqjehYHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZhWhSoc69fvosto6LnuIa4DzBxnT813N7uDGVWhNJQ=;
 b=Oo6M5tBgKeGM6oyc+a3b7iV9nq2rO3zhSkXQV2/y4xB1xFXczk9vFWG+Hffg3cY1ZTWpjPFU2lUP6zUbWuf2293UmCgYjdiDdG0JfQPVBq4ypEXvYrxE+bnqiZICEqqfcgS/LL61t9uk8jNSWb1O1A679gKauFUJ6L3exFfO6YI=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN8PR12MB3220.namprd12.prod.outlook.com (2603:10b6:408:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18; Mon, 17 Aug
 2020 22:07:17 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::ac22:9457:4d25:5ff0]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::ac22:9457:4d25:5ff0%5]) with mapi id 15.20.3283.024; Mon, 17 Aug 2020
 22:07:17 +0000
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
Subject: [PATCH 4/7] perf/x86/amd/ibs: Don't include randomized bits in get_ibs_op_count()
Date:   Mon, 17 Aug 2020 17:06:25 -0500
Message-Id: <20200817220628.7604-4-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200817220628.7604-1-kim.phillips@amd.com>
References: <20200817220628.7604-1-kim.phillips@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0084.namprd12.prod.outlook.com
 (2603:10b6:802:21::19) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (70.114.200.6) by SN1PR12CA0084.namprd12.prod.outlook.com (2603:10b6:802:21::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Mon, 17 Aug 2020 22:07:15 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [70.114.200.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f6ff2ee7-d6f3-4c79-e6a0-08d842f9e746
X-MS-TrafficTypeDiagnostic: BN8PR12MB3220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB32208B999C11F2BD02615D6E875F0@BN8PR12MB3220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lg+0qwmuXjUkTfxrK7ezVIYPmz9KbT3/IX7xeo5DWA06HD/8Gy0M+y4HQ/DW6WJ9lH8rRLyMzTXBLoXklozX8erUqI9JWqWUvDdW0a4xQG1Y7SkpJ6rJCqEBmS3gfcwFgbzrlMBZn27wOJ4MNAxXLxDURMnUwNp5IB7Za2R/OACc+ndvGXWnJianlWDKuAsZTFAl7+39dAEBcUiEoDnvtObApN1pJ9knVqzIe0qBvEDCO7Y3jwXLZlX51oVd13YLjLW71G0hIJJURTPMhe7nApytuh8kGYZ2mMTErZ9IlJCNLy87Ez/tymbb+lDHjikMQaW/598i+1MfC+jRYimzF7HCvHyZoPJcrK1/7GBXfH79iFfDfy1wil2JujCX17ZcalI2drSEgbEDfkW8pqy1R2o9T3AUhYtv0wT2IPe/oAMOSvLVjUK+/ZGBQYisD9e4vscJ05rkDSFAzVxCdV/G8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(36756003)(5660300002)(7049001)(2906002)(6506007)(83380400001)(44832011)(956004)(186003)(52116002)(69590400007)(478600001)(2616005)(16526019)(7416002)(6486002)(4326008)(966005)(6512007)(8676002)(66946007)(1076003)(6666004)(86362001)(26005)(316002)(66556008)(110136005)(8936002)(54906003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: c2ldzvM4YqOemP+/NYOtEKBewJxQpO9HryFd56qMSNtyjZyABzXT4QWWCOEuzG5jtPZm7wl9WkrSJ/ocWr48bAf4BKcEzFyaPH2qwcGIlw9xuON06fgi+yI6qaCYd6Y+WV4G9jd8Weg8jwv3Uo/DTE4T7W1E4TC4MU7aK3fXUPrIjcM1OTTy3YPTHy0gLsDuknWVdl3c01NyGpUujO2mTOqWdFgytHllLxZ/0otGt0hbCAtOMYxG1ZpbZ8ek6tNFLfCFqZnU4rlBY4FYezoI/h8Fx9vuKtaCIGOYq0pm44vkHgJBvCDsGI2mLwH38D97ai2jfNFn13Gev5Va7N6pIogPfxzXf2X7sTzJETPEDzYuHm2DRBMmnVZjdNevbRTsD43ndqKQihfTEqoU8WCpzuHW1BHXnvIv1tOCO9AShHmjB9LRm1mHGy5PMlgJfzu9oDSCtqN6IJk8PfnxTVoQ466sQciqaHFQ3JQ5oEbnP4/vHmC1cbnpKwTNcc3BEwzddDYQRekHFPt9lh/pZDD7SeVn16XvmtMRPBWS4qZXWiWFvaQkJ0sE1YmT7eywihfY5MNfLEYmImbQalQDv1rPjOoeuu5XLcQiclitavtDXOs8jnQeEif7V4DrWUBqSYM8QlpkZbwMdBt81uxJEyauCA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ff2ee7-d6f3-4c79-e6a0-08d842f9e746
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 22:07:16.9267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EMAk2uhvK70ckPR3WkJjyAyXtTT81JIYSu5a1B8vsgmHUoe1Jgdh6VpFlLZ+pQdAZ7vUsDdaAEelQmgcHszy1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3220
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
 arch/x86/events/amd/ibs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 8ddce7dd2c4a..ffeb24d31c3d 100644
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

