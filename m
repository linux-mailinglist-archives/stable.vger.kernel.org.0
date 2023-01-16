Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3116B66CCC0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbjAPR3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbjAPR2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:28:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677AA23DBC
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BCC5B81014
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF07C433D2;
        Mon, 16 Jan 2023 17:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888749;
        bh=YEgd9/ufPKDPwBq2ItBbX0/W5UAJwFGwbt6yJM8tJQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdLtWKJ57noBBJzShXv9NYpcdicBauhZQ5p4rSOjMACPTMguHCwyI9/huwlzWxU2+
         8H5dbAvO7kYrphFXpfu+aYtfs0xrA9DgDqPxdZqxnlYs4FWklAlzZcK8zXDWK60YGq
         nS65w/VSwSNe1Wke9Ml4iRxLnGbUU5wkjy6QLjJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 125/338] net: apple: mace: dont call dev_kfree_skb() under spin_lock_irqsave()
Date:   Mon, 16 Jan 2023 16:49:58 +0100
Message-Id: <20230116154826.285246496@linuxfoundation.org>
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
index e58b157b7d7c..11e6285b0c8e 100644
--- a/drivers/net/ethernet/apple/mace.c
+++ b/drivers/net/ethernet/apple/mace.c
@@ -842,7 +842,7 @@ static void mace_tx_timeout(unsigned long data)
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



