Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F47E37C9E2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhELQXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240553AbhELQSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A07261C89;
        Wed, 12 May 2021 15:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834261;
        bh=nwy01tHbYVB+5hAC8Rr4L6mUhaBkVjntt3nMuMpJZEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdVQht4PWq8BczFl2WZ5BcqRl0+zEIuANTE35LcTsEriVOOff+6KrvN7kC6kSCV1D
         ZaiubhPdSWXZuWt3F4th0UHAvXJOFpUMw8w+bruO/pLzxOR50w4Dc7dpIeM4OdylMg
         j6kRHPLW5H1MtZuFlC84T3uRGfz+pgIVkX9z6zD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 472/601] mt76: mt7663: fix when beacon filter is being applied
Date:   Wed, 12 May 2021 16:49:09 +0200
Message-Id: <20210512144843.389719756@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index a42b4d96860d..0ec836af211c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -231,8 +231,6 @@ static int mt7615_add_interface(struct ieee80211_hw *hw,
 	ret = mt7615_mcu_add_dev_info(dev, vif, true);
 	if (ret)
 		goto out;
-
-	mt7615_mac_set_beacon_filter(phy, vif, true);
 out:
 	mt7615_mutex_release(dev);
 
@@ -258,7 +256,6 @@ static void mt7615_remove_interface(struct ieee80211_hw *hw,
 
 	mt7615_free_pending_tx_skbs(dev, msta);
 
-	mt7615_mac_set_beacon_filter(phy, vif, false);
 	mt7615_mcu_add_dev_info(dev, vif, false);
 
 	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
@@ -557,6 +554,9 @@ static void mt7615_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ARP_FILTER)
 		mt7615_mcu_update_arp_filter(hw, vif, info);
 
+	if (changed & BSS_CHANGED_ASSOC)
+		mt7615_mac_set_beacon_filter(phy, vif, info->assoc);
+
 	mt7615_mutex_release(dev);
 }
 
-- 
2.30.2



