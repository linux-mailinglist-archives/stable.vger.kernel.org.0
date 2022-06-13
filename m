Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0EE54918B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350701AbiFMMlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352727AbiFMMik (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:38:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9990B5C771;
        Mon, 13 Jun 2022 04:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A928DCE1193;
        Mon, 13 Jun 2022 11:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA0DC34114;
        Mon, 13 Jun 2022 11:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118491;
        bh=pVbQQJnC2klcxehKXrT4BratL+k4FXGLii9HIRyxjdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMJwTC5klwa8SOhSDnmOuaPkXrCDhWqLXVh1UFGaFnNl3v+GAvYOoXTWX+G+dA6wj
         2l6v3J81iVqcKnneYv1hKbUVy8UHBF8lQmnPJRJPGcShBe9gTsaviT5OJZWp2CMMST
         85LLa2gn2OI50WhXNW5jaLbZqCIasFC+YSTmrrvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoju Fang <gjfang@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/172] net: sched: add barrier to fix packet stuck problem for lockless qdisc
Date:   Mon, 13 Jun 2022 12:10:27 +0200
Message-Id: <20220613094906.477256914@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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

From: Guoju Fang <gjfang@linux.alibaba.com>

[ Upstream commit 2e8728c955ce0624b958eee6e030a37aca3a5d86 ]

In qdisc_run_end(), the spin_unlock() only has store-release semantic,
which guarantees all earlier memory access are visible before it. But
the subsequent test_bit() has no barrier semantics so may be reordered
ahead of the spin_unlock(). The store-load reordering may cause a packet
stuck problem.

The concurrent operations can be described as below,
         CPU 0                      |          CPU 1
   qdisc_run_end()                  |     qdisc_run_begin()
          .                         |           .
 ----> /* may be reorderd here */   |           .
|         .                         |           .
|     spin_unlock()                 |         set_bit()
|         .                         |         smp_mb__after_atomic()
 ---- test_bit()                    |         spin_trylock()
          .                         |          .

Consider the following sequence of events:
    CPU 0 reorder test_bit() ahead and see MISSED = 0
    CPU 1 calls set_bit()
    CPU 1 calls spin_trylock() and return fail
    CPU 0 executes spin_unlock()

At the end of the sequence, CPU 0 calls spin_unlock() and does nothing
because it see MISSED = 0. The skb on CPU 1 has beed enqueued but no one
take it, until the next cpu pushing to the qdisc (if ever ...) will
notice and dequeue it.

This patch fix this by adding one explicit barrier. As spin_unlock() and
test_bit() ordering is a store-load ordering, a full memory barrier
smp_mb() is needed here.

Fixes: a90c57f2cedd ("net: sched: fix packet stuck problem for lockless qdisc")
Signed-off-by: Guoju Fang <gjfang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220528101628.120193-1-gjfang@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 769764bda7a8..bed2387af456 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -197,6 +197,12 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		spin_unlock(&qdisc->seqlock);
 
+		/* spin_unlock() only has store-release semantic. The unlock
+		 * and test_bit() ordering is a store-load ordering, so a full
+		 * memory barrier is needed here.
+		 */
+		smp_mb();
+
 		if (unlikely(test_bit(__QDISC_STATE_MISSED,
 				      &qdisc->state))) {
 			clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
-- 
2.35.1



