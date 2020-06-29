Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8E420E743
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389336AbgF2VzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgF2Sfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 599502416F;
        Mon, 29 Jun 2020 15:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443945;
        bh=1exbRlzb96w1M8sEPv8iGNvs/bLhDth7Ks6Y+p7V5oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QD8PYGR7Fv63K9VjVbcFKUN0u1pMp3sccx4KL9mTIml2hjfwd2DAH15VQ79U0YAGX
         RqiN4CzMKDCYB98uGq4lmDqtN2ncRZnAplvCZTs3dZx26YC0wbL7r67M6a1/+eweqo
         3nStlZ1N1rL+PzhmPqzuatuwDk1VeNhjwvvohXCQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 047/265] wireguard: device: avoid circular netns references
Date:   Mon, 29 Jun 2020 11:14:40 -0400
Message-Id: <20200629151818.2493727-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 900575aa33a3eaaef802b31de187a85c4a4b4bd0 ]

Before, we took a reference to the creating netns if the new netns was
different. This caused issues with circular references, with two
wireguard interfaces swapping namespaces. The solution is to rather not
take any extra references at all, but instead simply invalidate the
creating netns pointer when that netns is deleted.

In order to prevent this from happening again, this commit improves the
rough object leak tracking by allowing it to account for created and
destroyed interfaces, aside from just peers and keys. That then makes it
possible to check for the object leak when having two interfaces take a
reference to each others' namespaces.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/device.c             | 58 ++++++++++------------
 drivers/net/wireguard/device.h             |  3 +-
 drivers/net/wireguard/netlink.c            | 14 ++++--
 drivers/net/wireguard/socket.c             | 25 +++++++---
 tools/testing/selftests/wireguard/netns.sh | 13 ++++-
 5 files changed, 67 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 3ac3f8570ca1b..a8f151b1b5fab 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -45,17 +45,18 @@ static int wg_open(struct net_device *dev)
 	if (dev_v6)
 		dev_v6->cnf.addr_gen_mode = IN6_ADDR_GEN_MODE_NONE;
 
+	mutex_lock(&wg->device_update_lock);
 	ret = wg_socket_init(wg, wg->incoming_port);
 	if (ret < 0)
-		return ret;
-	mutex_lock(&wg->device_update_lock);
+		goto out;
 	list_for_each_entry(peer, &wg->peer_list, peer_list) {
 		wg_packet_send_staged_packets(peer);
 		if (peer->persistent_keepalive_interval)
 			wg_packet_send_keepalive(peer);
 	}
+out:
 	mutex_unlock(&wg->device_update_lock);
-	return 0;
+	return ret;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -225,6 +226,7 @@ static void wg_destruct(struct net_device *dev)
 	list_del(&wg->device_list);
 	rtnl_unlock();
 	mutex_lock(&wg->device_update_lock);
+	rcu_assign_pointer(wg->creating_net, NULL);
 	wg->incoming_port = 0;
 	wg_socket_reinit(wg, NULL, NULL);
 	/* The final references are cleared in the below calls to destroy_workqueue. */
@@ -240,13 +242,11 @@ static void wg_destruct(struct net_device *dev)
 	skb_queue_purge(&wg->incoming_handshakes);
 	free_percpu(dev->tstats);
 	free_percpu(wg->incoming_handshakes_worker);
-	if (wg->have_creating_net_ref)
-		put_net(wg->creating_net);
 	kvfree(wg->index_hashtable);
 	kvfree(wg->peer_hashtable);
 	mutex_unlock(&wg->device_update_lock);
 
-	pr_debug("%s: Interface deleted\n", dev->name);
+	pr_debug("%s: Interface destroyed\n", dev->name);
 	free_netdev(dev);
 }
 
@@ -292,7 +292,7 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 	struct wg_device *wg = netdev_priv(dev);
 	int ret = -ENOMEM;
 
-	wg->creating_net = src_net;
+	rcu_assign_pointer(wg->creating_net, src_net);
 	init_rwsem(&wg->static_identity.lock);
 	mutex_init(&wg->socket_update_lock);
 	mutex_init(&wg->device_update_lock);
@@ -393,30 +393,26 @@ static struct rtnl_link_ops link_ops __read_mostly = {
 	.newlink		= wg_newlink,
 };
 
