Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37F459BA72
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiHVHnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiHVHnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:43:23 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAB42703;
        Mon, 22 Aug 2022 00:43:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGQouZ0TXJF2FGmlxiFtmlE+GKA5lZjZQzz1vOtOwkipmKkXYBrbpeITQwJulv9EzP3dhpLWUKN7xWNnzLWBRaR6oV1LSw1i6/5UqFRmunnCubjFxM2ud1PeMSbVsbUG+/GzVK1NwUxwzPAORmE55EOHlFjcfpZsHW5Iz9fL8TJvple/EEWwEHOfTF2ZwyAE+k5NNjmVZv4pVx/Xco9VdE2g1wefOpQYWX+Ylt65PB1z289zMyws5745KBXXRmUZ1EFplcfj1fWeGvE7PkrPm1gpOQNxcxTQUVv5FQbosR1Lc1zr8jibpm6+DN/BsV3BdVWS9DrDOshGKwJNrv8I7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KWU5v2Lp3zUFZUWGFyqJXPrcmikXVcANqtkgtN5ACQ=;
 b=V2D/LDar7tcTv0w1hbs2jF99lsXVkvhLiyIWVlEKSTAtX5gpzESeAlKPJUmsAdjS1BzZHznbM+wJ6oP+7+J9wBvRfk88+dzRRTPK5jezKb2biZ+B1p9S/kVEUg2xBPFdW9AfQvGIqws4aYFGWjt4J/B8vMag7pELBrs9XSAT46tN2njCUuQyrGP1ne5Gk1zGoxj90QnfpKns84XFIREAZUAWZ60sI/3+HFch78vEujRlFAa3VuGa6AApcIeJK9nZG2PXnlIcpgEklMrWDZaG4/fsb4rt0JWBwRBQscltsd/m4cgBGsJOrNbvXaQ4PTm+oh8EF+LRV83T0Guittuw4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KWU5v2Lp3zUFZUWGFyqJXPrcmikXVcANqtkgtN5ACQ=;
 b=z3AU6RMNwwJNmh6z/g7ZzwZZjF/jzSDGthKoiC6tRdOyvl71VW8arF+EEDx66gUAX99MwbtlWlQX3V1DPkk22U/jmyr9JnCdl0iFFed9qF6OyUOSnsJ3TLexHO1zH7xz7ivhgm4r6Glu7w02q/Sx5Px+ahG/EaDWx+DzwYK3A4Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from SA1PR05MB8311.namprd05.prod.outlook.com (2603:10b6:806:1e2::19)
 by DM4PR05MB9253.namprd05.prod.outlook.com (2603:10b6:8:8c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.8; Mon, 22 Aug
 2022 07:43:20 +0000
Received: from SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d]) by SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d%7]) with mapi id 15.20.5566.014; Mon, 22 Aug 2022
 07:43:20 +0000
From:   Ankit Jain <ankitja@vmware.com>
To:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com,
        sturlapati@vmware.com, bordoloih@vmware.com, keerthanak@vmware.com,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH v5.4.y 1/4] sched/deadline: Unthrottle PI boosted threads while enqueuing
