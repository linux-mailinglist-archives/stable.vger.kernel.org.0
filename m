Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C8165832D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbiL1Qow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbiL1QgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:36:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6B51BE8C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:32:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6514AB8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B513FC433D2;
        Wed, 28 Dec 2022 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245162;
        bh=d0MDth/qfY9cxyxy3Zk9k5EtCVwww8sBDvtx9JZk5d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXkmib7iRy+U9vp2EXLq6BryBhuy/05f9B6Bq9hCmJB08RILFbNyMuu+x8JZ0AICs
         CGk2TeoL2n3/jwtiOdWehs0n3boDO8GLNWgeylqratlFrXosa7GVZDLPP6BPhLAcQA
         ZPnt3FEqAztzkU1hqtWTmRJtxV1N8PCz9fwZkTW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0843/1073] mISDN: hfcmulti: dont call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
Date:   Wed, 28 Dec 2022 15:40:31 +0100
Message-Id: <20221228144350.919123830@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 1232946cf522b8de9e398828bde325d7c41f29dd ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

skb_queue_purge() is called under spin_lock_irqsave() in handle_dmsg()
and hfcm_l1callback(), kfree_skb() is called in them, to fix this, use
skb_queue_splice_init() to move the dch->squeue to a free queue, also
enqueue the tx_skb and rx_skb, at last calling __skb_queue_purge() to
free the SKBs afer unlock.

Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 4f7eaa17fb27..e840609c50eb 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3217,6 +3217,7 @@ static int
 hfcm_l1callback(struct dchannel *dch, u_int cmd)
 {
 	struct hfc_multi	*hc = dch->hw;
+	struct sk_buff_head	free_queue;
 	u_long	flags;
 
 	switch (cmd) {
@@ -3245,6 +3246,7 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 		l1_event(dch->l1, HW_POWERUP_IND);
 		break;
 	case HW_DEACT_REQ:
+		__skb_queue_head_init(&free_queue);
 		/* start deactivation */
 		spin_lock_irqsave(&hc->lock, flags);
 		if (hc->ctype == HFC_TYPE_E1) {
@@ -3264,20 +3266,21 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 				plxsd_checksync(hc, 0);
 			}
 		}
-		skb_queue_purge(&dch->squeue);
+		skb_queue_splice_init(&dch->squeue, &free_queue);
 		if (dch->tx_skb) {
-			dev_kfree_skb(dch->tx_skb);
+			__skb_queue_tail(&free_queue, dch->tx_skb);
 			dch->tx_skb = NULL;
 		}
 		dch->tx_idx = 0;
 		if (dch->rx_skb) {
-			dev_kfree_skb(dch->rx_skb);
+			__skb_queue_tail(&free_queue, dch->rx_skb);
 			dch->rx_skb = NULL;
 		}
 		test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
 		if (test_and_clear_bit(FLG_BUSY_TIMER, &dch->Flags))
 			del_timer(&dch->timer);
 		spin_unlock_irqrestore(&hc->lock, flags);
+		__skb_queue_purge(&free_queue);
 		break;
 	case HW_POWERUP_REQ:
 		spin_lock_irqsave(&hc->lock, flags);
@@ -3384,6 +3387,9 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 	case PH_DEACTIVATE_REQ:
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 		if (dch->dev.D.protocol != ISDN_P_TE_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			spin_lock_irqsave(&hc->lock, flags);
 			if (debug & DEBUG_HFCMULTI_MSG)
 				printk(KERN_DEBUG
@@ -3405,14 +3411,14 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 				/* deactivate */
 				dch->state = 1;
 			}
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
@@ -3424,6 +3430,7 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 #endif
 			ret = 0;
 			spin_unlock_irqrestore(&hc->lock, flags);
+			__skb_queue_purge(&free_queue);
 		} else
 			ret = l1_event(dch->l1, hh->prim);
 		break;
-- 
2.35.1



