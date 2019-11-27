Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD0B010BC5E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732790AbfK0VIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:08:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732372AbfK0VIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:08:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC5982086A;
        Wed, 27 Nov 2019 21:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888923;
        bh=Uqz+Pl5c/Di1mUQpPbEYuvi2Q8PKELQ8wd/LOIjO17k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNLj5rBK/4Rzo4R8A4HBWyudDZeA2JUSbeHR9TiQzlQoflAOH/FeDqRBK1g+CX59L
         dxa8kfCUtvpksqI54Pfik74D8DIugmYkOygRsplqaBTbYmiG7YFrQ5DY9L/O2fPGPM
         wTDcUL/Ajb/Dp05AHizuelFVdV8GhgMo/IdEFe2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 16/95] net/mlx5e: Do not use non-EXT link modes in EXT mode
Date:   Wed, 27 Nov 2019 21:31:33 +0100
Message-Id: <20191127202850.246292290@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit 24960574505c49b102ca1dfa6bf109669bca2a66 ]

On some old Firmwares, connector type value was not supported, and value
read from FW was 0. For those, driver used link mode in order to set
connector type in link_ksetting.

After FW exposed the connector type, driver translated the value to ethtool
definitions. However, as 0 is a valid value, before returning PORT_OTHER,
driver run the check of link mode in order to maintain backward
compatibility.

Cited patch added support to EXT mode.  With both features (connector type
and EXT link modes) ,if connector_type read from FW is 0 and EXT mode is
set, driver mistakenly compare EXT link modes to non-EXT link mode.
Fixed that by skipping this comparison if we are in EXT mode, as connector
type value is valid in this scenario.

Fixes: 6a897372417e ("net/mlx5: ethtool, Add ethtool support for 50Gbps per lane link modes")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -708,9 +708,9 @@ static int get_fec_supported_advertised(
 
 static void ptys2ethtool_supported_advertised_port(struct ethtool_link_ksettings *link_ksettings,
 						   u32 eth_proto_cap,
-						   u8 connector_type)
+						   u8 connector_type, bool ext)
 {
-	if (!connector_type || connector_type >= MLX5E_CONNECTOR_TYPE_NUMBER) {
+	if ((!connector_type && !ext) || connector_type >= MLX5E_CONNECTOR_TYPE_NUMBER) {
 		if (eth_proto_cap & (MLX5E_PROT_MASK(MLX5E_10GBASE_CR)
 				   | MLX5E_PROT_MASK(MLX5E_10GBASE_SR)
 				   | MLX5E_PROT_MASK(MLX5E_40GBASE_CR4)
@@ -842,9 +842,9 @@ static int ptys2connector_type[MLX5E_CON
 		[MLX5E_PORT_OTHER]              = PORT_OTHER,
 	};
 
-static u8 get_connector_port(u32 eth_proto, u8 connector_type)
+static u8 get_connector_port(u32 eth_proto, u8 connector_type, bool ext)
 {
-	if (connector_type && connector_type < MLX5E_CONNECTOR_TYPE_NUMBER)
+	if ((connector_type || ext) && connector_type < MLX5E_CONNECTOR_TYPE_NUMBER)
 		return ptys2connector_type[connector_type];
 
 	if (eth_proto &
@@ -945,9 +945,9 @@ int mlx5e_ethtool_get_link_ksettings(str
 	eth_proto_oper = eth_proto_oper ? eth_proto_oper : eth_proto_cap;
 
 	link_ksettings->base.port = get_connector_port(eth_proto_oper,
-						       connector_type);
+						       connector_type, ext);
 	ptys2ethtool_supported_advertised_port(link_ksettings, eth_proto_admin,
-					       connector_type);
+					       connector_type, ext);
 	get_lp_advertising(mdev, eth_proto_lp, link_ksettings);
 
 	if (an_status == MLX5_AN_COMPLETE)


