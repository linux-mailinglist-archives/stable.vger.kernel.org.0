Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E568C499C85
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579547AbiAXWFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577015AbiAXV5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:57:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AA8C09427B;
        Mon, 24 Jan 2022 12:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25A53614FF;
        Mon, 24 Jan 2022 20:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EE7C340E5;
        Mon, 24 Jan 2022 20:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056724;
        bh=iIcfM+H8IGt2OdfW65l2nBT0+BJsI2zRIUQJ8nSCAbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgOLe2pEhdljyz87KUcXx56cKft5TzYR0hYwHGEtrK/ynOUt5QrX1I4rVaMmxGQHE
         S338iMBfwjqNDiUukzmbe7Q2WWCsVb14zC8MSQKZWeMWL3Og01XCDC2PTHhMv0UiaQ
         tnDx9idniwHTUczUmvyfZnr5Zwywiv9I9+D1OxWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suresh Kumar <suresh2514@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 546/846] net: bonding: debug: avoid printing debug logs when bond is not notifying peers
Date:   Mon, 24 Jan 2022 19:41:03 +0100
Message-Id: <20220124184119.858064545@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 77dc79a7f5748..d779fed900ffa 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1096,9 +1096,6 @@ static bool bond_should_notify_peers(struct bonding *bond)
 	slave = rcu_dereference(bond->curr_active_slave);
 	rcu_read_unlock();
 
-	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
-		   slave ? slave->dev->name : "NULL");
-
 	if (!slave || !bond->send_peer_notif ||
 	    bond->send_peer_notif %
 	    max(1, bond->params.peer_notif_delay) != 0 ||
@@ -1106,6 +1103,9 @@ static bool bond_should_notify_peers(struct bonding *bond)
 	    test_bit(__LINK_STATE_LINKWATCH_PENDING, &slave->dev->state))
 		return false;
 
+	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
+		   slave ? slave->dev->name : "NULL");
+
 	return true;
 }
 
-- 
2.34.1



