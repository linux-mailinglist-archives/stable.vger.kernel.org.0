Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE7166CD21
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbjAPRd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbjAPRdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:33:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B3565B6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5693B810A0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093E0C433D2;
        Mon, 16 Jan 2023 17:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888969;
        bh=PtBN6fqtXXG1vpvAp9SpjVGy2kXUtNMc/oheOwFEgA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ql9FxeJ38Q9bM0QentttLBUzDJtSHg4lqTAeSeY87mSZ/uspY5mgELj4LhUFWlEmN
         PY7NQSrsc/EdldM5tGqoJGysz48IwkgixcujBUQvBTSdwVDYRfPbnxFf4MH6SHwxEO
         ayUafFU8yE9hl9zPhsb3uSeFmbXRem658thl2RKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 207/338] mISDN: hfcmulti: dont call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
Date:   Mon, 16 Jan 2023 16:51:20 +0100
Message-Id: <20230116154830.015544418@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index df01018acff1..cb86b9bd5c7c 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3233,6 +3233,7 @@ static int
 hfcm_l1callback(struct dchannel *dch, u_int cmd)
 {
 	struct hfc_multi	*hc = dch->hw;
+	struct sk_buff_head	free_queue;
 	u_long	flags;
 
 	switch (cmd) {
@@ -3261,6 +3262,7 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 		l1_event(dch->l1, HW_POWERUP_IND);
 		break;
 	case HW_DEACT_REQ:
+		__skb_queue_head_init(&free_queue);
 		/* start deactivation */
 		spin_lock_irqsave(&hc->lock, flags);
 		if (hc->ctype == HFC_TYPE_E1) {
@@ -3280,20 +3282,21 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
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
@@ -3400,6 +3403,9 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 	case PH_DEACTIVATE_REQ:
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 		if (dch->dev.D.protocol != ISDN_P_TE_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			spin_lock_irqsave(&hc->lock, flags);
 			if (debug & DEBUG_HFCMULTI_MSG)
 				printk(KERN_DEBUG
@@ -3421,14 +3427,14 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
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
@@ -3440,6 +3446,7 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 #endif
 			ret = 0;
 			spin_unlock_irqrestore(&hc->lock, flags);
+			__skb_queue_purge(&free_queue);
 		} else
 			ret = l1_event(dch->l1, hh->prim);
 		break;
-- 
2.35.1



