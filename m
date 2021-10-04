Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956DE420BED
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhJDNBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:32776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233795AbhJDM7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:59:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B560E6187D;
        Mon,  4 Oct 2021 12:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352255;
        bh=Lc7Q0zUu6vqlUij3rlYfeXXPmyerIA5WnyUQL0WNRYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtq2gVElzmho0xs35G9YVPL1FWlRrEitdQlPzOvPcoaU0jTF/wUeX5IO8j30J0v5D
         5+8a6tj0iGRg8WtaYW7TG6izBoBt3HO1cKpf/eNXnQioN2FaetDUGx3Ty/bvJ5TOAp
         j8FOPLhDXvm00fXAns6hGzdHQqLn4cDsrne0ZFjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 16/57] net/mlx4_en: Dont allow aRFS for encapsulated packets
Date:   Mon,  4 Oct 2021 14:52:00 +0200
Message-Id: <20211004125029.447900545@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125028.940212411@linuxfoundation.org>
References: <20211004125028.940212411@linuxfoundation.org>
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
index 437e30a5a314..cb3e6db20088 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -309,6 +309,9 @@ mlx4_en_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
 	int nhoff = skb_network_offset(skb);
 	int ret = 0;
 
+	if (skb->encapsulation)
+		return -EPROTONOSUPPORT;
+
 	if (skb->protocol != htons(ETH_P_IP))
 		return -EPROTONOSUPPORT;
 
-- 
2.33.0



