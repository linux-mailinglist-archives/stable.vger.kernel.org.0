Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFAF50BB1B
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 17:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449137AbiDVPFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 11:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449156AbiDVPF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 11:05:27 -0400
X-Greylist: delayed 566 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Apr 2022 08:02:00 PDT
Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4EDD5D64E;
        Fri, 22 Apr 2022 08:02:00 -0700 (PDT)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1650639152;
        bh=GaoJjEeYtrkZYq4AFZT1+CvDCcuhrnUYGXMkfI7FpRQ=;
        h=From:To:Cc:Subject:Date;
        b=CzwZrV5NYZL8KIzCM80lEPB0a80IVCueADtEVEo9uBUEVg8EmD2lDnBRKGL3r+Z8o
         5S5mdhPakWfCJItvRs08fROhG85iWAsV715NDOvLFcvnk/HL6a/SnuT4ztipDUmFpQ
         bebjjXoAlKOM3jkhvN7xSI6T0SiOgcMESUb9RuTU=
To:     linux-wireless@vger.kernel.org
Cc:     Alexander Wetzel <alexander@wetzel-home.de>,
        stable@vger.kernel.org, pa@panix.com
Subject: [PATCH] rtl8180: Prevent using not initialized queues
Date:   Fri, 22 Apr 2022 16:52:28 +0200
Message-Id: <20220422145228.7567-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Using not existing queues can panic the kernel with rtl8180/rtl8185
cards. Ignore the skb priority for those cards, they only have one
tx queue.

Cc: stable@vger.kernel.org
Reported-by: pa@panix.com
Tested-by: pa@panix.com
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

Pierre Asselin (pa@panix.com) reported a kernel crash in the Gentoo forum:
https://forums.gentoo.org/viewtopic-t-1147832-postdays-0-postorder-asc-start-25.html
He also confirmed that this patch fixes the issue.

In summary this happened:
After updating wpa_supplicant from 2.9 to 2.10 the kernel crashed with a
"divide error: 0000" when connecting to an AP.
Control port tx now tries to use IEEE80211_AC_VO for the priority, which
wpa_supplicants starts to use in 2.10.

Since only the rtl8187se part of the driver supports QoS, the priority
of the skb is set to IEEE80211_AC_BE (2) by mac80211 for rtl8180/rtl8185
cards.

rtl8180 is then unconditionally reading out the priority and finally crashes on
drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c line 544 without this
patch:
	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries

"ring->entries" is zero for rtl8180/rtl8185 cards, tx_ring[2] never got
initialized.

 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index 2477e18c7cae..025619cd14e8 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -460,8 +460,10 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
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
@@ -470,7 +472,9 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	/* do arithmetic and then convert to le16 */
 	u16 frame_duration = 0;
 
-	prio = skb_get_queue_mapping(skb);
+	/* rtl8180/rtl8185 only has one useable tx queue */
+	if (dev->queues > IEEE80211_AC_BK)
+		prio = skb_get_queue_mapping(skb);
 	ring = &priv->tx_ring[prio];
 
 	mapping = dma_map_single(&priv->pdev->dev, skb->data, skb->len,
-- 
2.35.1

