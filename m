Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4BA106E3E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbfKVLFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbfKVLFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:05:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BA4D2084D;
        Fri, 22 Nov 2019 11:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420753;
        bh=QpPlVOH8XrovDhe/giG6zh7Ap7H68BvM/SfG639B8S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxieqrOVAfPjysVtZqJNmzTsmYXiAK51Un9EhGnUCFLfuOCqwYtnafdHwurAnnsMp
         8Xh2IxrOLJnlh4kbRoCsxLZGD82QVlqsOcATtAuV9ljrAMqXenxkAZo/bru+k+YarO
         st0HTuOmLaxaXwy9ZEYUqOriVnBkSFJZN5+7PX+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 212/220] mlxsw: spectrum_switchdev: Check notification relevance based on upper device
Date:   Fri, 22 Nov 2019 11:29:37 +0100
Message-Id: <20191122100928.933327853@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
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
index a4f237f815d1a..8d556eb37b7aa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2324,8 +2324,15 @@ static int mlxsw_sp_switchdev_event(struct notifier_block *unused,
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



