Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB263C4E38
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243936AbhGLHRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241863AbhGLHQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65A2861166;
        Mon, 12 Jul 2021 07:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074023;
        bh=yJcSW5A/JrH7Vk7WKVMGyO6xZMu5aSJE2TTTdO3+DHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIX9bSYHSBXGNeSPcWrY82H1eCZxhFPgUGsFgfW8J3eyc1/lzgbx2wUX7Apm+duMU
         Iv/WfQ/kl8jUNxXIknPZ1vCrilQ22HqOMg+qOHvPJC/stIwa07mnPGEEnFZ90kzh7m
         qyI6b7+WfpqjQ0/DBJiLPu+BOsKDItGnOmqKrW+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 436/700] mt76: mt7921: consider the invalid value for to_rssi
Date:   Mon, 12 Jul 2021 08:08:39 +0200
Message-Id: <20210712061022.833057801@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index ce4eae7f1e44..39be2e396269 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -420,16 +420,19 @@ int mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
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



