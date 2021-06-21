Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732283AED6A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhFUQT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231226AbhFUQTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:19:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7372561164;
        Mon, 21 Jun 2021 16:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292242;
        bh=W+ke9zJyqw84kUdH9XSWVdJY9U6zwa4GfhYkxYxSdVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ae5KtWnZa9NiM+467VyD+SH/fEGUlWa+KOYYbhoR8aJOjBOUpqlsr4Y21RW+QzE23
         U52dgxx68zTvmjQEXgOu+eC4fQIkTS7J+h7zLJKW8r3Z1r7uhQu9PTU5v+KlAzOGyr
         XddmfLnQr6Rcle/Hef8qbENAin3qmWEt1owykeIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/90] net/mlx5e: allow TSO on VXLAN over VLAN topologies
Date:   Mon, 21 Jun 2021 18:14:53 +0200
Message-Id: <20210621154904.754908745@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit a1718505d7f67ee0ab051322f1cbc7ac42b5da82 ]

since mlx5 hardware can segment correctly TSO packets on VXLAN over VLAN
topologies, CPU usage can improve significantly if we enable tunnel
offloads in dev->vlan_features, like it was done in the past with other
NIC drivers (e.g. mlx4, be2net and ixgbe).

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 36b9a364ef26..374ce17e1499 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5012,6 +5012,8 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL |
 					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL |
+					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 
 	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_GRE)) {
-- 
2.30.2



