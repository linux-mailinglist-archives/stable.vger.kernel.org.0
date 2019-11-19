Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1731014C3
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbfKSFhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:37:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730026AbfKSFhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:37:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE49214DE;
        Tue, 19 Nov 2019 05:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141827;
        bh=c8KsAEiMdXpU+ct8AoP47mQ6yVted/wuYpqdIaHF2vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xJoWmIdeaO62ui5Xb1iF2Lyk6wHAn9lcYnwOv2GbAF+ybQ0kZ3kpMNsaEpV2GN0B
         7PtSNmHzZryjeswvG8EJugVG9VFpXEBBef35YXwrLsZIyTtnhrKjik7ochMMIhkx5j
         S3Z0W3X6kuwfuKCR6sJoRxGgb/HydHABhEXpER7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 294/422] mlxsw: spectrum: Init shaper for TCs 8..15
Date:   Tue, 19 Nov 2019 06:18:11 +0100
Message-Id: <20191119051418.043038302@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit a9f36656b519a9a21309793c306941a3cd0eeb8f ]

With introduction of MC-aware mode to mlxsw, it became necessary to
configure TCs above 7 as well. There is now code in mlxsw to disable ETS
for these higher classes, but disablement of max shaper was neglected.

By default, max shaper is currently disabled to begin with, so the
problem is just cosmetic. However, for symmetry, do like we do for ETS
configuration, and call mlxsw_sp_port_ets_maxrate_set() for both TC i
and i + 8.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ccd9aca281b37..1c170a0fd2cc9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2815,6 +2815,13 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_port *mlxsw_sp_port)
 						    MLXSW_REG_QEEC_MAS_DIS);
 		if (err)
 			return err;
+
+		err = mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
+						    MLXSW_REG_QEEC_HIERARCY_TC,
+						    i + 8, i,
+						    MLXSW_REG_QEEC_MAS_DIS);
+		if (err)
+			return err;
 	}
 
 	/* Map all priorities to traffic class 0. */
-- 
2.20.1



