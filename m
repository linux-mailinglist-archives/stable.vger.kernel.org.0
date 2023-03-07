Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E456AEE40
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbjCGSKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjCGSKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BFB9DE31
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:05:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 112DFB8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47362C433D2;
        Tue,  7 Mar 2023 18:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212297;
        bh=Le0XJppRH2Gh/YcCBkNWHfu3aHGKcvhNtp2U/9r1+8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riDDvux53KxFQlQWeZrXLSTQ29p2qKFaw2UefpfKBRAjxzKO6Z7FjNabyyMg760sb
         zHNLomEAADkBoDV8y8d8hpMELHq3aRaAOPn+vCdUUd3Ph+3vj2eGqzT7Puv2BONynX
         VzmPo71ZWScRNGnw9O0KxS7h+IB1xF+TE71jxrHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/885] wifi: mt76: mt7915: check return value before accessing free_block_num
Date:   Tue,  7 Mar 2023 17:50:47 +0100
Message-Id: <20230307170006.783131837@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 59b27a7d472f100ac8998e15a63c47a03cced12a ]

Check return value of mt7915_mcu_get_eeprom_free_block() first before
accessing free_block_num.

Fixes: bbc1d4154ec1 ("mt76: mt7915: add default calibrated data support")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7915/eeprom.c    | 19 ++++++++++++-------
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 10 ++++++----
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 0bce0ce51be00..f0ec000d46cf7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -110,18 +110,23 @@ static int mt7915_eeprom_load(struct mt7915_dev *dev)
 	} else {
 		u8 free_block_num;
 		u32 block_num, i;
+		u32 eeprom_blk_size = MT7915_EEPROM_BLOCK_SIZE;
 
-		mt7915_mcu_get_eeprom_free_block(dev, &free_block_num);
-		/* efuse info not enough */
+		ret = mt7915_mcu_get_eeprom_free_block(dev, &free_block_num);
+		if (ret < 0)
+			return ret;
+
+		/* efuse info isn't enough */
 		if (free_block_num >= 29)
 			return -EINVAL;
 
 		/* read eeprom data from efuse */
-		block_num = DIV_ROUND_UP(eeprom_size,
-					 MT7915_EEPROM_BLOCK_SIZE);
-		for (i = 0; i < block_num; i++)
-			mt7915_mcu_get_eeprom(dev,
-					      i * MT7915_EEPROM_BLOCK_SIZE);
+		block_num = DIV_ROUND_UP(eeprom_size, eeprom_blk_size);
+		for (i = 0; i < block_num; i++) {
+			ret = mt7915_mcu_get_eeprom(dev, i * eeprom_blk_size);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	return mt7915_check_eeprom(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 8d297e4aa7d43..c4843f4de34ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2743,8 +2743,9 @@ int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset)
 	int ret;
 	u8 *buf;
 
-	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_EXT_QUERY(EFUSE_ACCESS), &req,
-				sizeof(req), true, &skb);
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
+					MCU_EXT_QUERY(EFUSE_ACCESS),
+					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
 
@@ -2769,8 +2770,9 @@ int mt7915_mcu_get_eeprom_free_block(struct mt7915_dev *dev, u8 *block_num)
 	struct sk_buff *skb;
 	int ret;
 
-	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_EXT_QUERY(EFUSE_FREE_BLOCK), &req,
-					sizeof(req), true, &skb);
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
+					MCU_EXT_QUERY(EFUSE_FREE_BLOCK),
+					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
 
-- 
2.39.2



