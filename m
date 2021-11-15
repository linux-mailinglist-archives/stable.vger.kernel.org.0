Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C67E451DE1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344376AbhKPAe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343926AbhKOTWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B54A63597;
        Mon, 15 Nov 2021 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002154;
        bh=XMurRLKbdokoQ0wXu8uqWwWWsUmdqJRhIwYGr3T1sQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vz8QcieqcwF3aoOFQuVo+5yrzKCRQ251yZRCV2eBVKTbapFeSEjuq8Acms2Kh8o99
         0EN+MG/6rqT+Znar/M37Cb7CB7QvnWTdFiRAz0smy7TBwRq/tpNW78C8BmQEwmvCGr
         zH5ICcoXnzzAgjcELaD9CafCN60OzJXeF8GfXSF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 459/917] mt76: mt7921: fix endianness warning in mt7921_update_txs
Date:   Mon, 15 Nov 2021 17:59:14 +0100
Message-Id: <20211115165444.338825732@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 7fc167bbc9296e6aeaaa4063db3639e8a3db75f6 ]

Fix the following sparse warning in mt7921_update_txs routine:
drivers/net/wireless/mediatek/mt76/mt7921/mac.c:752:31:
	warning: cast to restricted __le32
drivers/net/wireless/mediatek/mt76/mt7921/mac.c:752:31:
	warning: restricted __le32 degrades to integer

Fixes: e5bca8c5d2cd3 ("mt76: mt7921: improve code readability for mt7921_update_txs")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 7fe2e3a50428f..f4714b0f6e5c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -735,8 +735,9 @@ mt7921_mac_write_txwi_80211(struct mt7921_dev *dev, __le32 *txwi,
 static void mt7921_update_txs(struct mt76_wcid *wcid, __le32 *txwi)
 {
 	struct mt7921_sta *msta = container_of(wcid, struct mt7921_sta, wcid);
-	u32 pid, frame_type = FIELD_GET(MT_TXD2_FRAME_TYPE, txwi[2]);
+	u32 pid, frame_type;
 
+	frame_type = FIELD_GET(MT_TXD2_FRAME_TYPE, le32_to_cpu(txwi[2]));
 	if (!(frame_type & (IEEE80211_FTYPE_DATA >> 2)))
 		return;
 
-- 
2.33.0