Date:   Mon, 22 Aug 2022 13:09:39 +0530
Message-Id: <20220822073942.218045-2-ankitja@vmware.com>
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
X-MS-Office365-Filtering-Correlation-Id: ac87bbab-032c-4c51-2d94-08da8411fc28
X-MS-TrafficTypeDiagnostic: DM4PR05MB9253:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6lVd16x5ZpCIrV+pWPaXE6y3vOsOXttgQaXQvwvMgjwNWL1IXt1WoFeLglY8nGXIDfneD7EOTaG+yOOa0T5uaoMGfbn37JhMbhyDwWtr0/6JCFixUS/P+9R/sH1gCshcveJ6PBX2rZDT/XUgjQ08eKz3sRPj9S733QvaTSVC2Op+y/Ov9CTFNcdiWk6WveY5UY1I9kPyyX5rvUUx16NZF/xKvn9b1sHwaYKWlCgvQTffRp2pV+fp08jxRXsIX5o0FVmWJgxu12s0aKKRKhwyy1cYoSkpph2XwI/2BxtNdUDE7+DMc6OLoQtn7YnqcbJNKJTxRx1If0X9wMI0ajws9AZXxI2I7NNuZp/FQVPzgwyEm3j3AnMW0rdsKtA4yAKAZS5PgTfUUFLTF+DyjVUyMuXIqqx8tgxnfW0bpgc2Xkq1uDh1+jyRv9cXVAb7xiUvjjg6d3rlYdlD01bffjpZ0mKiGPWoygpj6yb4T7CdebpP7458d7Kmo61c7s6GJ9FmmgK9CW2AR4zC47churZbLv8XpDWftswHhbjqf4brWpn6MlvWz3Jm7O84pGUlYdAd4wxtp9o9Vufb6qIfs7IHsMKYDmFmBQ6oWi9tnkkG/y/e/PjWOibLnAGf02NpV6vABi6yMHspZoWCDOjx2GJi7ZetXWny3FtlcV5rf+rbuEzguAWP8tmBIT9SSVPYTBsqS9+ClhSdAGMaJ31BI+6luQBh/Yuk8aoWBrMmbnhp491h0fDCxk7HqAUL26dFfcZ1hfYp2/HbTDQC/qccdhBfzQXF2Y6umPh40lRZIa2qlb9wAIak6bL6maO1QRao3sDklQaHEFDWo+AlXpzLCjchPuPLrId4AGss7BqZmNwIl3xWjGMRRj6S6iqL4hxpiDMGokmtY2SBZ5EEXn6toylpoSMkWujNQNXD3wOpH9CFt4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8311.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(6666004)(83380400001)(36756003)(38350700002)(38100700002)(2616005)(52116002)(6506007)(26005)(921005)(186003)(1076003)(6512007)(478600001)(6486002)(107886003)(966005)(2906002)(4326008)(41300700001)(66946007)(5660300002)(7416002)(66556008)(8676002)(8936002)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2sCAkcZb2knxTSv2fgrCfstdYTgBYU1SwZpSn8sJzHKZvhzdMtw6X1Dj6jcE?=
 =?us-ascii?Q?pvm/OxXal/3e1E0SX1RaPKSNHvvwZ53nHJiMukhJbe9M5gLpuQNpQ2u6ngAC?=
 =?us-ascii?Q?s5es4/Or1izfyEcMnpOvIHOBHWtTrOlyFDHRnRNj5ST129irIzEjoZvofmYd?=
 =?us-ascii?Q?Xy4S2uqw1cKlRPysTyEXeWnrmh1r/Zd3XAlE2oumpPP7HYAr7RcNN98oaJlJ?=
 =?us-ascii?Q?0GQ5ermJ3d9nWSRqpXbeTAn+oNcs20hPm4Rl24OmiOkYKUumCjZABOVguYdW?=
 =?us-ascii?Q?+fAZCbsAHFbUJcia50lwRUo2IbYvsI1rFDDnP7Wbq0pz8qclGiiStOo1ko8s?=
 =?us-ascii?Q?qKktl0ftBrce1fx5Kgs0ziQfPUwn4oK4Nk26SkPaplxY0vQVRojyluESnG62?=
 =?us-ascii?Q?5/dgXKvYho3UK1eGUQDLSWwETO4aeTDS7+8I0NeE5BOAMwS4/c9A+MZXMA8X?=
 =?us-ascii?Q?3407+6FioC+QiaRYlZlXRJTWY9U1ZWsJ5cb9AAWtGooOR0he7r7RVLD6n+Us?=
 =?us-ascii?Q?mZU6uPtL3uM92iDhqLnMVj2Dllg06c5SvMlCgm1lx/6W+hv5QW4otJdMrwF/?=
 =?us-ascii?Q?nibrznZxuhkyZJ3cILVBi2+K9kUsmLzKWKXYS66UsfLqovhahjWMyE4Zioe/?=
 =?us-ascii?Q?3eJpSYvXAN6Kd6OtRLCxaXpBDnK17dFXAmaQ0BsvDkW/pgzwNPj9b//HcGGE?=
 =?us-ascii?Q?K/3Uvrv6I/iSX/J7JEmYYyKpw/7em6vceJuO4cgaKxoaeHFIAvB1W5kJBBuj?=
 =?us-ascii?Q?FuN83SAwB/kV4DMP8KWpWm2sXNOBz/t3NGJGVMXK+5kUjQVk8obnvshzOqG+?=
 =?us-ascii?Q?gC1bW2MKhqXeradKRSwstXgsOOQ/Pp0+62lT6w65ktisXHv80QfOFOS2sNUY?=
 =?us-ascii?Q?pC57eW1kTduwkDA32SUXOnVOUip8yji9/WBkutcyqklYFf7L1n0ZPSim2yql?=
 =?us-ascii?Q?J1obM3rCuihbYAe+hvKINuWOdx3SMrN3+miHva4jjWLEtCtm+4lRHQMgOIDz?=
 =?us-ascii?Q?ocpTDugpwxOII7oO5Y8muyTQ00T0ki32jy7nSswYyQsqRbK1cddV+n54+JWG?=
 =?us-ascii?Q?qW0IPh0C2Eaq9Q5uS2jM3zpd4CaIIh3rI6qahO8R/OKzIm/Fg6gSFLiy3yc6?=
 =?us-ascii?Q?yfWfnqMUHxsVcDnsTMMrFhIC3WzvoF3K/gRWWh9tlpZSQKkqtuJJQGI0onvP?=
 =?us-ascii?Q?cmC8TvnszcTr9VgjFWi+w2ZXgepOjt8502sGpN6UKxHw/RUhbSGwc4DsBn2r?=
 =?us-ascii?Q?ion8PgRRW9lRk5H0XStewKyjw8mfg0lCMNumPYmGNIhpLJNvyq8hzMvB0zWk?=
 =?us-ascii?Q?f9O2fSRXNG8Yxn2EErVmlvhw7PMVp/hWbetiJk217Z/vgxpVt8B5GrswE7gX?=
 =?us-ascii?Q?gLqyqvTXkNfCEWK+Nhwjm+gclIljeM4c2R15qrabSaim4wfDH4hhPadx4wFW?=
 =?us-ascii?Q?GyDT+0spEeuWAhv69+/JATHapmTG6sqOqU/DJ6XhloHn83/DH8OOhIkQcoqO?=
 =?us-ascii?Q?kYeOb47+bJ4X+vHR/Lnb8UfrIEIOhP0+CmcN6mglzxOja+Tcj4u1uGI1j+uK?=
 =?us-ascii?Q?/pGqchmi4vN3qMujmUGIjFiUf3+uCq+q1Ykb/cQm?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac87bbab-032c-4c51-2d94-08da8411fc28
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8311.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 07:43:20.8179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ptDISjaMIBIpsGwowbQRVCN9s7mXQgrX23juq+xk7+YzwzPuoYHpsgaqwpjEkR+7Ueqb5u0dbUy2gnqRmogSOg==
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

