Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6BF3C53E5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349037AbhGLH4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350766AbhGLHvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ABCA60FF1;
        Mon, 12 Jul 2021 07:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076093;
        bh=0KdloTFyTu4iZAS6iDvxMQ/hOTX7F1EjYJaTOFf8c5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oK6Dzj4Kf5+ldFp202ldqmPQhrNXNfJh/JCH4aqR2OzbmqmcdoItEhYaip1iVUQeh
         6RW+0sv8QWrfZsNKkLYQ3Ak3uyOIghTGnpJjdI3EVE+2r/DquwP5fIOF+PSqTztOvp
         FnE6TW4GQPb3WPWvWbwxEOejY6O+z+iQAGrQvpkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 495/800] mt76: mt7921: consider the invalid value for to_rssi
Date:   Mon, 12 Jul 2021 08:08:38 +0200
Message-Id: <20210712061019.850273551@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit edb5aebc1c3db312e74e1dcf75b8626ee5300596 ]

It is possible the RCPI from the certain antenna is an invalid value,
especially packets are receiving while the system is frequently entering
deep sleep mode, so consider calculating RSSI with the reasonable upper
bound to avoid report the wrong value to the mac80211 layer.

Fixes: 163f4d22c118 ("mt76: mt7921: add MAC support")
Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index decf2d5f0ce3..9bb88b2e28a9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -444,16 +444,19 @@ int mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
 		status->chain_signal[1] = to_rssi(MT_PRXV_RCPI1, v1);
 		status->chain_signal[2] = to_rssi(MT_PRXV_RCPI2, v1);
 		status->chain_signal[3] = to_rssi(MT_PRXV_RCPI3, v1);
-		status->signal = status->chain_signal[0];
-
-		for (i = 1; i < hweight8(mphy->antenna_mask); i++) {
-			if (!(status->chains & BIT(i)))
+		status->signal = -128;
+		for (i = 0; i < hweight8(mphy->antenna_mask); i++) {
+			if (!(status->chains & BIT(i)) ||
+			    status->chain_signal[i] >= 0)
 				continue;
 
 			status->signal = max(status->signal,
 					     status->chain_signal[i]);
 		}
 
+		if (status->signal == -128)
+			status->flag |= RX_FLAG_NO_SIGNAL_VAL;
+
 		stbc = FIELD_GET(MT_PRXV_STBC, v0);
 		gi = FIELD_GET(MT_PRXV_SGI, v0);
 		cck = false;
-- 
2.30.2



