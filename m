Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6ABF3D5FA0
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhGZPSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236127AbhGZPQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B9D160F02;
        Mon, 26 Jul 2021 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315025;
        bh=v2Bj5V1f/5/BtfVaui+4hou+3ngcsCnOxUNORf8hhHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0dpO85Xg8w3aTIRjdGQ83er4fOKU+P50z6GEsHV9L0TqSLT49DjnKSG9Kup7JB6W
         a5iS6sAdan3RwICoeslfFABraXP94PamA1kiUzh+IcyaXKqD4WbavuqAAohX88dsFr
         ZtG5v5Bg/6yWEnxgOgqIBZ+6lDrURtdG7fvVIrDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/108] net/tcp_fastopen: fix data races around tfo_active_disable_stamp
Date:   Mon, 26 Jul 2021 17:38:57 +0200
Message-Id: <20210726153833.477127378@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
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
index a9971e41f31b..8af4fefe371f 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -504,8 +504,15 @@ void tcp_fastopen_active_disable(struct sock *sk)
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
 
@@ -523,10 +530,16 @@ bool tcp_fastopen_active_should_disable(struct sock *sk)
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



