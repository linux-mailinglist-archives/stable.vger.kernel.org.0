Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E2042902D
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238330AbhJKOFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240158AbhJKODo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:03:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A411611B0;
        Mon, 11 Oct 2021 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960729;
        bh=HLdCo8F8PP7XUQxj6QqPJcmWVho25bVJcAIXLb6PbGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF1QNs4J6j3U5Icy4HeaUcTPb0RLfPuepIbtZHjZ3ABa5BH5lHuZo8Yu5Y24m2kMk
         6nfiKXX5NSBff+NllyZuiLqrheZy0lmVtmjWBvU9826exrIlbbEc5OLb2jdkJO/aEd
         qjrjoJV8oZcE5ufaJhnWh005dlx+lwimVgv6C1rQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 058/151] net/mlx5e: IPSEC RX, enable checksum complete
Date:   Mon, 11 Oct 2021 15:45:30 +0200
Message-Id: <20211011134519.721551472@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

[ Upstream commit f9a10440f0b1f33faa792af26f4e9823a9b8b6a4 ]

Currently in Rx data path IPsec crypto offloaded packets uses
csum_none flag, so checksum is handled by the stack, this naturally
have some performance/cpu utilization impact on such flows. As Nvidia
NIC starting from ConnectX6DX provides checksum complete value out of
the box also for such flows there is no sense in taking csum_none path,
furthermore the stack (xfrm) have the method to handle checksum complete
corrections for such flows i.e. IPsec trailer removal and consequently
checksum value adjustment.

Because of the above and in addition the ConnectX6DX is the first HW
which supports IPsec crypto offload then it is safe to report csum
complete for IPsec offloaded traffic.

Fixes: b2ac7541e377 ("net/mlx5e: IPsec: Add Connect-X IPsec Rx data path offload")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 3c65fd0bcf31..29a6586ef28d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1001,14 +1001,9 @@ static inline void mlx5e_handle_csum(struct net_device *netdev,
 		goto csum_unnecessary;
 
 	if (likely(is_last_ethertype_ip(skb, &network_depth, &proto))) {
-		u8 ipproto = get_ip_proto(skb, network_depth, proto);
-
-		if (unlikely(ipproto == IPPROTO_SCTP))
+		if (unlikely(get_ip_proto(skb, network_depth, proto) == IPPROTO_SCTP))
 			goto csum_unnecessary;
 
-		if (unlikely(mlx5_ipsec_is_rx_flow(cqe)))
-			goto csum_none;
-
 		stats->csum_complete++;
 		skb->ip_summed = CHECKSUM_COMPLETE;
 		skb->csum = csum_unfold((__force __sum16)cqe->check_sum);
-- 
2.33.0



