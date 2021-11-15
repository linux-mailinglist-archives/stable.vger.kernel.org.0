Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113CA4510FB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243383AbhKOS5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:57:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243223AbhKOSzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:55:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A2F6347F;
        Mon, 15 Nov 2021 18:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999878;
        bh=ZFO3A1aLs7UM3wgRW6/wf0hSRY6OOaENZhff+KKRNes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydgoIDfpNVNlFfKrKu3pYpSs6SoS6QGc0Z+lM1fEYhpegvhj5tCkzsTJ2elZH8WAP
         jGxhKt2NCH6cXZzfE/3Hh0outJ5hvf9ZY3QqUUzkOgw9XBOftHKH9VFFaXstV6m1YU
         bWNV67f/tI3BCcui1Qve/UpUwcoFrjtXwM2/mNVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 455/849] mt76: fix build error implicit enumeration conversion
Date:   Mon, 15 Nov 2021 17:58:58 +0100
Message-Id: <20211115165435.683794554@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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



