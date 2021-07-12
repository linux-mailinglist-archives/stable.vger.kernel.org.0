Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9253C540B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349424AbhGLH4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351895AbhGLHwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F42260FF1;
        Mon, 12 Jul 2021 07:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076163;
        bh=d34LXbSGPpPRbMyO7h2/vEZi5O4P4JPPhh6R+acCnt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bi1Q/KmTZyvb8my/fl31Ed7hW4cZq2j1isHMhL1j0gwOxZrrBQUvrEc0qag5QjZ+J
         h38BoHNyKD4UyWaCGH6s9SdKtN5AodJjtcpXsmkoPlJrjM/g4S3R4zJsEJy8E31m6T
         SkwnMAB2CZpy+fboNabCqmdYaHFpCoj/Iy82d7n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 518/800] net: sched: add barrier to ensure correct ordering for lockless qdisc
Date:   Mon, 12 Jul 2021 08:09:01 +0200
Message-Id: <20210712061022.342857507@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 1e625519ae96..57710303908c 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -163,6 +163,12 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
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
@@ -180,6 +186,12 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
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



