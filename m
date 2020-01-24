Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4A914845B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbgAXLBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbgAXLBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:30 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A83A92075D;
        Fri, 24 Jan 2020 11:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863689;
        bh=6vN8yAvuv2mIxnl69qt0BC6aB8iw1WxfoMTr+3DNk/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gatTKJ6AkFA05ghqpCftzKmHWc4WG79Pj8sYm0aI6ED6sD+CM2lChaVMBj+pTkRgu
         z9mL780MeNNTxJKIhCpPUD70qP2Yfsn1COvx/rgSlAakInWjlGdDmsUvP9flE/vuVb
         8I/gCQ5XIPijPbdF14DYMrnWPAalovyzBviY2aWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/639] mlxsw: spectrum: Set minimum shaper on MC TCs
Date:   Fri, 24 Jan 2020 10:23:51 +0100
Message-Id: <20200124093055.057770252@linuxfoundation.org>
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

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 0fe64023162aef123de2f1993ba13a35a786e1de ]

An MC-aware mode was introduced in commit 7b8195306694 ("mlxsw:
spectrum: Configure MC-aware mode on mlxsw ports"). In MC-aware mode,
BUM traffic gets a special treatment by being assigned to a separate set
of traffic classes 8..15. Pairs of TCs 0 and 8, 1 and 9, etc., are then
configured to strictly prioritize the lower-numbered ones. The intention
is to prevent BUM traffic from flooding the switch and push out all UC
traffic, which would otherwise happen, and instead give UC traffic
precedence.

However strictly prioritizing UC traffic has the effect that UC overload
pushes out all BUM traffic, such as legitimate ARP queries. These
packets are kept in queues for a while, but under sustained UC overload,
their lifetime eventually expires and these packets are dropped. That is
detrimental to network performance as well.

Therefore configure the MC TCs (8..15) with minimum shaper of 200Mbps (a
minimum permitted value) to allow a trickle of necessary control traffic
to get through.

Fixes: 7b8195306694 ("mlxsw: spectrum: Configure MC-aware mode on mlxsw ports")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 30ef318b3d68d..5df9b25cab27d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2753,6 +2753,21 @@ int mlxsw_sp_port_ets_maxrate_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qeec), qeec_pl);
 }
 
+static int mlxsw_sp_port_min_bw_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				    enum mlxsw_reg_qeec_hr hr, u8 index,
+				    u8 next_index, u32 minrate)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char qeec_pl[MLXSW_REG_QEEC_LEN];
+
+	mlxsw_reg_qeec_pack(qeec_pl, mlxsw_sp_port->local_port, hr, index,
+			    next_index);
+	mlxsw_reg_qeec_mise_set(qeec_pl, true);
+	mlxsw_reg_qeec_min_shaper_rate_set(qeec_pl, minrate);
+
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qeec), qeec_pl);
+}
+
 int mlxsw_sp_port_prio_tc_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			      u8 switch_prio, u8 tclass)
 {
@@ -2830,6 +2845,16 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_port *mlxsw_sp_port)
 			return err;
 	}
 
+	/* Configure the min shaper for multicast TCs. */
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		err = mlxsw_sp_port_min_bw_set(mlxsw_sp_port,
+					       MLXSW_REG_QEEC_HIERARCY_TC,
+					       i + 8, i,
+					       MLXSW_REG_QEEC_MIS_MIN);
+		if (err)
+			return err;
+	}
+
 	/* Map all priorities to traffic class 0. */
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err = mlxsw_sp_port_prio_tc_set(mlxsw_sp_port, i, 0);
-- 
2.20.1



