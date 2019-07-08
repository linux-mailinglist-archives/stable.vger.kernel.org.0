Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 957CE62404
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731987AbfGHP3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729984AbfGHP3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:29:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E456B20645;
        Mon,  8 Jul 2019 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599746;
        bh=73jRZ6iwEIMn0gQH0betICznSgckgcGhuUC5XcftbRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZFWfYzOmejRoyzwaLP/CYTolSGLPVlMwSvcSobiuCLaSQ1xrfczcQW+2FGmndzDO
         Xsdmkz+elUrWtUCoSg5q9PpUQMURQ1QG52SikY3/erEimsk7Gb+4HOk2AX9yUjbXHF
         7SO1zFrKCeEz6/XHuAWYV+u/rthxUo5wYNpxVjoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 64/90] mlxsw: spectrum: Handle VLAN device unlinking
Date:   Mon,  8 Jul 2019 17:13:31 +0200
Message-Id: <20190708150525.627075755@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e149113a74c35f0a28d1bfe17d2505a03563c1d5 ]

In commit 993107fea5ee ("mlxsw: spectrum_switchdev: Fix VLAN device
deletion via ioctl") I fixed a bug caused by the fact that the driver
views differently the deletion of a VLAN device when it is deleted via
an ioctl and netlink.

Instead of relying on a specific order of events (device being
unregistered vs. VLAN filter being updated), simply make sure that the
driver performs the necessary cleanup when the VLAN device is unlinked,
which always happens before the other two events.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ff2f6b8e2fab..0cab06046e5d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4681,6 +4681,16 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 		} else if (netif_is_macvlan(upper_dev)) {
 			if (!info->linking)
 				mlxsw_sp_rif_macvlan_del(mlxsw_sp, upper_dev);
+		} else if (is_vlan_dev(upper_dev)) {
+			struct net_device *br_dev;
+
+			if (!netif_is_bridge_port(upper_dev))
+				break;
+			if (info->linking)
+				break;
+			br_dev = netdev_master_upper_dev_get(upper_dev);
+			mlxsw_sp_port_bridge_leave(mlxsw_sp_port, upper_dev,
+						   br_dev);
 		}
 		break;
 	}
-- 
2.20.1



