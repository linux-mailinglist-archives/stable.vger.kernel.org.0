Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF0E681150
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237241AbjA3OMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237214AbjA3OMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:12:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646623BD9F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7C4E6102E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9003FC433EF;
        Mon, 30 Jan 2023 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087918;
        bh=zsdSU1RrO2sdbPG2Nt3Lm1Aer3Jz1cInwr2V165nWZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2ZQcgheCYbxqPTkBPz73Y6qZi24HrLN7rCZZqEi3jccNzp+N4JFxbiQscqiygyY/
         YYB/s0GHGq82dalNUEmBsECNlxX21Piqm8vCq7ce38kUMLKxpms86mdDEgR8bEwfQA
         pK/+C04DR2pqFba1GLwIOcad2eqDG+61AnUPvCyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com,
        syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Guillaume Nault <gnault@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Tom Parkin <tparkin@katalix.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/204] l2tp: close all race conditions in l2tp_tunnel_register()
Date:   Mon, 30 Jan 2023 14:50:19 +0100
Message-Id: <20230130134318.674700182@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 0b2c59720e65885a394a017d0cf9cab118914682 ]

The code in l2tp_tunnel_register() is racy in several ways:

1. It modifies the tunnel socket _after_ publishing it.

2. It calls setup_udp_tunnel_sock() on an existing socket without
   locking.

3. It changes sock lock class on fly, which triggers many syzbot
   reports.

This patch amends all of them by moving socket initialization code
before publishing and under sock lock. As suggested by Jakub, the
l2tp lockdep class is not necessary as we can just switch to
bh_lock_sock_nested().

Fixes: 37159ef2c1ae ("l2tp: fix a lockdep splat")
Fixes: 6b9f34239b00 ("l2tp: fix races in tunnel creation")
Reported-by: syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com
Reported-by: syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Guillaume Nault <gnault@redhat.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Tom Parkin <tparkin@katalix.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 68d8b2aa6f6d..4c5227048be4 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1041,7 +1041,7 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, uns
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED | IPSKB_REROUTED);
 	nf_reset_ct(skb);
 
-	bh_lock_sock(sk);
+	bh_lock_sock_nested(sk);
 	if (sock_owned_by_user(sk)) {
 		kfree_skb(skb);
 		ret = NET_XMIT_DROP;
@@ -1387,8 +1387,6 @@ static int l2tp_tunnel_sock_create(struct net *net,
 	return err;
 }
 
-static struct lock_class_key l2tp_socket_class;
-
 int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
 		       struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
 {
@@ -1484,21 +1482,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	}
 
 	sk = sock->sk;
+	lock_sock(sk);
 	write_lock_bh(&sk->sk_callback_lock);
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
-	if (ret < 0)
+	if (ret < 0) {
+		release_sock(sk);
 		goto err_inval_sock;
+	}
 	rcu_assign_sk_user_data(sk, tunnel);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	sock_hold(sk);
-	tunnel->sock = sk;
-	tunnel->l2tp_net = net;
-
-	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
-	idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
-	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
-
 	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
 		struct udp_tunnel_sock_cfg udp_cfg = {
 			.sk_user_data = tunnel,
@@ -1512,9 +1505,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
 	sk->sk_destruct = &l2tp_tunnel_destruct;
-	lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class,
-				   "l2tp_sock");
 	sk->sk_allocation = GFP_ATOMIC;
+	release_sock(sk);
+
+	sock_hold(sk);
+	tunnel->sock = sk;
+	tunnel->l2tp_net = net;
+
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
 
 	trace_register_tunnel(tunnel);
 
-- 
2.39.0



