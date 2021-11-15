Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6582E4523C9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347048AbhKPBay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:30:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243220AbhKOSzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:55:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C85F63480;
        Mon, 15 Nov 2021 18:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999881;
        bh=X03UOnOAj5lzHAtG1htSWTtU5Fn1ySb8Y34IxPWlr4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKoCXOiUKOluI/y9IaIZaN2Tv4hHNNEhCWIX458BHNvnYmEUF0HOXNMGJTRYtCi00
         FsKUyrKLGJi0uj9VEMWoICfsg3Pses7DkltHFRjHGhtbHsg1tmGqCoD6l2vkSHgfR9
         Iacq1mNZ+alvX1I+uwDHY4o2+JsE2+yRfUgUBaLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 456/849] mt76: mt7921: fix survey-dump reporting
Date:   Mon, 15 Nov 2021 17:58:59 +0100
Message-Id: <20211115165435.721103238@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 64ed76d118c656907ec1155f2cdd24de778470a2 ]

Fix MIB tx-rx MIB counters for survey-dump reporting.

Fixes: 163f4d22c118d ("mt76: mt7921: add MAC support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h | 8 ++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index a9ce10b988273..52d40385fab6c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -106,6 +106,10 @@ mt7921_mac_init_band(struct mt7921_dev *dev, u8 band)
 	mt76_set(dev, MT_WF_RMAC_MIB_TIME0(band), MT_WF_RMAC_MIB_RXTIME_EN);
 	mt76_set(dev, MT_WF_RMAC_MIB_AIRTIME0(band), MT_WF_RMAC_MIB_RXTIME_EN);
 
+	/* enable MIB tx-rx time reporting */
+	mt76_set(dev, MT_MIB_SCR1(band), MT_MIB_TXDUR_EN);
+	mt76_set(dev, MT_MIB_SCR1(band), MT_MIB_RXDUR_EN);
+
 	mt76_rmw_field(dev, MT_DMA_DCR0(band), MT_DMA_DCR0_MAX_RX_LEN, 1536);
 	/* disable rx rate report by default due to hw issues */
 	mt76_clear(dev, MT_DMA_DCR0(band), MT_DMA_DCR0_RXD_G5_EN);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index b6944c867a573..26fb118237626 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -96,6 +96,10 @@
 #define MT_WF_MIB_BASE(_band)		((_band) ? 0xa4800 : 0x24800)
 #define MT_WF_MIB(_band, ofs)		(MT_WF_MIB_BASE(_band) + (ofs))
 
+#define MT_MIB_SCR1(_band)		MT_WF_MIB(_band, 0x004)
+#define MT_MIB_TXDUR_EN			BIT(8)
+#define MT_MIB_RXDUR_EN			BIT(9)
+
 #define MT_MIB_SDR3(_band)		MT_WF_MIB(_band, 0x698)
 #define MT_MIB_SDR3_FCS_ERR_MASK	GENMASK(31, 16)
 
@@ -108,9 +112,9 @@
 #define MT_MIB_SDR34(_band)		MT_WF_MIB(_band, 0x090)
 #define MT_MIB_MU_BF_TX_CNT		GENMASK(15, 0)
 
-#define MT_MIB_SDR36(_band)		MT_WF_MIB(_band, 0x098)
+#define MT_MIB_SDR36(_band)		MT_WF_MIB(_band, 0x054)
 #define MT_MIB_SDR36_TXTIME_MASK	GENMASK(23, 0)
-#define MT_MIB_SDR37(_band)		MT_WF_MIB(_band, 0x09c)
+#define MT_MIB_SDR37(_band)		MT_WF_MIB(_band, 0x058)
 #define MT_MIB_SDR37_RXTIME_MASK	GENMASK(23, 0)
 
 #define MT_MIB_DR8(_band)		MT_WF_MIB(_band, 0x0c0)
-- 
2.33.0



