Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD8059BA78
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiHVHni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiHVHnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:43:32 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBAD55AA;
        Mon, 22 Aug 2022 00:43:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T97ftkA9TOM9rnW4rXLKY7qlZohDzseUe2gEsx8Swq8EUr83+lwuKYzLxukQGQp8xY14YaQzKlwEgZkjzrY4VwCnmc2YZk+n3PKQP/jJ1homZ6JmzpRPL5rbksqUr6FYI2msD2iQkzXT86vyF7YiNpWOnM++/6OK3ji/kt86Y663OP+DVpWkPu0HM8JpS/u19qXl6uPpvwJLMYqYe04ZDNMk3Y+Z8GxBuh7WSSlu4vXiFYdIDpd6uHYiin9jBS/mQnVlZHnI10P0E4xvmHIcSZgNTzu7UAwx7/nkN+yQAL9T4FOQbAvGOYs0ZpPijoH4Hgc2N9dtKknWVAqHjZaJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRiCRmnv4hYRFNNbopPpU4oGbPnj1GnovVRiIlSWJ88=;
 b=AVHuQVJuqAUXmVANGnAb18fOE/Tqvn1fWFKLPctgDFq29eksQM9B49NQOubK6J+78xEPbA84+7gtn7h1ziNkjgm2qIubPBGaVjieyi1HxJT+nFbGKOagopE2FEU4RUqXfMMoGjG9WoW0Q3/px0OEUvoh1hk5DTvSNmsFZDpG/7pMIJLNoueEPkp+bmZVbS24hoGJZ/hjqZpz9FXWMM18nZ6OuyOccO+ZmYFeYQDcwjQhKnBO+EKASHtj8hnIKWC1DuMLUj4fLrTgZeWl/WoDIkqk61oo9c/n042MkD0NdlpK4W2mryfiIwRKPTQMgopAFMphccK7U9+lPbRIYRst5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRiCRmnv4hYRFNNbopPpU4oGbPnj1GnovVRiIlSWJ88=;
 b=n8Q33ZtXupapqVr87HNHyyez2Z8M+x6ccXtQ2+55Mg8jgOQPW+Ars65ZOdb/ww9dfHOSpdg62N+gUrfJqZk14CkrkBSLymswnyetig3kdMcqhlWdeA2UTyNtnYHaqjUhzTbh7ERGc46i9XrWcOHNnXZYhEvb0jazJWC1RNk8/bM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from SA1PR05MB8311.namprd05.prod.outlook.com (2603:10b6:806:1e2::19)
 by DM4PR05MB9253.namprd05.prod.outlook.com (2603:10b6:8:8c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.8; Mon, 22 Aug
 2022 07:43:28 +0000
Received: from SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d]) by SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d%7]) with mapi id 15.20.5566.014; Mon, 22 Aug 2022
 07:43:28 +0000
From:   Ankit Jain <ankitja@vmware.com>
To:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com,
        sturlapati@vmware.com, bordoloih@vmware.com, keerthanak@vmware.com,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH v5.4.y 2/4] sched/deadline: Fix stale throttling on de-/boosted tasks
