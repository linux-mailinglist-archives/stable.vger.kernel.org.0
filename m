Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B286BB343
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbjCOMnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbjCOMmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:42:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6122A2C1B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:41:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85981CE19BF
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38A6C433EF;
        Wed, 15 Mar 2023 12:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884076;
        bh=TwIcYf7MZJ4YVx6S517a7KQ3JgmyO62xRTD5Xa97Tro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZ13yIEtARBcaq4VKPq26daYy+SzZjZoi90wZhVuXThfN3YVmFYqNuhepiFvZJRAX
         67l0Xqtx2+SqUyYKhDh3asdruwOCpthhvj5BKMLuVjvDGNbqpd17fYLXQBxjVLZAIX
         kbzJlqsDoNFzkB3CcyAS09vgAX7d7W9+jWsMXRII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 068/141] nfp: fix incorrectly set csum flag for nfd3 path
Date:   Wed, 15 Mar 2023 13:12:51 +0100
Message-Id: <20230315115742.027580932@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

[ Upstream commit 3e04419cbe2d0bc10ffc20c006c6513ffa4b1ca3 ]

The csum flag of IPsec packet are set repeatedly. Therefore, the csum
flag set of IPsec and non-IPsec packet need to be distinguished.

As the ipv6 header does not have a csum field, so l3-csum flag is not
required to be set for ipv6 case.

L4-csum flag include the tcp csum flag and udp csum flag, we shouldn't
set the udp and tcp csum flag at the same time for one packet, should
set l4-csum flag according to the transport layer is tcp or udp.

Fixes: 57f273adbcd4 ("nfp: add framework to support ipsec offloading")
Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  7 +++---
 .../net/ethernet/netronome/nfp/nfd3/ipsec.c   | 25 +++++++++++++++++--
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 861082c5dbffb..ee2e442809c69 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -327,14 +327,15 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 
 	/* Do not reorder - tso may adjust pkt cnt, vlan may override fields */
 	nfp_nfd3_tx_tso(r_vec, txbuf, txd, skb, md_bytes);
-	nfp_nfd3_tx_csum(dp, r_vec, txbuf, txd, skb);
+	if (ipsec)
+		nfp_nfd3_ipsec_tx(txd, skb);
+	else
+		nfp_nfd3_tx_csum(dp, r_vec, txbuf, txd, skb);
 	if (skb_vlan_tag_present(skb) && dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN) {
 		txd->flags |= NFD3_DESC_TX_VLAN;
 		txd->vlan = cpu_to_le16(skb_vlan_tag_get(skb));
 	}
 
-	if (ipsec)
-		nfp_nfd3_ipsec_tx(txd, skb);
 	/* Gather DMA */
 	if (nr_frags > 0) {
 		__le64 second_half;
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
index e90f8c975903b..51087693072c2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
@@ -10,9 +10,30 @@
 void nfp_nfd3_ipsec_tx(struct nfp_nfd3_tx_desc *txd, struct sk_buff *skb)
 {
 	struct xfrm_state *x = xfrm_input_state(skb);
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	struct iphdr *iph = ip_hdr(skb);
+	int l4_proto;
 
 	if (x->xso.dev && (x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM)) {
-		txd->flags |= NFD3_DESC_TX_CSUM | NFD3_DESC_TX_IP4_CSUM |
-			      NFD3_DESC_TX_TCP_CSUM | NFD3_DESC_TX_UDP_CSUM;
+		txd->flags |= NFD3_DESC_TX_CSUM;
+
+		if (iph->version == 4)
+			txd->flags |= NFD3_DESC_TX_IP4_CSUM;
+
+		if (x->props.mode == XFRM_MODE_TRANSPORT)
+			l4_proto = xo->proto;
+		else if (x->props.mode == XFRM_MODE_TUNNEL)
+			l4_proto = xo->inner_ipproto;
+		else
+			return;
+
+		switch (l4_proto) {
+		case IPPROTO_UDP:
+			txd->flags |= NFD3_DESC_TX_UDP_CSUM;
+			return;
+		case IPPROTO_TCP:
+			txd->flags |= NFD3_DESC_TX_TCP_CSUM;
+			return;
+		}
 	}
 }
-- 
2.39.2



