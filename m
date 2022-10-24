Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C0B60A417
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiJXMFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiJXMEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:04:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BE9638EB;
        Mon, 24 Oct 2022 04:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71FBEB811B6;
        Mon, 24 Oct 2022 11:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ACAC433D6;
        Mon, 24 Oct 2022 11:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612147;
        bh=nLPJMf6RKNv0U3Go0wd8wDoSsDzpMir4BM5wySpxLXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ES5RJg1QJpie1U1TPWrNyrzqP09RGfdL4xaLTnPWH/LB4Ti93EOdsAgZKzqU7hQpY
         KC91oYX4xHvkdLrFvkuUFmA5dato9qBUJE9e5ckJIHalhrPyVA8SQfbbs6vPQR0EXH
         yKf7E5RSNpWG2VMoFqnYWw7OVD0rR4a4Uuz69C00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 087/210] wifi: rtl8xxxu: Fix skb misuse in TX queue selection
Date:   Mon, 24 Oct 2022 13:30:04 +0200
Message-Id: <20221024112959.871050235@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit edd5747aa12ed61a5ecbfa58d3908623fddbf1e8 ]

rtl8xxxu_queue_select() selects the wrong TX queues because it's
reading memory from the wrong address. It expects to find ieee80211_hdr
at skb->data, but that's not the case after skb_push(). Move the call
to rtl8xxxu_queue_select() before the call to skb_push().

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/7fa4819a-4f20-b2af-b7a6-8ee01ac49295@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 5588518daa96..7cace68ef3c7 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4955,6 +4955,8 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	if (control && control->sta)
 		sta = control->sta;
 
+	queue = rtl8xxxu_queue_select(hw, skb);
+
 	tx_desc = skb_push(skb, tx_desc_size);
 
 	memset(tx_desc, 0, tx_desc_size);
@@ -4967,7 +4969,6 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	    is_broadcast_ether_addr(ieee80211_get_DA(hdr)))
 		tx_desc->txdw0 |= TXDESC_BROADMULTICAST;
 
-	queue = rtl8xxxu_queue_select(hw, skb);
 	tx_desc->txdw1 = cpu_to_le32(queue << TXDESC_QUEUE_SHIFT);
 
 	if (tx_info->control.hw_key) {
-- 
2.35.1



