Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C603E3788D5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhEJLYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232113AbhEJLLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA65D61924;
        Mon, 10 May 2021 11:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644966;
        bh=iWExxXiCDQzUfgzXXr/E4mZPbsi6kipT5A/Mmq3YgxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuuZy/c85u/H2Byp5YbQvXhmxWGi6qRW4GrbLnhzpxfNcg2fJQrxANX9dc/HyR3Uf
         6rfgbOaUVHMHRf32BIfYMZLL9BQIyCMV3B8Af5GkqkBJrA/gR4H5XSyQkf+EHMHdAV
         NOOEYfOrHqmiCFJLiTBTcNLNyCKbFePgkTHSWXyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 295/384] openvswitch: fix stack OOB read while fragmenting IPv4 packets
Date:   Mon, 10 May 2021 12:21:24 +0200
Message-Id: <20210510102024.536293294@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

commit 7c0ea5930c1c211931819d83cfb157bff1539a4c upstream.

running openvswitch on kernels built with KASAN, it's possible to see the
following splat while testing fragmentation of IPv4 packets:

 BUG: KASAN: stack-out-of-bounds in ip_do_fragment+0x1b03/0x1f60
 Read of size 1 at addr ffff888112fc713c by task handler2/1367

 CPU: 0 PID: 1367 Comm: handler2 Not tainted 5.12.0-rc6+ #418
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 Call Trace:
  dump_stack+0x92/0xc1
  print_address_description.constprop.7+0x1a/0x150
  kasan_report.cold.13+0x7f/0x111
  ip_do_fragment+0x1b03/0x1f60
  ovs_fragment+0x5bf/0x840 [openvswitch]
  do_execute_actions+0x1bd5/0x2400 [openvswitch]
  ovs_execute_actions+0xc8/0x3d0 [openvswitch]
  ovs_packet_cmd_execute+0xa39/0x1150 [openvswitch]
  genl_family_rcv_msg_doit.isra.15+0x227/0x2d0
  genl_rcv_msg+0x287/0x490
  netlink_rcv_skb+0x120/0x380
  genl_rcv+0x24/0x40
  netlink_unicast+0x439/0x630
  netlink_sendmsg+0x719/0xbf0
  sock_sendmsg+0xe2/0x110
  ____sys_sendmsg+0x5ba/0x890
  ___sys_sendmsg+0xe9/0x160
  __sys_sendmsg+0xd3/0x170
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f957079db07
 Code: c3 66 90 41 54 41 89 d4 55 48 89 f5 53 89 fb 48 83 ec 10 e8 eb ec ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 44 24 08 e8 24 ed ff ff 48
 RSP: 002b:00007f956ce35a50 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 0000000000000019 RCX: 00007f957079db07
 RDX: 0000000000000000 RSI: 00007f956ce35ae0 RDI: 0000000000000019
 RBP: 00007f956ce35ae0 R08: 0000000000000000 R09: 00007f9558006730
 R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
 R13: 00007f956ce37308 R14: 00007f956ce35f80 R15: 00007f956ce35ae0

 The buggy address belongs to the page:
 page:00000000af2a1d93 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x112fc7
 flags: 0x17ffffc0000000()
 raw: 0017ffffc0000000 0000000000000000 dead000000000122 0000000000000000
 raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 addr ffff888112fc713c is located in stack of task handler2/1367 at offset 180 in frame:
  ovs_fragment+0x0/0x840 [openvswitch]

 this frame has 2 objects:
  [32, 144) 'ovs_dst'
  [192, 424) 'ovs_rt'

 Memory state around the buggy address:
  ffff888112fc7000: f3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff888112fc7080: 00 f1 f1 f1 f1 00 00 00 00 00 00 00 00 00 00 00
 >ffff888112fc7100: 00 00 00 f2 f2 f2 f2 f2 f2 00 00 00 00 00 00 00
                                         ^
  ffff888112fc7180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff888112fc7200: 00 00 00 00 00 00 f2 f2 f2 00 00 00 00 00 00 00

for IPv4 packets, ovs_fragment() uses a temporary struct dst_entry. Then,
in the following call graph:

  ip_do_fragment()
    ip_skb_dst_mtu()
      ip_dst_mtu_maybe_forward()
        ip_mtu_locked()

the pointer to struct dst_entry is used as pointer to struct rtable: this
turns the access to struct members like rt_mtu_locked into an OOB read in
the stack. Fix this changing the temporary variable used for IPv4 packets
in ovs_fragment(), similarly to what is done for IPv6 few lines below.

Fixes: d52e5a7e7ca4 ("ipv4: lock mtu in fnhe when received PMTU < net.ipv4.route.min_pmt")
Cc: <stable@vger.kernel.org>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -827,17 +827,17 @@ static void ovs_fragment(struct net *net
 	}
 
 	if (key->eth.type == htons(ETH_P_IP)) {
-		struct dst_entry ovs_dst;
+		struct rtable ovs_rt = { 0 };
 		unsigned long orig_dst;
 
 		prepare_frag(vport, skb, orig_network_offset,
 			     ovs_key_mac_proto(key));
-		dst_init(&ovs_dst, &ovs_dst_ops, NULL, 1,
+		dst_init(&ovs_rt.dst, &ovs_dst_ops, NULL, 1,
 			 DST_OBSOLETE_NONE, DST_NOCOUNT);
-		ovs_dst.dev = vport->dev;
+		ovs_rt.dst.dev = vport->dev;
 
 		orig_dst = skb->_skb_refdst;
-		skb_dst_set_noref(skb, &ovs_dst);
+		skb_dst_set_noref(skb, &ovs_rt.dst);
 		IPCB(skb)->frag_max_size = mru;
 
 		ip_do_fragment(net, skb->sk, skb, ovs_vport_output);


