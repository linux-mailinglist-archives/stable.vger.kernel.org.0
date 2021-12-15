Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87202475EA9
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245450AbhLORXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245477AbhLORXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A1BC06175C;
        Wed, 15 Dec 2021 09:23:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F5E4619C9;
        Wed, 15 Dec 2021 17:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F55C36AE0;
        Wed, 15 Dec 2021 17:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588995;
        bh=01A2+zIPO4o+Dmgp8Q9y/Jlu4dUUNtnMB0nQdN71ZZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DV/YRbMuhqL1TPdO9BE5kjCr1UukBLi6qyvWTxinYCp7JLkjOdLPjW1EZZLT/vX2S
         1WmeyIwacSbxe4R9e3AfvZb4PPSYdT3Lv/aqe3j5twk5TconPRcJsAOa4MutoSd/LE
         KEENSSdUwwyL9jGWj95Z1fWA0dpE9PEzV/EgU1n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Stapelberg <michael@stapelberg.ch>,
        Erik Ekman <erik@kryo.se>, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 26/42] net/mlx4_en: Update reported link modes for 1/10G
Date:   Wed, 15 Dec 2021 18:21:07 +0100
Message-Id: <20211215172027.564659304@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Ekman <erik@kryo.se>

[ Upstream commit 2191b1dfef7d45f44b5008d2148676d9f2c82874 ]

When link modes were initially added in commit 2c762679435dc
("net/mlx4_en: Use PTYS register to query ethtool settings") and
later updated for the new ethtool API in commit 3d8f7cc78d0eb
("net: mlx4: use new ETHTOOL_G/SSETTINGS API") the only 1/10G non-baseT
link modes configured were 1000baseKX, 10000baseKX4 and 10000baseKR.
It looks like these got picked to represent other modes since nothing
better was available.

Switch to using more specific link modes added in commit 5711a98221443
("net: ethtool: add support for 1000BaseX and missing 10G link modes").

Tested with MCX311A-XCAT connected via DAC.
Before:

% sudo ethtool enp3s0
Settings for enp3s0:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseKX/Full
	                        10000baseKR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  1000baseKX/Full
	                        10000baseKR/Full
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Speed: 10000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: Direct Attach Copper
	PHYAD: 0
	Transceiver: internal
	Supports Wake-on: d
	Wake-on: d
        Current message level: 0x00000014 (20)
                               link ifdown
	Link detected: yes

With this change:

% sudo ethtool enp3s0
	Settings for enp3s0:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseX/Full
	                        10000baseCR/Full
 	                        10000baseSR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  1000baseX/Full
 	                        10000baseCR/Full
 	                        10000baseSR/Full
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Speed: 10000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: Direct Attach Copper
	PHYAD: 0
	Transceiver: internal
	Supports Wake-on: d
	Wake-on: d
        Current message level: 0x00000014 (20)
                               link ifdown
	Link detected: yes

Tested-by: Michael Stapelberg <michael@stapelberg.ch>
Signed-off-by: Erik Ekman <erik@kryo.se>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index ef518b1040f72..fde521b1eecad 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -663,7 +663,7 @@ void __init mlx4_en_init_ptys2ethtool_map(void)
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_T, SPEED_1000,
 				       ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_CX_SGMII, SPEED_1000,
-				       ETHTOOL_LINK_MODE_1000baseKX_Full_BIT);
+				       ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_KX, SPEED_1000,
 				       ETHTOOL_LINK_MODE_1000baseKX_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_T, SPEED_10000,
@@ -675,9 +675,9 @@ void __init mlx4_en_init_ptys2ethtool_map(void)
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_KR, SPEED_10000,
 				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_CR, SPEED_10000,
-				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
+				       ETHTOOL_LINK_MODE_10000baseCR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_SR, SPEED_10000,
-				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
+				       ETHTOOL_LINK_MODE_10000baseSR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_20GBASE_KR2, SPEED_20000,
 				       ETHTOOL_LINK_MODE_20000baseMLD2_Full_BIT,
 				       ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT);
-- 
2.33.0



