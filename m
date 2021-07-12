Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070713C53DD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348867AbhGLH4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350741AbhGLHvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B31161981;
        Mon, 12 Jul 2021 07:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076076;
        bh=psLLuZJiTApHCBi4AlJ4ZkeQvYSA/GjKq0ydKo6VIZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWSVpor7oXGQ/q6weWo3chPeEukAF8+QiugBH1AB+5QDLICaZ8Y+yabj65jzqDZ9l
         a1/AOnL/evYWbXKPOsTA5USl9RlqQ5+ZendVWp28b/TWrykJ+I973fmxu9GoZJgzU6
         HlB9yObV51ccPIZkECZiZ2EiNLUkZcwcf6oQ10/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 489/800] mt76: fix possible NULL pointer dereference in mt76_tx
Date:   Mon, 12 Jul 2021 08:08:32 +0200
Message-Id: <20210712061019.174305633@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d7400a2f3e295b8cee692c7a66e10f60015a3c37 ]

Even if this is not a real issue since mt76_tx is never run with wcid set
to NULL, fix a theoretical NULL pointer dereference in mt76_tx routine

Fixes: db9f11d3433f7 ("mt76: store wcid tx rate info in one u32 reduce locking")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 53ea8de82df0..441d06e30b1a 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -285,7 +285,7 @@ mt76_tx(struct mt76_phy *phy, struct ieee80211_sta *sta,
 		skb_set_queue_mapping(skb, qid);
 	}
 
-	if (!(wcid->tx_info & MT_WCID_TX_INFO_SET))
+	if (wcid && !(wcid->tx_info & MT_WCID_TX_INFO_SET))
 		ieee80211_get_tx_rates(info->control.vif, sta, skb,
 				       info->control.rates, 1);
 
-- 
2.30.2