-static int wg_netdevice_notification(struct notifier_block *nb,
-				     unsigned long action, void *data)
+static void wg_netns_pre_exit(struct net *net)
 {
-	struct net_device *dev = ((struct netdev_notifier_info *)data)->dev;
-	struct wg_device *wg = netdev_priv(dev);
-
-	ASSERT_RTNL();
-
-	if (action != NETDEV_REGISTER || dev->netdev_ops != &netdev_ops)
-		return 0;
+	struct wg_device *wg;
 
-	if (dev_net(dev) == wg->creating_net && wg->have_creating_net_ref) {
-		put_net(wg->creating_net);
-		wg->have_creating_net_ref = false;
-	} else if (dev_net(dev) != wg->creating_net &&
-		   !wg->have_creating_net_ref) {
-		wg->have_creating_net_ref = true;
-		get_net(wg->creating_net);
+	rtnl_lock();
+	list_for_each_entry(wg, &device_list, device_list) {
+		if (rcu_access_pointer(wg->creating_net) == net) {
+			pr_debug("%s: Creating namespace exiting\n", wg->dev->name);
+			netif_carrier_off(wg->dev);
+			mutex_lock(&wg->device_update_lock);
+			rcu_assign_pointer(wg->creating_net, NULL);
+			wg_socket_reinit(wg, NULL, NULL);
+			mutex_unlock(&wg->device_update_lock);
+		}
 	}
-	return 0;
+	rtnl_unlock();
 }
 
-static struct notifier_block netdevice_notifier = {
-	.notifier_call = wg_netdevice_notification
+static struct pernet_operations pernet_ops = {
+	.pre_exit = wg_netns_pre_exit
 };
 
 int __init wg_device_init(void)
@@ -429,18 +425,18 @@ int __init wg_device_init(void)
 		return ret;
 #endif
 
-	ret = register_netdevice_notifier(&netdevice_notifier);
+	ret = register_pernet_device(&pernet_ops);
 	if (ret)
 		goto error_pm;
 
 	ret = rtnl_link_register(&link_ops);
 	if (ret)
-		goto error_netdevice;
+		goto error_pernet;
 
 	return 0;
 
-error_netdevice:
-	unregister_netdevice_notifier(&netdevice_notifier);
+error_pernet:
+	unregister_pernet_device(&pernet_ops);
 error_pm:
 #ifdef CONFIG_PM_SLEEP
 	unregister_pm_notifier(&pm_notifier);
@@ -451,7 +447,7 @@ error_pm:
 void wg_device_uninit(void)
 {
 	rtnl_link_unregister(&link_ops);
-	unregister_netdevice_notifier(&netdevice_notifier);
+	unregister_pernet_device(&pernet_ops);
 #ifdef CONFIG_PM_SLEEP
 	unregister_pm_notifier(&pm_notifier);
 #endif
diff --git a/drivers/net/wireguard/device.h b/drivers/net/wireguard/device.h
index b15a8be9d8169..4d0144e169478 100644
--- a/drivers/net/wireguard/device.h
+++ b/drivers/net/wireguard/device.h
@@ -40,7 +40,7 @@ struct wg_device {
 	struct net_device *dev;
 	struct crypt_queue encrypt_queue, decrypt_queue;
 	struct sock __rcu *sock4, *sock6;
-	struct net *creating_net;
+	struct net __rcu *creating_net;
 	struct noise_static_identity static_identity;
 	struct workqueue_struct *handshake_receive_wq, *handshake_send_wq;
 	struct workqueue_struct *packet_crypt_wq;
@@ -56,7 +56,6 @@ struct wg_device {
 	unsigned int num_peers, device_update_gen;
 	u32 fwmark;
 	u16 incoming_port;
-	bool have_creating_net_ref;
 };
 
 int wg_device_init(void);
diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index 802099c8828a6..20a4f3c0a0a19 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -511,11 +511,15 @@ static int wg_set_device(struct sk_buff *skb, struct genl_info *info)
 	if (flags & ~__WGDEVICE_F_ALL)
 		goto out;
 
-	ret = -EPERM;
-	if ((info->attrs[WGDEVICE_A_LISTEN_PORT] ||
-	     info->attrs[WGDEVICE_A_FWMARK]) &&
-	    !ns_capable(wg->creating_net->user_ns, CAP_NET_ADMIN))
-		goto out;
+	if (info->attrs[WGDEVICE_A_LISTEN_PORT] || info->attrs[WGDEVICE_A_FWMARK]) {
+		struct net *net;
+		rcu_read_lock();
+		net = rcu_dereference(wg->creating_net);
+		ret = !net || !ns_capable(net->user_ns, CAP_NET_ADMIN) ? -EPERM : 0;
+		rcu_read_unlock();
+		if (ret)
+			goto out;
+	}
 
 	++wg->device_update_gen;
 
diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index f9018027fc133..c33e2c81635fa 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -347,6 +347,7 @@ static void set_sock_opts(struct socket *sock)
 
 int wg_socket_init(struct wg_device *wg, u16 port)
 {
+	struct net *net;
 	int ret;
 	struct udp_tunnel_sock_cfg cfg = {
 		.sk_user_data = wg,
@@ -371,37 +372,47 @@ int wg_socket_init(struct wg_device *wg, u16 port)
 	};
 #endif
 
+	rcu_read_lock();
+	net = rcu_dereference(wg->creating_net);
+	net = net ? maybe_get_net(net) : NULL;
+	rcu_read_unlock();
+	if (unlikely(!net))
+		return -ENONET;
+
 #if IS_ENABLED(CONFIG_IPV6)
 retry:
 #endif
 
-	ret = udp_sock_create(wg->creating_net, &port4, &new4);
+	ret = udp_sock_create(net, &port4, &new4);
 	if (ret < 0) {
 		pr_err("%s: Could not create IPv4 socket\n", wg->dev->name);
-		return ret;
+		goto out;
 	}
 	set_sock_opts(new4);
-	setup_udp_tunnel_sock(wg->creating_net, new4, &cfg);
+	setup_udp_tunnel_sock(net, new4, &cfg);
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (ipv6_mod_enabled()) {
 		port6.local_udp_port = inet_sk(new4->sk)->inet_sport;
-		ret = udp_sock_create(wg->creating_net, &port6, &new6);
+		ret = udp_sock_create(net, &port6, &new6);
 		if (ret < 0) {
 			udp_tunnel_sock_release(new4);
 			if (ret == -EADDRINUSE && !port && retries++ < 100)
 				goto retry;
 			pr_err("%s: Could not create IPv6 socket\n",
 			       wg->dev->name);
-			return ret;
+			goto out;
 		}
 		set_sock_opts(new6);
-		setup_udp_tunnel_sock(wg->creating_net, new6, &cfg);
+		setup_udp_tunnel_sock(net, new6, &cfg);
 	}
 #endif
 
 	wg_socket_reinit(wg, new4->sk, new6 ? new6->sk : NULL);
-	return 0;
+	ret = 0;
+out:
+	put_net(net);
+	return ret;
 }
 
 void wg_socket_reinit(struct wg_device *wg, struct sock *new4,
diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index 17a1f53ceba01..d77f4829f1e07 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -587,9 +587,20 @@ ip0 link set wg0 up
 kill $ncat_pid
 ip0 link del wg0
 
+# Ensure there aren't circular reference loops
+ip1 link add wg1 type wireguard
+ip2 link add wg2 type wireguard
+ip1 link set wg1 netns $netns2
+ip2 link set wg2 netns $netns1
+pp ip netns delete $netns1
+pp ip netns delete $netns2
+pp ip netns add $netns1
+pp ip netns add $netns2
+
+sleep 2 # Wait for cleanup and grace periods
 declare -A objects
 while read -t 0.1 -r line 2>/dev/null || [[ $? -ne 142 ]]; do
-	[[ $line =~ .*(wg[0-9]+:\ [A-Z][a-z]+\ [0-9]+)\ .*(created|destroyed).* ]] || continue
+	[[ $line =~ .*(wg[0-9]+:\ [A-Z][a-z]+\ ?[0-9]*)\ .*(created|destroyed).* ]] || continue
 	objects["${BASH_REMATCH[1]}"]+="${BASH_REMATCH[2]}"
 done < /dev/kmsg
 alldeleted=1
-- 
2.25.1

