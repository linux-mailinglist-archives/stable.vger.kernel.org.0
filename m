Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E5059BA8F
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiHVHrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiHVHrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:47:22 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11010010.outbound.protection.outlook.com [52.101.51.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA92DEA6;
        Mon, 22 Aug 2022 00:47:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfSnqt2oGmD1hhwmIegvrd2TXDSM9TtaHY52Z5r2MBDHVyOlGPLrMFbGvxy1snbqzYmG2MKmNwRTRA4GzA+W+yp62W96mbNQmrXsCnifoZAOP2xtxuVbAzw8PJRQHpEd82oGE37txcXf9tHgrI7AY+c2q+3BS3R6pgmw4tosl7ATeohWu1wB42yjMaWQoH2z5Nlul/3wsbQDfCSTyp26NkFXPujQyPvC/Bzz5KU6cSl5qBqpJZTXf8Ti1nk4d6kiBIAkYbAkLLZM22VyYrTj1p5J/yrUTsM1qaKgbyClcYfyuzWgtYvuJ5AGs13fe3InGmdiUZfe+yHlMAy4D0W0xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fw2Sk8OS21HcTbNwDFsQzn+3ci/4+wJwGkx8mfZMx60=;
 b=nl9+WfvwGwWloHkHNTeGHnelPukGq3w2t0LWBPKfUibc5S1pW2gWy8F4P9BCuUfWYS7ENq0wEOO9WgBJ/29AQECJ89AXNrH4U5EHFzneBmn4lLDiiByuNiYVepux5QT0n0gXGuKWS4NWIaEYENyWdt4thwO+2b3et6puz73RrDzEMqHmXqugIb9rZk4EfE6PnNsB9heeU3EbTeBnhRMk+9VXZgqBoazaKEByMyxaOFXGM+pE/MfSd8ZGygH6gzYZsH/aaqghS0Iix8LvZWOngNPt7N2KQ+ybo9p2Wlb+apoXCrZLm4cLlg1M7+8mcyxTPtOGi2cycgWdl4beugx/bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fw2Sk8OS21HcTbNwDFsQzn+3ci/4+wJwGkx8mfZMx60=;
 b=C6yrHS4JFyhO63J62Mid8QK8BPmqYx13F4QCAqkO7IlqKEi3B9ba+ZCmEa/Lz1CyvCG4dwVAkVQU8fW1LB4cge7KP5LWi1YufMuJy+TjcoBXWwXiOcozQm+hEd1GVAEsl02CrpauzCGoCAFCpxL9NGjwtgrtAiKVg1PH1JhooKM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from SA1PR05MB8311.namprd05.prod.outlook.com (2603:10b6:806:1e2::19)
 by DM4PR05MB9253.namprd05.prod.outlook.com (2603:10b6:8:8c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.8; Mon, 22 Aug
 2022 07:47:15 +0000
Received: from SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d]) by SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d%7]) with mapi id 15.20.5566.014; Mon, 22 Aug 2022
 07:47:15 +0000
From:   Ankit Jain <ankitja@vmware.com>
To:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com,
        sturlapati@vmware.com, bordoloih@vmware.com, keerthanak@vmware.com,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH v4.19.y 1/4] sched/deadline: Unthrottle PI boosted threads while enqueuing
