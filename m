Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CC7451DEB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhKPAeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343981AbhKOTWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E1B8615E1;
        Mon, 15 Nov 2021 18:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002186;
        bh=bUJhkn8O66m8xRPJtc8JMligjM41Q4ed+tc24hFcbz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFXHMBow6m2P5uqwW6EteCrdtysSce6CuV42c0cwhOcqjBcM0CM5aRQU5pZSBAgnn
         wbRdom0V6F7M/KsBPPyZ4q8vjzDibn1FCg/pNOkUD+XRxMJJW/baiU6MoMHLJJ8jKz
         hJbuKDz432r0cuqBpw9DwUj35ThOQkcBFjOBVLI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Leon Yen <Leon.Yen@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 470/917] mt76: connac: fix GTK rekey offload failure on WPA mixed mode
Date:   Mon, 15 Nov 2021 17:59:25 +0100
Message-Id: <20211115165444.713839461@linuxfoundation.org>
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

From: Leon Yen <Leon.Yen@mediatek.com>

[ Upstream commit 781f62960c635cfed55a8f8c0f909bdaf8268257 ]

Update the proper firmware programming sequence to fix GTK rekey
offload failure on WPA mixed mode.

In the mt76_connac_mcu_key_iter,
gtk_tlv->proto should be only set up on pairwise key
and gtk_tlk->group_cipher should be only set up on the group key.

Otherwise, those parameters required by firmware would be set
incorrectly to cause GTK rekey offload failure on WPA mixed mode
and then disconnection follows.

Fixes: b47e21e75c80 ("mt76: mt7615: add gtk rekey offload support")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Leon Yen <Leon.Yen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c  | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 5c3a81e5f559d..f57f047fce99c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1929,19 +1929,22 @@ mt76_connac_mcu_key_iter(struct ieee80211_hw *hw,
 	    key->cipher != WLAN_CIPHER_SUITE_TKIP)
 		return;
 
-	if (key->cipher == WLAN_CIPHER_SUITE_TKIP) {
-		gtk_tlv->proto = cpu_to_le32(NL80211_WPA_VERSION_1);
+	if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
 		cipher = BIT(3);
-	} else {
-		gtk_tlv->proto = cpu_to_le32(NL80211_WPA_VERSION_2);
+	else
 		cipher = BIT(4);
-	}
 
 	/* we are assuming here to have a single pairwise key */
 	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
+		if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
+			gtk_tlv->proto = cpu_to_le32(NL80211_WPA_VERSION_1);
+		else
+			gtk_tlv->proto = cpu_to_le32(NL80211_WPA_VERSION_2);
+
 		gtk_tlv->pairwise_cipher = cpu_to_le32(cipher);
-		gtk_tlv->group_cipher = cpu_to_le32(cipher);
 		gtk_tlv->keyid = key->keyidx;
+	} else {
+		gtk_tlv->group_cipher = cpu_to_le32(cipher);
 	}
 }
 
-- 
2.33.0



