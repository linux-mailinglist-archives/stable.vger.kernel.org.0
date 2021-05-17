Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BCF382F34
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbhEQOOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238709AbhEQOMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E125613D2;
        Mon, 17 May 2021 14:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260485;
        bh=7p6tEwovRvT2WrIfHuoK31hZhYVgfKlrH0G76qE3MfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVAgKB3eVd5gJ8n0B9mSix2mmfrhy3vExE50oKsrvpmO6sU0n6Cmzo34yloU4iIcA
         D20pyNksxkZyl4WW4MVCFBNVpUAiHS/P74XNP1E9S0Nk5eMWEoZpCYcWSxlTrUXePE
         vNPPi+VXWXkOxTElfmtyC4LUdfsp9Lf7oqemzJ3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 067/363] mt76: mt7915: always check return value from mt7915_mcu_alloc_wtbl_req
Date:   Mon, 17 May 2021 15:58:53 +0200
Message-Id: <20210517140304.870300189@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 45f93e368211fbbd247e1ece254ffb121e20fa10 ]

As done for mt76_connac_mcu_alloc_wtbl_req, even if this is not a real
bug since mt7915_mcu_alloc_wtbl_req routine can fails just if nskb is NULL,
always check return value from mt7915_mcu_alloc_wtbl_req in order to avoid
possible future mistake.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 443cb09ae7cb..c747349a4c13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1198,6 +1198,9 @@ mt7915_mcu_sta_ba(struct mt7915_dev *dev,
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, sta_wtbl,
 					     &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt7915_mcu_wtbl_ba_tlv(skb, params, enable, tx, sta_wtbl, wtbl_hdr);
 
 	ret = mt76_mcu_skb_send_msg(&dev->mt76, skb,
@@ -1714,6 +1717,9 @@ int mt7915_mcu_sta_update_hdr_trans(struct mt7915_dev *dev,
 		return -ENOMEM;
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, NULL, &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt7915_mcu_wtbl_hdr_trans_tlv(skb, vif, sta, NULL, wtbl_hdr);
 
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb, MCU_EXT_CMD(WTBL_UPDATE),
@@ -1738,6 +1744,9 @@ int mt7915_mcu_add_smps(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_SET, sta_wtbl,
 					     &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt7915_mcu_wtbl_smps_tlv(skb, sta, sta_wtbl, wtbl_hdr);
 
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
@@ -2263,6 +2272,9 @@ int mt7915_mcu_add_sta(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 
 	wtbl_hdr = mt7915_mcu_alloc_wtbl_req(dev, msta, WTBL_RESET_AND_SET,
 					     sta_wtbl, &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	if (enable) {
 		mt7915_mcu_wtbl_generic_tlv(skb, vif, sta, sta_wtbl, wtbl_hdr);
 		mt7915_mcu_wtbl_hdr_trans_tlv(skb, vif, sta, sta_wtbl, wtbl_hdr);
-- 
2.30.2



