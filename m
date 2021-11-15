Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA19F4513BA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhKOTzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343950AbhKOTWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E9B63365;
        Mon, 15 Nov 2021 18:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002151;
        bh=qwivl6QBXeWUvuLBRy8LfcdNXw5gHAOodpc44a9sNMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTHujEe9xqp/8cZg6zrkN+iThFFf1te+3h8i5JZYhyqKc27WNfr/etpO2FrR5+6bv
         T0Opi059G7asTpgXpsFEwbbp5yY981cuO5v/Vz0vyOvzmbiaHSs6uArUYLEnRRI7AC
         sfOmLmbQ8htU0gpu6h47oymCo2A5q2EXcBmat1fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 458/917] mt76: mt7915: fix endianness warning in mt7915_mac_add_txs_skb
Date:   Mon, 15 Nov 2021 17:59:13 +0100
Message-Id: <20211115165444.306061906@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 08b3c8da87aed4200dab00906f149d675ca90f23 ]

Fix the following sparse warning in mt7915_mac_add_txs_skb routine:

drivers/net/wireless/mediatek/mt76/mt7915/mac.c:1235:29:
	warning: cast to restricted __le32
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:1235:23:
	warning: restricted __le32 degrades to integer

Fixes: 3de4cb1756565 ("mt76: mt7915: add support for tx status reporting")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 2462704094b0a..bbc996f86b5c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1232,7 +1232,7 @@ mt7915_mac_add_txs_skb(struct mt7915_dev *dev, struct mt76_wcid *wcid, int pid,
 		goto out;
 
 	info = IEEE80211_SKB_CB(skb);
-	if (!(txs_data[0] & le32_to_cpu(MT_TXS0_ACK_ERROR_MASK)))
+	if (!(txs_data[0] & cpu_to_le32(MT_TXS0_ACK_ERROR_MASK)))
 		info->flags |= IEEE80211_TX_STAT_ACK;
 
 	info->status.ampdu_len = 1;
-- 
2.33.0



