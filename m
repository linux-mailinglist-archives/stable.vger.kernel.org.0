Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B458C32883F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbhCARgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238032AbhCAR3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:29:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA67D64FA7;
        Mon,  1 Mar 2021 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617503;
        bh=QpN1pU+UeSxHLJCk6kDCHs3ZrZzebFTHdi12lmZz88E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEVU+XLiQWxrNmIaleeIXM59p6YN/WqimCvx8t5iOHGGMBbWw/bt9d6+bd5H7KL8i
         ZsPTALNBEo67fKM8wfa3J62qbenZMVZUApHBEBlLOJAadqoJxfzKMNbXpEL+15DMel
         16xH7gUkSYMqREnpYGsDU/NYWvHPnImwEYok7Lvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudheesh Mavila <sudheesh.mavila@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/340] net: amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning
Date:   Mon,  1 Mar 2021 17:10:10 +0100
Message-Id: <20210301161051.570566962@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 186edbb510bd60e748f93975989ccba25ee99c50 ]

The current driver calls netif_carrier_off() late in the link tear down
which can result in a netdev watchdog timeout.

Calling netif_carrier_off() immediately after netif_tx_stop_all_queues()
avoids the warning.

 ------------[ cut here ]------------
 NETDEV WATCHDOG: enp3s0f2 (amd-xgbe): transmit queue 0 timed out
 WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:461 dev_watchdog+0x20d/0x220
 Modules linked in: amd_xgbe(E)  amd-xgbe 0000:03:00.2 enp3s0f2: Link is Down
 CPU: 3 PID: 0 Comm: swapper/3 Tainted: G            E
 Hardware name: AMD Bilby-RV2/Bilby-RV2, BIOS RBB1202A 10/18/2019
 RIP: 0010:dev_watchdog+0x20d/0x220
 Code: 00 49 63 4e e0 eb 92 4c 89 e7 c6 05 c6 e2 c1 00 01 e8 e7 ce fc ff 89 d9 48
 RSP: 0018:ffff90cfc28c3e88 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
 RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffff90cfc28d63c0
 RBP: ffff90cfb977845c R08: 0000000000000050 R09: 0000000000196018
 R10: ffff90cfc28c3ef8 R11: 0000000000000000 R12: ffff90cfb9778000
 R13: 0000000000000003 R14: ffff90cfb9778480 R15: 0000000000000010
 FS:  0000000000000000(0000) GS:ffff90cfc28c0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f240ff2d9d0 CR3: 00000001e3e0a000 CR4: 00000000003406e0
 Call Trace:
  <IRQ>
  ? pfifo_fast_reset+0x100/0x100
  call_timer_fn+0x2b/0x130
  run_timer_softirq+0x3e8/0x440
  ? enqueue_hrtimer+0x39/0x90

Fixes: e722ec82374b ("amd-xgbe: Update the BelFuse quirk to support SGMII")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 1 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 3bd20f7651207..da8c2c4aca7ef 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1443,6 +1443,7 @@ static void xgbe_stop(struct xgbe_prv_data *pdata)
 		return;
 
 	netif_tx_stop_all_queues(netdev);
+	netif_carrier_off(pdata->netdev);
 
 	xgbe_stop_timers(pdata);
 	flush_workqueue(pdata->dev_workqueue);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 8a3a60bb26888..4d5506d928973 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1396,7 +1396,6 @@ static void xgbe_phy_stop(struct xgbe_prv_data *pdata)
 	pdata->phy_if.phy_impl.stop(pdata);
 
 	pdata->phy.link = 0;
-	netif_carrier_off(pdata->netdev);
 
 	xgbe_phy_adjust_link(pdata);
 }
-- 
2.27.0



