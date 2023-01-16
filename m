Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A485766CB3C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbjAPRMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbjAPRLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:11:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD9B46717
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:51:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEDDD61050
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C41C433D2;
        Mon, 16 Jan 2023 16:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887908;
        bh=0GMCo5dgqnLZz/xLU33OcMf9PF1DcJX2vENH8Awur4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZtwY+3/HB7YsHiE/jvWRjlNxu5b0oUmTtffmS7ILwS8GDH7N14OOYnr1GGbZ92rL
         yyvDbJIMWr99iFQGMLzlhCU3ike5CN/jyGEY8Tpmyb3GGPemL1LMjCkkEHFgSYaSb+
         KVFvvGg/SHJoDzboO4Uq7XgPkrGE8MCY9Rg8caTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 298/521] mISDN: hfcsusb: dont call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
Date:   Mon, 16 Jan 2023 16:49:20 +0100
Message-Id: <20230116154900.444259088@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit ddc9648db162eee556edd5222d2808fe33730203 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

skb_queue_purge() is called under spin_lock_irqsave() in hfcusb_l2l1D(),
kfree_skb() is called in it, to fix this, use skb_queue_splice_init()
to move the dch->squeue to a free queue, also enqueue the tx_skb and
rx_skb, at last calling __skb_queue_purge() to free the SKBs afer unlock.

In tx_iso_complete(), dev_kfree_skb() is called to consume the transmitted
SKB, so replace it with dev_consume_skb_irq().

Fixes: 69f52adb2d53 ("mISDN: Add HFC USB driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index c952002c6301..c49081ed5734 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -337,20 +337,24 @@ hfcusb_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 
 		if (hw->protocol == ISDN_P_NT_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			hfcsusb_ph_command(hw, HFC_L1_DEACTIVATE_NT);
 			spin_lock_irqsave(&hw->lock, flags);
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
 			spin_unlock_irqrestore(&hw->lock, flags);
+			__skb_queue_purge(&free_queue);
 #ifdef FIXME
 			if (test_and_clear_bit(FLG_L1_BUSY, &dch->Flags))
 				dchannel_sched_event(&hc->dch, D_CLEARBUSY);
@@ -1344,7 +1348,7 @@ tx_iso_complete(struct urb *urb)
 					printk("\n");
 				}
 
-				dev_kfree_skb(tx_skb);
+				dev_consume_skb_irq(tx_skb);
 				tx_skb = NULL;
 				if (fifo->dch && get_next_dframe(fifo->dch))
 					tx_skb = fifo->dch->tx_skb;
-- 
2.35.1



