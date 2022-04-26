Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8521B50F7C3
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346529AbiDZJIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346763AbiDZJE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:04:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D712E6C59;
        Tue, 26 Apr 2022 01:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E38EBB81CFE;
        Tue, 26 Apr 2022 08:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46264C385AC;
        Tue, 26 Apr 2022 08:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962626;
        bh=tHBwQJ6rRcMp2aSFYxudKL5By5NcYvKgPRim1s1nXGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltmcHLHV/PLRDbL1yYbzsL5T9YAlzuuwC65Uc7bQA+UoAqqZ1gne0i99655ShJrYr
         ylvCW9jjzNx9bnRNQpEZRHWLhtx3ul5nGGC9jEAa+NxJp1E/iLHZxEa6EnSNg0i0VR
         FvTNpUMPnlDA/mP2USlKZu5wVEGu1ka08bF2L03E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feng Zhou <zhoufeng.zf@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 035/146] ip6_gre: Fix skb_under_panic in __gre6_xmit()
Date:   Tue, 26 Apr 2022 10:20:30 +0200
Message-Id: <20220426081751.054765959@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit ab198e1d0dd8dc4bc7575fb50758e2cbd51e14e1 ]

Feng reported an skb_under_panic BUG triggered by running
test_ip6gretap() in tools/testing/selftests/bpf/test_tunnel.sh:

[   82.492551] skbuff: skb_under_panic: text:ffffffffb268bb8e len:403 put:12 head:ffff9997c5480000 data:ffff9997c547fff8 tail:0x18b end:0x2c0 dev:ip6gretap11
<...>
[   82.607380] Call Trace:
[   82.609389]  <TASK>
[   82.611136]  skb_push.cold.109+0x10/0x10
[   82.614289]  __gre6_xmit+0x41e/0x590
[   82.617169]  ip6gre_tunnel_xmit+0x344/0x3f0
[   82.620526]  dev_hard_start_xmit+0xf1/0x330
[   82.623882]  sch_direct_xmit+0xe4/0x250
[   82.626961]  __dev_queue_xmit+0x720/0xfe0
<...>
[   82.633431]  packet_sendmsg+0x96a/0x1cb0
[   82.636568]  sock_sendmsg+0x30/0x40
<...>

The following sequence of events caused the BUG:

1. During ip6gretap device initialization, tunnel->tun_hlen (e.g. 4) is
   calculated based on old flags (see ip6gre_calc_hlen());
2. packet_snd() reserves header room for skb A, assuming
   tunnel->tun_hlen is 4;
3. Later (in clsact Qdisc), the eBPF program sets a new tunnel key for
   skb A using bpf_skb_set_tunnel_key() (see _ip6gretap_set_tunnel());
4. __gre6_xmit() detects the new tunnel key, and recalculates
   "tun_hlen" (e.g. 12) based on new flags (e.g. TUNNEL_KEY and
   TUNNEL_SEQ);
5. gre_build_header() calls skb_push() with insufficient reserved header
   room, triggering the BUG.

As sugguested by Cong, fix it by moving the call to skb_cow_head() after
the recalculation of tun_hlen.

Reproducer:

  OBJ=$LINUX/tools/testing/selftests/bpf/test_tunnel_kern.o

  ip netns add at_ns0
  ip link add veth0 type veth peer name veth1
  ip link set veth0 netns at_ns0
  ip netns exec at_ns0 ip addr add 172.16.1.100/24 dev veth0
  ip netns exec at_ns0 ip link set dev veth0 up
  ip link set dev veth1 up mtu 1500
  ip addr add dev veth1 172.16.1.200/24

  ip netns exec at_ns0 ip addr add ::11/96 dev veth0
  ip netns exec at_ns0 ip link set dev veth0 up
  ip addr add dev veth1 ::22/96
  ip link set dev veth1 up

  ip netns exec at_ns0 \
  	ip link add dev ip6gretap00 type ip6gretap seq flowlabel 0xbcdef key 2 \
  	local ::11 remote ::22

  ip netns exec at_ns0 ip addr add dev ip6gretap00 10.1.1.100/24
  ip netns exec at_ns0 ip addr add dev ip6gretap00 fc80::100/96
  ip netns exec at_ns0 ip link set dev ip6gretap00 up

  ip link add dev ip6gretap11 type ip6gretap external
  ip addr add dev ip6gretap11 10.1.1.200/24
  ip addr add dev ip6gretap11 fc80::200/24
  ip link set dev ip6gretap11 up

  tc qdisc add dev ip6gretap11 clsact
  tc filter add dev ip6gretap11 egress bpf da obj $OBJ sec ip6gretap_set_tunnel
  tc filter add dev ip6gretap11 ingress bpf da obj $OBJ sec ip6gretap_get_tunnel

  ping6 -c 3 -w 10 -q ::11

Fixes: 6712abc168eb ("ip6_gre: add ip6 gre and gretap collect_md mode")
Reported-by: Feng Zhou <zhoufeng.zf@bytedance.com>
Co-developed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index b43a46449130..976236736146 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -733,9 +733,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	else
 		fl6->daddr = tunnel->parms.raddr;
 
-	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
-		return -ENOMEM;
-
 	/* Push GRE header. */
 	protocol = (dev->type == ARPHRD_ETHER) ? htons(ETH_P_TEB) : proto;
 
@@ -763,6 +760,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 			(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
 		tun_hlen = gre_calc_hlen(flags);
 
+		if (skb_cow_head(skb, dev->needed_headroom ?: tun_hlen + tunnel->encap_hlen))
+			return -ENOMEM;
+
 		gre_build_header(skb, tun_hlen,
 				 flags, protocol,
 				 tunnel_id_to_key32(tun_info->key.tun_id),
@@ -773,6 +773,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		if (tunnel->parms.o_flags & TUNNEL_SEQ)
 			tunnel->o_seqno++;
 
+		if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
+			return -ENOMEM;
+
 		gre_build_header(skb, tunnel->tun_hlen, tunnel->parms.o_flags,
 				 protocol, tunnel->parms.o_key,
 				 htonl(tunnel->o_seqno));
-- 
2.35.1



