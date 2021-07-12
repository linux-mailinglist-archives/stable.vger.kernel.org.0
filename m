Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EF13C53D6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348807AbhGLH4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350734AbhGLHvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93BBC61182;
        Mon, 12 Jul 2021 07:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076086;
        bh=dvXbd3fSMyubVxYgqTPS5gQVYHPba5rqS1s6OinuAA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpYanlQGaG+3ZcnQI2ckFjWlQGom8mR3F6hkLrEBrXt0kb9vYdCnJfDPkOOstfRBQ
         4mS+Na7c8fM3cYi7g1ehrDugps0pyi8ytFeb0mwQ9U23+t/R/ym1FfkAjyRLgPln55
         VHjAOt+JHziYGD5CfbZzJbgn2KnrzAlMua2xC9sI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 492/800] mt76: mt7921: Dont alter Rx path classifier
Date:   Mon, 12 Jul 2021 08:08:35 +0200
Message-Id: <20210712061019.504753375@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 2c80c02a682aefc073df2cfbb48c77c74579cb4a ]

Keep Rx path classifier the mt7921 firmware prefers to allow frames pass
through MCU.

Fixes: 5c14a5f944b9 ("mt76: mt7921: introduce mt7921e support")
Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/init.c   | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 1763ea0614ce..b85e46f5820f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -116,30 +116,12 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 static void
 mt7921_mac_init_band(struct mt7921_dev *dev, u8 band)
 {
-	u32 mask, set;
-
 	mt76_rmw_field(dev, MT_TMAC_CTCR0(band),
 		       MT_TMAC_CTCR0_INS_DDLMT_REFTIME, 0x3f);
 	mt76_set(dev, MT_TMAC_CTCR0(band),
 		 MT_TMAC_CTCR0_INS_DDLMT_VHT_SMPDU_EN |
 		 MT_TMAC_CTCR0_INS_DDLMT_EN);
 
-	mask = MT_MDP_RCFR0_MCU_RX_MGMT |
-	       MT_MDP_RCFR0_MCU_RX_CTL_NON_BAR |
-	       MT_MDP_RCFR0_MCU_RX_CTL_BAR;
-	set = FIELD_PREP(MT_MDP_RCFR0_MCU_RX_MGMT, MT_MDP_TO_HIF) |
-	      FIELD_PREP(MT_MDP_RCFR0_MCU_RX_CTL_NON_BAR, MT_MDP_TO_HIF) |
-	      FIELD_PREP(MT_MDP_RCFR0_MCU_RX_CTL_BAR, MT_MDP_TO_HIF);
-	mt76_rmw(dev, MT_MDP_BNRCFR0(band), mask, set);
-
-	mask = MT_MDP_RCFR1_MCU_RX_BYPASS |
-	       MT_MDP_RCFR1_RX_DROPPED_UCAST |
-	       MT_MDP_RCFR1_RX_DROPPED_MCAST;
-	set = FIELD_PREP(MT_MDP_RCFR1_MCU_RX_BYPASS, MT_MDP_TO_HIF) |
-	      FIELD_PREP(MT_MDP_RCFR1_RX_DROPPED_UCAST, MT_MDP_TO_HIF) |
-	      FIELD_PREP(MT_MDP_RCFR1_RX_DROPPED_MCAST, MT_MDP_TO_HIF);
-	mt76_rmw(dev, MT_MDP_BNRCFR1(band), mask, set);
-
 	mt76_set(dev, MT_WF_RMAC_MIB_TIME0(band), MT_WF_RMAC_MIB_RXTIME_EN);
 	mt76_set(dev, MT_WF_RMAC_MIB_AIRTIME0(band), MT_WF_RMAC_MIB_RXTIME_EN);
 
-- 
2.30.2



