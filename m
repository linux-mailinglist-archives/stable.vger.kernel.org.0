Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A62237C315
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhELPRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233808AbhELPPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:15:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4236B61417;
        Wed, 12 May 2021 15:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831882;
        bh=RVNQamG8Kq48uincw8ad543Tfj7183+UltcuyUsEuEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVS4FeqlFpruBG1kPqkyv8mi6AYDLA2udzvkugWYIz/mDxMX50kmHtFEfyoGhUI6p
         QKdh09y6pT5F0JnP2T8HbFduvwO2NRvMszL3dnJSywYCqCskhIjFRz2LVZRjiGTYvi
         Nj2tDxK5zjH1sw26hhyY4ECDj5EwJAvrk+7DeEbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.10 053/530] mt76: mt7615: use ieee80211_free_txskb() in mt7615_tx_token_put()
Date:   Wed, 12 May 2021 16:42:43 +0200
Message-Id: <20210512144821.481478769@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

commit 06991d1f73a9bdbc5f234ee96737b9102705b89c upstream.

We should use ieee80211_free_txskb() to report skb status avoid wrong
aql accounting after reset.

Cc: stable@vger.kernel.org
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2106,8 +2106,12 @@ void mt7615_tx_token_put(struct mt7615_d
 	spin_lock_bh(&dev->token_lock);
 	idr_for_each_entry(&dev->token, txwi, id) {
 		mt7615_txp_skb_unmap(&dev->mt76, txwi);
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


