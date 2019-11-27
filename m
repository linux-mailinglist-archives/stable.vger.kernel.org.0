Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573B510B99D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbfK0UzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730926AbfK0UzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:55:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75C5E2070B;
        Wed, 27 Nov 2019 20:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888110;
        bh=6vo/Y59EGoUBJsZLYnDV6gLsI3MwKSYt5mAwDC241UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTMTH0ptvPwFdMIue5p8NiFrfRGgeJLIyeTNOMpmMn1H2W7gYE2pv2/eGNTx3Dvsf
         Afo8MQqBDVBzjVQ+yFsrIHJm7mLjaSk/hl9j8Yr4IRwcs4JHo5nNmuJXaUl8EjbKCE
         zhCztiLr0gjKnukhYjD/M8oCTEKPpOvhO2DkK560=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 001/306] mlxsw: spectrum_router: Fix determining underlay for a GRE tunnel
Date:   Wed, 27 Nov 2019 21:27:31 +0100
Message-Id: <20191127203114.870042090@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
@@ -970,7 +970,7 @@ u32 mlxsw_sp_ipip_dev_ul_tb_id(const str
 	if (d)
 		return l3mdev_fib_table(d) ? : RT_TABLE_MAIN;
 	else
-		return l3mdev_fib_table(ol_dev) ? : RT_TABLE_MAIN;
+		return RT_TABLE_MAIN;
 }
 
 static struct mlxsw_sp_rif *
@@ -1532,27 +1532,10 @@ static int mlxsw_sp_netdevice_ipip_ol_vr
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


