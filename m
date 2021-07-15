Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821223CA8A5
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242517AbhGOTCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241463AbhGOTBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:01:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2A5E613D4;
        Thu, 15 Jul 2021 18:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375480;
        bh=0Em+bgYmrDU1JOZhftUS5xrrOixdfruBKkFRuFCROBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MehYmks3hPIAXbE8JZzu8NrN4v2mQ0A6saVx+484vV+m2YqyHeoWAJoiX7G05rZgE
         Q6nvtbwZd8v8EgjHephxvOAxU+YPZkvPe1hRv8ESiFRcu70bmI60QWM1C17UQun170
         LNkZ3m58TwyoqB0NHLMJq6SNQIxu4Sg/XMD4mZMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evelyn Tsai <evelyn.tsai@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 104/242] mt76: mt7915: fix tssi indication field of DBDC NICs
Date:   Thu, 15 Jul 2021 20:37:46 +0200
Message-Id: <20210715182611.324416592@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evelyn Tsai <evelyn.tsai@mediatek.com>

[ Upstream commit 64cf5ad3c2fa841e4b416343a7ea69c63d60fa4e ]

Correct the bitfield which indicates TSSI on/off for MT7915D NIC.

Signed-off-by: Evelyn Tsai <evelyn.tsai@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
index 3ee8c27bb61b..40a51d99a781 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
@@ -116,12 +116,15 @@ static inline bool
 mt7915_tssi_enabled(struct mt7915_dev *dev, enum nl80211_band band)
 {
 	u8 *eep = dev->mt76.eeprom.data;
+	u8 val = eep[MT_EE_WIFI_CONF + 7];
 
-	/* TODO: DBDC */
-	if (band == NL80211_BAND_5GHZ)
-		return eep[MT_EE_WIFI_CONF + 7] & MT_EE_WIFI_CONF7_TSSI0_5G;
+	if (band == NL80211_BAND_2GHZ)
+		return val & MT_EE_WIFI_CONF7_TSSI0_2G;
+
+	if (dev->dbdc_support)
+		return val & MT_EE_WIFI_CONF7_TSSI1_5G;
 	else
-		return eep[MT_EE_WIFI_CONF + 7] & MT_EE_WIFI_CONF7_TSSI0_2G;
+		return val & MT_EE_WIFI_CONF7_TSSI0_5G;
 }
 
 extern const struct sku_group mt7915_sku_groups[];
-- 
2.30.2