Date:   Mon, 22 Aug 2022 13:13:45 +0530
Message-Id: <20220822074348.218135-2-ankitja@vmware.com>
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
X-MS-Office365-Filtering-Correlation-Id: cbb3d8f1-c6b8-4240-8ede-08da841287f6
X-MS-TrafficTypeDiagnostic: DM4PR05MB9253:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QTpM/5Hjva+pZzBkgcG2kzNBt+AnKWkJlkcgOS2JB9Us43h6KCNwYA+nu4JsJAUv9umVGrFER6FT1gcbsqKbMxmSRwYSLu17oxz8g1p+rPTgCHFRihDnloBEsqYRrevKLk2SLqkYEG7Bf6SAuv8pEEvZeIYOKOF1eeuc1dosyo7jZ61oinx+tMTNwx6nzvMrd+5d3v0CNx66kwQHs3Pdqs/3Cile2Zf7evZU3Y3WpnDBKOKdD4GFSFMErDdOzDUXMCnPyW9t1hCbYApPHivbBqS7b3D8qXOQIBDC+tBVuGt5zIuJJdWskxmNTOSwPq0JB5ITPFeYnFvVS7m5sHXnzXVY20ku8LTRLK0HHDo2xWsvzUCS9N5f8p5+GIygbUpzLKM6Zz3ONidSaUdfQJ/2lVIShC99KplNOlPH6BHs4d+zDXRz3KNEIPlcSXRfNt+0j1R2emuv+lnCzJlS7F6a8hcAhDVneS5PtGtRkHLiNZOtxeNFuX2Cg5Hi3RkI0sadCeIrifmhBTCqRfnqwttxecCt/+zNDAtOX4J50oDBDcKsynbonYuexg5kmJGnBcDi5sdpsWwZpftrDLh1q3s9RDOFhuhjXVoZ50MrZSPi2yyuETuBjMZFQAENvRapOfAI46OEkmgsUeoTeU56N0Bl/5xlJ+KVlekaQffM5kTX3JYA/+ILbNxgGbLvqcWJFBfpC9envMlvnybP6ZTafSKtfPdykhS35vcTu7iGVygxx2L7UuDqual3ZEYMozciJ1mE5Or4tap7tSJ4mpweP6CnSx/VYDdIQP7XiTSK8T6alNCl5N7xBTTKIhbTUQLzaH1gfNoAIHHczLQikvAlp0KFgLsqpRi3jIHD/VkLmYanQdArMH9L8KFQcoXxAcora8kMTszjuWWxyMIvQYeU2dbQDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8311.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(6666004)(83380400001)(36756003)(38350700002)(38100700002)(2616005)(52116002)(6506007)(26005)(921005)(186003)(1076003)(6512007)(478600001)(6486002)(107886003)(966005)(2906002)(4326008)(41300700001)(66946007)(5660300002)(7416002)(66556008)(8676002)(8936002)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2XLD52cuTPSUY/eskVvEtERvV6d4ag8NG1Xo2KkVY7Q6mzrm3heFIgCf8Th6?=
 =?us-ascii?Q?pSFpq3aBGZuSECR7aMKZade09AHIrCwjHtIpkQIg51Q1cEyIFkRshjK2H2pd?=
 =?us-ascii?Q?AvQv0EOu0w4UWkTY6faEC2Fl6p1o9L0cGE2d6zS191ZUVivKFpQkxLVBLPTz?=
 =?us-ascii?Q?ceFN/FdyYUdjOS5yE51Tz6Ay3jaqghPIolyipVOgNRRxWpLf8B4Abv7c5F+V?=
 =?us-ascii?Q?N2q2YysdHorMtWHVYRwqz+Wp5vKKSWTb9iw7hv9cYpNLOJjvnrmTPDQ1+bJM?=
 =?us-ascii?Q?2GBm59nnO1EXGHcmB/qkXaxdLIr1QKFuUAZyOAglrsoj8IftQmon2XHgR+G4?=
 =?us-ascii?Q?0dLpNC8yH9iPvCqxYTzb+cSqV8kgdQ37mT1A3AgwkKKI1yrBkoyj60mIZiKI?=
 =?us-ascii?Q?8JanYL7rtRirGjTXRIXlMfGPmfdab/RfmPIbp+x1AOaqYNfKfiFcokCsoCDD?=
 =?us-ascii?Q?XlS+PqNYuj4YqqSAuNfvFolNbFPyzuhAJcJwsZnRP68bM2SyyXgPUVdBX+Vv?=
 =?us-ascii?Q?vat7kHwUrQrz7LGN9bqAXVJtGoEaQ4yWrG64MGmlOdvAvehHzYvw24ykZxBt?=
 =?us-ascii?Q?5LsV60yiZMkTHs1SmBgBjVk+dDecWfOAPsT4LHro+f+GHXOrpNfpDZLzRqH5?=
 =?us-ascii?Q?ZGwFFxjP/0HzsrIUDnH2Ec/0iBOv3+ed0muN5Dur0HgQZin375Ek/qmYod6z?=
 =?us-ascii?Q?QL6oEqU6/YsBUb6lSmTl19GmghwGqGBF1vYlJ9tz6SYJ3L5ZgTqKcdAaVG99?=
 =?us-ascii?Q?qaEXwMLROMMDcPvlKI9bxbH1PzZpCOHMMkwB5tJqN/sp1IAXEYrtxP+QmUQU?=
 =?us-ascii?Q?ynvT4sblwBcUToT2rMjzzqxDWO/yWjWPC7Mc2KbYQDNwL8u3OnepQAL2rScy?=
 =?us-ascii?Q?9Zq9EAtpmD3h0lL3x/ngyJtn7nfUeil/qdJMR5AO1AVosk7Hn9o8O+tF0FpW?=
 =?us-ascii?Q?bfJxQxAOIsBBBkGasbXCww6LFv0fGoeMNAWHJsH9smKlEAm8jdMmvNQeByF6?=
 =?us-ascii?Q?RC6R4v9S7fe4fLKKUlzOZQItWFHMWTdFqUgZATsbq1tmsliuO47TV4VtBTDP?=
 =?us-ascii?Q?LHyEdgdA6bFG9lebj7Ydd3Vqy/UWt0HpbYVN9HzPzpO2g/0ygbuu4r7egOfn?=
 =?us-ascii?Q?vckdwCOfoPp/eBh/d20S+o/YxuPdsUc0rVmxPDTQfuo4AxcR5RfAGRRiZZ96?=
 =?us-ascii?Q?vwP7zvK13/ypKb2OKtceMMGFDeglq8/o1NsWfFaVMAGzGcb939u8OziH+W5e?=
 =?us-ascii?Q?kCq7WM0N28muQeSuTIdHSlqLdLjCVZeytbyY5PruFW8N1OYhTq3sxED/op1x?=
 =?us-ascii?Q?yXMhtCgzPIEuKZZw+IKdPC/bsNEuAKuiqFPr7tJzVQufrNUAOA/r+4oXDUaQ?=
 =?us-ascii?Q?cAifl88nHjAOHlNGz/B5MkrPDyU842NNbYf38vPRA//PH4DrzkUuJ33FwOPX?=
 =?us-ascii?Q?03Uke3f8Knv289AM+oCmiZJCF4klyCcGwLcAC/UgoV3gdn9WGLtqIlLy+MAt?=
 =?us-ascii?Q?UxyDh+nmmcy02LAwCD1Tr3puSTiSQcX5ECkXj0upUEaP9Fcj4BOIzgMppeXE?=
 =?us-ascii?Q?YtWB8/uSjZM8PiFIGC+J64J8Gr+rdJlzJpEQ417V?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb3d8f1-c6b8-4240-8ede-08da841287f6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8311.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 07:47:15.3269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+BeFxZTlqEpuxGYLmjpzvfjnVJCdNFl0iuK2ap5DpS81I0CRIGMs6Ut5+kokE3Sme/pAf2qKzrPvG0+Zkbbbw==
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
[Ankit: Regenerated the patch for v4.19.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
---
 kernel/sched/deadline.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index beec5081a55a..1f8444d9df9d 100644
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

