Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6AD6B43B1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjCJOQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjCJOQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:16:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EB6104607
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:15:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B135EB822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17273C433EF;
        Fri, 10 Mar 2023 14:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457734;
        bh=7IM/zsojAGQsDH/JtzFRT3kehHuaeOVwCp0dELAfsuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQEcTM3AwgIqn3Eg9d3vLy5rZtxFvtQegi3Q7/o8m5B3Lnz2VZveEA8AH+s18+9Kv
         BaEcavabd/yPGSe2IJPtERIPhikhQqyxVRn0SMudqEZeqJ/J+UfkI2S55Buey552e1
         uHY92CXNV/fAqhFzjUJF6hw4p6njIbuJLxOEiWj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/252] wifi: rtl8xxxu: dont call dev_kfree_skb() under spin_lock_irqsave()
Date:   Fri, 10 Mar 2023 14:36:32 +0100
Message-Id: <20230310133719.494234835@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4c2005ac87685907b3719b4f40215b578efd27c4 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In this case, dev_kfree_skb() is called to free and drop the SKB when
it's shutdown, so replace it with dev_kfree_skb_irq(). Compile tested
only.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221208143517.2383424-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index e5aac9694ade2..9cdc8bc41c11a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5101,7 +5101,7 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 		pending = priv->rx_urb_pending_count;
 	} else {
 		skb = (struct sk_buff *)rx_urb->urb.context;
-		dev_kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		usb_free_urb(&rx_urb->urb);
 	}
 
-- 
2.39.2



