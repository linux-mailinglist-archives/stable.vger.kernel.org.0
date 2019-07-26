Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A536076E06
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388530AbfGZP2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388524AbfGZP2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:28:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C132E22BF5;
        Fri, 26 Jul 2019 15:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154916;
        bh=HpJ+7nvcg/FsLO6UTuVPOhWi1h82QdrPejqjOwhsQ/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVPCRXr8tcNA/Z6vUOuPnBsk5Z0UlzEIURL1wguU+IBk1FmgEPqcrQrzBygcEpR/g
         g6COAB/Guzzsx1m5JVvFipBOccSUCJvqbfJEEn8LDT3ur1Chwi8S6CyQTjVXIQ43NC
         9LPqeTFeSMQQLaLsgie3YO6tUHA2Ab9F+urR9Z0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Alex Veber <alexve@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 44/66] mlxsw: spectrum_dcb: Configure DSCP map as the last rule is removed
Date:   Fri, 26 Jul 2019 17:24:43 +0200
Message-Id: <20190726152306.737029220@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit dedfde2fe1c4ccf27179fcb234e2112d065c39bb ]

Spectrum systems use DSCP rewrite map to update DSCP field in egressing
packets to correspond to priority that the packet has. Whether rewriting
will take place is determined at the point when the packet ingresses the
switch: if the port is in Trust L3 mode, packet priority is determined from
the DSCP map at the port, and DSCP rewrite will happen. If the port is in
Trust L2 mode, 802.1p is used for packet prioritization, and no DSCP
rewrite will happen.

The driver determines the port trust mode based on whether any DSCP
prioritization rules are in effect at given port. If there are any, trust
level is L3, otherwise it's L2. When the last DSCP rule is removed, the
port is switched to trust L2. Under that scenario, if DSCP of a packet
should be rewritten, it should be rewritten to 0.

However, when switching to Trust L2, the driver neglects to also update the
DSCP rewrite map. The last DSCP rule thus remains in effect, and packets
egressing through this port, if they have the right priority, will have
their DSCP set according to this rule.

Fix by first configuring the rewrite map, and only then switching to trust
L2 and bailing out.

Fixes: b2b1dab6884e ("mlxsw: spectrum: Support ieee_setapp, ieee_delapp")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reported-by: Alex Veber <alexve@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -408,14 +408,6 @@ static int mlxsw_sp_port_dcb_app_update(
 	have_dscp = mlxsw_sp_port_dcb_app_prio_dscp_map(mlxsw_sp_port,
 							&prio_map);
 
-	if (!have_dscp) {
-		err = mlxsw_sp_port_dcb_toggle_trust(mlxsw_sp_port,
-					MLXSW_REG_QPTS_TRUST_STATE_PCP);
-		if (err)
-			netdev_err(mlxsw_sp_port->dev, "Couldn't switch to trust L2\n");
-		return err;
-	}
-
 	mlxsw_sp_port_dcb_app_dscp_prio_map(mlxsw_sp_port, default_prio,
 					    &dscp_map);
 	err = mlxsw_sp_port_dcb_app_update_qpdpm(mlxsw_sp_port,
@@ -432,6 +424,14 @@ static int mlxsw_sp_port_dcb_app_update(
 		return err;
 	}
 
+	if (!have_dscp) {
+		err = mlxsw_sp_port_dcb_toggle_trust(mlxsw_sp_port,
+					MLXSW_REG_QPTS_TRUST_STATE_PCP);
+		if (err)
+			netdev_err(mlxsw_sp_port->dev, "Couldn't switch to trust L2\n");
+		return err;
+	}
+
 	err = mlxsw_sp_port_dcb_toggle_trust(mlxsw_sp_port,
 					     MLXSW_REG_QPTS_TRUST_STATE_DSCP);
 	if (err) {


