Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764EA59BA88
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiHVHrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiHVHrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:47:23 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11010010.outbound.protection.outlook.com [52.101.51.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C8C11170;
        Mon, 22 Aug 2022 00:47:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1QMwA8YFV+CpgdydLj3w5gc85Y7KqtQ3PSh7MyALxdFZEFXyLadUSCmclxp8iWv16ILOVSESahQ7CLPF/dUW7lS8q4Om+t9rZq82Foxe4jUKkYWt8CtyDcXBtAEYGmjeRwl5I/ub6OBCdGm8/ZSHaX1kNAjBvN5yVnfht9rDRoVfPl5b9QDBZVMTJobBAj7yFx/berrKpauQDDprzmBFEUMjhe3VsAE2YgEqF9BU7iOBh9uVviC8k+0gh44lpZDiBIqz5/tUybbITk+Hmnf5Vz98ZU9JS30LyhWJRKxWU4Y16lJXqm/LY34OGskDaR5GpoiV84ryq1Cr3K81HVa0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCwtDo3iUEf2bvP8rnG/lwOm9vBykBrMx20uzgoRLcI=;
 b=XWtq/zqXbAr/YEgqP4FXiKwTKzAkDvjDnkhzbMNw34lAa/4qtTOY4qntCskOfy6AVUi3fCuvjSxb7qK764Y5F+jMZU0BGMHOWC3JLa/5kradXpWWTDDNwwyYA2wXz6EiGkN3R+eISyCwzt3SPTMFiKAiT0GnWhKTcAhl6+F4gSJc/ac8Icc50IPCK2+r2p8ZY8zpBs6P6jqyBmROULrYZXxl2lRiYYIynNENJV5n1sgqkT/3jtbGPW9tOU+RmiPFqDfkZrLXq4ivgOUjaVolujbQBBk3Lja0EZvEjC8UebX9GOlVpOm+TCaPS8mpcLrMlldTXkm415+yidA3j0GLEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCwtDo3iUEf2bvP8rnG/lwOm9vBykBrMx20uzgoRLcI=;
 b=O8NH5M+X1rfftYZsFs9kFsYyt1pxclXSbXTajeFWMKmOP6wmIww0z+4eeusWUoXCN0w13wL6IwRF4ijD6TVxtna70NswBERWOtjDSCq4LQ/4EW3ZZOsMaXejJAjaVRjE+qX4YeHAwRHeO9ajQN6cCGeZkFIHiUCxd4jWhPXo5Y4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from SA1PR05MB8311.namprd05.prod.outlook.com (2603:10b6:806:1e2::19)
 by DM4PR05MB9253.namprd05.prod.outlook.com (2603:10b6:8:8c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.8; Mon, 22 Aug
 2022 07:47:20 +0000
Received: from SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d]) by SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d%7]) with mapi id 15.20.5566.014; Mon, 22 Aug 2022
 07:47:20 +0000
From:   Ankit Jain <ankitja@vmware.com>
To:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com,
        sturlapati@vmware.com, bordoloih@vmware.com, keerthanak@vmware.com,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH v4.19.y 2/4] sched/deadline: Fix stale throttling on de-/boosted tasks
