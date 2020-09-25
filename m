Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6762788BC
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgIYM53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729088AbgIYMuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08B682075E;
        Fri, 25 Sep 2020 12:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038239;
        bh=vCOuBYj4kuqRhIv+5WV0WgEYmGLUUlWsBW2gIXeJfXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drZNw26kN4caAA2Bs3u2P9sgI3yqgL4N6tgRUHpK04DGi8/VyQqX43W3lEWPgH3C6
         OnWrR225aL8NwU1IudqIjHdpf0Y9+UJXMpysQYZlSgDHQJ+yyGA/pp51Iw27UEOJhb
         29CdjpMHjXf2Kwkr812TQN+Tq27rAp0w/MR9lL2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        syzbot+3f960c64a104eaa2c813@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 53/56] Revert "netns: dont disable BHs when locking "nsid_lock""
Date:   Fri, 25 Sep 2020 14:48:43 +0200
Message-Id: <20200925124735.734169325@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit e1f469cd5866499ac40bfdca87411e1c525a10c7 ]

This reverts commit 8d7e5dee972f1cde2ba96c621f1541fa36e7d4f4.

To protect netns id, the nsid_lock is used when netns id is being
allocated and removed by peernet2id_alloc() and unhash_nsid().
The nsid_lock can be used in BH context but only spin_lock() is used
in this code.
Using spin_lock() instead of spin_lock_bh() can result in a deadlock in
the following scenario reported by the lockdep.
In order to avoid a deadlock, the spin_lock_bh() should be used instead
of spin_lock() to acquire nsid_lock.

Test commands:
    ip netns del nst
    ip netns add nst
    ip link add veth1 type veth peer name veth2
    ip link set veth1 netns nst
    ip netns exec nst ip link add name br1 type bridge vlan_filtering 1
    ip netns exec nst ip link set dev br1 up
    ip netns exec nst ip link set dev veth1 master br1
    ip netns exec nst ip link set dev veth1 up
    ip netns exec nst ip link add macvlan0 link br1 up type macvlan

Splat looks like:
[   33.615860][  T607] WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
[   33.617194][  T607] 5.9.0-rc1+ #665 Not tainted
[ ... ]
[   33.670615][  T607] Chain exists of:
[   33.670615][  T607]   &mc->mca_lock --> &bridge_netdev_addr_lock_key --> &net->nsid_lock
[   33.670615][  T607]
[   33.673118][  T607]  Possible interrupt unsafe locking scenario:
[   33.673118][  T607]
[   33.674599][  T607]        CPU0                    CPU1
[   33.675557][  T607]        ----                    ----
[   33.676516][  T607]   lock(&net->nsid_lock);
[   33.677306][  T607]                                local_irq_disable();
[   33.678517][  T607]                                lock(&mc->mca_lock);
[   33.679725][  T607]                                lock(&bridge_netdev_addr_lock_key);
[   33.681166][  T607]   <Interrupt>
[   33.681791][  T607]     lock(&mc->mca_lock);
[   33.682579][  T607]
[   33.682579][  T607]  *** DEADLOCK ***
[ ... ]
[   33.922046][  T607] stack backtrace:
[   33.922999][  T607] CPU: 3 PID: 607 Comm: ip Not tainted 5.9.0-rc1+ #665
[   33.924099][  T607] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   33.925714][  T607] Call Trace:
[   33.926238][  T607]  dump_stack+0x78/0xab
[   33.926905][  T607]  check_irq_usage+0x70b/0x720
[   33.927708][  T607]  ? iterate_chain_key+0x60/0x60
[   33.928507][  T607]  ? check_path+0x22/0x40
[   33.929201][  T607]  ? check_noncircular+0xcf/0x180
[   33.930024][  T607]  ? __lock_acquire+0x1952/0x1f20
[   33.930860][  T607]  __lock_acquire+0x1952/0x1f20
[   33.931667][  T607]  lock_acquire+0xaf/0x3a0
[   33.932366][  T607]  ? peernet2id_alloc+0x3a/0x170
[   33.933147][  T607]  ? br_port_fill_attrs+0x54c/0x6b0 [bridge]
[   33.934140][  T607]  ? br_port_fill_attrs+0x5de/0x6b0 [bridge]
[   33.935113][  T607]  ? kvm_sched_clock_read+0x14/0x30
[   33.935974][  T607]  _raw_spin_lock+0x30/0x70
[   33.936728][  T607]  ? peernet2id_alloc+0x3a/0x170
[   33.937523][  T607]  peernet2id_alloc+0x3a/0x170
[   33.938313][  T607]  rtnl_fill_ifinfo+0xb5e/0x1400
[   33.939091][  T607]  rtmsg_ifinfo_build_skb+0x8a/0xf0
[   33.939953][  T607]  rtmsg_ifinfo_event.part.39+0x17/0x50
[   33.940863][  T607]  rtmsg_ifinfo+0x1f/0x30
[   33.941571][  T607]  __dev_notify_flags+0xa5/0xf0
[   33.942376][  T607]  ? __irq_work_queue_local+0x49/0x50
[   33.943249][  T607]  ? irq_work_queue+0x1d/0x30
[   33.943993][  T607]  ? __dev_set_promiscuity+0x7b/0x1a0
[   33.944878][  T607]  __dev_set_promiscuity+0x7b/0x1a0
[   33.945758][  T607]  dev_set_promiscuity+0x1e/0x50
[   33.946582][  T607]  br_port_set_promisc+0x1f/0x40 [bridge]
[   33.947487][  T607]  br_manage_promisc+0x8b/0xe0 [bridge]
[   33.948388][  T607]  __dev_set_promiscuity+0x123/0x1a0
[   33.949244][  T607]  __dev_set_rx_mode+0x68/0x90
[   33.950021][  T607]  dev_uc_add+0x50/0x60
[   33.950720][  T607]  macvlan_open+0x18e/0x1f0 [macvlan]
[   33.951601][  T607]  __dev_open+0xd6/0x170
[   33.952269][  T607]  __dev_change_flags+0x181/0x1d0
[   33.953056][  T607]  rtnl_configure_link+0x2f/0xa0
[   33.953884][  T607]  __rtnl_newlink+0x6b9/0x8e0
[   33.954665][  T607]  ? __lock_acquire+0x95d/0x1f20
[   33.955450][  T607]  ? lock_acquire+0xaf/0x3a0
[   33.956193][  T607]  ? is_bpf_text_address+0x5/0xe0
[   33.956999][  T607]  rtnl_newlink+0x47/0x70

