Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A00451DDE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348755AbhKPAeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343965AbhKOTWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E6B63610;
        Mon, 15 Nov 2021 18:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002165;
        bh=ZFO3A1aLs7UM3wgRW6/wf0hSRY6OOaENZhff+KKRNes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wEjY1VJGoyPSfC05h+LgkYLoafby5IoT+IkstM02KrdFIMCgCp+y6+bDul255UheZ
         yx7xCRvWZ/p/fdKooMfMnAYyx0/g6z9cNnwb2bHVXe1zdDr4NonSIrGRCGh/Cc9rwZ
         t02Xnob0oKRsLDDrspei73oZCOZH2aKzODIx6zjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 463/917] mt76: fix build error implicit enumeration conversion
Date:   Mon, 15 Nov 2021 17:59:18 +0100
Message-Id: <20211115165444.474981447@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit adedbc643f02f5a3193b8dcc5cfca97b4c988667 ]

drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:114:10: error: implicit
conversion from enumeration type 'enum mt76_cipher_type' to different
enumeration type 'enum mcu_cipher_type' [-Werror,-Wenum-conversion]
                return MT_CIPHER_NONE;
                ~~~~~~ ^~~~~~~~~~~~~~

drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:114:10: error: implicit
conversion from enumeration type 'enum mt76_cipher_type' to different
enumeration type 'enum mcu_cipher_type' [-Werror,-Wenum-conversion]
                return MT_CIPHER_NONE;
                ~~~~~~ ^~~~~~~~~~~~~~

Fixes: c368362c36d3 ("mt76: fix iv and CCMP header insertion")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index caf2033c5c17e..c08c7398f9b85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1201,7 +1201,7 @@ mt7915_mcu_sta_key_tlv(struct mt7915_sta *msta, struct sk_buff *skb,
 		u8 cipher;
 
 		cipher = mt7915_mcu_get_cipher(key->cipher);
-		if (cipher == MT_CIPHER_NONE)
+		if (cipher == MCU_CIPHER_NONE)
 			return -EOPNOTSUPP;
 
 		sec_key = &sec->key[0];
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 68840e55ede7a..8329b705c2ca2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -620,7 +620,7 @@ mt7921_mcu_sta_key_tlv(struct mt7921_sta *msta, struct sk_buff *skb,
 		u8 cipher;
 
 		cipher = mt7921_mcu_get_cipher(key->cipher);
-		if (cipher == MT_CIPHER_NONE)
+		if (cipher == MCU_CIPHER_NONE)
 			return -EOPNOTSUPP;
 
 		sec_key = &sec->key[0];
-- 
2.33.0



