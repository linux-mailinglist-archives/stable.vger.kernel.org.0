Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AB05B7205
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiIMOuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbiIMOtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D708070E5E;
        Tue, 13 Sep 2022 07:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C5B5614B0;
        Tue, 13 Sep 2022 14:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A341AC433C1;
        Tue, 13 Sep 2022 14:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079013;
        bh=XfoVHhO2KwoVqCnflZpVxrBPhafIjjfzPTnfE+4PjpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9z/j6/MN8qA+dcTH65z+k7ekzeQse0fi+B6kVCCnEKhOEdD8R+fq/9esOs4gEn5I
         UIBsBN/HLp7sTmgYlBty5YJfA3pQ0fyVsy46/asUwWHnRP/fgT9NRGRYjcSWW7uNAx
         qnappy6CDeuKHB8QwtbT/d99LFwj85R36tS101so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harsh Modi <harshmodi@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/79] netfilter: br_netfilter: Drop dst references before setting.
Date:   Tue, 13 Sep 2022 16:04:53 +0200
Message-Id: <20220913140352.580765780@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harsh Modi <harshmodi@google.com>

[ Upstream commit d047283a7034140ea5da759a494fd2274affdd46 ]

The IPv6 path already drops dst in the daddr changed case, but the IPv4
path does not. This change makes the two code paths consistent.

Further, it is possible that there is already a metadata_dst allocated from
ingress that might already be attached to skbuff->dst while following
the bridge path. If it is not released before setting a new
metadata_dst, it will be leaked. This is similar to what is done in
bpf_set_tunnel_key() or ip6_route_input().

It is important to note that the memory being leaked is not the dst
being set in the bridge code, but rather memory allocated from some
other code path that is not being freed correctly before the skb dst is
overwritten.

An example of the leakage fixed by this commit found using kmemleak:

unreferenced object 0xffff888010112b00 (size 256):
  comm "softirq", pid 0, jiffies 4294762496 (age 32.012s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 80 16 f1 83 ff ff ff ff  ................
    e1 4e f6 82 ff ff ff ff 00 00 00 00 00 00 00 00  .N..............
  backtrace:
    [<00000000d79567ea>] metadata_dst_alloc+0x1b/0xe0
    [<00000000be113e13>] udp_tun_rx_dst+0x174/0x1f0
    [<00000000a36848f4>] geneve_udp_encap_recv+0x350/0x7b0
    [<00000000d4afb476>] udp_queue_rcv_one_skb+0x380/0x560
    [<00000000ac064aea>] udp_unicast_rcv_skb+0x75/0x90
    [<000000009a8ee8c5>] ip_protocol_deliver_rcu+0xd8/0x230
    [<00000000ef4980bb>] ip_local_deliver_finish+0x7a/0xa0
    [<00000000d7533c8c>] __netif_receive_skb_one_core+0x89/0xa0
    [<00000000a879497d>] process_backlog+0x93/0x190
    [<00000000e41ade9f>] __napi_poll+0x28/0x170
    [<00000000b4c0906b>] net_rx_action+0x14f/0x2a0
    [<00000000b20dd5d4>] __do_softirq+0xf4/0x305
    [<000000003a7d7e15>] __irq_exit_rcu+0xc3/0x140
    [<00000000968d39a2>] sysvec_apic_timer_interrupt+0x9e/0xc0
    [<000000009e920794>] asm_sysvec_apic_timer_interrupt+0x16/0x20
    [<000000008942add0>] native_safe_halt+0x13/0x20

Florian Westphal says: "Original code was likely fine because nothing
ever did set a skb->dst entry earlier than bridge in those days."

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Harsh Modi <harshmodi@google.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netfilter_hooks.c | 2 ++
 net/bridge/br_netfilter_ipv6.c  | 1 +
 2 files changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 10a2c7bca7199..a718204c4bfdd 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -384,6 +384,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 				/* - Bridged-and-DNAT'ed traffic doesn't
 				 *   require ip_forwarding. */
 				if (rt->dst.dev == dev) {
+					skb_dst_drop(skb);
 					skb_dst_set(skb, &rt->dst);
 					goto bridged_dnat;
 				}
@@ -413,6 +414,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index e4e0c836c3f51..6b07f30675bb0 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -197,6 +197,7 @@ static int br_nf_pre_routing_finish_ipv6(struct net *net, struct sock *sk, struc
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
-- 
2.35.1



