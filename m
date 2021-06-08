Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8A53A01D3
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbhFHS43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236380AbhFHSx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAC04613D2;
        Tue,  8 Jun 2021 18:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177652;
        bh=iK7+E9QBQVH4LFNgW/kV6vHLD3+OluFg6RO3ED//qIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heOZJNpSfsq5mSTiyM5J/9hm+psQMR8aHoNhQVmt860mEhEXv7bPob9LVaCv/CCWs
         ACiwXmvNKrlZa7zcSfxC1qh6Jv6bqeBCvfgHXZoclzCWQjtTqAAczx/+nkm5bimcTo
         6eV/ccR8pe3H20t4KdG3o+jCApxedmsc1krtFr6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/137] cxgb4: avoid link re-train during TC-MQPRIO configuration
Date:   Tue,  8 Jun 2021 20:26:31 +0200
Message-Id: <20210608175944.121391651@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 3822d0670c9d4342794d73e0d0e615322b40438e ]

When configuring TC-MQPRIO offload, only turn off netdev carrier and
don't bring physical link down in hardware. Otherwise, when the
physical link is brought up again after configuration, it gets
re-trained and stalls ongoing traffic.

Also, when firmware is no longer accessible or crashed, avoid sending
FLOWC and waiting for reply that will never come.

Fix following hung_task_timeout_secs trace seen in these cases.

INFO: task tc:20807 blocked for more than 122 seconds.
      Tainted: G S                5.13.0-rc3+ #122
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:tc   state:D stack:14768 pid:20807 ppid: 19366 flags:0x00000000
Call Trace:
 __schedule+0x27b/0x6a0
 schedule+0x37/0xa0
 schedule_preempt_disabled+0x5/0x10
 __mutex_lock.isra.14+0x2a0/0x4a0
 ? netlink_lookup+0x120/0x1a0
 ? rtnl_fill_ifinfo+0x10f0/0x10f0
 __netlink_dump_start+0x70/0x250
 rtnetlink_rcv_msg+0x28b/0x380
 ? rtnl_fill_ifinfo+0x10f0/0x10f0
 ? rtnl_calcit.isra.42+0x120/0x120
 netlink_rcv_skb+0x4b/0xf0
 netlink_unicast+0x1a0/0x280
 netlink_sendmsg+0x216/0x440
 sock_sendmsg+0x56/0x60
 __sys_sendto+0xe9/0x150
 ? handle_mm_fault+0x6d/0x1b0
 ? do_user_addr_fault+0x1c5/0x620
 __x64_sys_sendto+0x1f/0x30
 do_syscall_64+0x3c/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f7f73218321
RSP: 002b:00007ffd19626208 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000055b7c0a8b240 RCX: 00007f7f73218321
RDX: 0000000000000028 RSI: 00007ffd19626210 RDI: 0000000000000003
RBP: 000055b7c08680ff R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000055b7c085f5f6
R13: 000055b7c085f60a R14: 00007ffd19636470 R15: 00007ffd196262a0

Fixes: b1396c2bd675 ("cxgb4: parse and configure TC-MQPRIO offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h           | 2 --
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c      | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c | 9 ++++++---
 drivers/net/ethernet/chelsio/cxgb4/sge.c             | 6 ++++++
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 27308600da15..2dd486915629 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -2177,8 +2177,6 @@ int cxgb4_update_mac_filt(struct port_info *pi, unsigned int viid,
 			  bool persistent, u8 *smt_idx);
 int cxgb4_get_msix_idx_from_bmap(struct adapter *adap);
 void cxgb4_free_msix_idx_in_bmap(struct adapter *adap, u32 msix_idx);
-int cxgb_open(struct net_device *dev);
-int cxgb_close(struct net_device *dev);
 void cxgb4_enable_rx(struct adapter *adap, struct sge_rspq *q);
 void cxgb4_quiesce_rx(struct sge_rspq *q);
 int cxgb4_port_mirror_alloc(struct net_device *dev);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 23c13f34a572..04dcb5e4b316 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2834,7 +2834,7 @@ static void cxgb_down(struct adapter *adapter)
 /*
  * net_device operations
  */
-int cxgb_open(struct net_device *dev)
+static int cxgb_open(struct net_device *dev)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
@@ -2882,7 +2882,7 @@ out_unlock:
 	return err;
 }
 
-int cxgb_close(struct net_device *dev)
+static int cxgb_close(struct net_device *dev)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index 6c259de96f96..338b04f339b3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -589,7 +589,8 @@ int cxgb4_setup_tc_mqprio(struct net_device *dev,
 	 * down before configuring tc params.
 	 */
 	if (netif_running(dev)) {
-		cxgb_close(dev);
+		netif_tx_stop_all_queues(dev);
+		netif_carrier_off(dev);
 		needs_bring_up = true;
 	}
 
@@ -615,8 +616,10 @@ int cxgb4_setup_tc_mqprio(struct net_device *dev,
 	}
 
 out:
-	if (needs_bring_up)
-		cxgb_open(dev);
+	if (needs_bring_up) {
+		netif_tx_start_all_queues(dev);
+		netif_carrier_on(dev);
+	}
 
 	mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
 	return ret;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 546301272271..ccb6bd002b20 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2552,6 +2552,12 @@ int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
 	if (!eosw_txq)
 		return -ENOMEM;
 
+	if (!(adap->flags & CXGB4_FW_OK)) {
+		/* Don't stall caller when access to FW is lost */
+		complete(&eosw_txq->completion);
+		return -EIO;
+	}
+
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
-- 
2.30.2



