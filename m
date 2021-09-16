Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DFE40E05C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhIPQVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240623AbhIPQTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF115613CF;
        Thu, 16 Sep 2021 16:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808772;
        bh=IycIb4iHAww5XLlbsPdZL2lbQwL0O3Vf4/pxEhQhe9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwSc0D7F+eOCUSpqintkk8ynSeC19fNnLZurF07B7Zn0i/0OQC3qUhJtRxCboft/+
         fBBhw/0iuNv4i7n+TfibhfBCnsMD+hq9xOwQEnqVSk0RO20enxB8kvosdtJ3l4AIrg
         20Ibgdpy2Qn89T+QI/k5EKKkQaITYf+g8sy0WUdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/306] bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()
Date:   Thu, 16 Sep 2021 17:58:39 +0200
Message-Id: <20210916155800.011624363@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 018af1e38eb9..645c7cabcbe4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2219,7 +2219,6 @@ static int __bond_release_one(struct net_device *bond_dev,
 	/* recompute stats just before removing the slave */
 	bond_get_stats(bond->dev, &bond->bond_stats);
 
-	bond_upper_dev_unlink(bond, slave);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
 	 * for this slave anymore.
 	 */
@@ -2228,6 +2227,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 	if (BOND_MODE(bond) == BOND_MODE_8023AD)
 		bond_3ad_unbind_slave(slave);
 
+	bond_upper_dev_unlink(bond, slave);
+
 	if (bond_mode_can_use_xmit_hash(bond))
 		bond_update_slave_arr(bond, slave);
 
-- 
2.30.2