Acked-by: Guillaume Nault <gnault@redhat.com>
Fixes: 8d7e5dee972f ("netns: don't disable BHs when locking "nsid_lock"")
Reported-by: syzbot+3f960c64a104eaa2c813@syzkaller.appspotmail.com
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net_namespace.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -251,10 +251,10 @@ int peernet2id_alloc(struct net *net, st
 	if (refcount_read(&net->count) == 0)
 		return NETNSA_NSID_NOT_ASSIGNED;
 
-	spin_lock(&net->nsid_lock);
+	spin_lock_bh(&net->nsid_lock);
 	id = __peernet2id(net, peer);
 	if (id >= 0) {
-		spin_unlock(&net->nsid_lock);
+		spin_unlock_bh(&net->nsid_lock);
 		return id;
 	}
 
@@ -264,12 +264,12 @@ int peernet2id_alloc(struct net *net, st
 	 * just been idr_remove()'d from there in cleanup_net().
 	 */
 	if (!maybe_get_net(peer)) {
-		spin_unlock(&net->nsid_lock);
+		spin_unlock_bh(&net->nsid_lock);
 		return NETNSA_NSID_NOT_ASSIGNED;
 	}
 
 	id = alloc_netid(net, peer, -1);
-	spin_unlock(&net->nsid_lock);
+	spin_unlock_bh(&net->nsid_lock);
 
 	put_net(peer);
 	if (id < 0)
@@ -534,20 +534,20 @@ static void unhash_nsid(struct net *net,
 	for_each_net(tmp) {
 		int id;
 
-		spin_lock(&tmp->nsid_lock);
+		spin_lock_bh(&tmp->nsid_lock);
 		id = __peernet2id(tmp, net);
 		if (id >= 0)
 			idr_remove(&tmp->netns_ids, id);
-		spin_unlock(&tmp->nsid_lock);
+		spin_unlock_bh(&tmp->nsid_lock);
 		if (id >= 0)
 			rtnl_net_notifyid(tmp, RTM_DELNSID, id, 0, NULL,
 					  GFP_KERNEL);
 		if (tmp == last)
 			break;
 	}
-	spin_lock(&net->nsid_lock);
+	spin_lock_bh(&net->nsid_lock);
 	idr_destroy(&net->netns_ids);
-	spin_unlock(&net->nsid_lock);
+	spin_unlock_bh(&net->nsid_lock);
 }
 
 static LLIST_HEAD(cleanup_list);
@@ -760,9 +760,9 @@ static int rtnl_net_newid(struct sk_buff
 		return PTR_ERR(peer);
 	}
 
-	spin_lock(&net->nsid_lock);
+	spin_lock_bh(&net->nsid_lock);
 	if (__peernet2id(net, peer) >= 0) {
-		spin_unlock(&net->nsid_lock);
+		spin_unlock_bh(&net->nsid_lock);
 		err = -EEXIST;
 		NL_SET_BAD_ATTR(extack, nla);
 		NL_SET_ERR_MSG(extack,
@@ -771,7 +771,7 @@ static int rtnl_net_newid(struct sk_buff
 	}
 
 	err = alloc_netid(net, peer, nsid);
-	spin_unlock(&net->nsid_lock);
+	spin_unlock_bh(&net->nsid_lock);
 	if (err >= 0) {
 		rtnl_net_notifyid(net, RTM_NEWNSID, err, NETLINK_CB(skb).portid,
 				  nlh, GFP_KERNEL);


