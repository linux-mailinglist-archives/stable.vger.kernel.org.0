Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E9910BC75
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbfK0VI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:08:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732745AbfK0VI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:08:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D62A121775;
        Wed, 27 Nov 2019 21:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888905;
        bh=CtSLhzyb06Smd4jXF1wFX4VZf1mgeLast+tdXdmpxPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVJfSbbxjLye4Lel78cngdYn8Y08XkW/VJzqkYm6BLLMR5jlCZz2CR7t+mNlrN4VV
         8siR9taU2tFUFw1RN8xjkMpVRd5GwpRI/gXZs7s6eXFtH3uZK8DRSwz4PwmtDJ0fcX
         UeFFonEZfbhQqLiMnBELlatVYbKfvP2ajMiGFqys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 01/95] mlxsw: spectrum_router: Fix determining underlay for a GRE tunnel
Date:   Wed, 27 Nov 2019 21:31:18 +0100
Message-Id: <20191127202847.038070792@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 1fc1657775dc1b19e9ac1d46b4054ed8ae5d99ab ]

The helper mlxsw_sp_ipip_dev_ul_tb_id() determines the underlay VRF of a
GRE tunnel. For a tunnel without a bound device, it uses the same VRF that
the tunnel is in. However in Linux, a GRE tunnel without a bound device
uses the main VRF as the underlay. Fix the function accordingly.

mlxsw further assumed that moving a tunnel to a different VRF could cause
conflict in local tunnel endpoint address, which cannot be offloaded.
However, the only way that an underlay could be changed by moving the
tunnel device itself is if the tunnel device does not have a bound device.
But in that case the underlay is always the main VRF, so there is no
opportunity to introduce a conflict by moving such device. Thus this check
constitutes a dead code, and can be removed, which do.

Fixes: 6ddb7426a7d4 ("mlxsw: spectrum_router: Introduce loopback RIFs")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |   19 ------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -994,7 +994,7 @@ u32 mlxsw_sp_ipip_dev_ul_tb_id(const str
 	if (d)
 		return l3mdev_fib_table(d) ? : RT_TABLE_MAIN;
 	else
-		return l3mdev_fib_table(ol_dev) ? : RT_TABLE_MAIN;
+		return RT_TABLE_MAIN;
 }
 
 static struct mlxsw_sp_rif *
@@ -1598,27 +1598,10 @@ static int mlxsw_sp_netdevice_ipip_ol_vr
 {
 	struct mlxsw_sp_ipip_entry *ipip_entry =
 		mlxsw_sp_ipip_entry_find_by_ol_dev(mlxsw_sp, ol_dev);
-	enum mlxsw_sp_l3proto ul_proto;
-	union mlxsw_sp_l3addr saddr;
-	u32 ul_tb_id;
 
 	if (!ipip_entry)
 		return 0;
 
-	/* For flat configuration cases, moving overlay to a different VRF might
-	 * cause local address conflict, and the conflicting tunnels need to be
-	 * demoted.
-	 */
-	ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(ol_dev);
-	ul_proto = mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt]->ul_proto;
-	saddr = mlxsw_sp_ipip_netdev_saddr(ul_proto, ol_dev);
-	if (mlxsw_sp_ipip_demote_tunnel_by_saddr(mlxsw_sp, ul_proto,
-						 saddr, ul_tb_id,
-						 ipip_entry)) {
-		mlxsw_sp_ipip_entry_demote_tunnel(mlxsw_sp, ipip_entry);
-		return 0;
-	}
-
 	return __mlxsw_sp_ipip_entry_update_tunnel(mlxsw_sp, ipip_entry,
 						   true, false, false, extack);
 }


