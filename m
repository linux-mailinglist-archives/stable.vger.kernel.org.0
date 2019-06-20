Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE4D4D7E1
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbfFTSM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729031AbfFTSM3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:12:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 844BD214AF;
        Thu, 20 Jun 2019 18:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054348;
        bh=degohdkmT46QhXhqgztd6HWLd7thAPLeXSXw6lMR4Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6b3bTtYbHsN3zgYje/DEkoWICHiD6oz4a99cGWsW4PmY+SJn7Z6w4OGuYUtlSplM
         qI9WUA64ENg3j9VD0w7oEJ0lxak3yzw7cB4dMOH4+93f6nqz0KoiqrJgloN27NSgu/
         mgNedlsMGMwx2AI1LRAGyXqS4OBW30QGIy5EyDB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amitc@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 58/61] mlxsw: spectrum: Prevent force of 56G
Date:   Thu, 20 Jun 2019 19:57:53 +0200
Message-Id: <20190620174347.301757984@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 275e928f19117d22f6d26dee94548baf4041b773 ]

Force of 56G is not supported by hardware in Ethernet devices. This
configuration fails with a bad parameter error from firmware.

Add check of this case. Instead of trying to set 56G with autoneg off,
return a meaningful error.

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c5b82e283d13..ff2f6b8e2fab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2488,6 +2488,10 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
 	mlxsw_reg_ptys_eth_unpack(ptys_pl, &eth_proto_cap, NULL, NULL);
 
 	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
+	if (!autoneg && cmd->base.speed == SPEED_56000) {
+		netdev_err(dev, "56G not supported with autoneg off\n");
+		return -EINVAL;
+	}
 	eth_proto_new = autoneg ?
 		mlxsw_sp_to_ptys_advert_link(cmd) :
 		mlxsw_sp_to_ptys_speed(cmd->base.speed);
-- 
2.20.1



