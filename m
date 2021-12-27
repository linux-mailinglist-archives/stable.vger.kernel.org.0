Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C674C47FF0E
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbhL0PfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:35:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39544 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbhL0Peq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:34:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9495CCE10AF;
        Mon, 27 Dec 2021 15:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80332C36AEA;
        Mon, 27 Dec 2021 15:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619284;
        bh=H7qLFCRVe/WtExWYZe1pbucg24PKnnInhWdglyJUEO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAL5IryKdfSjfiAYrjFUSjhGGZTMqJYHF4egVUCYW8Qbhn3VyR9K3HniLxLXM61hG
         SzFpc3sjTBPUdSjKEpo8SYpUajdDZEG5VKXyWu6mK82Jvx6Gs5HLX9nFKeaOQ44Aut
         igLJN0gwh19PY90mgUVepLNNytKHIS0+gTyRSOTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Melnichenko <andrew@daynix.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/47] net: accept UFOv6 packages in virtio_net_hdr_to_skb
Date:   Mon, 27 Dec 2021 16:30:45 +0100
Message-Id: <20211227151321.099657892@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 7e5cced9ca84df52d874aca6b632f930b3dc5bc6 ]

Skb with skb->protocol 0 at the time of virtio_net_hdr_to_skb may have
a protocol inferred from virtio_net_hdr with virtio_net_hdr_set_proto.

Unlike TCP, UDP does not have separate types for IPv4 and IPv6. Type
VIRTIO_NET_HDR_GSO_UDP is guessed to be IPv4/UDP. As of the below
commit, UFOv6 packets are dropped due to not matching the protocol as
obtained from dev_parse_header_protocol.

Invert the test to take that L2 protocol field as starting point and
pass both UFOv4 and UFOv6 for VIRTIO_NET_HDR_GSO_UDP.

Fixes: 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
Link: https://lore.kernel.org/netdev/CABcq3pG9GRCYqFDBAJ48H1vpnnX=41u+MhQnayF1ztLH4WX0Fw@mail.gmail.com/
Reported-by: Andrew Melnichenko <andrew@daynix.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20211220144901.2784030-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_net.h | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 04e87f4b9417c..22dd48c825600 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -7,6 +7,21 @@
 #include <uapi/linux/udp.h>
 #include <uapi/linux/virtio_net.h>
 
+static inline bool virtio_net_hdr_match_proto(__be16 protocol, __u8 gso_type)
+{
+	switch (gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
+	case VIRTIO_NET_HDR_GSO_TCPV4:
+		return protocol == cpu_to_be16(ETH_P_IP);
+	case VIRTIO_NET_HDR_GSO_TCPV6:
+		return protocol == cpu_to_be16(ETH_P_IPV6);
+	case VIRTIO_NET_HDR_GSO_UDP:
+		return protocol == cpu_to_be16(ETH_P_IP) ||
+		       protocol == cpu_to_be16(ETH_P_IPV6);
+	default:
+		return false;
+	}
+}
+
 static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 					   const struct virtio_net_hdr *hdr)
 {
@@ -88,9 +103,12 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			if (!skb->protocol) {
 				__be16 protocol = dev_parse_header_protocol(skb);
 
-				virtio_net_hdr_set_proto(skb, hdr);
-				if (protocol && protocol != skb->protocol)
+				if (!protocol)
+					virtio_net_hdr_set_proto(skb, hdr);
+				else if (!virtio_net_hdr_match_proto(protocol, hdr->gso_type))
 					return -EINVAL;
+				else
+					skb->protocol = protocol;
 			}
 retry:
 			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
-- 
2.34.1



