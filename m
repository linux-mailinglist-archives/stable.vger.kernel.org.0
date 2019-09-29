Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17D93C14CD
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbfI2N6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfI2N6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F40A21882;
        Sun, 29 Sep 2019 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765482;
        bh=4OUpF6soZwSpSA/Bi5kTX+rRqC5xgUKzEdUIw5cqoFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEGO8ghveRBVaVta0en7Eh+5DUnreEVRUXSMD2/WIchr+NS/OWIdwVj743IM1v2PS
         EEArYNZHqrOvE+uxLQeBT/15LqyS6G7PL+DgzM6bWhUuUlaHowLFcA6WG+0h8tBc4j
         iMe/MYC3KR97FU3woJcXv0X2LazItvSUjUdzYINs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 17/63] mlx5: fix get_ip_proto()
Date:   Sun, 29 Sep 2019 15:53:50 +0200
Message-Id: <20190929135035.269253760@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit ef6fcd455278c2be3032a346cc66d9dd9866b787 ]

IP header is not necessarily located right after struct ethhdr,
there could be multiple 802.1Q headers in between, this is why
we call __vlan_get_protocol().

Fixes: fe1dc069990c ("net/mlx5e: don't set CHECKSUM_COMPLETE on SCTP packets")
Cc: Alaa Hleihel <alaa@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -725,9 +725,9 @@ static u32 mlx5e_get_fcs(const struct sk
 	return __get_unaligned_cpu32(fcs_bytes);
 }
 
-static u8 get_ip_proto(struct sk_buff *skb, __be16 proto)
+static u8 get_ip_proto(struct sk_buff *skb, int network_depth, __be16 proto)
 {
-	void *ip_p = skb->data + sizeof(struct ethhdr);
+	void *ip_p = skb->data + network_depth;
 
 	return (proto == htons(ETH_P_IP)) ? ((struct iphdr *)ip_p)->protocol :
 					    ((struct ipv6hdr *)ip_p)->nexthdr;
@@ -766,7 +766,7 @@ static inline void mlx5e_handle_csum(str
 		goto csum_unnecessary;
 
 	if (likely(is_last_ethertype_ip(skb, &network_depth, &proto))) {
-		if (unlikely(get_ip_proto(skb, proto) == IPPROTO_SCTP))
+		if (unlikely(get_ip_proto(skb, network_depth, proto) == IPPROTO_SCTP))
 			goto csum_unnecessary;
 
 		skb->ip_summed = CHECKSUM_COMPLETE;


