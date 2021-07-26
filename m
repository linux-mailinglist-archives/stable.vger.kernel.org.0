Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5533D61EE
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbhGZPd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233470AbhGZPcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD25604AC;
        Mon, 26 Jul 2021 16:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315962;
        bh=inOWQfLVnDgye7I8eMJNLtVK9WP2hsqyDZbNzzns8AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsRLYgJyZwun1UDLy1s83IXy2MKWcw+rx1m8rj6OVzHb6Ifcoubjxm5dvfER47YUs
         HQ8cU0R71nHkuEuX88LfzNyp0R2OEpzX4PKOf2Q0uZLXHcop9qmI5KFh4NoLaCWXYo
         jxAMHKE5s0p3+td/p0L9sh3Jq461PeCuBC9FsOFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 134/223] tcp: disable TFO blackhole logic by default
Date:   Mon, 26 Jul 2021 17:38:46 +0200
Message-Id: <20210726153850.631461851@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <weiwan@google.com>

[ Upstream commit 213ad73d06073b197a02476db3a4998e219ddb06 ]

Multiple complaints have been raised from the TFO users on the internet
stating that the TFO blackhole logic is too aggressive and gets falsely
triggered too often.
(e.g. https://blog.apnic.net/2021/07/05/tcp-fast-open-not-so-fast/)
Considering that most middleboxes no longer drop TFO packets, we decide
to disable the blackhole logic by setting
/proc/sys/net/ipv4/tcp_fastopen_blackhole_timeout_set to 0 by default.

Fixes: cf1ef3f0719b4 ("net/tcp_fastopen: Disable active side TFO in certain scenarios")
Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 2 +-
 net/ipv4/tcp_fastopen.c                | 9 ++++++++-
 net/ipv4/tcp_ipv4.c                    | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c2ecc9894fd0..9a57e972dae4 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -772,7 +772,7 @@ tcp_fastopen_blackhole_timeout_sec - INTEGER
 	initial value when the blackhole issue goes away.
 	0 to disable the blackhole detection.
 
-	By default, it is set to 1hr.
+	By default, it is set to 0 (feature is disabled).
 
 tcp_fastopen_key - list of comma separated 32-digit hexadecimal INTEGERs
 	The list consists of a primary key and an optional backup key. The
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 08548ff23d83..d49709ba8e16 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -507,6 +507,9 @@ void tcp_fastopen_active_disable(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
+	if (!sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout)
+		return;
+
 	/* Paired with READ_ONCE() in tcp_fastopen_active_should_disable() */
 	WRITE_ONCE(net->ipv4.tfo_active_disable_stamp, jiffies);
 
@@ -526,10 +529,14 @@ void tcp_fastopen_active_disable(struct sock *sk)
 bool tcp_fastopen_active_should_disable(struct sock *sk)
 {
 	unsigned int tfo_bh_timeout = sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout;
-	int tfo_da_times = atomic_read(&sock_net(sk)->ipv4.tfo_active_disable_times);
 	unsigned long timeout;
+	int tfo_da_times;
 	int multiplier;
 
+	if (!tfo_bh_timeout)
+		return false;
+
+	tfo_da_times = atomic_read(&sock_net(sk)->ipv4.tfo_active_disable_times);
 	if (!tfo_da_times)
 		return false;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e409f2de5dc4..8bb5f7f51dae 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2954,7 +2954,7 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_comp_sack_nr = 44;
 	net->ipv4.sysctl_tcp_fastopen = TFO_CLIENT_ENABLE;
 	spin_lock_init(&net->ipv4.tcp_fastopen_ctx_lock);
-	net->ipv4.sysctl_tcp_fastopen_blackhole_timeout = 60 * 60;
+	net->ipv4.sysctl_tcp_fastopen_blackhole_timeout = 0;
 	atomic_set(&net->ipv4.tfo_active_disable_times, 0);
 
 	/* Reno is always built in */
-- 
2.30.2



