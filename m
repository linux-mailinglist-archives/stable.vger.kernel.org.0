Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FD554185F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379593AbiFGVMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380017AbiFGVLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39D9131F19;
        Tue,  7 Jun 2022 11:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 291D3B82182;
        Tue,  7 Jun 2022 18:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82772C385A5;
        Tue,  7 Jun 2022 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627972;
        bh=edmrEx74CLJEL2ZSmVTR+lC6JWHI26Po+D1lAUpwoPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4Q55Z7L8Tw3J/7qB58IA4eiMBgcgrUKZOowfNQr0hyWpydyceiA/q5cB6ZG+91tA
         YJhET7idukzVIQRbJRX+vMJWAkqXY1C4KRiXL2Ul85jeJT/ywQvutO9tYwQPBQA3s0
         M2jEgyU/sWdyg6Egxvj9CMekeNhNJz/FRRcCMwPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thibaut=20VAR=C3=88NE?= <hacks+kernel@slashdirt.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 161/879] mt76: fix encap offload ethernet type check
Date:   Tue,  7 Jun 2022 18:54:39 +0200
Message-Id: <20220607165007.379568253@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bc98e7fdd80d215b4b55eea001023231eb8ce12e ]

The driver needs to check if the format is 802.2 vs 802.3 in order to set
a tx descriptor flag. skb->protocol can't be used, since it may not be properly
initialized for packets coming in from a packet socket.
Fix misdetection by checking the ethertype from the skb data instead

Reported-by: Thibaut VARÈNE <hacks+kernel@slashdirt.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index a8df65cc115f..eaa31f5e0b00 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1017,6 +1017,7 @@ mt7915_mac_write_txwi_8023(struct mt7915_dev *dev, __le32 *txwi,
 
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	u8 fc_type, fc_stype;
+	u16 ethertype;
 	bool wmm = false;
 	u32 val;
 
@@ -1030,7 +1031,8 @@ mt7915_mac_write_txwi_8023(struct mt7915_dev *dev, __le32 *txwi,
 	val = FIELD_PREP(MT_TXD1_HDR_FORMAT, MT_HDR_FORMAT_802_3) |
 	      FIELD_PREP(MT_TXD1_TID, tid);
 
-	if (be16_to_cpu(skb->protocol) >= ETH_P_802_3_MIN)
+	ethertype = get_unaligned_be16(&skb->data[12]);
+	if (ethertype >= ETH_P_802_3_MIN)
 		val |= MT_TXD1_ETH_802_3;
 
 	txwi[1] |= cpu_to_le32(val);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index f34070ca7bbe..c5350e7a11e6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -814,6 +814,7 @@ mt7921_mac_write_txwi_8023(struct mt7921_dev *dev, __le32 *txwi,
 {
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	u8 fc_type, fc_stype;
+	u16 ethertype;
 	bool wmm = false;
 	u32 val;
 
@@ -827,7 +828,8 @@ mt7921_mac_write_txwi_8023(struct mt7921_dev *dev, __le32 *txwi,
 	val = FIELD_PREP(MT_TXD1_HDR_FORMAT, MT_HDR_FORMAT_802_3) |
 	      FIELD_PREP(MT_TXD1_TID, tid);
 
-	if (be16_to_cpu(skb->protocol) >= ETH_P_802_3_MIN)
+	ethertype = get_unaligned_be16(&skb->data[12]);
+	if (ethertype >= ETH_P_802_3_MIN)
 		val |= MT_TXD1_ETH_802_3;
 
 	txwi[1] |= cpu_to_le32(val);
-- 
2.35.1



