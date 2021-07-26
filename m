Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99B73D6007
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhGZPUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237008AbhGZPUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB38760F6E;
        Mon, 26 Jul 2021 16:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315247;
        bh=M7uSeC+ZAIRAMcpCB2e08wR+uC2UeqVYLHBwEpY6vj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZPeVnLTec06T6wvLZA++cIhCyyZWSGwTr7HPTE5wtGSRlCv/kAgwIXt67ZpHz2ad
         EnWTI/4LXB9xNbkki6jr5T4aUwYwn5Fd3euyfTsOFOoSmAJgTGpR9hfykvhCds6JGh
         844bBWiPg9jSe7eXK426KeMzLelTrvUggAQRQ7P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/167] bonding: fix suspicious RCU usage in bond_ipsec_offload_ok()
Date:   Mon, 26 Jul 2021 17:37:34 +0200
Message-Id: <20210726153840.081638074@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 955b785ec6b3b2f9b91914d6eeac8ee66ee29239 ]

To dereference bond->curr_active_slave, it uses rcu_dereference().
But it and the caller doesn't acquire RCU so a warning occurs.
So add rcu_read_lock().

Splat looks like:
WARNING: suspicious RCU usage
5.13.0-rc6+ #1179 Not tainted
drivers/net/bonding/bond_main.c:571 suspicious
rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by ping/974:
 #0: ffff888109e7db70 (sk_lock-AF_INET){+.+.}-{0:0},
at: raw_sendmsg+0x1303/0x2cb0

stack backtrace:
CPU: 2 PID: 974 Comm: ping Not tainted 5.13.0-rc6+ #1179
Call Trace:
 dump_stack+0xa4/0xe5
 bond_ipsec_offload_ok+0x1f4/0x260 [bonding]
 xfrm_output+0x179/0x890
 xfrm4_output+0xfa/0x410
 ? __xfrm4_output+0x4b0/0x4b0
 ? __ip_make_skb+0xecc/0x2030
 ? xfrm4_udp_encap_rcv+0x800/0x800
 ? ip_local_out+0x21/0x3a0
 ip_send_skb+0x37/0xa0
 raw_sendmsg+0x1bfd/0x2cb0

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 484784757073..9aa2d79aa942 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -557,24 +557,34 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	struct net_device *real_dev;
 	struct slave *curr_active;
 	struct bonding *bond;
+	int err;
 
 	bond = netdev_priv(bond_dev);
+	rcu_read_lock();
 	curr_active = rcu_dereference(bond->curr_active_slave);
 	real_dev = curr_active->dev;
 
-	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
-		return true;
+	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
+		err = true;
+		goto out;
+	}
 
-	if (!xs->xso.real_dev)
-		return false;
+	if (!xs->xso.real_dev) {
+		err = false;
+		goto out;
+	}
 
 	if (!real_dev->xfrmdev_ops ||
 	    !real_dev->xfrmdev_ops->xdo_dev_offload_ok ||
 	    netif_is_bond_master(real_dev)) {
-		return false;
+		err = false;
+		goto out;
 	}
 
-	return real_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
+	err = real_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
+out:
+	rcu_read_unlock();
+	return err;
 }
 
 static const struct xfrmdev_ops bond_xfrmdev_ops = {
-- 
2.30.2



