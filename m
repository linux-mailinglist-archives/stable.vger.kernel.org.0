Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DD566C8AD
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbjAPQlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbjAPQlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:41:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD8E3D0AC
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:29:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C67261058
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0972C433EF;
        Mon, 16 Jan 2023 16:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886565;
        bh=TDEAjpv6OXyS2VpgDx29bD+bXXZKdHgohv67L/H87lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GraySmRaX32Wx/8bVZYQvvRLC161cF8Ye5kW3VjyNVkpljXHp4pZL63UlCWroE7d1
         47+vxSx0/jfVOIBIAuTe+5HJJY8aWPzcYl8OttSeeeG815kXJ9QLrBPtZ/lrpeoHMm
         4lmv20oIp2OUHPsIbxVBZdIxTn8BDSHc36mIT7I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangbin Liu <liuhangbin@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 5.4 477/658] net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO
Date:   Mon, 16 Jan 2023 16:49:25 +0100
Message-Id: <20230116154931.299273580@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

commit dfed913e8b55a0c2c4906f1242fd38fd9a116e49 upstream.

Currently, the kernel drops GSO VLAN tagged packet if it's created with
socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.

The reason is AF_PACKET doesn't adjust the skb network header if there is
a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
is dropped as network header position is invalid.

Let's handle VLAN packets by adjusting network header position in
packet_parse_headers(). The adjustment is safe and does not affect the
later xmit as tap device also did that.

In packet_snd(), packet_parse_headers() need to be moved before calling
virtio_net_hdr_set_proto(), so we can set correct skb->protocol and
network header first.

There is no need to update tpacket_snd() as it calls packet_parse_headers()
in tpacket_fill_skb(), which is already before calling virtio_net_hdr_*
functions.

skb->no_fcs setting is also moved upper to make all skb settings together
and keep consistency with function packet_sendmsg_spkt().

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20220425014502.985464-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1864,12 +1864,20 @@ oom:
 
 static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 {
+	int depth;
+
 	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
 	    sock->type == SOCK_RAW) {
 		skb_reset_mac_header(skb);
 		skb->protocol = dev_parse_header_protocol(skb);
 	}
 
+	/* Move network header to the right position for VLAN tagged packets */
+	if (likely(skb->dev->type == ARPHRD_ETHER) &&
+	    eth_type_vlan(skb->protocol) &&
+	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
+		skb_set_network_header(skb, depth);
+
 	skb_probe_transport_header(skb);
 }
 
@@ -2979,6 +2987,11 @@ static int packet_snd(struct socket *soc
 	skb->mark = sockc.mark;
 	skb->tstamp = sockc.transmit_time;
 
+	if (unlikely(extra_len == 4))
+		skb->no_fcs = 1;
+
+	packet_parse_headers(skb, sock);
+
 	if (has_vnet_hdr) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
 		if (err)
@@ -2987,11 +3000,6 @@ static int packet_snd(struct socket *soc
 		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
-	packet_parse_headers(skb, sock);
-
-	if (unlikely(extra_len == 4))
-		skb->no_fcs = 1;
-
 	err = po->xmit(skb);
 	if (unlikely(err != 0)) {
 		if (err > 0)


