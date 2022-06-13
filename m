Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1735548692
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378345AbiFMNlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379041AbiFMNjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3237981D;
        Mon, 13 Jun 2022 04:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 736F361036;
        Mon, 13 Jun 2022 11:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8039AC34114;
        Mon, 13 Jun 2022 11:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119710;
        bh=qHJWRt6JAniE3k7YYbpJB8AFjQEVSMDk2DDe4PaqYYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaeLHhQen8INvEPQqHiAAxeBLIR6xHQ/Ja483zIu64hk6YjQqMlkZDOKPMK4A7X27
         1mZ31eFsbEvBn5vFgdDwUVg8TZRpFzQ/fcsfboJPDPdMf1lB978qTlL2ODlFc36JT+
         3qkwOCs8lCi4Ayb+kPLuS3fiZP1hJPjhxkmMppkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Ray <vray@kalrayinc.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 093/339] net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog
Date:   Mon, 13 Jun 2022 12:08:38 +0200
Message-Id: <20220613094929.334981825@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Ray <vray@kalrayinc.com>

[ Upstream commit a54ce3703613e41fe1d98060b62ec09a3984dc28 ]

In qdisc_run_begin(), smp_mb__before_atomic() used before test_bit()
does not provide any ordering guarantee as test_bit() is not an atomic
operation. This, added to the fact that the spin_trylock() call at
the beginning of qdisc_run_begin() does not guarantee acquire
semantics if it does not grab the lock, makes it possible for the
following statement :

if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))

to be executed before an enqueue operation called before
qdisc_run_begin().

As a result the following race can happen :

           CPU 1                             CPU 2

      qdisc_run_begin()               qdisc_run_begin() /* true */
        set(MISSED)                            .
      /* returns false */                      .
          .                            /* sees MISSED = 1 */
          .                            /* so qdisc not empty */
          .                            __qdisc_run()
          .                                    .
          .                              pfifo_fast_dequeue()
 ----> /* may be done here */                  .
|         .                                clear(MISSED)
|         .                                    .
|         .                                smp_mb __after_atomic();
|         .                                    .
|         .                                /* recheck the queue */
|         .                                /* nothing => exit   */
|   enqueue(skb1)
|         .
|   qdisc_run_begin()
|         .
|     spin_trylock() /* fail */
|         .
|     smp_mb__before_atomic() /* not enough */
|         .
 ---- if (test_bit(MISSED))
        return false;   /* exit */

In the above scenario, CPU 1 and CPU 2 both try to grab the
qdisc->seqlock at the same time. Only CPU 2 succeeds and enters the
bypass code path, where it emits its skb then calls __qdisc_run().

CPU1 fails, sets MISSED and goes down the traditionnal enqueue() +
dequeue() code path. But when executing qdisc_run_begin() for the
second time, after enqueuing its skbuff, it sees the MISSED bit still
set (by itself) and consequently chooses to exit early without setting
it again nor trying to grab the spinlock again.

Meanwhile CPU2 has seen MISSED = 1, cleared it, checked the queue
and found it empty, so it returned.

At the end of the sequence, we end up with skb1 enqueued in the
backlog, both CPUs out of __dev_xmit_skb(), the MISSED bit not set,
and no __netif_schedule() called made. skb1 will now linger in the
qdisc until somebody later performs a full __qdisc_run(). Associated
to the bypass capacity of the qdisc, and the ability of the TCP layer
to avoid resending packets which it knows are still in the qdisc, this
can lead to serious traffic "holes" in a TCP connection.

We fix this by replacing the smp_mb__before_atomic() / test_bit() /
set_bit() / smp_mb__after_atomic() sequence inside qdisc_run_begin()
by a single test_and_set_bit() call, which is more concise and
enforces the needed memory barriers.

Fixes: 89837eb4b246 ("net: sched: add barrier to ensure correct ordering for lockless qdisc")
Signed-off-by: Vincent Ray <vray@kalrayinc.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220526001746.2437669-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 36 ++++++++----------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9bab396c1f3b..80973ce820f3 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -187,37 +187,17 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 		if (spin_trylock(&qdisc->seqlock))
 			return true;
 
-		/* Paired with smp_mb__after_atomic() to make sure
-		 * STATE_MISSED checking is synchronized with clearing
-		 * in pfifo_fast_dequeue().
+		/* No need to insist if the MISSED flag was already set.
+		 * Note that test_and_set_bit() also gives us memory ordering
+		 * guarantees wrt potential earlier enqueue() and below
+		 * spin_trylock(), both of which are necessary to prevent races
 		 */
-		smp_mb__before_atomic();
-
-		/* If the MISSED flag is set, it means other thread has
-		 * set the MISSED flag before second spin_trylock(), so
-		 * we can return false here to avoid multi cpus doing
-		 * the set_bit() and second spin_trylock() concurrently.
-		 */
-		if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
+		if (test_and_set_bit(__QDISC_STATE_MISSED, &qdisc->state))
 			return false;
 
-		/* Set the MISSED flag before the second spin_trylock(),
-		 * if the second spin_trylock() return false, it means
-		 * other cpu holding the lock will do dequeuing for us
-		 * or it will see the MISSED flag set after releasing
-		 * lock and reschedule the net_tx_action() to do the
-		 * dequeuing.
-		 */
-		set_bit(__QDISC_STATE_MISSED, &qdisc->state);
-
-		/* spin_trylock() only has load-acquire semantic, so use
-		 * smp_mb__after_atomic() to ensure STATE_MISSED is set
-		 * before doing the second spin_trylock().
-		 */
-		smp_mb__after_atomic();
-
-		/* Retry again in case other CPU may not see the new flag
-		 * after it releases the lock at the end of qdisc_run_end().
+		/* Try to take the lock again to make sure that we will either
+		 * grab it or the CPU that still has it will see MISSED set
+		 * when testing it in qdisc_run_end()
 		 */
 		return spin_trylock(&qdisc->seqlock);
 	}
-- 
2.35.1



