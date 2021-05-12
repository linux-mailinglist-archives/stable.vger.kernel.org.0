Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAD737C6FC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhELP5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhELPwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:52:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2A98619E6;
        Wed, 12 May 2021 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833196;
        bh=DAKWdt7SaXq9d8cSe5caxObFgT5KjxCIGYbUGBmgI14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujphlxiLyA1YcnaJU8To8+qmopZyfDNW75nZ+OPxOAOB23wGVelvXFD9Cm323oRSk
         SuCD2ldpMINWZWafUU9VC37RuBxLEmKg5PJy1ui1XNsnkx+fVJ59SYopFEr4QIWTye
         JpBIIyxd7YeZ9uNc9ZDiB/9R4zS0F611WF8s6qLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.11 056/601] mt76: mt7615: use ieee80211_free_txskb() in mt7615_tx_token_put()
Date:   Wed, 12 May 2021 16:42:13 +0200
Message-Id: <20210512144829.661119020@linuxfoundation.org>
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
@@ -2066,8 +2066,12 @@ void mt7615_tx_token_put(struct mt7615_d
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


