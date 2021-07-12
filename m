Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4F73C49DF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238320AbhGLGrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237775AbhGLGqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B861D61154;
        Mon, 12 Jul 2021 06:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072135;
        bh=CGX4STmYmzKoBC4bYW/lXC/RX7FrsyVht2Q8keJQoYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEKxN7U9lgUBVOw8aG0TTSGyE47FKKOj9kQzyAw86/WzjvNWZv2u3Pp4pCm+erAlP
         OQ03Zj4tiTDAWUTckKPTUXi5jzerlllx0cMr6TU6cH6gowXQ7J/t5qNm+Ru7tU3CxS
         36aR+jhbWo+wxu9RZrXZA/z28P4H5NgnQi1Tba1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 368/593] mt76: fix possible NULL pointer dereference in mt76_tx
Date:   Mon, 12 Jul 2021 08:08:48 +0200
Message-Id: <20210712060927.117146199@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 44ef4bc7a46e..073c29eb2ed8 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -278,7 +278,7 @@ mt76_tx(struct mt76_phy *phy, struct ieee80211_sta *sta,
 		skb_set_queue_mapping(skb, qid);
 	}
 
-	if (!(wcid->tx_info & MT_WCID_TX_INFO_SET))
+	if (wcid && !(wcid->tx_info & MT_WCID_TX_INFO_SET))
 		ieee80211_get_tx_rates(info->control.vif, sta, skb,
 				       info->control.rates, 1);
 
-- 
2.30.2



