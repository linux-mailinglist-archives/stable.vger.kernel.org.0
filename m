Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF53283A2C
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgJEPb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgJEPbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA1320637;
        Mon,  5 Oct 2020 15:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911910;
        bh=41COe5x7JjD1OwT5Ov3l1HjeqLrAse49svUyDHzocaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h45kjn5EZFxNw2J8UHxB7mRNSv4p+Xxzg69AIpir+K3m4603Zh14n3QYnFsYBD9yT
         5JquhSYqnZdbWabrGkhhpj/YLNzDg/1uaeXszHaUZaaZykXcIFflkCPRSmbD8oS7l1
         iKx898JBrkOxYhzXMdBxzJNRVYu+aB0lPHweTgvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 26/85] mt76: mt7915: use ieee80211_free_txskb to free tx skbs
Date:   Mon,  5 Oct 2020 17:26:22 +0200
Message-Id: <20201005142115.992519492@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit b4be5a53ebf478ffcfb4c98c0ccc4a8d922b9a02 ]

Using dev_kfree_skb for tx skbs breaks AQL. This worked until now only
by accident, because a mac80211 issue breaks AQL on drivers with firmware
rate control that report the rate via ieee80211_tx_status_ext as struct
rate_info.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200812144943.91974-1-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 8 ++++++--
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c  | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index aadf56e80bae8..d7a3b05ab50c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -691,8 +691,12 @@ void mt7915_unregister_device(struct mt7915_dev *dev)
 	spin_lock_bh(&dev->token_lock);
 	idr_for_each_entry(&dev->token, txwi, id) {
 		mt7915_txp_skb_unmap(&dev->mt76, txwi);
-		if (txwi->skb)
-			dev_kfree_skb_any(txwi->skb);
+		if (txwi->skb) {
+			struct ieee80211_hw *hw;
+
+			hw = mt76_tx_status_get_hw(&dev->mt76, txwi->skb);
+			ieee80211_free_txskb(hw, txwi->skb);
+		}
 		mt76_put_txwi(&dev->mt76, txwi);
 	}
 	spin_unlock_bh(&dev->token_lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index a264e304a3dfb..5800b2d1fb233 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -844,7 +844,7 @@ mt7915_tx_complete_status(struct mt76_dev *mdev, struct sk_buff *skb,
 	if (sta || !(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mt7915_tx_status(sta, hw, info, NULL);
 
-	dev_kfree_skb(skb);
+	ieee80211_free_txskb(hw, skb);
 }
 
 void mt7915_txp_skb_unmap(struct mt76_dev *dev,
-- 
2.25.1



