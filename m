Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8707737CDD8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbhELQ64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244281AbhELQmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70F4661D3D;
        Wed, 12 May 2021 16:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835933;
        bh=FPCu4wS85Mh0AFZqXVdiT5Jacnrk35+PiSkNOqhXPho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdM5K5BLk8RfyzwVAu+fOqKPe+iv5utHInEEjtILw34Fd1BqgJVm+LVXqWD6gWpHe
         6yD3fNQGeHisFQK4gRC3gpLA28pGVnUHXCQG+Tsy/pa0aVYk3kBK094xfZtGfcZdgx
         Ga+PF2TRMB/YU3+qpbm46PE69y7AcNWMw8kET2l4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soul Huang <Soul.Huang@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 543/677] mt76: mt7921: fix the dwell time control
Date:   Wed, 12 May 2021 16:49:49 +0200
Message-Id: <20210512144855.403912209@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 9db419f0cb39a63fb2f645a846cae17b81cd5c96 ]

dwell time for the scan is not configurable according to the current
firmware submitted into linux-firmware.git, so leave the dwell time 0 to
indicate the dwell time always determined by the firmware.

Fixes: 399090ef9605 ("mt76: mt76_connac: move hw_scan and sched_scan routine in mt76_connac_mcu module")
Suggested-by: Soul Huang <Soul.Huang@mediatek.com>
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 8e9e42b77692..76a61e8b7fb9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1309,7 +1309,7 @@ int mt76_connac_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 {
 	struct mt76_vif *mvif = (struct mt76_vif *)vif->drv_priv;
 	struct cfg80211_scan_request *sreq = &scan_req->req;
-	int n_ssids = 0, err, i, duration = MT76_CONNAC_SCAN_CHANNEL_TIME;
+	int n_ssids = 0, err, i, duration;
 	int ext_channels_num = max_t(int, sreq->n_channels - 32, 0);
 	struct ieee80211_channel **scan_list = sreq->channels;
 	struct mt76_dev *mdev = phy->dev;
@@ -1346,6 +1346,7 @@ int mt76_connac_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	req->ssid_type_ext = n_ssids ? BIT(0) : 0;
 	req->ssids_num = n_ssids;
 
+	duration = is_mt7921(phy->dev) ? 0 : MT76_CONNAC_SCAN_CHANNEL_TIME;
 	/* increase channel time for passive scan */
 	if (!sreq->n_ssids)
 		duration *= 2;
-- 
2.30.2



