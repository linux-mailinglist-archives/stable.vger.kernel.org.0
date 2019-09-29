Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62301C14D0
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfI2N6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfI2N6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 103E321882;
        Sun, 29 Sep 2019 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765495;
        bh=1UXddJBhGzTR7X65RIq+VFUTwq0rTKPxvadhmJrHFxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ok/zQek4ZvrfAT+RbRXX9TbBmHMwyT4xN53ifXrI4U2DliLXQZ3xuJ50Mu6lkbmnn
         Yh3p+kWH2vIwwIZuUHFdHZYcv44PPJ3lfvYqJmL5PthHBE9r5W4cNnEqztephORmAf
         XAv0OnORfEUkb+F1PEvoD5gptsjwTcVbllUrEBtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 21/63] net/mlx5e: Rx, Check ip headers sanity
Date:   Sun, 29 Sep 2019 15:53:54 +0200
Message-Id: <20190929135036.383440709@linuxfoundation.org>
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

From: Saeed Mahameed <saeedm@mellanox.com>

[ Upstream commit 0318a7b7fcad9765931146efa7ca3a034194737c ]

In the two places is_last_ethertype_ip is being called, the caller will
be looking inside the ip header, to be safe, add ip{4,6} header sanity
check. And return true only on valid ip headers, i.e: the whole header
is contained in the linear part of the skb.

Note: Such situation is very rare and hard to reproduce, since mlx5e
allocates a large enough headroom to contain the largest header one can
imagine.

Fixes: fe1dc069990c ("net/mlx5e: don't set CHECKSUM_COMPLETE on SCTP packets")
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -694,7 +694,14 @@ static inline bool is_last_ethertype_ip(
 {
 	*proto = ((struct ethhdr *)skb->data)->h_proto;
 	*proto = __vlan_get_protocol(skb, *proto, network_depth);
-	return (*proto == htons(ETH_P_IP) || *proto == htons(ETH_P_IPV6));
+
+	if (*proto == htons(ETH_P_IP))
+		return pskb_may_pull(skb, *network_depth + sizeof(struct iphdr));
+
+	if (*proto == htons(ETH_P_IPV6))
+		return pskb_may_pull(skb, *network_depth + sizeof(struct ipv6hdr));
+
+	return false;
 }
 
 static inline void mlx5e_enable_ecn(struct mlx5e_rq *rq, struct sk_buff *skb)


