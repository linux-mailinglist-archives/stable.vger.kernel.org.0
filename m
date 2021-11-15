Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA5C451119
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243468AbhKOTBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:01:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243484AbhKOS7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:59:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AE2161027;
        Mon, 15 Nov 2021 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000002;
        bh=hn6X+C2qlh+J4yg96QjtdrInsnzs22vSWVQS4gkvOHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQBXZpyfCkCaVbpudKYkEhc6Jdf3gn2AdcYWBcW3Y0dzZKL01TwPZfIaWcl018x+W
         bxOTfv24QsjUFUwKelChiHJ579MfQTNQ+P7GSjaMDT90b3SdHO/tCIlWUDVYKyMGch
         B7e7EbYXBwhix9rdPuKs/bqJYK+sAJu0l6cNRF7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bo Jiao <bo.jiao@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 459/849] mt76: mt7915: fix potential overflow of eeprom page index
Date:   Mon, 15 Nov 2021 17:59:02 +0100
Message-Id: <20211115165435.814500967@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 82a980f82a511ce74ab57eb9f692d02225eb32f4 ]

If total eeprom size is divisible by per-page size, the i in for loop
will exceed max page index, which happens in our newer chipset.

Fixes: 26f18380e6ca ("mt76: mt7915: add support for flash mode")
Signed-off-by: Bo Jiao <bo.jiao@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index c08c7398f9b85..e7e396f58c92c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3391,20 +3391,20 @@ int mt7915_mcu_set_chan_info(struct mt7915_phy *phy, int cmd)
 
 static int mt7915_mcu_set_eeprom_flash(struct mt7915_dev *dev)
 {
-#define TOTAL_PAGE_MASK		GENMASK(7, 5)
+#define MAX_PAGE_IDX_MASK	GENMASK(7, 5)
 #define PAGE_IDX_MASK		GENMASK(4, 2)
 #define PER_PAGE_SIZE		0x400
 	struct mt7915_mcu_eeprom req = { .buffer_mode = EE_MODE_BUFFER };
-	u8 total = MT7915_EEPROM_SIZE / PER_PAGE_SIZE;
+	u8 total = DIV_ROUND_UP(MT7915_EEPROM_SIZE, PER_PAGE_SIZE);
 	u8 *eep = (u8 *)dev->mt76.eeprom.data;
 	int eep_len;
 	int i;
 
-	for (i = 0; i <= total; i++, eep += eep_len) {
+	for (i = 0; i < total; i++, eep += eep_len) {
 		struct sk_buff *skb;
 		int ret;
 
-		if (i == total)
+		if (i == total - 1 && !!(MT7915_EEPROM_SIZE % PER_PAGE_SIZE))
 			eep_len = MT7915_EEPROM_SIZE % PER_PAGE_SIZE;
 		else
 			eep_len = PER_PAGE_SIZE;
@@ -3414,7 +3414,7 @@ static int mt7915_mcu_set_eeprom_flash(struct mt7915_dev *dev)
 		if (!skb)
 			return -ENOMEM;
 
-		req.format = FIELD_PREP(TOTAL_PAGE_MASK, total) |
+		req.format = FIELD_PREP(MAX_PAGE_IDX_MASK, total - 1) |
 			     FIELD_PREP(PAGE_IDX_MASK, i) | EE_FORMAT_WHOLE;
 		req.len = cpu_to_le16(eep_len);
 
-- 
2.33.0