From: Daniel Bristot de Oliveira <bristot@redhat.com>

commit feff2e65efd8d84cf831668e182b2ce73c604bbb upstream.

stress-ng has a test (stress-ng --cyclic) that creates a set of threads
under SCHED_DEADLINE with the following parameters:

    dl_runtime   =  10000 (10 us)
    dl_deadline  = 100000 (100 us)
    dl_period    = 100000 (100 us)

These parameters are very aggressive. When using a system without HRTICK
set, these threads can easily execute longer than the dl_runtime because
the throttling happens with 1/HZ resolution.

During the main part of the test, the system works just fine because
the workload does not try to run over the 10 us. The problem happens at
the end of the test, on the exit() path. During exit(), the threads need
to do some cleanups that require real-time mutex locks, mainly those
related to memory management, resulting in this scenario:

Note: locks are rt_mutexes...
 ------------------------------------------------------------------------
    TASK A:		TASK B:				TASK C:
    activation
							activation
			activation

    lock(a): OK!	lock(b): OK!
    			<overrun runtime>
    			lock(a)
    			-> block (task A owns it)
			  -> self notice/set throttled
 +--<			  -> arm replenished timer
 |    			switch-out
 |    							lock(b)
 |    							-> <C prio > B prio>
 |    							-> boost TASK B
 |  unlock(a)						switch-out
 |  -> handle lock a to B
 |    -> wakeup(B)
 |      -> B is throttled:
 |        -> do not enqueue
 |     switch-out
 |
 |
 +---------------------> replenishment timer
			-> TASK B is boosted:
			  -> do not enqueue
 ------------------------------------------------------------------------

BOOM: TASK B is runnable but !enqueued, holding TASK C: the system
crashes with hung task C.

This problem is avoided by removing the throttle state from the boosted
thread while boosting it (by TASK A in the example above), allowing it to
be queued and run boosted.

The next replenishment will take care of the runtime overrun, pushing
the deadline further away. See the "while (dl_se->runtime <= 0)" on
replenish_dl_entity() for more information.

Reported-by: Mark Simmons <msimmons@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Tested-by: Mark Simmons <msimmons@redhat.com>
Link: https://lkml.kernel.org/r/5076e003450835ec74e6fa5917d02c4fa41687e6.1600170294.git.bristot@redhat.com
[Ankit: Regenerated the patch for v5.4.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
---
 kernel/sched/deadline.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2bda9fdba31c..fdeb2afffc48 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1484,6 +1484,27 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 	 */
 	if (pi_task && dl_prio(pi_task->normal_prio) && p->dl.dl_boosted) {
 		pi_se = &pi_task->dl;
+		/*
+		 * Because of delays in the detection of the overrun of a
+		 * thread's runtime, it might be the case that a thread
+		 * goes to sleep in a rt mutex with negative runtime. As
+		 * a consequence, the thread will be throttled.
+		 *
+		 * While waiting for the mutex, this thread can also be
+		 * boosted via PI, resulting in a thread that is throttled
+		 * and boosted at the same time.
+		 *
+		 * In this case, the boost overrides the throttle.
+		 */
+		if (p->dl.dl_throttled) {
+			/*
+			 * The replenish timer needs to be canceled. No
+			 * problem if it fires concurrently: boosted threads
+			 * are ignored in dl_task_timer().
+			 */
+			hrtimer_try_to_cancel(&p->dl.dl_timer);
+			p->dl.dl_throttled = 0;
+		}
 	} else if (!dl_prio(p->normal_prio)) {
 		/*
 		 * Special case in which we have a !SCHED_DEADLINE task
-- 
2.34.1

