Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CE2681292
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbjA3OWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237626AbjA3OW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:22:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80F838B64
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:21:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8F6060CEE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD3EC433EF;
        Mon, 30 Jan 2023 14:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088484;
        bh=ZHBpX9KxC3LEi9OcnAPDAGFSsoszTJ/4TvHEruM7HZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jM7HzPod/H5Agz+dB7cO5r0Qsvth/ToJhd8JTqMRYKIEZ8G86kE9IkoTt2FfG8w/U
         jAHn7w2gGwpiSnQixangr0YAI4g3qajnwQSwK+/X2JC5wj2GWFlkI/PxPtVNfIatxU
         KcijtplDUy9AX+I+OLsrusX/abXx41FzJqwbG3tI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tom Parkin <tparkin@katalix.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Dumazet <edumazet@google.com>,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/143] l2tp: Dont sleep and disable BH under writer-side sk_callback_lock
Date:   Mon, 30 Jan 2023 14:51:32 +0100
Message-Id: <20230130134308.311427355@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit af295e854a4e3813ffbdef26dbb6a4d6226c3ea1 ]

When holding a reader-writer spin lock we cannot sleep. Calling
setup_udp_tunnel_sock() with write lock held violates this rule, because we
end up calling percpu_down_read(), which might sleep, as syzbot reports
[1]:

 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9890
 percpu_down_read include/linux/percpu-rwsem.h:49 [inline]
 cpus_read_lock+0x1b/0x140 kernel/cpu.c:310
 static_key_slow_inc+0x12/0x20 kernel/jump_label.c:158
 udp_tunnel_encap_enable include/net/udp_tunnel.h:187 [inline]
 setup_udp_tunnel_sock+0x43d/0x550 net/ipv4/udp_tunnel_core.c:81
 l2tp_tunnel_register+0xc51/0x1210 net/l2tp/l2tp_core.c:1509
 pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723

Trim the writer-side critical section for sk_callback_lock down to the
minimum, so that it covers only operations on sk_user_data.

Also, when grabbing the sk_callback_lock, we always need to disable BH, as
Eric points out. Failing to do so leads to deadlocks because we acquire
sk_callback_lock in softirq context, which can get stuck waiting on us if:

1) it runs on the same CPU, or

       CPU0
       ----
  lock(clock-AF_INET6);
  <Interrupt>
    lock(clock-AF_INET6);

2) lock ordering leads to priority inversion

       CPU0                    CPU1
       ----                    ----
  lock(clock-AF_INET6);
                               local_irq_disable();
                               lock(&tcp_hashinfo.bhash[i].lock);
                               lock(clock-AF_INET6);
  <Interrupt>
    lock(&tcp_hashinfo.bhash[i].lock);

... as syzbot reports [2,3]. Use the _bh variants for write_(un)lock.

[1] https://lore.kernel.org/netdev/0000000000004e78ec05eda79749@google.com/
[2] https://lore.kernel.org/netdev/000000000000e38b6605eda76f98@google.com/
[3] https://lore.kernel.org/netdev/000000000000dfa31e05eda76f75@google.com/

v2:
- Check and set sk_user_data while holding sk_callback_lock for both
  L2TP encapsulation types (IP and UDP) (Tetsuo)

Cc: Tom Parkin <tparkin@katalix.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Fixes: b68777d54fac ("l2tp: Serialize access to sk_user_data with sk_callback_lock")
Reported-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com
Reported-by: syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com
Reported-by: syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index e89852bc5309..d6bb1795329a 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1476,11 +1476,12 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	}
 
 	sk = sock->sk;
-	write_lock(&sk->sk_callback_lock);
-
+	write_lock_bh(&sk->sk_callback_lock);
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
 	if (ret < 0)
-		goto err_sock;
+		goto err_inval_sock;
+	rcu_assign_sk_user_data(sk, tunnel);
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
@@ -1509,8 +1510,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		};
 
 		setup_udp_tunnel_sock(net, sock, &udp_cfg);
-	} else {
-		rcu_assign_sk_user_data(sk, tunnel);
 	}
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
@@ -1524,16 +1523,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
-	write_unlock(&sk->sk_callback_lock);
 	return 0;
 
 err_sock:
+	write_lock_bh(&sk->sk_callback_lock);
+	rcu_assign_sk_user_data(sk, NULL);
+err_inval_sock:
+	write_unlock_bh(&sk->sk_callback_lock);
+
 	if (tunnel->fd < 0)
 		sock_release(sock);
 	else
 		sockfd_put(sock);
-
-	write_unlock(&sk->sk_callback_lock);
 err:
 	return ret;
 }
-- 
2.39.0



