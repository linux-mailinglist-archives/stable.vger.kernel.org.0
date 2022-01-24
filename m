Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CE749A8EA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1321321AbiAYDR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:17:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45052 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349676AbiAXTVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:21:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E3C4B8121C;
        Mon, 24 Jan 2022 19:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D767C340E7;
        Mon, 24 Jan 2022 19:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052065;
        bh=mJzXnS1IcEmpxWvMgmaLHW9EGxrSV9VAOnlDQMkv5PE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAXrpTpwwj7j405ShQ8jBsiGJcjPRPfktlisELvgvfnYS4wamLkZarvSaAphHJk/z
         4Fd0bO7r8GWFkVUsYbUztkvYWcKhGTQibz779JdNXtwTi4wm4DW2LdXU2F7xCoSZ9z
         JE7TQWpklEtuEBb+bU0T1+8eOfBm9k+3l1Cum/qM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suresh Kumar <suresh2514@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/239] net: bonding: debug: avoid printing debug logs when bond is not notifying peers
Date:   Mon, 24 Jan 2022 19:43:03 +0100
Message-Id: <20220124183947.707901508@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suresh Kumar <surkumar@redhat.com>

[ Upstream commit fee32de284ac277ba434a2d59f8ce46528ff3946 ]

Currently "bond_should_notify_peers: slave ..." messages are printed whenever
"bond_should_notify_peers" function is called.

+++
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): Received LACPDU on port 1
Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): Rx Machine: Port=1, Last State=6, Curr State=6
Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): partner sync=1
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
...
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): Received LACPDU on port 2
Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): Rx Machine: Port=2, Last State=6, Curr State=6
Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): partner sync=1
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
+++

This is confusing and can also clutter up debug logs.
Print logs only when the peer notification happens.

Signed-off-by: Suresh Kumar <suresh2514@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index d6c5f41b17f7e..2d70cdd26f89d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -782,14 +782,14 @@ static bool bond_should_notify_peers(struct bonding *bond)
 	slave = rcu_dereference(bond->curr_active_slave);
 	rcu_read_unlock();
 
-	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
-		   slave ? slave->dev->name : "NULL");
-
 	if (!slave || !bond->send_peer_notif ||
 	    !netif_carrier_ok(bond->dev) ||
 	    test_bit(__LINK_STATE_LINKWATCH_PENDING, &slave->dev->state))
 		return false;
 
+	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
+		   slave ? slave->dev->name : "NULL");
+
 	return true;
 }
 
-- 
2.34.1



