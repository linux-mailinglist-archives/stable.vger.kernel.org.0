Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F41D2E67B1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbgL1Q2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:28:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730849AbgL1NHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E21207C9;
        Mon, 28 Dec 2020 13:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160852;
        bh=ueensCA/GY8lQs1lE3YWuA5roC1kc2x3rpLt016DSss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afA1lJWvH/rbSq0oko+4tbsX4LtW+3Q0iXxTq8sgB/0UAb8b1BimfPfX81cFFExXl
         hy2TFVo5NjDxLiofXuewqOPTdEOloGdMZ1zx9x/Ub+h64ZVU6r+6X6NLARsLv5J7e/
         R5pO8YLVYakbJnHtdH/GoDRHTMvzx28VhHN4mzwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 017/242] net: stmmac: free tx skb buffer in stmmac_resume()
Date:   Mon, 28 Dec 2020 13:47:02 +0100
Message-Id: <20201228124905.520184309@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit 4ec236c7c51f89abb0224a4da4a6b77f9beb6600 ]

When do suspend/resume test, there have WARN_ON() log dump from
stmmac_xmit() funciton, the code logic:
	entry = tx_q->cur_tx;
	first_entry = entry;
	WARN_ON(tx_q->tx_skbuff[first_entry]);

In normal case, tx_q->tx_skbuff[txq->cur_tx] should be NULL because
the skb should be handled and freed in stmmac_tx_clean().

But stmmac_resume() reset queue parameters like below, skb buffers
may not be freed.
	tx_q->cur_tx = 0;
	tx_q->dirty_tx = 0;

So free tx skb buffer in stmmac_resume() to avoid warning and
memory leak.

log:
[   46.139824] ------------[ cut here ]------------
[   46.144453] WARNING: CPU: 0 PID: 0 at drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3235 stmmac_xmit+0x7a0/0x9d0
[   46.154969] Modules linked in: crct10dif_ce vvcam(O) flexcan can_dev
[   46.161328] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O      5.4.24-2.1.0+g2ad925d15481 #1
[   46.170369] Hardware name: NXP i.MX8MPlus EVK board (DT)
[   46.175677] pstate: 80000005 (Nzcv daif -PAN -UAO)
[   46.180465] pc : stmmac_xmit+0x7a0/0x9d0
[   46.184387] lr : dev_hard_start_xmit+0x94/0x158
[   46.188913] sp : ffff800010003cc0
[   46.192224] x29: ffff800010003cc0 x28: ffff000177e2a100
[   46.197533] x27: ffff000176ef0840 x26: ffff000176ef0090
[   46.202842] x25: 0000000000000000 x24: 0000000000000000
[   46.208151] x23: 0000000000000003 x22: ffff8000119ddd30
[   46.213460] x21: ffff00017636f000 x20: ffff000176ef0cc0
[   46.218769] x19: 0000000000000003 x18: 0000000000000000
[   46.224078] x17: 0000000000000000 x16: 0000000000000000
[   46.229386] x15: 0000000000000079 x14: 0000000000000000
[   46.234695] x13: 0000000000000003 x12: 0000000000000003
[   46.240003] x11: 0000000000000010 x10: 0000000000000010
[   46.245312] x9 : ffff00017002b140 x8 : 0000000000000000
[   46.250621] x7 : ffff00017636f000 x6 : 0000000000000010
[   46.255930] x5 : 0000000000000001 x4 : ffff000176ef0000
[   46.261238] x3 : 0000000000000003 x2 : 00000000ffffffff
[   46.266547] x1 : ffff000177e2a000 x0 : 0000000000000000
[   46.271856] Call trace:
[   46.274302]  stmmac_xmit+0x7a0/0x9d0
[   46.277874]  dev_hard_start_xmit+0x94/0x158
[   46.282056]  sch_direct_xmit+0x11c/0x338
[   46.285976]  __qdisc_run+0x118/0x5f0
[   46.289549]  net_tx_action+0x110/0x198
[   46.293297]  __do_softirq+0x120/0x23c
[   46.296958]  irq_exit+0xb8/0xd8
[   46.300098]  __handle_domain_irq+0x64/0xb8
[   46.304191]  gic_handle_irq+0x5c/0x148
[   46.307936]  el1_irq+0xb8/0x180
[   46.311076]  cpuidle_enter_state+0x84/0x360
[   46.315256]  cpuidle_enter+0x34/0x48
[   46.318829]  call_cpuidle+0x18/0x38
[   46.322314]  do_idle+0x1e0/0x280
[   46.325539]  cpu_startup_entry+0x24/0x40
[   46.329460]  rest_init+0xd4/0xe0
[   46.332687]  arch_call_rest_init+0xc/0x14
[   46.336695]  start_kernel+0x420/0x44c
[   46.340353] ---[ end trace bc1ee695123cbacd ]---

Fixes: 47dd7a540b8a0 ("net: add support for STMicroelectronics Ethernet controllers.")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1429,6 +1429,19 @@ static void dma_free_tx_skbufs(struct st
 }
 
 /**
+ * stmmac_free_tx_skbufs - free TX skb buffers
+ * @priv: private structure
+ */
+static void stmmac_free_tx_skbufs(struct stmmac_priv *priv)
+{
+	u32 tx_queue_cnt = priv->plat->tx_queues_to_use;
+	u32 queue;
+
+	for (queue = 0; queue < tx_queue_cnt; queue++)
+		dma_free_tx_skbufs(priv, queue);
+}
+
+/**
  * free_dma_rx_desc_resources - free RX dma desc resources
  * @priv: private structure
  */
@@ -4503,6 +4516,7 @@ int stmmac_resume(struct device *dev)
 	 */
 	priv->mss = 0;
 
+	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv);
 
 	stmmac_hw_setup(ndev, false);


