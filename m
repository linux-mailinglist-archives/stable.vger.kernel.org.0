Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE1933B770
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhCOOAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232516AbhCON7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F29E64F3A;
        Mon, 15 Mar 2021 13:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816723;
        bh=DDDeyg45GvOn03ZoQxqrenV4AUdjU6WKHIuQ+dJVNAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eScxqGm3vVyvcJXqDo12AJJZiJmsO4+DAAvvMXwLIuAeN8XxulNovas2srasuefce
         20P9P7gq/67H8D1m6VA4sGQOWmRuEuOrNfo+7V63C3orlPxoOwizdIJZTBFlPCgdu/
         MNHs92htSKITp/2XrlOybln+vtZT3cEmaPi3sS1o=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danielle Ratson <danieller@nvidia.com>,
        Eddie Shklaer <eddies@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.11 086/306] mlxsw: spectrum_ethtool: Add an external speed to PTYS register
Date:   Mon, 15 Mar 2021 14:52:29 +0100
Message-Id: <20210315135510.558953173@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Danielle Ratson <danieller@nvidia.com>

commit ae9b24ddb69b4e31cda1b5e267a5a08a1db11717 upstream.

Currently, only external bits are added to the PTYS register, whereas
there is one external bit that is wrongly marked as internal, and so was
recently removed from the register.

Add that bit to the PTYS register again, as this bit is no longer
internal.

Its removal resulted in '100000baseLR4_ER4/Full' link mode no longer
being supported, causing a regression on some setups.

Fixes: 5bf01b571cf4 ("mlxsw: spectrum_ethtool: Remove internal speeds from PTYS register")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reported-by: Eddie Shklaer <eddies@nvidia.com>
Tested-by: Eddie Shklaer <eddies@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h              |    1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |    5 +++++
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c         |    3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4430,6 +4430,7 @@ MLXSW_ITEM32(reg, ptys, ext_eth_proto_ca
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4		BIT(20)
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4		BIT(21)
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4		BIT(22)
+#define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4	BIT(23)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_CR		BIT(27)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_KR		BIT(28)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_SR		BIT(29)
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1171,6 +1171,11 @@ static const struct mlxsw_sp1_port_link_
 		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
 		.speed		= SPEED_100000,
 	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
+		.speed		= SPEED_100000,
+	},
 };
 
 #define MLXSW_SP1_PORT_LINK_MODE_LEN ARRAY_SIZE(mlxsw_sp1_port_link_mode)
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -613,7 +613,8 @@ static const struct mlxsw_sx_port_link_m
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4 |
 				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4 |
-				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4,
+				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4 |
+				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4,
 		.speed		= 100000,
 	},
 };


