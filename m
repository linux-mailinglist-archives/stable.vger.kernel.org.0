Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6B35AB046
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237747AbiIBMwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237748AbiIBMvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:51:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E5C3C8CB;
        Fri,  2 Sep 2022 05:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D228862181;
        Fri,  2 Sep 2022 12:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDA4C433C1;
        Fri,  2 Sep 2022 12:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121668;
        bh=qObAQRL9jDvbNVUCBg+ifDtMBYI49zFZuQMYlD9sB0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulBxUM9WwWTEWnorfkHoueEPatANFVlg/vjgnskDfmIYcnOh/S/aWD3M3ZEuLEZzt
         FQmv1pOBNOGFiDFJ1E/k2/rY/uOOtt1CjcOQdUyWenhbExgQc5/Lq26EhSpO12jTNa
         4eloWoKlCq3U0tuiykcrvET//ZJN5Ml3Plv0VPtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com, sturlapati@vmware.com,
        bordoloih@vmware.com, keerthanak@vmware.com, Ankit Jain" 
        <ankitja@vmware.com>, Mark Simmons <msimmons@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH 5.4 08/77] sched/deadline: Unthrottle PI boosted threads while enqueuing
Date:   Fri,  2 Sep 2022 14:18:17 +0200
Message-Id: <20220902121403.891470207@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
[Ankit: Regenerated the patch for v5.4.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/deadline.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1484,6 +1484,27 @@ static void enqueue_task_dl(struct rq *r
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


