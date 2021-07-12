Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C5B3C468A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhGLG0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234795AbhGLGZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:25:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CB666115C;
        Mon, 12 Jul 2021 06:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070973;
        bh=UmSGOiZVN2BZcaFMNMeQp4ABHSZA4Qxowtk2Jfxqxjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EQcPAU+g2vkDYLHbAHfssl5ZIYrZCyT4EqFIUvRDzlIHS7eEyfSvh3AoRJmeWcp6
         EY0HoXFNuLh1aBWLoTTRecr1kzRE7ObakYO/nLpYfvBCYZdeagVIVNehe09eXWLzd4
         OOLmYvQr9kRUdQi7+h1mfIi9DINoitoFPSQk9ads=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 221/348] net: sched: add barrier to ensure correct ordering for lockless qdisc
Date:   Mon, 12 Jul 2021 08:10:05 +0200
Message-Id: <20210712060731.018723515@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 89837eb4b2463c556a123437f242d6c2bc62ce81 ]

The spin_trylock() was assumed to contain the implicit
barrier needed to ensure the correct ordering between
STATE_MISSED setting/clearing and STATE_MISSED checking
in commit a90c57f2cedd ("net: sched: fix packet stuck
problem for lockless qdisc").

But it turns out that spin_trylock() only has load-acquire
semantic, for strongly-ordered system(like x86), the compiler
barrier implicitly contained in spin_trylock() seems enough
to ensure the correct ordering. But for weakly-orderly system
(like arm64), the store-release semantic is needed to ensure
the correct ordering as clear_bit() and test_bit() is store
operation, see queued_spin_lock().

So add the explicit barrier to ensure the correct ordering
for the above case.

Fixes: a90c57f2cedd ("net: sched: fix packet stuck problem for lockless qdisc")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 0852f3e51360..0cb0a4bcb544 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -160,6 +160,12 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 		if (spin_trylock(&qdisc->seqlock))
 			goto nolock_empty;
 
+		/* Paired with smp_mb__after_atomic() to make sure
+		 * STATE_MISSED checking is synchronized with clearing
+		 * in pfifo_fast_dequeue().
+		 */
+		smp_mb__before_atomic();
+
 		/* If the MISSED flag is set, it means other thread has
 		 * set the MISSED flag before second spin_trylock(), so
 		 * we can return false here to avoid multi cpus doing
@@ -177,6 +183,12 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 		 */
 		set_bit(__QDISC_STATE_MISSED, &qdisc->state);
 
+		/* spin_trylock() only has load-acquire semantic, so use
+		 * smp_mb__after_atomic() to ensure STATE_MISSED is set
+		 * before doing the second spin_trylock().
+		 */
+		smp_mb__after_atomic();
+
 		/* Retry again in case other CPU may not see the new flag
 		 * after it releases the lock at the end of qdisc_run_end().
 		 */
-- 
2.30.2



