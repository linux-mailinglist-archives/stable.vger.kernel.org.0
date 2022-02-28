Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13144C73CE
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238311AbiB1Rif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238700AbiB1RiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:38:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486FB580DF;
        Mon, 28 Feb 2022 09:33:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE3B61359;
        Mon, 28 Feb 2022 17:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69D5C340E7;
        Mon, 28 Feb 2022 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069614;
        bh=Ef5KvnxkJ6Iv+ke4WtsG7da/lgdJDeo+xBjd0/3QwCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7MMXh3IOvqyjz22OlOZdRBJdyO2MhJR4ahO+somweMK/kMgPwATHULogJiQnoLST
         hbUjLUoZnj3OLBNbjgWYC3k/sZ9TXAPSFM3Vc9ctwf2cNLsJbZCGteCbUuzLbWfLQf
         XsXz/58cwX+qOsS2RQcQu8Zqw6PTcPjQSWOxneM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <thomas.liu@ucloud.cn>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 30/80] gso: do not skip outer ip header in case of ipip and net_failover
Date:   Mon, 28 Feb 2022 18:24:11 +0100
Message-Id: <20220228172315.246668594@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
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
@@ -1374,8 +1374,11 @@ struct sk_buff *inet_gso_segment(struct
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
@@ -113,6 +113,8 @@ static struct sk_buff *ipv6_gso_segment(
 	if (likely(ops && ops->callbacks.gso_segment)) {
 		skb_reset_transport_header(skb);
 		segs = ops->callbacks.gso_segment(skb, features);
+		if (!segs)
+			skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
 	}
 
 	if (IS_ERR_OR_NULL(segs))


