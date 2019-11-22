Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D9F106F02
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfKVKzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:55:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730432AbfKVKzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:55:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CDF82073F;
        Fri, 22 Nov 2019 10:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420112;
        bh=SUtoJuBQ0kWFqFHCogcPBI0EufRGC1iwfMg31fJcoOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nub6eK2MsZ8YrP4zYK8Hf3HB57yjVFDMlumNbyeW3eRSDGXkbER0Ob0OlR5stIU3Y
         wRm46gUI+5DbFMka5rA9Et7GSw2a03bf2yKnJsNBxscib7gzvphnjmo/8oUXHkI5l8
         yP1dlgSVM30XzjO5kHJKfnsAAhjOVtxcsMtsrZ90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 118/122] mlxsw: spectrum_switchdev: Check notification relevance based on upper device
Date:   Fri, 22 Nov 2019 11:29:31 +0100
Message-Id: <20191122100837.148745973@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 5050f6ae253ad1307af3486c26fc4f94287078b7 ]

VxLAN FDB updates are sent with the VxLAN device which is not our upper
and will therefore be ignored by current code.

Solve this by checking whether the upper device (bridge) is our upper.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 8a1788108f52a..698de51b3fef0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1939,8 +1939,15 @@ static int mlxsw_sp_switchdev_event(struct notifier_block *unused,
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 	struct mlxsw_sp_switchdev_event_work *switchdev_work;
 	struct switchdev_notifier_fdb_info *fdb_info = ptr;
+	struct net_device *br_dev;
 
-	if (!mlxsw_sp_port_dev_lower_find_rcu(dev))
+	/* Tunnel devices are not our uppers, so check their master instead */
+	br_dev = netdev_master_upper_dev_get_rcu(dev);
+	if (!br_dev)
+		return NOTIFY_DONE;
+	if (!netif_is_bridge_master(br_dev))
+		return NOTIFY_DONE;
+	if (!mlxsw_sp_port_dev_lower_find_rcu(br_dev))
 		return NOTIFY_DONE;
 
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-- 
2.20.1



