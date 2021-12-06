Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749FA469EFD
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391177AbhLFPpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386643AbhLFP0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:26:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EEEC08E843;
        Mon,  6 Dec 2021 07:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA7DEB8101B;
        Mon,  6 Dec 2021 15:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2182C341C1;
        Mon,  6 Dec 2021 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803818;
        bh=r1fLnjSkFDFMM8K9EWPXdy5Sjw6FO2poZifXfJq0aCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3V22gs0bIk/1Wmjfh/oq1HVbIDPlN2ng5Fq5lT+TZSjierc5JytjY72f3a4rnKxa
         yOoBaFFqbnYKFtZIPZ2eOiwgi7AA7BNHCUXExVrcqgMMKLojwR58IK86H+uyCY9Zk/
         DbKMsqY7pdmnoxO1yZt2ArEPjwUVqVItjJSOl1ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Xiumei Mu <xmu@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 057/130] wireguard: device: reset peer src endpoint when netns exits
Date:   Mon,  6 Dec 2021 15:56:14 +0100
Message-Id: <20211206145601.652047576@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 20ae1d6aa159eb91a9bf09ff92ccaa94dbea92c2 upstream.

Each peer's endpoint contains a dst_cache entry that takes a reference
to another netdev. When the containing namespace exits, we take down the
socket and prevent future sockets from being created (by setting
creating_net to NULL), which removes that potential reference on the
netns. However, it doesn't release references to the netns that a netdev
cached in dst_cache might be taking, so the netns still might fail to
exit. Since the socket is gimped anyway, we can simply clear all the
dst_caches (by way of clearing the endpoint src), which will release all
references.

However, the current dst_cache_reset function only releases those
references lazily. But it turns out that all of our usages of
wg_socket_clear_peer_endpoint_src are called from contexts that are not
exactly high-speed or bottle-necked. For example, when there's
connection difficulty, or when userspace is reconfiguring the interface.
And in particular for this patch, when the netns is exiting. So for
those cases, it makes more sense to call dst_release immediately. For
that, we add a small helper function to dst_cache.

This patch also adds a test to netns.sh from Hangbin Liu to ensure this
doesn't regress.

Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Reported-by: Xiumei Mu <xmu@redhat.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Fixes: 900575aa33a3 ("wireguard: device: avoid circular netns references")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/device.c             |    3 +++
 drivers/net/wireguard/socket.c             |    2 +-
 include/net/dst_cache.h                    |   11 +++++++++++
 net/core/dst_cache.c                       |   19 +++++++++++++++++++
 tools/testing/selftests/wireguard/netns.sh |   24 +++++++++++++++++++++++-
 5 files changed, 57 insertions(+), 2 deletions(-)

--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -398,6 +398,7 @@ static struct rtnl_link_ops link_ops __r
 static void wg_netns_pre_exit(struct net *net)
 {
 	struct wg_device *wg;
+	struct wg_peer *peer;
 
 	rtnl_lock();
 	list_for_each_entry(wg, &device_list, device_list) {
@@ -407,6 +408,8 @@ static void wg_netns_pre_exit(struct net
 			mutex_lock(&wg->device_update_lock);
 			rcu_assign_pointer(wg->creating_net, NULL);
 			wg_socket_reinit(wg, NULL, NULL);
+			list_for_each_entry(peer, &wg->peer_list, peer_list)
+				wg_socket_clear_peer_endpoint_src(peer);
 			mutex_unlock(&wg->device_update_lock);
 		}
 	}
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -308,7 +308,7 @@ void wg_socket_clear_peer_endpoint_src(s
 {
 	write_lock_bh(&peer->endpoint_lock);
 	memset(&peer->endpoint.src6, 0, sizeof(peer->endpoint.src6));
-	dst_cache_reset(&peer->endpoint_cache);
+	dst_cache_reset_now(&peer->endpoint_cache);
 	write_unlock_bh(&peer->endpoint_lock);
 }
 
--- a/include/net/dst_cache.h
+++ b/include/net/dst_cache.h
@@ -80,6 +80,17 @@ static inline void dst_cache_reset(struc
 }
 
 /**
+ *	dst_cache_reset_now - invalidate the cache contents immediately
+ *	@dst_cache: the cache
+ *
+ *	The caller must be sure there are no concurrent users, as this frees
+ *	all dst_cache users immediately, rather than waiting for the next
+ *	per-cpu usage like dst_cache_reset does. Most callers should use the
+ *	higher speed lazily-freed dst_cache_reset function instead.
+ */
+void dst_cache_reset_now(struct dst_cache *dst_cache);
+
+/**
  *	dst_cache_init - initialize the cache, allocating the required storage
  *	@dst_cache: the cache
  *	@gfp: allocation flags
--- a/net/core/dst_cache.c
+++ b/net/core/dst_cache.c
@@ -162,3 +162,22 @@ void dst_cache_destroy(struct dst_cache
 	free_percpu(dst_cache->cache);
 }
 EXPORT_SYMBOL_GPL(dst_cache_destroy);
+
+void dst_cache_reset_now(struct dst_cache *dst_cache)
+{
+	int i;
+
+	if (!dst_cache->cache)
+		return;
+
+	dst_cache->reset_ts = jiffies;
+	for_each_possible_cpu(i) {
+		struct dst_cache_pcpu *idst = per_cpu_ptr(dst_cache->cache, i);
+		struct dst_entry *dst = idst->dst;
+
+		idst->cookie = 0;
+		idst->dst = NULL;
+		dst_release(dst);
+	}
+}
+EXPORT_SYMBOL_GPL(dst_cache_reset_now);
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -613,6 +613,28 @@ ip0 link set wg0 up
 kill $ncat_pid
 ip0 link del wg0
 
+# Ensure that dst_cache references don't outlive netns lifetime
+ip1 link add dev wg0 type wireguard
+ip2 link add dev wg0 type wireguard
+configure_peers
+ip1 link add veth1 type veth peer name veth2
+ip1 link set veth2 netns $netns2
+ip1 addr add fd00:aa::1/64 dev veth1
+ip2 addr add fd00:aa::2/64 dev veth2
+ip1 link set veth1 up
+ip2 link set veth2 up
+waitiface $netns1 veth1
+waitiface $netns2 veth2
+ip1 -6 route add default dev veth1 via fd00:aa::2
+ip2 -6 route add default dev veth2 via fd00:aa::1
+n1 wg set wg0 peer "$pub2" endpoint [fd00:aa::2]:2
+n2 wg set wg0 peer "$pub1" endpoint [fd00:aa::1]:1
+n1 ping6 -c 1 fd00::2
+pp ip netns delete $netns1
+pp ip netns delete $netns2
+pp ip netns add $netns1
+pp ip netns add $netns2
+
 # Ensure there aren't circular reference loops
 ip1 link add wg1 type wireguard
 ip2 link add wg2 type wireguard
@@ -631,7 +653,7 @@ while read -t 0.1 -r line 2>/dev/null ||
 done < /dev/kmsg
 alldeleted=1
 for object in "${!objects[@]}"; do
-	if [[ ${objects["$object"]} != *createddestroyed ]]; then
+	if [[ ${objects["$object"]} != *createddestroyed && ${objects["$object"]} != *createdcreateddestroyeddestroyed ]]; then
 		echo "Error: $object: merely ${objects["$object"]}" >&3
 		alldeleted=0
 	fi


