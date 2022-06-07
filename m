Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C392541E8F
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380727AbiFGWcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384010AbiFGWbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA80276201;
        Tue,  7 Jun 2022 12:24:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F3AEB823D6;
        Tue,  7 Jun 2022 19:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6509C36B01;
        Tue,  7 Jun 2022 19:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629841;
        bh=4v+cu7e+Xt75WklgaATgEEarc6UDXVoriEbxTMfiz7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9LHnac5sSkmSc7GDLQLoC8Jo+2H3JbOw2oy7a2X0dnQp+qdGEKV/2RHlu9SVPiQL
         UYYvozpp96NP2b7gZkJjsAGyrcFYp92Q81wLxXz9YMqV7fhIxVV00V3egbZ04I9CIC
         Qy3wNHvo+RI1HKiv2tHaJ9xZeYEopCcr8zyxSZf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pa@panix.com,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.18 835/879] rtl818x: Prevent using not initialized queues
Date:   Tue,  7 Jun 2022 19:05:53 +0200
Message-Id: <20220607165027.092843914@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Wetzel <alexander@wetzel-home.de>

commit 746285cf81dc19502ab238249d75f5990bd2d231 upstream.

Using not existing queues can panic the kernel with rtl8180/rtl8185 cards.
Ignore the skb priority for those cards, they only have one tx queue. Pierre
Asselin (pa@panix.com) reported the kernel crash in the Gentoo forum:

https://forums.gentoo.org/viewtopic-t-1147832-postdays-0-postorder-asc-start-25.html

He also confirmed that this patch fixes the issue. In summary this happened:

After updating wpa_supplicant from 2.9 to 2.10 the kernel crashed with a
"divide error: 0000" when connecting to an AP. Control port tx now tries to
use IEEE80211_AC_VO for the priority, which wpa_supplicants starts to use in
2.10.

Since only the rtl8187se part of the driver supports QoS, the priority
of the skb is set to IEEE80211_AC_BE (2) by mac80211 for rtl8180/rtl8185
cards.

rtl8180 is then unconditionally reading out the priority and finally crashes on
drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c line 544 without this
patch:
	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries

"ring->entries" is zero for rtl8180/rtl8185 cards, tx_ring[2] never got
initialized.

Cc: stable@vger.kernel.org
Reported-by: pa@panix.com
Tested-by: pa@panix.com
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220422145228.7567-1-alexander@wetzel-home.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -460,8 +460,10 @@ static void rtl8180_tx(struct ieee80211_
 	struct rtl8180_priv *priv = dev->priv;
 	struct rtl8180_tx_ring *ring;
 	struct rtl8180_tx_desc *entry;
+	unsigned int prio = 0;
 	unsigned long flags;
-	unsigned int idx, prio, hw_prio;
+	unsigned int idx, hw_prio;
+
 	dma_addr_t mapping;
 	u32 tx_flags;
 	u8 rc_flags;
@@ -470,7 +472,9 @@ static void rtl8180_tx(struct ieee80211_
 	/* do arithmetic and then convert to le16 */
 	u16 frame_duration = 0;
 
-	prio = skb_get_queue_mapping(skb);
+	/* rtl8180/rtl8185 only has one useable tx queue */
+	if (dev->queues > IEEE80211_AC_BK)
+		prio = skb_get_queue_mapping(skb);
 	ring = &priv->tx_ring[prio];
 
 	mapping = dma_map_single(&priv->pdev->dev, skb->data, skb->len,


