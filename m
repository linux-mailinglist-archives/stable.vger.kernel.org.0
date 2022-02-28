Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B331D4C7284
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbiB1R0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbiB1R02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:26:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DD476E04;
        Mon, 28 Feb 2022 09:25:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DEB2B815AB;
        Mon, 28 Feb 2022 17:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9294C340F1;
        Mon, 28 Feb 2022 17:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069146;
        bh=yC33GZMrlqD0i2w93NF1iJJZDlo/CRXfu2IKUrbZvqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Biks0AlaBumy632OvNFKYRa6cjrhJFsvo0sKXYmisHB3I5LKg4BRXoiZZMJE7Rx6q
         J5rmufNbBUm0iaTD7AX1kZC+uZN0eptKHcB18aQGe29XGY9v70HTPNvihuamRl2CeZ
         ZPB/4ox7E8ZhmYFbjmpykQPjCyMx3CnQz3wPVByY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <thomas.liu@ucloud.cn>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 10/29] gso: do not skip outer ip header in case of ipip and net_failover
Date:   Mon, 28 Feb 2022 18:23:37 +0100
Message-Id: <20220228172142.482484537@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
References: <20220228172141.744228435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Liu <thomas.liu@ucloud.cn>

commit cc20cced0598d9a5ff91ae4ab147b3b5e99ee819 upstream.

We encounter a tcp drop issue in our cloud environment. Packet GROed in
host forwards to a VM virtio_net nic with net_failover enabled. VM acts
as a IPVS LB with ipip encapsulation. The full path like:
host gro -> vm virtio_net rx -> net_failover rx -> ipvs fullnat
 -> ipip encap -> net_failover tx -> virtio_net tx

When net_failover transmits a ipip pkt (gso_type = 0x0103, which means
SKB_GSO_TCPV4, SKB_GSO_DODGY and SKB_GSO_IPXIP4), there is no gso
did because it supports TSO and GSO_IPXIP4. But network_header points to
inner ip header.

Call Trace:
 tcp4_gso_segment        ------> return NULL
 inet_gso_segment        ------> inner iph, network_header points to
 ipip_gso_segment
 inet_gso_segment        ------> outer iph
 skb_mac_gso_segment

Afterwards virtio_net transmits the pkt, only inner ip header is modified.
And the outer one just keeps unchanged. The pkt will be dropped in remote
host.

Call Trace:
 inet_gso_segment        ------> inner iph, outer iph is skipped
 skb_mac_gso_segment
 __skb_gso_segment
 validate_xmit_skb
 validate_xmit_skb_list
 sch_direct_xmit
 __qdisc_run
 __dev_queue_xmit        ------> virtio_net
 dev_hard_start_xmit
 __dev_queue_xmit        ------> net_failover
 ip_finish_output2
 ip_output
 iptunnel_xmit
 ip_tunnel_xmit
 ipip_tunnel_xmit        ------> ipip
 dev_hard_start_xmit
 __dev_queue_xmit
 ip_finish_output2
 ip_output
 ip_forward
 ip_rcv
 __netif_receive_skb_one_core
 netif_receive_skb_internal
 napi_gro_receive
 receive_buf
 virtnet_poll
 net_rx_action

The root cause of this issue is specific with the rare combination of
SKB_GSO_DODGY and a tunnel device that adds an SKB_GSO_ tunnel option.
SKB_GSO_DODGY is set from external virtio_net. We need to reset network
header when callbacks.gso_segment() returns NULL.

This patch also includes ipv6_gso_segment(), considering SIT, etc.

Fixes: cb32f511a70b ("ipip: add GSO/TSO support")
Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/af_inet.c     |    5 ++++-
 net/ipv6/ip6_offload.c |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1238,8 +1238,11 @@ struct sk_buff *inet_gso_segment(struct
 	}
 
 	ops = rcu_dereference(inet_offloads[proto]);
-	if (likely(ops && ops->callbacks.gso_segment))
+	if (likely(ops && ops->callbacks.gso_segment)) {
 		segs = ops->callbacks.gso_segment(skb, features);
+		if (!segs)
+			skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
+	}
 
 	if (IS_ERR_OR_NULL(segs))
 		goto out;
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -96,6 +96,8 @@ static struct sk_buff *ipv6_gso_segment(
 	if (likely(ops && ops->callbacks.gso_segment)) {
 		skb_reset_transport_header(skb);
 		segs = ops->callbacks.gso_segment(skb, features);
+		if (!segs)
+			skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
 	}
 
 	if (IS_ERR_OR_NULL(segs))


