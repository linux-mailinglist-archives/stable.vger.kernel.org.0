Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3E23D5F6A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236930AbhGZPRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236764AbhGZPPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAEDC60F91;
        Mon, 26 Jul 2021 15:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314759;
        bh=n4HENStembwB5aGCkrcK9PIac0J6gEm/Fg3ufO4PN6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clkC6d6dmdlKu0RQtZVZ/H6d+NCjWM1RVK9Elzz1bZKojOe3cPt3ZDGvQ1QFOOSQr
         XMRK3rcy9PWUjjYf4+ttppCpud0mNzVdHEMp+yIxgQvaa/lTkZa4R9ngS09kfxCgkm
         kkWP6mTMBNXnVvsm5yQWko+z25mRWgl+JqFOXx2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/120] net/tcp_fastopen: fix data races around tfo_active_disable_stamp
Date:   Mon, 26 Jul 2021 17:38:54 +0200
Message-Id: <20210726153835.018403531@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6f20c8adb1813467ea52c1296d52c4e95978cb2f ]

tfo_active_disable_stamp is read and written locklessly.
We need to annotate these accesses appropriately.

Then, we need to perform the atomic_inc(tfo_active_disable_times)
after the timestamp has been updated, and thus add barriers
to make sure tcp_fastopen_active_should_disable() wont read
a stale timestamp.

Fixes: cf1ef3f0719b ("net/tcp_fastopen: Disable active side TFO in certain scenarios")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Wei Wang <weiwan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 018a48477355..2ab371f55525 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -454,8 +454,15 @@ void tcp_fastopen_active_disable(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
+	/* Paired with READ_ONCE() in tcp_fastopen_active_should_disable() */
+	WRITE_ONCE(net->ipv4.tfo_active_disable_stamp, jiffies);
+
+	/* Paired with smp_rmb() in tcp_fastopen_active_should_disable().
+	 * We want net->ipv4.tfo_active_disable_stamp to be updated first.
+	 */
+	smp_mb__before_atomic();
 	atomic_inc(&net->ipv4.tfo_active_disable_times);
-	net->ipv4.tfo_active_disable_stamp = jiffies;
+
 	NET_INC_STATS(net, LINUX_MIB_TCPFASTOPENBLACKHOLE);
 }
 
@@ -473,10 +480,16 @@ bool tcp_fastopen_active_should_disable(struct sock *sk)
 	if (!tfo_da_times)
 		return false;
 
+	/* Paired with smp_mb__before_atomic() in tcp_fastopen_active_disable() */
+	smp_rmb();
+
 	/* Limit timout to max: 2^6 * initial timeout */
 	multiplier = 1 << min(tfo_da_times - 1, 6);
-	timeout = multiplier * tfo_bh_timeout * HZ;
-	if (time_before(jiffies, sock_net(sk)->ipv4.tfo_active_disable_stamp + timeout))
+
+	/* Paired with the WRITE_ONCE() in tcp_fastopen_active_disable(). */
+	timeout = READ_ONCE(sock_net(sk)->ipv4.tfo_active_disable_stamp) +
+		  multiplier * tfo_bh_timeout * HZ;
+	if (time_before(jiffies, timeout))
 		return true;
 
 	/* Mark check bit so we can check for successful active TFO
-- 
2.30.2



