Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500F12E3D80
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440968AbgL1OQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440944AbgL1OQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C0EB22583;
        Mon, 28 Dec 2020 14:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164930;
        bh=9PRscArJdIz080d3J4yv/u/iu37fCnpUoJZKn9l/q1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUPrOMRqL7kpaOjV7mBnLdH8JEWHAPz73bFT0ErKIF858htFZrOjZ4dRHWtDoWkGK
         FlzLRViTdnzxZrWFpvaby8RRi4MClqjl0IyktsB7GhTt7if/7oNqh6nxOsfX8YfAqo
         IW+AAzy0X4p6aHJ9Ko6+QrbN2nRYHLdygdo/LS9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <yn.chen@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/717] mt76: fix tkip configuration for mt7615/7663 devices
Date:   Mon, 28 Dec 2020 13:45:06 +0100
Message-Id: <20201228125035.784546506@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 930e0eaddf810cfa90e114a0df02f48539e1346f ]

Fix Tx-Rx MIC overwrite during TKIP hw key configuration

Fixes: 01cfc1b45421 ("mt76: mt7615: add BIP_CMAC_128 cipher support")
Tested-by: YN Chen <yn.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 8dc645e398fda..3d62fda067e44 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1046,15 +1046,17 @@ int mt7615_mac_wtbl_update_key(struct mt7615_dev *dev,
 	if (cmd == SET_KEY) {
 		if (cipher == MT_CIPHER_TKIP) {
 			/* Rx/Tx MIC keys are swapped */
+			memcpy(data, key, 16);
 			memcpy(data + 16, key + 24, 8);
 			memcpy(data + 24, key + 16, 8);
+		} else {
+			if (cipher != MT_CIPHER_BIP_CMAC_128 && wcid->cipher)
+				memmove(data + 16, data, 16);
+			if (cipher != MT_CIPHER_BIP_CMAC_128 || !wcid->cipher)
+				memcpy(data, key, keylen);
+			else if (cipher == MT_CIPHER_BIP_CMAC_128)
+				memcpy(data + 16, key, 16);
 		}
-		if (cipher != MT_CIPHER_BIP_CMAC_128 && wcid->cipher)
-			memmove(data + 16, data, 16);
-		if (cipher != MT_CIPHER_BIP_CMAC_128 || !wcid->cipher)
-			memcpy(data, key, keylen);
-		else if (cipher == MT_CIPHER_BIP_CMAC_128)
-			memcpy(data + 16, key, 16);
 	} else {
 		if (wcid->cipher & ~BIT(cipher)) {
 			if (cipher != MT_CIPHER_BIP_CMAC_128)
-- 
2.27.0



