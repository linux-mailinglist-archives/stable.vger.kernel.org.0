Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2C92479F2
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 00:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgHQWH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 18:07:26 -0400
Received: from mail-bn8nam12on2063.outbound.protection.outlook.com ([40.107.237.63]:20384
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729823AbgHQWHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 18:07:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6vylFwGFNQRAJeHHHYBDxcf2z+JkpeTO2YBBSJBZWRCTPD4+XsZsquZlU693y07SjruZSlB6zG6+nTO+MQ3ZrucwRI10O+3YAjfZZ3DvQGZWeAWTlGjpDvaZ7CrGOMnuuhg1aP2Lbjea4qlr7UTc7ZSxag5DrQpQ5/Q9lDIV/0EUxvmFmZaoHvwjayYkrfmJ17bDgzAnFJeFACz+MKdQkIXcomDNLyV3+62Bi1n3duRv4Pht05vuCXSm85fnfNHnlyWtD9JLjTGoYCXMWgvD5tQipvoLuhmKu4iOP2R8OTHtCg0RPbOFGPx7V6yWOhpsJ2yRRq33XVuo+Sa1i7Mcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWlakddX/mXdlMo3YVJIBNDqfwOTSLlTw+XltoCWNrw=;
 b=RKudCqPgSU0vUhn2cqno6Vl0KMmXcOjnUSLYJ1/9QYD6rmw+camvVe/p6Z2Ad5nG9jKggdiO9yEOqi1+N9S3SpCjYaOmucqQ45nJzWYKk9ORq7n5W3PG/hqTm9rRpUfDWC5T+cDbsaEQmJxBkawClNOd6xuvgSiSuMZZRfPuQrUFDJLiLqRWGG0iyPse9c2jzeH4m24KYTTOmZhTheyAdjitHZMI7KN346brTXprmEzW8HEDpXRYsQKDRoC6EzqnUy878/QOghmHv32GA770rcOnwUOaOLJszFdPcrwSuQFoP3j8oYfRMUFgfefmL9iS5nbqaWPBrpfRCprquI7R5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWlakddX/mXdlMo3YVJIBNDqfwOTSLlTw+XltoCWNrw=;
 b=DAYwF3iC6tLKUyNWQ6tOmX2xH9BYYHReIp0xtGAuSrtlz27JZ2yMeFw1bt+gDNZJckfZ3aOI0q60a12kp8v/VK1kiF37IN1X9jlJ6jy87YsraODg5qAr9E6axpVgA6TI+pkloaOQkvu9ArgZCbak97hcsyoKYuyYLZalRyP7Uag=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN8PR12MB3220.namprd12.prod.outlook.com (2603:10b6:408:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18; Mon, 17 Aug
 2020 22:07:04 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::ac22:9457:4d25:5ff0]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::ac22:9457:4d25:5ff0%5]) with mapi id 15.20.3283.024; Mon, 17 Aug 2020
 22:07:04 +0000
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
Subject: [PATCH 3/7] arch/x86/amd/ibs: Fix re-arming IBS Fetch
Date:   Mon, 17 Aug 2020 17:06:24 -0500
Message-Id: <20200817220628.7604-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200817220628.7604-1-kim.phillips@amd.com>
References: <20200817220628.7604-1-kim.phillips@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0004.namprd04.prod.outlook.com
 (2603:10b6:803:21::14) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (70.114.200.6) by SN4PR0401CA0004.namprd04.prod.outlook.com (2603:10b6:803:21::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Mon, 17 Aug 2020 22:07:02 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [70.114.200.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 97249ba6-ce45-44c4-53bd-08d842f9dfab
X-MS-TrafficTypeDiagnostic: BN8PR12MB3220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB32202A60649B5408CB37DF12875F0@BN8PR12MB3220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l74c0G66GkpH/6GuuZltjPZkV6r2xFq2UyifHFxPQ6YIkmVpg49FMDOSjhr+YtdfahcGXnWKhumG/t+JwQQdhgjw/ADKcP6cKveF6PHiIhINbuJkfWleOERb6TOXAU5OsuroIANIO1gMjWhqPenaBrhuXAMq7hhsBaUW98dkD0ZQCf4LdswWndh6hUHzDM53wfss+X3XKDVf+rGZ3ejKhGfHvPZJCfm9NCQ1obomS2vXqQPCMooLLZPU2qPoLmloDeMVRVi2elMJ0gQGo/yTYtysngO1OyvUkbwiC6AnFa6zsi1m7EaqZKzLeRHp7+8L0E9xX/xnrAxyC7MUhv85KB+w4uJOASN3bDn3KPU4yB+806Ec1uUh6gG7r8v5YANoPqd/XbtikEZx+tz506mUXLOMire014CmKng6tQcUhEBcG1LiUi3tRSUkU8IJoNv0BCue165cu3bGg5WoXScIjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(36756003)(5660300002)(7049001)(2906002)(6506007)(83380400001)(44832011)(956004)(186003)(52116002)(69590400007)(478600001)(2616005)(16526019)(7416002)(6486002)(4326008)(966005)(6512007)(8676002)(66946007)(1076003)(6666004)(86362001)(26005)(316002)(66556008)(110136005)(8936002)(54906003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: d84hrNVxPrPhQr1gdgtrNIBE9iHyhGa//WhiJmRQO5uhhRfVLMf0G68TwLf7tZLKiLWOW1vKb4FOCouQpWfjZQZd8FMXP+fDm3jsSeCWcQ5z8zygE/PEf/8AETF5n356EUoFP029as/1hY5HlVC9oFoeqXItQRt+PUMAvne0kMnWnLm6DLVLw0X1kFLaConFih5jp2XnSl+L2mffBRjnKDGj4FqOSBRC6f+z+STkG8RGwiJ8qO8+mrvW0eLd2cKsW5aZTt1cDcDsdhRTa4ds1UREU+LF3+qmchvxJFy9feQ8Kkc8QRmbbTg8kl3Mzg+iuKotOhljm5CV2HHiwLevRPiYMoxrff1xHuQ+Lo9RDv1xaT8bRVNwV96bK4c/2sIrbl+E/t6+rywwfdZFKNcD8JAlFrJ+iBeF3UMthXOMo2+anbO8egihlSVxjIWtBuk6tQ9UHusYOiJs7GJ4tCVzsOl8nfBTQht38SG/XJba0RmqVZx15+UieMQy8JYOLXUhDJPUjhNnZ17EN3v8o50/GLE9bPc9O16siLGPo2oO0r/v6z2dvgPhx+WPh5R+ZjS+yd5cQcyaWOa/oVNgx2ZAoLQNEWBEMtnREX44Cqg5P7DIg2oVttc1ixGhiBUnnd5s91MWtIgCSe24qRjIwcvwoQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97249ba6-ce45-44c4-53bd-08d842f9dfab
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 22:07:04.1501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ackMSf+3mUy1qwB5RnRzn6NkdC19yLirPvN3GX0pVzt1O2eRSUUrmiYu9sG0cHenItNR77CUutvrn13XBbPKAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3220
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stephane Eranian found a bug in that IBS' current Fetch counter was not
being reset when the driver would write the new value to clear it along
with the enable bit set, and found that adding an MSR write that would
first disable IBS Fetch would make IBS Fetch reset its current count.

Indeed, the PPR for AMD Family 17h Model 31h B0 55803 Rev 0.54 - Sep 12,
2019 states "The periodic fetch counter is set to IbsFetchCnt [...] when
IbsFetchEn is changed from 0 to 1."

Explicitly set IbsFetchEn to 0 and then to 1 when re-enabling IBS Fetch,
so the driver properly resets the internal counter to 0 and IBS
Fetch starts counting again.

It is not clear what versions of IBS hardware need IbsFetchEn explicitly
zeroed and which historically may not have, so now make the driver
always do it.

Reported-by: Stephane Eranian <stephane.eranian@google.com>
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
 arch/x86/events/amd/ibs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 26c36357c4c9..8ddce7dd2c4a 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -363,7 +363,14 @@ perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
 static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
 					 struct hw_perf_event *hwc, u64 config)
 {
-	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
+	u64 _config = (hwc->config | config) & ~perf_ibs->enable_mask;
+
+	/* The periodic fetch counter is set when IbsFetchEn is changed from 0 to 1 */
+	if (perf_ibs == &perf_ibs_fetch)
+		wrmsrl(hwc->config_base, _config);
+
+ 	_config |= perf_ibs->enable_mask;
+	wrmsrl(hwc->config_base, _config);
 }
 
 /*
-- 
2.27.0

