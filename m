Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8DE60FDE1
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbiJ0RAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbiJ0Q76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306B32CC9F
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4F0D623EB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7606C433D6;
        Thu, 27 Oct 2022 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889996;
        bh=uIN+5Ab9o8I14Q9lYB2aekxVXznqiPM/59cd4hdefLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLu667cva7so0IM7Kf7i7Ban0rSifkCqu6AwTMhllbNmWUj444xRXZ98XUqY0n6Fi
         7vl8PMxxrRWQrxJrSUi4BWDbPfJL+KDz+MJt4+/jq40JndQN2oM/8kuBQhtq9jQvIa
         Hva0QQM++1C5y//BKN4qvriKsQ3ekfB9wv086IOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Blakey <paulb@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 77/94] net: Fix return value of qdisc ingress handling on success
Date:   Thu, 27 Oct 2022 18:55:19 +0200
Message-Id: <20221027165100.305403960@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit 672e97ef689a38cb20c2cc6a1814298fea34461e ]

Currently qdisc ingress handling (sch_handle_ingress()) doesn't
set a return value and it is left to the old return value of
the caller (__netif_receive_skb_core()) which is RX drop, so if
the packet is consumed, caller will stop and return this value
as if the packet was dropped.

This causes a problem in the kernel tcp stack when having a
egress tc rule forwarding to a ingress tc rule.
The tcp stack sending packets on the device having the egress rule
will see the packets as not successfully transmitted (although they
actually were), will not advance it's internal state of sent data,
and packets returning on such tcp stream will be dropped by the tcp
stack with reason ack-of-unsent-data. See reproduction in [0] below.

Fix that by setting the return value to RX success if
the packet was handled successfully.

[0] Reproduction steps:
 $ ip link add veth1 type veth peer name peer1
 $ ip link add veth2 type veth peer name peer2
 $ ifconfig peer1 5.5.5.6/24 up
 $ ip netns add ns0
 $ ip link set dev peer2 netns ns0
 $ ip netns exec ns0 ifconfig peer2 5.5.5.5/24 up
 $ ifconfig veth2 0 up
 $ ifconfig veth1 0 up

 #ingress forwarding veth1 <-> veth2
 $ tc qdisc add dev veth2 ingress
 $ tc qdisc add dev veth1 ingress
 $ tc filter add dev veth2 ingress prio 1 proto all flower \
   action mirred egress redirect dev veth1
 $ tc filter add dev veth1 ingress prio 1 proto all flower \
   action mirred egress redirect dev veth2

 #steal packet from peer1 egress to veth2 ingress, bypassing the veth pipe
 $ tc qdisc add dev peer1 clsact
 $ tc filter add dev peer1 egress prio 20 proto ip flower \
   action mirred ingress redirect dev veth1

 #run iperf and see connection not running
 $ iperf3 -s&
 $ ip netns exec ns0 iperf3 -c 5.5.5.6 -i 1

 #delete egress rule, and run again, now should work
 $ tc filter del dev peer1 egress
 $ ip netns exec ns0 iperf3 -c 5.5.5.6 -i 1

Fixes: f697c3e8b35c ("[NET]: Avoid unnecessary cloning for ingress filtering")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 56c8b0921c9f..2c14f48d2457 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5136,11 +5136,13 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
 		kfree_skb_reason(skb, SKB_DROP_REASON_TC_INGRESS);
+		*ret = NET_RX_DROP;
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
 	case TC_ACT_TRAP:
 		consume_skb(skb);
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_REDIRECT:
 		/* skb_mac_header check was done by cls/act_bpf, so
@@ -5153,8 +5155,10 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 			*another = true;
 			break;
 		}
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_CONSUMED:
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	default:
 		break;
-- 
2.35.1



