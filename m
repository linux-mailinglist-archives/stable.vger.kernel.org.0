Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A3B37CDC6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245688AbhELQ6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244167AbhELQmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 078B161999;
        Wed, 12 May 2021 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835881;
        bh=zxxSk/IyWU5dv8/Xaz0sUaO6ulTnEJEGiLK0dDVusBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kS3GKzHjueayXnb5IsmoKKP4D0dyKFUHMoRUNr45GBtevdisoDTsxPcnghKUtZ4nE
         Mcnt7RChMXexlrzGHOp8Ogu7bC3C5tdnSY9t1smTkH00cwcjbVAM3p52cW2Bp9ls5N
         Fg53ZFV+elu1+jJTZcx52/ExPIUGasOImTxLVe3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soul Huang <Soul.Huang@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 521/677] mt76: connac: fix up the setting for ht40 mode in mt76_connac_mcu_uni_add_bss
Date:   Wed, 12 May 2021 16:49:27 +0200
Message-Id: <20210512144854.698418815@linuxfoundation.org>
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

[ Upstream commit a7e3033fcdb60ad51b03896ae99ad9447389bed0 ]

Use proper value for ht40 mode configuration in mt76_connac_mcu_uni_add_bss
routine and not ht20 one

Fixes: d0e274af2f2e4 ("mt76: mt76_connac: create mcu library")
Co-developed-by: Soul Huang <Soul.Huang@mediatek.com>
Signed-off-by: Soul Huang <Soul.Huang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 6cbccfb05f8b..4356bf130dbd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1195,6 +1195,7 @@ int mt76_connac_mcu_uni_add_bss(struct mt76_phy *phy,
 			.center_chan = ieee80211_frequency_to_channel(freq1),
 			.center_chan2 = ieee80211_frequency_to_channel(freq2),
 			.tx_streams = hweight8(phy->antenna_mask),
+			.ht_op_info = 4, /* set HT 40M allowed */
 			.rx_streams = phy->chainmask,
 			.short_st = true,
 		},
@@ -1287,6 +1288,7 @@ int mt76_connac_mcu_uni_add_bss(struct mt76_phy *phy,
 	case NL80211_CHAN_WIDTH_20:
 	default:
 		rlm_req.rlm.bw = CMD_CBW_20MHZ;
+		rlm_req.rlm.ht_op_info = 0;
 		break;
 	}
 
-- 
2.30.2



