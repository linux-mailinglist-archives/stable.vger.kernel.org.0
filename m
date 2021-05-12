Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A9C37CDD3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbhELQ6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244282AbhELQmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7474761D30;
        Wed, 12 May 2021 16:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835915;
        bh=P+AiUyKVA3U5krzT2rqlWzxXhFL8PY2fFnCn1fGycOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMrd5y1i9jecr8CLs6kubjFdddrOr71NqVGCOqE/uhWVJCeZK1WO4ocy+1viB8iu1
         TgfHy2rgRLG4DLwBF/bg9iU8HLqOXUSBiICI/NA7oEyxs72nJcmeJXrJV5o4XZ3xhf
         vRkjomdwfinya2VpwTtIOuWuK45g6a9Zd4XjC9Tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 536/677] mt76: mt7663: fix when beacon filter is being applied
Date:   Wed, 12 May 2021 16:49:42 +0200
Message-Id: <20210512144855.180423128@linuxfoundation.org>
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

[ Upstream commit 4bec61d9fb9629c21e60cd24a97235ea1f6020ec ]

HW beacon filter command is being applied until we're in associated state
because the command would rely on the associated access point's beacon
interval and DTIM information.

Fixes: 7124198ab1a4 ("mt76: mt7615: enable beacon filtering by default for offload fw")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 8263ff81bb7b..6107e827b383 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -217,8 +217,6 @@ static int mt7615_add_interface(struct ieee80211_hw *hw,
 	ret = mt7615_mcu_add_dev_info(phy, vif, true);
 	if (ret)
 		goto out;
-
-	mt7615_mac_set_beacon_filter(phy, vif, true);
 out:
 	mt7615_mutex_release(dev);
 
@@ -244,7 +242,6 @@ static void mt7615_remove_interface(struct ieee80211_hw *hw,
 
 	mt76_connac_free_pending_tx_skbs(&dev->pm, &msta->wcid);
 
-	mt7615_mac_set_beacon_filter(phy, vif, false);
 	mt7615_mcu_add_dev_info(phy, vif, false);
 
 	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
@@ -544,6 +541,9 @@ static void mt7615_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ARP_FILTER)
 		mt7615_mcu_update_arp_filter(hw, vif, info);
 
+	if (changed & BSS_CHANGED_ASSOC)
+		mt7615_mac_set_beacon_filter(phy, vif, info->assoc);
+
 	mt7615_mutex_release(dev);
 }
 
-- 
2.30.2



