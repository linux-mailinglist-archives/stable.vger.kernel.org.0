Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D84647FEA2
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbhL0Pam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:30:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60042 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237648AbhL0P33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:29:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55FB5610A7;
        Mon, 27 Dec 2021 15:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE21C36AEA;
        Mon, 27 Dec 2021 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618968;
        bh=QOfcTuxHylX/Q66Am8z7uBFzVY5vzDckccPl0RX1Kxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDykEZJ/gzzAGvrdJBjE46fJvyo22MzZRkjPC7s3Yyk8/EsvNpWAzv7835pSFpPzA
         vbzeOOtJZZ6iyGNDsBlGO9FqZUwqkEna3UbYNSC6oHlo+4qXlABLGmAqyjHifMkey/
         UZFM3f9gL0D1PA2iOFOnZHZfHIHFEZZzbEaPJ8Zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Melnichenko <andrew@daynix.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/29] net: accept UFOv6 packages in virtio_net_hdr_to_skb
Date:   Mon, 27 Dec 2021 16:27:18 +0100
Message-Id: <20211227151318.745200077@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
References: <20211227151318.475251079@linuxfoundation.org>
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
index 162761f72c142..f5876f7a2ab24 100644
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
 			if (!skb_flow_dissect_flow_keys(skb, &keys, 0)) {
-- 
2.34.1



