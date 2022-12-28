Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E6657A76
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiL1PLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiL1PLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:11:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC7513E16
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:11:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73705B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BF9C433D2;
        Wed, 28 Dec 2022 15:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240277;
        bh=PK9DHjeDqa+7dXSz8ls1e+rVW8Q40/ZB2ysndfLFgf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y23Sp3d3kXDhIdJ9JxBqMjDtzbYG0j5dz1wek2+hBQNcKvG3hEBUaOEG3uIPRr2oN
         +W8lPr/hV7DIAi01orxK/E97hj1teQ4gauhgcr3j7ygKmC2kG0I/vRtEyeeqXgTnf7
         ZcQBlcQlW/wHUGdLPaYMK3oBIb5mS5y0w9hygg2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 331/731] net: apple: mace: dont call dev_kfree_skb() under spin_lock_irqsave()
Date:   Wed, 28 Dec 2022 15:37:18 +0100
Message-Id: <20221228144306.166590972@linuxfoundation.org>
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

[ Upstream commit 3dfe3486c1cd4f82b466b7d307f23777137b8acc ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In this case, dev_kfree_skb() is called in mace_tx_timeout() to drop
the SKB, when tx timeout, so replace it with dev_kfree_skb_irq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apple/mace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/mace.c b/drivers/net/ethernet/apple/mace.c
index 4b80e3a52a19..44037e9e197f 100644
--- a/drivers/net/ethernet/apple/mace.c
+++ b/drivers/net/ethernet/apple/mace.c
@@ -841,7 +841,7 @@ static void mace_tx_timeout(struct timer_list *t)
     if (mp->tx_bad_runt) {
 	mp->tx_bad_runt = 0;
     } else if (i != mp->tx_fill) {
-	dev_kfree_skb(mp->tx_bufs[i]);
+	dev_kfree_skb_irq(mp->tx_bufs[i]);
 	if (++i >= N_TX_RING)
 	    i = 0;
 	mp->tx_empty = i;
-- 
2.35.1



