Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7223A45266B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346119AbhKPCFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239821AbhKOSEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F55A632E9;
        Mon, 15 Nov 2021 17:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997955;
        bh=Doa+dlrt1E9DETPcps4m52VHayOEhSJS+X69tFRtHRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pv5p9EETsiWPygHMZb0igdkLF0a41aJEbyUGp5nUnoenpoytcxjmGp1y3CLfa+T+N
         6jp+L0XUzn/oP5xJqn/UlFHm5yd2bLOmCzW73qmc2I4eTA2PI+crxlQbwm16jKhteu
         +fZ6geLM8gSPta9eC1kwJr97KoUfdMYTvyOBnmqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 336/575] mt76: mt7915: fix muar_idx in mt7915_mcu_alloc_sta_req()
Date:   Mon, 15 Nov 2021 18:01:01 +0100
Message-Id: <20211115165355.413219363@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 161cc13912d3c3e8857001988dfba39be842454a ]

For broadcast/multicast wcid, the muar_idx should be 0xe.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 63bc4577c5c57..7b6e9a5352b35 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -631,7 +631,7 @@ mt7915_mcu_alloc_sta_req(struct mt7915_dev *dev, struct mt7915_vif *mvif,
 		.bss_idx = mvif->idx,
 		.wlan_idx_lo = msta ? to_wcid_lo(msta->wcid.idx) : 0,
 		.wlan_idx_hi = msta ? to_wcid_hi(msta->wcid.idx) : 0,
-		.muar_idx = msta ? mvif->omac_idx : 0,
+		.muar_idx = msta && msta->wcid.sta ? mvif->omac_idx : 0xe,
 		.is_tlv_append = 1,
 	};
 	struct sk_buff *skb;
-- 
2.33.0