Date:   Mon, 22 Aug 2022 13:09:40 +0530
Message-Id: <20220822073942.218045-3-ankitja@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220822073942.218045-1-ankitja@vmware.com>
References: <20220822073942.218045-1-ankitja@vmware.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::8) To SA1PR05MB8311.namprd05.prod.outlook.com
 (2603:10b6:806:1e2::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6fef729-a15d-4c47-1815-08da84120090
X-MS-TrafficTypeDiagnostic: DM4PR05MB9253:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nkZ4D3k5TWNGT8zzuscl7XuGfOTsaMaGSneTiDdStOL9FGtybPwov1dxX+0MRm32T8YDPgD+IGdrXn4aZckQVNo6wAlz/ldPbRnOmLC14h5/VJHeOO/EjYqWLSV95cpBG8TSaCxdnQ3OgF0MCDy28ApJLKlRAxZ6kwwK/a932iLdjARdUHFUl0HK0U4fytyIMUewhM7QStGdqb2TPgRH3zqS11WwElZi0XM1x+bH8MsPv/aLGRw2vdjZkjUfVtIi4QwCqUDv/fnW3Xakd6OJm0nOOUaifLqZZH0zMhh/mAd1UaqYpNYtCfwefR+YFFO6WbF5Es/+bwV6CWMtAVKmZtqe7KXSA4qupZqTpV4tVbp29gGZ+Rf0he3Bqrq1vj5Nm/4iS9D3+Y8StHb/rcI46dnKNIK0Vvxh32rfnHhS8qfp7uULvbiatm7bjMLg3uWVpMGSmRPcH9Xycv9G/afAR/0bNgEePI0hFxb1Li/hwnpuwwvqZBcgny1AuwwiAfUXbZY5xI+7DywkqjVDcXopnNq9h6Qr74z5MJtX+/2YNzG+GBqfTQEdFiT90rVh9xyzuFC8zdoWTJg7k2lQlnFS5dR66Rim0P2mCLHM32EpKlW6quVP4P4qCwrcBSeO/LqABZfc/KEF4mAYU59ZGvVwhhll64baPO2VriD5VvCyHctOQXAJL4TJlAm/6q12caLrifa7lq/z5ZUE6z2XCpXrQjfsfoLjCw2B+x4rmfRc3c2CzC1KaDeDUl37yZ/nsRi6z/oGs2TmVI+frgIcILDRRZnNwxf/GhIk4UvYvk/1N83xntsE9jGbpcS4JNDNZ17HjCA6Ce4sIZ78FYL7H5Hb8/iSOLRJMotrDdEuTORkf++PvimAHGnC/UiI/8xF8aPdDvRNifpTSDRr8dA685GxZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8311.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(6666004)(83380400001)(36756003)(38350700002)(38100700002)(2616005)(52116002)(6506007)(26005)(921005)(186003)(1076003)(6512007)(478600001)(6486002)(107886003)(966005)(2906002)(4326008)(41300700001)(66946007)(5660300002)(7416002)(66556008)(8676002)(8936002)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hSPrxS1S/asLOcDXH04R0JeTOj18Nr9O66h/sia7COgOmXndCXueZ/8XQvb9?=
 =?us-ascii?Q?89tcf62mj3i7rvydmn/ssDDAah/A0y/fiEN4VvoITol/YGZPQyesDmPwu/bc?=
 =?us-ascii?Q?ipzjqKu1WD/UQp1G1Cj4b0fVWfGyHW4TNJGQXuBBk4k/yZraX6VfvHU5xd0f?=
 =?us-ascii?Q?hi3xAz5eGWvZ0lQrnOFOeAuosKdGt66QRnFXSXx3Oaqudvq+P0W5vKAWWIV+?=
 =?us-ascii?Q?iO+kSCcNSFT7XgYgYo7cfOj1VxoJjCW1Bx03twylrAiCpM96dKEIO14HmR00?=
 =?us-ascii?Q?wLGIIQrUCdPu+U98gRF6DRS/4COHgKkZuSRtIWr1p6xly7GVAfnb3bSDGilo?=
 =?us-ascii?Q?1AWgNuEPP4l7nh9dGJZ55IBIaWO5OPWe2/79u7TxrwFQY6bRBjl4Qykt2GTB?=
 =?us-ascii?Q?VsGSd3TNCPMZ3mFakfNcrC1P6ZVp1Sn1sWs66DklrlZkQ8AWlVX1vTvuu2sW?=
 =?us-ascii?Q?WIqNBsiclHbO9ASP+8m8LNlJ2W9SdOcWE5vLlZPnW1g34rjOF0+bKESSpXpu?=
 =?us-ascii?Q?/Jb0fNKucluXW8VxH3Mhmk9tTO0abKMERVb8Ap0uICPJHgpegAz1mmHstpkH?=
 =?us-ascii?Q?PnU0xqdjetzK41/F75BguVVC30PzynJu+ZuyC8n7WU4HdEarFaXup7spk1Cv?=
 =?us-ascii?Q?vOnxhhzBppB3iuNWjeq2+jCe1h5MDMfuS4+T7LZz0v0K8TSR+9Qnc1vc+6et?=
 =?us-ascii?Q?BSkNZ8F1meuLkxgkO6Yy6boGkHsGyK/x+lsORhBKeLPJ23CU1ahHyfcaNs88?=
 =?us-ascii?Q?sSKYvaSd5Dw2y+sAEf59o0f87z4cPPifgffYPqJsMRt9dZYUHYqtVJeEllbW?=
 =?us-ascii?Q?d0vk/jXU2H4a8i3UWdkeWSDDlkRFlFoLpU9wjMTg4PiOx87VxVnG7+rGdEb8?=
 =?us-ascii?Q?Nrol/60fasURYfsOSlJxo4S1M3oFn13FQQSJMRb9QnxWKrKtPNC7u4+MzgMP?=
 =?us-ascii?Q?XxpvhqgJBqoocITGCJIdMlT40QAFn1UDJnM2wsR7rInDpU2DtpKHVl0IBna2?=
 =?us-ascii?Q?kyKT3dwTL4YjBjR21Hf6ZbL02OuzgqmzoS4HeB/ICa1L8xjM3Li6BXnPpJu+?=
 =?us-ascii?Q?01VxS/nmelrq8H2l04iDwgxoI/7vEMSACngdpbUvZ00QfQXbeP0oZVfOg9tA?=
 =?us-ascii?Q?winGOA2dvQx9B3mIftWqe/f4COyGDZkwIn8IBRYQlbe7lTGf/MW6nFlm74W0?=
 =?us-ascii?Q?hyHt5BWy5WCcmowNd2k3aKm+LZipVQlOZ2yfYlGBgeUTA64aTPUbWYFu9Fp9?=
 =?us-ascii?Q?JZNUDsCWLPQHIxZV1X7lOaqkK/r0yYGpDfKmtRV1mEmMu4yYg14VHjLSdj99?=
 =?us-ascii?Q?kO3Dk1lMl7AxjabCGMfzqyELPToMwhkMoQYDddZMjXMeWupdWagTVN7Fuwi6?=
 =?us-ascii?Q?5YmzRtukyAcVzE81rccn0JZ63mVVfFl0PgoTRNTfrCyjowxUlnrAddUcoX5Z?=
 =?us-ascii?Q?Z0JI3vfIiKXQ8ejHASNwriPGxH0/9DBLWEe0AfK6x9ebBDS5lVDshIri0XnT?=
 =?us-ascii?Q?igIfHJBjM2h496XWtRhtuAthVN3f6aJatv8mEmQANtTCP8VCh5okhrMa48Kp?=
 =?us-ascii?Q?YMnQvxheWqCD4E9cCRxOgYwifDtVAMmJrAod738i?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fef729-a15d-4c47-1815-08da84120090
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8311.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 07:43:28.1473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdyGiSwRWnwFeDIoAZpTmEjh726eW5Op/KDYcmwIHd9o6BNjprId5edHKUPo8jZw9Wr9IRenhBDkXJttviPKYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR05MB9253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 46fcc4b00c3cca8adb9b7c9afdd499f64e427135 upstream.

When a boosted task gets throttled, what normally happens is that it's
immediately enqueued again with ENQUEUE_REPLENISH, which replenishes the
runtime and clears the dl_throttled flag. There is a special case however:
if the throttling happened on sched-out and the task has been deboosted in
the meantime, the replenish is skipped as the task will return to its
normal scheduling class. This leaves the task with the dl_throttled flag
set.

Now if the task gets boosted up to the deadline scheduling class again
while it is sleeping, it's still in the throttled state. The normal wakeup
however will enqueue the task with ENQUEUE_REPLENISH not set, so we don't
actually place it on the rq. Thus we end up with a task that is runnable,
but not actually on the rq and neither a immediate replenishment happens,
nor is the replenishment timer set up, so the task is stuck in
forever-throttled limbo.

Clear the dl_throttled flag before dropping back to the normal scheduling
class to fix this issue.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lkml.kernel.org/r/20200831110719.2126930-1-l.stach@pengutronix.de
[Ankit: Regenerated the patch for v5.4.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
---
 kernel/sched/deadline.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fdeb2afffc48..4b87c5362ec0 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1507,12 +1507,15 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 		}
 	} else if (!dl_prio(p->normal_prio)) {
 		/*
-		 * Special case in which we have a !SCHED_DEADLINE task
-		 * that is going to be deboosted, but exceeds its
-		 * runtime while doing so. No point in replenishing
-		 * it, as it's going to return back to its original
-		 * scheduling class after this.
+		 * Special case in which we have a !SCHED_DEADLINE task that is going
+		 * to be deboosted, but exceeds its runtime while doing so. No point in
+		 * replenishing it, as it's going to return back to its original
+		 * scheduling class after this. If it has been throttled, we need to
+		 * clear the flag, otherwise the task may wake up as throttled after
+		 * being boosted again with no means to replenish the runtime and clear
+		 * the throttle.
 		 */
+		p->dl.dl_throttled = 0;
 		BUG_ON(!p->dl.dl_boosted || flags != ENQUEUE_REPLENISH);
 		return;
 	}
-- 
2.34.1

