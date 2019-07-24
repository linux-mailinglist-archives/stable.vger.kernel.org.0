Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC7173AF5
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404500AbfGXTza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404065AbfGXTza (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:55:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61DAA20665;
        Wed, 24 Jul 2019 19:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998128;
        bh=IEE+22g5OQ2To3AmLiJfIHdoE2uP0WmmHaHP3ulGDuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ieUBMYCKW3p1ijP76E6/e/deYI5FwcpexjKlqMrMkctxBF95rYc7rGnMmhcindkeU
         6WniU6izWxNUJ5UGvo3epVacTvqACCZWt5nFZZFOsYZb9bjYTNnYdqYQHHVv9i2oNv
         xvmopYYzAnkXKRaQOnyNQMi09oqTe0jmB8We3/Zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 214/371] gtp: fix suspicious RCU usage
Date:   Wed, 24 Jul 2019 21:19:26 +0200
Message-Id: <20190724191740.660928847@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e198987e7dd7d3645a53875151cd6f8fc425b706 ]

gtp_encap_enable_socket() and gtp_encap_destroy() are not protected
by rcu_read_lock(). and it's not safe to write sk->sk_user_data.
This patch make these functions to use lock_sock() instead of
rcu_dereference_sk_user_data().

Test commands:
    gtp-link add gtp1

Splat looks like:
[   83.238315] =============================
[   83.239127] WARNING: suspicious RCU usage
[   83.239702] 5.2.0-rc6+ #49 Not tainted
[   83.240268] -----------------------------
[   83.241205] drivers/net/gtp.c:799 suspicious rcu_dereference_check() usage!
[   83.243828]
[   83.243828] other info that might help us debug this:
[   83.243828]
[   83.246325]
[   83.246325] rcu_scheduler_active = 2, debug_locks = 1
[   83.247314] 1 lock held by gtp-link/1008:
[   83.248523]  #0: 0000000017772c7f (rtnl_mutex){+.+.}, at: __rtnl_newlink+0x5f5/0x11b0
[   83.251503]
[   83.251503] stack backtrace:
[   83.252173] CPU: 0 PID: 1008 Comm: gtp-link Not tainted 5.2.0-rc6+ #49
[   83.253271] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   83.254562] Call Trace:
[   83.254995]  dump_stack+0x7c/0xbb
[   83.255567]  gtp_encap_enable_socket+0x2df/0x360 [gtp]
[   83.256415]  ? gtp_find_dev+0x1a0/0x1a0 [gtp]
[   83.257161]  ? memset+0x1f/0x40
[   83.257843]  gtp_newlink+0x90/0xa21 [gtp]
[   83.258497]  ? __netlink_ns_capable+0xc3/0xf0
[   83.259260]  __rtnl_newlink+0xb9f/0x11b0
[   83.260022]  ? rtnl_link_unregister+0x230/0x230
[ ... ]

Fixes: 1e3a3abd8b28 ("gtp: make GTP sockets in gtp_newlink optional")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 83488f2bf7a0..f45a806b6c06 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -293,12 +293,14 @@ static void gtp_encap_destroy(struct sock *sk)
 {
 	struct gtp_dev *gtp;
 
-	gtp = rcu_dereference_sk_user_data(sk);
+	lock_sock(sk);
+	gtp = sk->sk_user_data;
 	if (gtp) {
 		udp_sk(sk)->encap_type = 0;
 		rcu_assign_sk_user_data(sk, NULL);
 		sock_put(sk);
 	}
+	release_sock(sk);
 }
 
 static void gtp_encap_disable_sock(struct sock *sk)
@@ -800,7 +802,8 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 		goto out_sock;
 	}
 
-	if (rcu_dereference_sk_user_data(sock->sk)) {
+	lock_sock(sock->sk);
+	if (sock->sk->sk_user_data) {
 		sk = ERR_PTR(-EBUSY);
 		goto out_sock;
 	}
@@ -816,6 +819,7 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &tuncfg);
 
 out_sock:
+	release_sock(sock->sk);
 	sockfd_put(sock);
 	return sk;
 }
-- 
2.20.1



