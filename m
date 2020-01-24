Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6511C148496
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389702AbgAXLNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:13:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389502AbgAXLNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:13:42 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A16420663;
        Fri, 24 Jan 2020 11:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864421;
        bh=R7TbViskE97d9rMMpX7vjsF0/3MofBwGTEbUaNw6LeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+oYtpDUk+KvFcVKz0gl8GmZuHeZfy+NK5kTmzP8NywgA6xQn3KaOtMI+fsyQhjC2
         JeFx4e5NtS2nu1MHuaT2Im05F3cEszo46yCOgrcVOKOmbYgmB1poonlKEkHvarqdLR
         s1wznaQK6wEjHYC3SAXzZAP/28V0jkjpbzvS50F4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feras Daoud <ferasda@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 260/639] net/mlx5e: IPoIB, Fix RX checksum statistics update
Date:   Fri, 24 Jan 2020 10:27:10 +0100
Message-Id: <20200124093119.306845192@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feras Daoud <ferasda@mellanox.com>

[ Upstream commit 3d6f3cdf9bfe92c430674308db0f1c8655f2c11d ]

Update the RX checksum only if the feature is enabled.

Fixes: 9d6bd752c63c ("net/mlx5e: IPoIB, RX handler")
Signed-off-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9cbc4173973e9..044687a1f27cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1364,8 +1364,14 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 
 	skb->protocol = *((__be16 *)(skb->data));
 
-	skb->ip_summed = CHECKSUM_COMPLETE;
-	skb->csum = csum_unfold((__force __sum16)cqe->check_sum);
+	if (netdev->features & NETIF_F_RXCSUM) {
+		skb->ip_summed = CHECKSUM_COMPLETE;
+		skb->csum = csum_unfold((__force __sum16)cqe->check_sum);
+		stats->csum_complete++;
+	} else {
+		skb->ip_summed = CHECKSUM_NONE;
+		stats->csum_none++;
+	}
 
 	if (unlikely(mlx5e_rx_hw_stamp(tstamp)))
 		skb_hwtstamps(skb)->hwtstamp =
@@ -1384,7 +1390,6 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 
 	skb->dev = netdev;
 
-	stats->csum_complete++;
 	stats->packets++;
 	stats->bytes += cqe_bcnt;
 }
-- 
2.20.1