Date:   Mon, 22 Aug 2022 13:13:46 +0530
Message-Id: <20220822074348.218135-3-ankitja@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220822074348.218135-1-ankitja@vmware.com>
References: <20220822074348.218135-1-ankitja@vmware.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To SA1PR05MB8311.namprd05.prod.outlook.com
 (2603:10b6:806:1e2::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff8f315b-e3d9-4396-499d-08da84128ae8
X-MS-TrafficTypeDiagnostic: DM4PR05MB9253:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jhFW1GeTLn8sDtu2BdruJMrJNcBleFmEnT958vji51USSeuKd6Q1R2sGANdGwhnVfrQSGc0OX3juPlrJNkH/ut3n7DGwerZkANGQFRQ4gE3iPCN8HvKd/9tB7oDup1MbFHbBWMl67KCdsF/d881L9j71b9mtJZhbOT3jInXxcqZEUWe+d6aAeVgtk6L6cfZ8VaOtqvqqUwbmdpi/M+CLBMyFPVEoIU73kv7XBzSex7AW4yLVIQARzQM+eQ5Kd3uXETRvskN742wI0Zw7TXMX+A5TmL6fxneg5QPsJnZDV6PWY6qthTD8WhVKKtZzZe+x+F+vs1l8fvLPpxl27yB+D4RyC+Obgm2yLiSAwhS8OocX7W9yZ9VIS/F5EVYyUnGnKJkfG7zg/g8jUB0YMnuER3zVVz/cJyfyf4D2Pq6DOn9uMycWWVUoEE90KDJBFERd0u+H8ov4yeXiJEiiTNpqWvJHrDUX9GByAI1EiUPusvgCqHjY0MS5zL/dRJfMmJ9cL3scdQaDhdu+/r+fMa3lhHkPJ7234z0hEHKqIab7LONi75nQ1pjjiMj+fIC3+h3h0pAah1VnKRrwDf9U286DYIDCT2IRURrsD/n/KntrpaEMjnpskEH3e2BFuehMipM2nmyWaWDfXQyi+DG+nhkZxbVQZn6lUzgEhOyp8GPSuAJ4fKYbJrdZoDCFZ4wy+zwZZr6hm/JXioKrsTzpEj4JybhnCQo1wO4UjP5vv7eGSwTgZjwnDnTc7yTKpbGlDS6U7eOIqz7aMsE1hZEsgFxAj+gYKjRjb8zsrShjkdrKrAijheIgfnqvOPeKhVxeCtOpFIsKkwJjjVMiZpSsEL7yo6woKnYTbqXovq/WWeMIl4SsndBXrdn7FH9zAT4FVg39ZzUBJEghyK612lBI4fODRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8311.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(6666004)(83380400001)(36756003)(38350700002)(38100700002)(2616005)(52116002)(6506007)(26005)(921005)(186003)(1076003)(6512007)(478600001)(6486002)(107886003)(966005)(2906002)(4326008)(41300700001)(66946007)(5660300002)(7416002)(66556008)(8676002)(8936002)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oQEVL9EG7hgSWxwPk7KkKevk1lcTPft9Pzz+oPHIOOcpAU6LmgQzmpKWdCR6?=
 =?us-ascii?Q?ML+hcwo4OtoTbL8zVZEH7S5oeGGfUrmSU0i+UA24G9n0CMJ+GMANp/5YYLPa?=
 =?us-ascii?Q?Ybf8LLG8Q5jgB6aDtccBOnvGC9wcasLKyMajaSCMK6+Uwxdttjt/wcRRhBMP?=
 =?us-ascii?Q?RRXuHxxsqbwOHAA59NsuOVBjw/g10FEo9foPGoWGVxqGb1oJVhkhv8ruZM7M?=
 =?us-ascii?Q?2x12zd8CIiDdoCFzYxEHlh+ebjjBqDjjnlQ2rnTykTh55em7YA14AH2PvZ7S?=
 =?us-ascii?Q?Et7fZQnwVdroRvKHRs6s55cXRq8KwlzecLFezTuEpZ2LJY01YJOEDI4wIJwe?=
 =?us-ascii?Q?7JQO1DuV2jjmgUqTG2yPli+1QJsyIrMe0PY38jFf4qnkKwG9mdFaycrGl0cf?=
 =?us-ascii?Q?k5IRoo3KS1Ux1PvD2oukd+1sQsWNKEUEMM8ScUh89YugRjU/zRujpaXbIezC?=
 =?us-ascii?Q?n7YRZSpRYjKh37nrp2Pd6Vai2AxcsV7aG6u5Kj67I8PafnEswEbng3cBtRdd?=
 =?us-ascii?Q?xKYIyupbFuWJoZtbmKxkm5qYHRYPaYdEAEkzeXeIH8CBGR2KlI+b9YFknhqF?=
 =?us-ascii?Q?6pYnAcXwf9sFjZAfyB1uoOCPEp2o4y2GcHGtfpXkzq13eva7OAEJW7y4MREG?=
 =?us-ascii?Q?n+8VD/cvaWVZbI/Vm0KDlUv+kS7oE6Nv7BQbHb0Bf1Je4PecvuKCF457hPF2?=
 =?us-ascii?Q?ytzwlYM+XF2L3H9YI8v64B1UJMsW2VTr1seVCtMUDd0PBWymt1tF+ccX5bVo?=
 =?us-ascii?Q?uSabM8+dqFXrgrcD+qc1MEJFOnssyqeS+86EhoYHM/VsCkfXcbQAYQRTMOeJ?=
 =?us-ascii?Q?X3jF/NfWzZbevooxI79hVmUafsJK4f5XYjeL7vBFzGHcoVYWCriAM+OUZo5b?=
 =?us-ascii?Q?pFUWNGW9pXiBxfoOH5FxlTGb9S8f1aOVNcWdL0a1MfKes+WIIDCuy4RiOr1C?=
 =?us-ascii?Q?G1dTYZouwmSt6/h31UNmjPIw0/Aep1kZ7OSU9bBGfeBZEsYugsqM32SMf0GI?=
 =?us-ascii?Q?r/s8Hc0UzPZaMAvkiDpWgNu6UhDwc4iHjLQEiDabzv6n/2YkIP/5pSLqM9rz?=
 =?us-ascii?Q?yJk87A+pXX7shwfPSCsBJCcFqVd5wuen5OOvc9MI61pEKzFd7RsHXcaJy6eT?=
 =?us-ascii?Q?mM99/b5r225MsJEyRifugtcwjs/xBPh57yXmSBy5BJv4N14b9vJeYGleUsDN?=
 =?us-ascii?Q?iaUmGJOnK5met9I+2WBylpHdpmWfttGN4YyGTPTbYijxOi5X3VzvTYRw3GsW?=
 =?us-ascii?Q?mpH3gpWYFBVWXEfAA/3Dw1PTd8K2b3OqzrLizbrEWWTQo5/cBaiEsdaSFdP7?=
 =?us-ascii?Q?Xa7xEJOhljIzRRZAVtFTtp5HofIXzZzqlU9srayimkAr3z2yj4DLQRKUT08Q?=
 =?us-ascii?Q?d25U/bAZM/FWfXDaUsvDse6A6O7jKltXURsl//EnZ0zo64U8O+7aDMF22VS2?=
 =?us-ascii?Q?3En9A8+OrT8fpU9DkEIG5bRHiAFDyAJ8JYXdnbblCbw6Av0sWfSt4ynuSMcn?=
 =?us-ascii?Q?VRrUUWzdX63kQveXGvgGqMDgudUFVICznOFHsFY6RgfQXEg8yObU+mRJAYVE?=
 =?us-ascii?Q?/dKdcesiM5HPdGFFHU6VcKdfXwwABNudn7IaKslf?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff8f315b-e3d9-4396-499d-08da84128ae8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8311.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 07:47:20.2509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9LHbK9gTdrHKjti+tvs+AE2sX5d3MHdsFuqOPybGXwp05tlVXWnw4vQXzZEIFGiN4Kx32W2s9td8fWHROA/EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR05MB9253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
[Ankit: Regenerated the patch for v4.19.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
---
 kernel/sched/deadline.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1f8444d9df9d..29cd4c0a92c0 100644
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

