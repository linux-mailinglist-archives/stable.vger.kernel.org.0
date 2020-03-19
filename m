Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF0B18B426
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgCSNHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgCSNHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 254C320781;
        Thu, 19 Mar 2020 13:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623219;
        bh=37Q0VzHVs35DMggwk1CLuRYmLTNx/OILxzaKA6W2pto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2WDDgRddh12g4GOt3ih+k7pqf2c9CtL+VwL6Pm+P5XoRd/NSdW7i0udvz5qq86IP
         M9jD5Khu/nkJlHGIZT8DU/Bzx6kbvNkb5ACBqLkxjdLsefWD9trjo7LNuWnvDp7O3l
         wju3jJ81DUmogTFkftJt1IYcM/oI5hVzBwNXfOys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Weinelt <martin@darmstadt.freifunk.net>,
        =?UTF-8?q?Linus=20L=FCssing?= <linus.luessing@c0d3.blue>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 48/93] batman-adv: Avoid duplicate neigh_node additions
Date:   Thu, 19 Mar 2020 13:59:52 +0100
Message-Id: <20200319123940.292122929@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

commit e123705e58bf171be8c6eb0902ebfb5d6ed255ad upstream.

Two parallel calls to batadv_neigh_node_new() might race for creating
and adding the same neig_node. Fix this by including the check for any
already existing, identical neigh_node within the spin-lock.

This fixes splats like the following:

[  739.535069] ------------[ cut here ]------------
[  739.535079] WARNING: CPU: 0 PID: 0 at /usr/src/batman-adv/git/batman-adv/net/batman-adv/bat_iv_ogm.c:1004 batadv_iv_ogm_process_per_outif+0xe3f/0xe60 [batman_adv]()
[  739.535092] too many matching neigh_nodes
[  739.535094] Modules linked in: dm_mod tun ip6table_filter ip6table_mangle ip6table_nat nf_nat_ipv6 ip6_tables xt_nat iptable_nat nf_nat_ipv4 nf_nat xt_TCPMSS xt_mark iptable_mangle xt_tcpudp xt_conntrack iptable_filter ip_tables x_tables ip_gre ip_tunnel gre bridge stp llc thermal_sys kvm_intel kvm crct10dif_pclmul crc32_pclmul sha256_ssse3 sha256_generic hmac drbg ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd evdev pcspkr ip6_gre ip6_tunnel tunnel6 batman_adv(O) libcrc32c nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack autofs4 ext4 crc16 mbcache jbd2 xen_netfront xen_blkfront crc32c_intel
[  739.535177] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W  O    4.2.0-0.bpo.1-amd64 #1 Debian 4.2.6-3~bpo8+2
[  739.535186]  0000000000000000 ffffffffa013b050 ffffffff81554521 ffff88007d003c18
[  739.535201]  ffffffff8106fa01 0000000000000000 ffff8800047a087a ffff880079c3a000
[  739.735602]  ffff88007b82bf40 ffff88007bc2d1c0 ffffffff8106fa7a ffffffffa013aa8e
[  739.735624] Call Trace:
[  739.735639]  <IRQ>  [<ffffffff81554521>] ? dump_stack+0x40/0x50
[  739.735677]  [<ffffffff8106fa01>] ? warn_slowpath_common+0x81/0xb0
[  739.735692]  [<ffffffff8106fa7a>] ? warn_slowpath_fmt+0x4a/0x50
[  739.735715]  [<ffffffffa012448f>] ? batadv_iv_ogm_process_per_outif+0xe3f/0xe60 [batman_adv]
[  739.735740]  [<ffffffffa0124813>] ? batadv_iv_ogm_receive+0x363/0x380 [batman_adv]
[  739.735762]  [<ffffffffa0124813>] ? batadv_iv_ogm_receive+0x363/0x380 [batman_adv]
[  739.735783]  [<ffffffff810b0841>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[  739.735804]  [<ffffffffa012cb39>] ? batadv_batman_skb_recv+0xc9/0x110 [batman_adv]
[  739.735825]  [<ffffffff81464891>] ? __netif_receive_skb_core+0x841/0x9a0
[  739.735838]  [<ffffffff810b0841>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[  739.735853]  [<ffffffff81465681>] ? process_backlog+0xa1/0x140
[  739.735864]  [<ffffffff81464f1a>] ? net_rx_action+0x20a/0x320
[  739.735878]  [<ffffffff81073aa7>] ? __do_softirq+0x107/0x270
[  739.735891]  [<ffffffff81073d82>] ? irq_exit+0x92/0xa0
[  739.735905]  [<ffffffff8137e0d1>] ? xen_evtchn_do_upcall+0x31/0x40
[  739.735924]  [<ffffffff8155b8fe>] ? xen_do_hypervisor_callback+0x1e/0x40
[  739.735939]  <EOI>  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
[  739.735965]  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
[  739.735979]  [<ffffffff8100a39c>] ? xen_safe_halt+0xc/0x20
[  739.735991]  [<ffffffff8101da6c>] ? default_idle+0x1c/0xa0
[  739.736004]  [<ffffffff810abf6b>] ? cpu_startup_entry+0x2eb/0x350
[  739.736019]  [<ffffffff81b2af5e>] ? start_kernel+0x480/0x48b
[  739.736032]  [<ffffffff81b2d116>] ? xen_start_kernel+0x507/0x511
[  739.736048] ---[ end trace c106bb901244bc8c ]---

Fixes: f987ed6ebd99 ("batman-adv: protect neighbor list with rcu locks")
Reported-by: Martin Weinelt <martin@darmstadt.freifunk.net>
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/originator.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -462,6 +462,8 @@ batadv_neigh_node_new(struct batadv_orig
 {
 	struct batadv_neigh_node *neigh_node;
 
+	spin_lock_bh(&orig_node->neigh_list_lock);
+
 	neigh_node = batadv_neigh_node_get(orig_node, hard_iface, neigh_addr);
 	if (neigh_node)
 		goto out;
@@ -488,15 +490,15 @@ batadv_neigh_node_new(struct batadv_orig
 	/* extra reference for return */
 	atomic_set(&neigh_node->refcount, 2);
 
-	spin_lock_bh(&orig_node->neigh_list_lock);
 	hlist_add_head_rcu(&neigh_node->list, &orig_node->neigh_list);
-	spin_unlock_bh(&orig_node->neigh_list_lock);
 
 	batadv_dbg(BATADV_DBG_BATMAN, orig_node->bat_priv,
 		   "Creating new neighbor %pM for orig_node %pM on interface %s\n",
 		   neigh_addr, orig_node->orig, hard_iface->net_dev->name);
 
 out:
+	spin_unlock_bh(&orig_node->neigh_list_lock);
+
 	return neigh_node;
 }
 


