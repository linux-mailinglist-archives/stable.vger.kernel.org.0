Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81526C15FF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjCTPBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbjCTPAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE632BF14
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:57:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB466158C
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1037C4339E;
        Mon, 20 Mar 2023 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324235;
        bh=1XAkOSnNH4I9ZPcymoFyqJfNCSszTJczGwhZAWsi6C4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFDRjbLNaq94HUvuuXkgP05ZnduswguvKUkbuZkQqVmVoJp2Fdczf5NaOcmWMgcUg
         ncPIUWqErcqEq0NU9z+0uyEH3823LTrbeWpu0R9rJ40W2LrQCISoZ7GpqAc/DW4XlD
         8lZK1zoOpGHhSIra6sUKY25ODc+OhiFq5JCLwbDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/30] net: tunnels: annotate lockless accesses to dev->needed_headroom
Date:   Mon, 20 Mar 2023 15:54:30 +0100
Message-Id: <20230320145420.473034354@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
References: <20230320145420.204894191@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4b397c06cb987935b1b097336532aa6b4210e091 ]

IP tunnels can apparently update dev->needed_headroom
in their xmit path.

This patch takes care of three tunnels xmit, and also the
core LL_RESERVED_SPACE() and LL_RESERVED_SPACE_EXTRA()
helpers.

More changes might be needed for completeness.

BUG: KCSAN: data-race in ip_tunnel_xmit / ip_tunnel_xmit

read to 0xffff88815b9da0ec of 2 bytes by task 888 on cpu 1:
ip_tunnel_xmit+0x1270/0x1730 net/ipv4/ip_tunnel.c:803
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip_finish_output2+0x740/0x840 net/ipv4/ip_output.c:228
ip_finish_output+0xf4/0x240 net/ipv4/ip_output.c:316
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip_output+0xe5/0x1b0 net/ipv4/ip_output.c:430
dst_output include/net/dst.h:444 [inline]
ip_local_out+0x64/0x80 net/ipv4/ip_output.c:126
iptunnel_xmit+0x34a/0x4b0 net/ipv4/ip_tunnel_core.c:82
ip_tunnel_xmit+0x1451/0x1730 net/ipv4/ip_tunnel.c:813
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246

write to 0xffff88815b9da0ec of 2 bytes by task 2379 on cpu 0:
ip_tunnel_xmit+0x1294/0x1730 net/ipv4/ip_tunnel.c:804
__gre_xmit net/ipv4/ip_gre.c:469 [inline]
ipgre_xmit+0x516/0x570 net/ipv4/ip_gre.c:661
__netdev_start_xmit include/linux/netdevice.h:4881 [inline]
netdev_start_xmit include/linux/netdevice.h:4895 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x127/0x400 net/core/dev.c:3596
__dev_queue_xmit+0x1007/0x1eb0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3051 [inline]
neigh_direct_output+0x17/0x20 net/core/neighbour.c:1623
neigh_output include/net/neighbour.h:546 [inline]
ip6_finish_output2+0x9bc/0xc50 net/ipv6/ip6_output.c:134
__ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
ip6_finish_output+0x39a/0x4e0 net/ipv6/ip6_output.c:206
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip6_output+0xeb/0x220 net/ipv6/ip6_output.c:227
dst_output include/net/dst.h:444 [inline]
NF_HOOK include/linux/netfilter.h:302 [inline]
mld_sendpack+0x438/0x6a0 net/ipv6/mcast.c:1820
mld_send_cr net/ipv6/mcast.c:2121 [inline]
mld_ifc_work+0x519/0x7b0 net/ipv6/mcast.c:2653
process_one_work+0x3e6/0x750 kernel/workqueue.c:2390
worker_thread+0x5f2/0xa10 kernel/workqueue.c:2537
kthread+0x1ac/0x1e0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

value changed: 0x0dd4 -> 0x0e14

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 2379 Comm: kworker/0:0 Not tainted 6.3.0-rc1-syzkaller-00002-g8ca09d5fa354-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Workqueue: mld mld_ifc_work

Fixes: 8eb30be0352d ("ipv6: Create ip6_tnl_xmit")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230310191109.2384387-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  6 ++++--
 net/ipv4/ip_tunnel.c      | 12 ++++++------
 net/ipv6/ip6_tunnel.c     |  4 ++--
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1edc2af51e038..2cd7eb2b91739 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -258,9 +258,11 @@ struct hh_cache {
  * relationship HH alignment <= LL alignment.
  */
 #define LL_RESERVED_SPACE(dev) \
-	((((dev)->hard_header_len+(dev)->needed_headroom)&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom)) \
+	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 #define LL_RESERVED_SPACE_EXTRA(dev,extra) \
-	((((dev)->hard_header_len+(dev)->needed_headroom+(extra))&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom) + (extra)) \
+	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 
 struct header_ops {
 	int	(*create) (struct sk_buff *skb, struct net_device *dev,
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index e9cf0d1854595..f0e4b3381258c 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -609,10 +609,10 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev, u8 proto)
 	else if (skb->protocol == htons(ETH_P_IP))
 		df = inner_iph->frag_off & htons(IP_DF);
 	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
-	if (headroom > dev->needed_headroom)
-		dev->needed_headroom = headroom;
+	if (headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, headroom);
 
-	if (skb_cow_head(skb, dev->needed_headroom)) {
+	if (skb_cow_head(skb, READ_ONCE(dev->needed_headroom))) {
 		ip_rt_put(rt);
 		goto tx_dropped;
 	}
@@ -786,10 +786,10 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	max_headroom = LL_RESERVED_SPACE(rt->dst.dev) + sizeof(struct iphdr)
 			+ rt->dst.header_len + ip_encap_hlen(&tunnel->encap);
-	if (max_headroom > dev->needed_headroom)
-		dev->needed_headroom = max_headroom;
+	if (max_headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, max_headroom);
 
-	if (skb_cow_head(skb, dev->needed_headroom)) {
+	if (skb_cow_head(skb, READ_ONCE(dev->needed_headroom))) {
 		ip_rt_put(rt);
 		dev->stats.tx_dropped++;
 		kfree_skb(skb);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 639440032c2b8..d59bf0da29124 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1200,8 +1200,8 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	 */
 	max_headroom = LL_RESERVED_SPACE(dst->dev) + sizeof(struct ipv6hdr)
 			+ dst->header_len + t->hlen;
-	if (max_headroom > dev->needed_headroom)
-		dev->needed_headroom = max_headroom;
+	if (max_headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, max_headroom);
 
 	err = ip6_tnl_encap(skb, t, &proto, fl6);
 	if (err)
-- 
2.39.2



