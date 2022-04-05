Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F56D4F28C0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbiDEIVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiDEIHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:07:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A0A6A401;
        Tue,  5 Apr 2022 01:01:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75F22617CB;
        Tue,  5 Apr 2022 08:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F38C385B6;
        Tue,  5 Apr 2022 08:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145714;
        bh=7kMRIe5E5plW+zWdx27wKfaHpZNnvpROlbcE8cgadSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gKkRu951TRGn8bDOB87PcXj4wGRVRIcI5dARq7fKGQDwDmUA/TqXaJ4KlnB3OrZF
         GbLRg4CPIdSR0BlEW/fhJWxmT377OMflxKiGodurz80UNlHB0wiYoLllGuRR2Jqa9F
         yGybahiIpJYZmtDbY7OX+Z98bmHv0yWmS37FSvWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Leon Yen <leon.yen@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0502/1126] mt76: mt7921s: fix mt7921s_mcu_[fw|drv]_pmctrl
Date:   Tue,  5 Apr 2022 09:20:49 +0200
Message-Id: <20220405070422.362109384@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Leon Yen <leon.yen@mediatek.com>

[ Upstream commit b12deb5e86fa36dc6f3aa3321f5da27addec4f1f ]

According to the firmware behavior (even the oldest one in linux-firmware)
If the firmware is downloaded, MT7921S must rely on the additional mailbox
mechanism that resides in firmware to check if the device is the right
state for mt7921s_mcu_[fw|drv]_pmctrl. Otherwise, we still apply the old
way for that.

That is a necessary patch before we enable runtime pm for mt7921s as
default.

Fixes: 48fab5bbef40 ("mt76: mt7921: introduce mt7921s support")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Leon Yen <leon.yen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7921/sdio_mcu.c  | 38 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/sdio.h     |  2 +
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c
index d20f2ff01be1..5d8af18c7026 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c
@@ -49,6 +49,26 @@ mt7921s_mcu_send_message(struct mt76_dev *mdev, struct sk_buff *skb,
 	return ret;
 }
 
+static u32 mt7921s_read_rm3r(struct mt7921_dev *dev)
+{
+	struct mt76_sdio *sdio = &dev->mt76.sdio;
+
+	return sdio_readl(sdio->func, MCR_D2HRM3R, NULL);
+}
+
+static u32 mt7921s_clear_rm3r_drv_own(struct mt7921_dev *dev)
+{
+	struct mt76_sdio *sdio = &dev->mt76.sdio;
+	u32 val;
+
+	val = sdio_readl(sdio->func, MCR_D2HRM3R, NULL);
+	if (val)
+		sdio_writel(sdio->func, H2D_SW_INT_CLEAR_MAILBOX_ACK,
+			    MCR_WSICR, NULL);
+
+	return val;
+}
+
 int mt7921s_mcu_init(struct mt7921_dev *dev)
 {
 	static const struct mt76_mcu_ops mt7921s_mcu_ops = {
@@ -88,6 +108,12 @@ int mt7921s_mcu_drv_pmctrl(struct mt7921_dev *dev)
 
 	err = readx_poll_timeout(mt76s_read_pcr, &dev->mt76, status,
 				 status & WHLPCR_IS_DRIVER_OWN, 2000, 1000000);
+
+	if (!err && test_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state))
+		err = readx_poll_timeout(mt7921s_read_rm3r, dev, status,
+					 status & D2HRM3R_IS_DRIVER_OWN,
+					 2000, 1000000);
+
 	sdio_release_host(func);
 
 	if (err < 0) {
@@ -115,12 +141,24 @@ int mt7921s_mcu_fw_pmctrl(struct mt7921_dev *dev)
 
 	sdio_claim_host(func);
 
+	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state)) {
+		err = readx_poll_timeout(mt7921s_clear_rm3r_drv_own,
+					 dev, status,
+					 !(status & D2HRM3R_IS_DRIVER_OWN),
+					 2000, 1000000);
+		if (err < 0) {
+			dev_err(dev->mt76.dev, "mailbox ACK not cleared\n");
+			goto err;
+		}
+	}
+
 	sdio_writel(func, WHLPCR_FW_OWN_REQ_SET, MCR_WHLPCR, NULL);
 
 	err = readx_poll_timeout(mt76s_read_pcr, &dev->mt76, status,
 				 !(status & WHLPCR_IS_DRIVER_OWN), 2000, 1000000);
 	sdio_release_host(func);
 
+err:
 	if (err < 0) {
 		dev_err(dev->mt76.dev, "firmware own failed\n");
 		clear_bit(MT76_STATE_PM, &mphy->state);
diff --git a/drivers/net/wireless/mediatek/mt76/sdio.h b/drivers/net/wireless/mediatek/mt76/sdio.h
index 99db4ad93b7c..27d5d2077eba 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.h
+++ b/drivers/net/wireless/mediatek/mt76/sdio.h
@@ -65,6 +65,7 @@
 #define MCR_H2DSM0R			0x0070
 #define H2D_SW_INT_READ			BIT(16)
 #define H2D_SW_INT_WRITE		BIT(17)
+#define H2D_SW_INT_CLEAR_MAILBOX_ACK	BIT(22)
 
 #define MCR_H2DSM1R			0x0074
 #define MCR_D2HRM0R			0x0078
@@ -109,6 +110,7 @@
 #define MCR_H2DSM2R			0x0160 /* supported in CONNAC2 */
 #define MCR_H2DSM3R			0x0164 /* supported in CONNAC2 */
 #define MCR_D2HRM3R			0x0174 /* supported in CONNAC2 */
+#define D2HRM3R_IS_DRIVER_OWN		BIT(0)
 #define MCR_WTQCR8			0x0190 /* supported in CONNAC2 */
 #define MCR_WTQCR9			0x0194 /* supported in CONNAC2 */
 #define MCR_WTQCR10			0x0198 /* supported in CONNAC2 */
-- 
2.34.1



