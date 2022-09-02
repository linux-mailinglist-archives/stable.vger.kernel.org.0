Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F315AB1FB
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbiIBNr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbiIBNrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7224B32EC6;
        Fri,  2 Sep 2022 06:22:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EBE96216A;
        Fri,  2 Sep 2022 12:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB6FC433C1;
        Fri,  2 Sep 2022 12:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121504;
        bh=Inn3o6JVhGcukmNOS9fSen8gB0FBNvdYR/bcr9er3v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wcgek9BKxxMnYX8/2XfQkdhSz3pmKHuG5CnJC33nPN3ZQX6zCQUKgtjYAWwStEME7
         wYWCDpVDb4X+mp8qcqW4EIT5qNBj0nDsbn3RKl4Bwz9Hp8PTlvPmIuPCVz9s3PUU4P
         e7bLC7oNiBLncr/slFrfDMukf11RDlKBe3iNWG6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com, sturlapati@vmware.com,
        bordoloih@vmware.com, keerthanak@vmware.com, Ankit Jain" 
        <ankitja@vmware.com>, Lucas Stach <l.stach@pengutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH 4.19 06/56] sched/deadline: Fix stale throttling on de-/boosted tasks
Date:   Fri,  2 Sep 2022 14:18:26 +0200
Message-Id: <20220902121400.419941755@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/deadline.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1507,12 +1507,15 @@ static void enqueue_task_dl(struct rq *r
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


