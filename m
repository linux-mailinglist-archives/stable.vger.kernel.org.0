Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A6D420CE8
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbhJDNKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235682AbhJDNIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:08:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0703A61507;
        Mon,  4 Oct 2021 13:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352574;
        bh=VXUGaDhtVoeZSSsU2IvHn6DYvzidLK0LF2xx5OmvA4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbvsY4THNac/6Kk7MR/o0dWRwEMKkyUS4WcOg+eR6n9M2iagHWmVh91UhcAKMx8Wc
         0LQVNnlD5naO6PDKGxXTMeHjWdd+tX/vHW+lGPJSWKHaLvGcU5jOkaEmLAHpkr7wGU
         aorjqtHFbLV18D6YzKqpCxk5HHbi0/4opgVknz/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/95] net/mlx4_en: Dont allow aRFS for encapsulated packets
Date:   Mon,  4 Oct 2021 14:51:52 +0200
Message-Id: <20211004125034.284315433@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit fdbccea419dc782079ce5881d2705cc9e3881480 ]

Driver doesn't support aRFS for encapsulated packets, return early error
in such a case.

Fixes: 1eb8c695bda9 ("net/mlx4_en: Add accelerated RFS support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index afd2dd8ebd73..d2a36c79714f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -372,6 +372,9 @@ mlx4_en_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
 	int nhoff = skb_network_offset(skb);
 	int ret = 0;
 
+	if (skb->encapsulation)
+		return -EPROTONOSUPPORT;
+
 	if (skb->protocol != htons(ETH_P_IP))
 		return -EPROTONOSUPPORT;
 
-- 
2.33.0



