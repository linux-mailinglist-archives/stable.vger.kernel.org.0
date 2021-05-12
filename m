Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D16F37CDD0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbhELQ6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244273AbhELQmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E0E761D3C;
        Wed, 12 May 2021 16:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835928;
        bh=+gVY7sAx7mTcq5TAJc+h88nNxE5YqCwdi1uzFIj/vfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTyWtzitdYFacKJmFwlKK8lxuJBLhaV6WeSvyC4iyRZiQDavypNH+gufEypfFL9aL
         /r+DWCYKSSm564HBUjuFx0/BUSStgp0RIuo4BC0paF8eC6U5uVPVuNcEIlQW0yNzzX
         D4c9yoElnB8VQBhiuWEypFWZSRT0Gs+8/lhgld6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Leon Yen <leon.yen@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 541/677] mt76: mt7921: always wake the device in mt7921_remove_interface
Date:   Wed, 12 May 2021 16:49:47 +0200
Message-Id: <20210512144855.340664768@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 859c85fd19715349ce01539459095fd5fc7e483a ]

Make sure the mcu is not in sleep mode before sending mcu messages in
mt7921_remove_interface routine.

Fixes: 1d8efc741df80 ("mt76: mt7921: introduce Runtime PM support")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Co-developed-by: Leon Yen <leon.yen@mediatek.com>
Signed-off-by: Leon Yen <leon.yen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 3566059e5704..166c9c0eb5fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -348,6 +348,7 @@ static void mt7921_remove_interface(struct ieee80211_hw *hw,
 	if (vif == phy->monitor_vif)
 		phy->monitor_vif = NULL;
 
+	mt7921_mutex_acquire(dev);
 	mt76_connac_free_pending_tx_skbs(&dev->pm, &msta->wcid);
 
 	if (dev->pm.enable) {
@@ -360,7 +361,6 @@ static void mt7921_remove_interface(struct ieee80211_hw *hw,
 
 	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 
-	mt7921_mutex_acquire(dev);
 	dev->mt76.vif_mask &= ~BIT(mvif->mt76.idx);
 	phy->omac_mask &= ~BIT_ULL(mvif->mt76.omac_idx);
 	mt7921_mutex_release(dev);
-- 
2.30.2



