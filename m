Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F33F412040
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353844AbhITRxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354397AbhITRtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 022ED61356;
        Mon, 20 Sep 2021 17:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157905;
        bh=idyDFC2+HeruMcqKUqpotWuIe9YhVI1CIW7aQEnqD8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GceA3frOSS/prOdek/frB2wy3QU+HyP5hILQtTvAKlM3hmc619OnaQpjbHMGIOUj5
         CGhhDCCKMSDq7d+YUEGC4q0gx1x+sYboi5btOUCW4STTKW2okhHFXxKZJ4vx6Q+ZS9
         p5RSBVykTZDV6gxqRtiDFoef/2GvErhixR7A+ExA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 204/293] bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()
Date:   Mon, 20 Sep 2021 18:42:46 +0200
Message-Id: <20210920163940.247622604@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 220ade77452c15ecb1ab94c3f8aaeb6d033c3582 ]

Some time ago, I reported a calltrace issue
"did not find a suitable aggregator", please see[1].
After a period of analysis and reproduction, I find
that this problem is caused by concurrency.

Before the problem occurs, the bond structure is like follows:

bond0 - slaver0(eth0) - agg0.lag_ports -> port0 - port1
                      \
                        port0
      \
        slaver1(eth1) - agg1.lag_ports -> NULL
                      \
                        port1

If we run 'ifenslave bond0 -d eth1', the process is like below:

excuting __bond_release_one()
|
bond_upper_dev_unlink()[step1]
|                       |                       |
|                       |                       bond_3ad_lacpdu_recv()
|                       |                       ->bond_3ad_rx_indication()
|                       |                       spin_lock_bh()
|                       |                       ->ad_rx_machine()
|                       |                       ->__record_pdu()[step2]
|                       |                       spin_unlock_bh()
|                       |                       |
|                       bond_3ad_state_machine_handler()
|                       spin_lock_bh()
|                       ->ad_port_selection_logic()
|                       ->try to find free aggregator[step3]
|                       ->try to find suitable aggregator[step4]
|                       ->did not find a suitable aggregator[step5]
|                       spin_unlock_bh()
|                       |
|                       |
bond_3ad_unbind_slave() |
spin_lock_bh()
spin_unlock_bh()

step1: already removed slaver1(eth1) from list, but port1 remains
step2: receive a lacpdu and update port0
step3: port0 will be removed from agg0.lag_ports. The struct is
       "agg0.lag_ports -> port1" now, and agg0 is not free. At the
	   same time, slaver1/agg1 has been removed from the list by step1.
	   So we can't find a free aggregator now.
step4: can't find suitable aggregator because of step2
step5: cause a calltrace since port->aggregator is NULL

To solve this concurrency problem, put bond_upper_dev_unlink()
after bond_3ad_unbind_slave(). In this way, we can invalid the port
first and skip this port in bond_3ad_state_machine_handler(). This
eliminates the situation that the slaver has been removed from the
list but the port is still valid.

[1]https://lore.kernel.org/netdev/10374.1611947473@famine/

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c814b266af79..d6c5f41b17f7 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1912,7 +1912,6 @@ static int __bond_release_one(struct net_device *bond_dev,
 	/* recompute stats just before removing the slave */
 	bond_get_stats(bond->dev, &bond->bond_stats);
 
-	bond_upper_dev_unlink(bond, slave);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
 	 * for this slave anymore.
 	 */
@@ -1921,6 +1920,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 	if (BOND_MODE(bond) == BOND_MODE_8023AD)
 		bond_3ad_unbind_slave(slave);
 
+	bond_upper_dev_unlink(bond, slave);
+
 	if (bond_mode_can_use_xmit_hash(bond))
 		bond_update_slave_arr(bond, slave);
 
-- 
2.30.2



