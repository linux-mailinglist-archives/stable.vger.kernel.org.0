Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A6E4F2C01
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbiDEJiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbiDEJE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:04:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED3C2E0BF;
        Tue,  5 Apr 2022 01:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 010D3B81BAE;
        Tue,  5 Apr 2022 08:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665B5C385A1;
        Tue,  5 Apr 2022 08:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148954;
        bh=ZWvgAqBtVuc4/CF/EAQd2akqIqkeQlbhlqYypL92EFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aF2cVI5O+SFYiJIBlQi2ZlNYENLV14ACNQUD9PSnVDMTnPcHB3b2cQgz5QJGGtxaN
         A7a2m0ugvl3YXZv2X9RpLlhTiDBxqBedEnI7UcnMLeByH+SRp928mElo4PJu0kTdqY
         UQCPAgMKsBtiBJj/rT6gShj71FsMuytYpjvIaJcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Leon Yen <Leon.Yen@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0540/1017] mt76: mt7921s: fix missing fc type/sub-type for 802.11 pkts
Date:   Tue,  5 Apr 2022 09:24:13 +0200
Message-Id: <20220405070410.318118777@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 355c060d5f38a784822d544e969121a273bcf545 ]

For non-mmio devices, should set fc values to proper txwi config

Fixes: 48fab5bbef40 ("mt76: mt7921: introduce mt7921s support")
Tested-by: Sean Wang <sean.wang@mediatek.com>
Co-developed-by: Leon Yen <Leon.Yen@mediatek.com>
Signed-off-by: Leon Yen <Leon.Yen@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 12 +++++++++---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h |  3 +++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index ea5ae0fc8f54..57fd626b40da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -836,9 +836,15 @@ mt7921_mac_write_txwi_80211(struct mt7921_dev *dev, __le32 *txwi,
 		txwi[3] |= cpu_to_le32(val);
 	}
 
-	val = FIELD_PREP(MT_TXD7_TYPE, fc_type) |
-	      FIELD_PREP(MT_TXD7_SUB_TYPE, fc_stype);
-	txwi[7] |= cpu_to_le32(val);
+	if (mt76_is_mmio(&dev->mt76)) {
+		val = FIELD_PREP(MT_TXD7_TYPE, fc_type) |
+		      FIELD_PREP(MT_TXD7_SUB_TYPE, fc_stype);
+		txwi[7] |= cpu_to_le32(val);
+	} else {
+		val = FIELD_PREP(MT_TXD8_L_TYPE, fc_type) |
+		      FIELD_PREP(MT_TXD8_L_SUB_TYPE, fc_stype);
+		txwi[8] |= cpu_to_le32(val);
+	}
 }
 
 void mt7921_mac_write_txwi(struct mt7921_dev *dev, __le32 *txwi,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.h b/drivers/net/wireless/mediatek/mt76/mt7921/mac.h
index 544a1c33126a..12e1cf8abe6e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.h
@@ -284,6 +284,9 @@ enum tx_mcu_port_q_idx {
 #define MT_TXD7_HW_AMSDU		BIT(10)
 #define MT_TXD7_TX_TIME			GENMASK(9, 0)
 
+#define MT_TXD8_L_TYPE			GENMASK(5, 4)
+#define MT_TXD8_L_SUB_TYPE		GENMASK(3, 0)
+
 #define MT_TX_RATE_STBC			BIT(13)
 #define MT_TX_RATE_NSS			GENMASK(12, 10)
 #define MT_TX_RATE_MODE			GENMASK(9, 6)
-- 
2.34.1



