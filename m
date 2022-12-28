Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23479657D9B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiL1PpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbiL1Po7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:44:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BF31759C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:44:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA558B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ED8C433D2;
        Wed, 28 Dec 2022 15:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242296;
        bh=CQLLyORBbIsh+JLk/hX2a2QxvM6QZEq71mvmyvFZBEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZJ+NzcRLCwciSLhkdYQ4asnTzJqRIxqMHR0pbPUtugjLUawtmbqgk5xHk3T38xjr
         TWeJVRvucc/Dqu4VoXhpzyheYcqdN6zm1v0J+Ka/WOpopxkQ1rNt2a2VldTZtqsqAT
         nJJ0IWc2JRYmVL1ccpbiIa4o/Vul5/2PImmGBdwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 585/731] mISDN: hfcpci: dont call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
Date:   Wed, 28 Dec 2022 15:41:32 +0100
Message-Id: <20221228144313.504424593@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f0f596bd75a9d573ca9b587abb39cee0b916bb82 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

skb_queue_purge() is called under spin_lock_irqsave() in hfcpci_l2l1D(),
kfree_skb() is called in it, to fix this, use skb_queue_splice_init()
to move the dch->squeue to a free queue, also enqueue the tx_skb and
rx_skb, at last calling __skb_queue_purge() to free the SKBs afer unlock.

Fixes: 1700fe1a10dc ("Add mISDN HFC PCI driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index af17459c1a5c..eba58b99cd29 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1617,16 +1617,19 @@ hfcpci_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 		spin_lock_irqsave(&hc->lock, flags);
 		if (hc->hw.protocol == ISDN_P_NT_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			/* prepare deactivation */
 			Write_hfc(hc, HFCPCI_STATES, 0x40);
-			skb_queue_purge(&dch->squeue);
+			skb_queue_splice_init(&dch->squeue, &free_queue);
 			if (dch->tx_skb) {
-				dev_kfree_skb(dch->tx_skb);
+				__skb_queue_tail(&free_queue, dch->tx_skb);
 				dch->tx_skb = NULL;
 			}
 			dch->tx_idx = 0;
 			if (dch->rx_skb) {
-				dev_kfree_skb(dch->rx_skb);
+				__skb_queue_tail(&free_queue, dch->rx_skb);
 				dch->rx_skb = NULL;
 			}
 			test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
@@ -1639,10 +1642,12 @@ hfcpci_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 			hc->hw.mst_m &= ~HFCPCI_MASTER;
 			Write_hfc(hc, HFCPCI_MST_MODE, hc->hw.mst_m);
 			ret = 0;
+			spin_unlock_irqrestore(&hc->lock, flags);
+			__skb_queue_purge(&free_queue);
 		} else {
 			ret = l1_event(dch->l1, hh->prim);
+			spin_unlock_irqrestore(&hc->lock, flags);
 		}
-		spin_unlock_irqrestore(&hc->lock, flags);
 		break;
 	}
 	if (!ret)
-- 
2.35.1



