Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B488F5493C0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354286AbiFMLe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354576AbiFMLdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:33:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB48B275E7;
        Mon, 13 Jun 2022 03:47:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 149EAB80E07;
        Mon, 13 Jun 2022 10:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEE9C34114;
        Mon, 13 Jun 2022 10:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117245;
        bh=Vsx/QCh4dOhsv+MH8znzyGSqiAyUjJoyK3m1U3HMMp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRijtFNE8ZzuuFVm+5c0lyrxl1GeDn1dTr6aMb83MpZ5SXsiuYtcSDPqvlCTW8OTN
         0yuzqKUY69rw9kbNCQxvcDA/i1F3Dd+LzfQcGsh5jiIfBgEHuun3cw5q/cRbJYQ+Ei
         OyLhZqb4kxRenqD8o5pu5Ytvt065pCtNDWtf6EFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoju Fang <gjfang@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 332/411] net: sched: add barrier to fix packet stuck problem for lockless qdisc
Date:   Mon, 13 Jun 2022 12:10:05 +0200
Message-Id: <20220613094938.678918996@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 90fb413d9fd7..1ee396ce0eda 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -194,6 +194,12 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
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



