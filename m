Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62CEF11B4EF
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbfLKPXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731717AbfLKPXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C842173E;
        Wed, 11 Dec 2019 15:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077825;
        bh=JsIC5CV+h7wmbyXfmTd2M9dfvD94GrrUw0tE3n+hI6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ab8KXeiSwkRioeV5ze3WK+kWit0Pjyw92J3vQuohRIFkamkc4ufX4ElAsdJy7BZKD
         s7a0bvxcmTV7Gci7pdYMXgRlcqUjBcw7RF85orUspLg6TVZJ2xnYc9KKIiUG271JPa
         Pah3KkM+hPlHfzXe6FfOj9/bg3ShiRcJQzcYNHkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nir Dotan <nird@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 184/243] mlxsw: spectrum_router: Relax GRE decap matching check
Date:   Wed, 11 Dec 2019 16:05:46 +0100
Message-Id: <20191211150351.589776296@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nir Dotan <nird@mellanox.com>

[ Upstream commit da93d2913fdf43d5cde3c5a53ac9cc29684d5c7c ]

GRE decap offload is configured when local routes prefix correspond to the
local address of one of the offloaded GRE tunnels. The matching check was
found to be too strict, such that for a flat GRE configuration, in which
the overlay and underlay traffic share the same non-default VRF, decap flow
was not offloaded.

Relax the check for decap flow offloading. A match occurs if the local
address of the tunnel matches the local route address while both share the
same VRF table.

Fixes: 4607f6d26950 ("mlxsw: spectrum_router: Support IPv4 underlay decap")
Signed-off-by: Nir Dotan <nird@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 3f54b3ca38bad..44b6c2ac5961d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1215,15 +1215,12 @@ mlxsw_sp_ipip_entry_matches_decap(struct mlxsw_sp *mlxsw_sp,
 {
 	u32 ul_tb_id = l3mdev_fib_table(ul_dev) ? : RT_TABLE_MAIN;
 	enum mlxsw_sp_ipip_type ipipt = ipip_entry->ipipt;
-	struct net_device *ipip_ul_dev;
 
 	if (mlxsw_sp->router->ipip_ops_arr[ipipt]->ul_proto != ul_proto)
 		return false;
 
-	ipip_ul_dev = __mlxsw_sp_ipip_netdev_ul_dev_get(ipip_entry->ol_dev);
 	return mlxsw_sp_ipip_entry_saddr_matches(mlxsw_sp, ul_proto, ul_dip,
-						 ul_tb_id, ipip_entry) &&
-	       (!ipip_ul_dev || ipip_ul_dev == ul_dev);
+						 ul_tb_id, ipip_entry);
 }
 
 /* Given decap parameters, find the corresponding IPIP entry. */
-- 
2.20.1



