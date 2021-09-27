Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E98419A2E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbhI0RHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235973AbhI0RGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83704611BD;
        Mon, 27 Sep 2021 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762304;
        bh=oykuXk5+eKoTA9NBaL8setZKnfPh8yGZDd5nJFID9GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pp6s8xtaehQYoXduta9Zlpbm4OK7I9nQJUcDmIflFWc+A2yGeJXFKeEZXqumM9Dm9
         xM+mZkXmQOzIJQ3X/tb93QJqQrCWrL215fHSwRp+sKIuz8IfHHy+sScU55pdbGhqyi
         rq4RgVdfmvv25jftwoTymvY8K6DtsmAy28t54a2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/68] net/mlx4_en: Dont allow aRFS for encapsulated packets
Date:   Mon, 27 Sep 2021 19:02:28 +0200
Message-Id: <20210927170221.081178868@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
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
index d7d20b7fae39..250177b5bcac 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -371,6 +371,9 @@ mlx4_en_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
 	int nhoff = skb_network_offset(skb);
 	int ret = 0;
 
+	if (skb->encapsulation)
+		return -EPROTONOSUPPORT;
+
 	if (skb->protocol != htons(ETH_P_IP))
 		return -EPROTONOSUPPORT;
 
-- 
2.33.0



