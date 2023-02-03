Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7046689684
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbjBCK2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbjBCK2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:28:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B5A9D586
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:27:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C139DB82A6C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A46C433D2;
        Fri,  3 Feb 2023 10:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420034;
        bh=/xH7/9lUQoAc88LV/0CbGzlRrqFbAg2s83LMksOXy1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fN5cB9GsUjOM1+Gpcolzecn3ufTa7OavDD7HpSaE04BsP41YACaniVWM/8KqmUWTn
         PAQU5haPFtDvRNYgjYA6IV+ofDGSllJLPLu0tFxJZnqeMPJD2lhieQOy00Tfk7h6mr
         iXf4zlPFFEc5uT3JB1vR6yZOjTJ659b0XospjNtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tom Parkin <tparkin@katalix.com>,
        Haowei Yan <g1042620637@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/134] l2tp: Serialize access to sk_user_data with sk_callback_lock
Date:   Fri,  3 Feb 2023 11:12:13 +0100
Message-Id: <20230203101025.117636971@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit b68777d54fac21fc833ec26ea1a2a84f975ab035 ]

sk->sk_user_data has multiple users, which are not compatible with each
other. Writers must synchronize by grabbing the sk->sk_callback_lock.

l2tp currently fails to grab the lock when modifying the underlying tunnel
socket fields. Fix it by adding appropriate locking.

We err on the side of safety and grab the sk_callback_lock also inside the
sk_destruct callback overridden by l2tp, even though there should be no
refs allowing access to the sock at the time when sk_destruct gets called.

v4:
- serialize write to sk_user_data in l2tp sk_destruct

v3:
- switch from sock lock to sk_callback_lock
- document write-protection for sk_user_data

v2:
- update Fixes to point to origin of the bug
- use real names in Reported/Tested-by tags

Cc: Tom Parkin <tparkin@katalix.com>
Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
Reported-by: Haowei Yan <g1042620637@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h   |  2 +-
 net/l2tp/l2tp_core.c | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index f508e86a2021..5fa255b1e0a6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -300,7 +300,7 @@ struct bpf_sk_storage;
   *	@sk_tskey: counter to disambiguate concurrent tstamp requests
   *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
   *	@sk_socket: Identd and reporting IO signals
-  *	@sk_user_data: RPC layer private data
+  *	@sk_user_data: RPC layer private data. Write-protected by @sk_callback_lock.
   *	@sk_frag: cached page frag
   *	@sk_peek_off: current peek_offset value
   *	@sk_send_head: front of stuff to transmit
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a0ec61f2295b..0e0f3e96b80e 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1171,8 +1171,10 @@ static void l2tp_tunnel_destruct(struct sock *sk)
 	}
 
 	/* Remove hooks into tunnel socket */
+	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_destruct = tunnel->old_sk_destruct;
 	sk->sk_user_data = NULL;
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	/* Call the original destructor */
 	if (sk->sk_destruct)
@@ -1491,16 +1493,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		sock = sockfd_lookup(tunnel->fd, &ret);
 		if (!sock)
 			goto err;
-
-		ret = l2tp_validate_socket(sock->sk, net, tunnel->encap);
-		if (ret < 0)
-			goto err_sock;
 	}
 
+	sk = sock->sk;
+	write_lock(&sk->sk_callback_lock);
+
+	ret = l2tp_validate_socket(sk, net, tunnel->encap);
+	if (ret < 0)
+		goto err_sock;
+
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
 
-	sk = sock->sk;
 	sock_hold(sk);
 	tunnel->sock = sk;
 
@@ -1526,7 +1530,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 		setup_udp_tunnel_sock(net, sock, &udp_cfg);
 	} else {
-		sk->sk_user_data = tunnel;
+		rcu_assign_sk_user_data(sk, tunnel);
 	}
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
@@ -1538,6 +1542,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
+	write_unlock(&sk->sk_callback_lock);
 	return 0;
 
 err_sock:
@@ -1545,6 +1550,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		sock_release(sock);
 	else
 		sockfd_put(sock);
+
+	write_unlock(&sk->sk_callback_lock);
 err:
 	return ret;
 }
-- 
2.39.0



