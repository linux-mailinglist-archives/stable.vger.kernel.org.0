Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC64CA925
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404662AbfJCQiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404656AbfJCQiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FF8F2133F;
        Thu,  3 Oct 2019 16:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120680;
        bh=NkcIYxUs1IlDR0mZf32LuTga/yc2ontPgJuKphfxU3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1nvjyNxS0yHElTX95jvU+rOjwJ3NX3ditkVscry506iWixa0i6wcLHh0AmIYb8LA
         embEIkAht25II/mgifEWpNyrB0HTLQRL6oI33wvgC3bKcmjYermqwkOiGJWwovv+/I
         ibn7stpy8Ll2cBR//rVB3SGJ7hrB+Tk5PwHLoXRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 312/313] mt76: mt7615: fix mt7615 firmware path definitions
Date:   Thu,  3 Oct 2019 17:54:50 +0200
Message-Id: <20191003154603.923216268@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 9d4d0d06bbf9f7e576b0ebbb2f77672d0fc7f503 ]

mt7615 patch/n9/cr4 firmwares are available in mediatek folder in
linux-firmware repository. Because of this mt7615 won't work on regular
distributions like Ubuntu. Fix path definitions.  Moreover remove useless
firmware name pointers and use definitions directly

Fixes: 04b8e65922f6 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 11 ++++-------
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  6 +++---
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index e2dd425ac97e0..f877e3862f8db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -289,7 +289,6 @@ static int mt7615_driver_own(struct mt7615_dev *dev)
 
 static int mt7615_load_patch(struct mt7615_dev *dev)
 {
-	const char *firmware = MT7615_ROM_PATCH;
 	const struct mt7615_patch_hdr *hdr;
 	const struct firmware *fw = NULL;
 	int len, ret, sem;
@@ -305,7 +304,7 @@ static int mt7615_load_patch(struct mt7615_dev *dev)
 		return -EAGAIN;
 	}
 
-	ret = request_firmware(&fw, firmware, dev->mt76.dev);
+	ret = request_firmware(&fw, MT7615_ROM_PATCH, dev->mt76.dev);
 	if (ret)
 		goto out;
 
@@ -371,14 +370,12 @@ static u32 gen_dl_mode(u8 feature_set, bool is_cr4)
 
 static int mt7615_load_ram(struct mt7615_dev *dev)
 {
-	const struct firmware *fw;
 	const struct mt7615_fw_trailer *hdr;
-	const char *n9_firmware = MT7615_FIRMWARE_N9;
-	const char *cr4_firmware = MT7615_FIRMWARE_CR4;
 	u32 n9_ilm_addr, offset;
 	int i, ret;
+	const struct firmware *fw;
 
-	ret = request_firmware(&fw, n9_firmware, dev->mt76.dev);
+	ret = request_firmware(&fw, MT7615_FIRMWARE_N9, dev->mt76.dev);
 	if (ret)
 		return ret;
 
@@ -426,7 +423,7 @@ static int mt7615_load_ram(struct mt7615_dev *dev)
 
 	release_firmware(fw);
 
-	ret = request_firmware(&fw, cr4_firmware, dev->mt76.dev);
+	ret = request_firmware(&fw, MT7615_FIRMWARE_CR4, dev->mt76.dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index 895c2904d7ebf..929b39fa57c34 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -25,9 +25,9 @@
 #define MT7615_RX_RING_SIZE		1024
 #define MT7615_RX_MCU_RING_SIZE		512
 
-#define MT7615_FIRMWARE_CR4		"mt7615_cr4.bin"
-#define MT7615_FIRMWARE_N9		"mt7615_n9.bin"
-#define MT7615_ROM_PATCH		"mt7615_rom_patch.bin"
+#define MT7615_FIRMWARE_CR4		"mediatek/mt7615_cr4.bin"
+#define MT7615_FIRMWARE_N9		"mediatek/mt7615_n9.bin"
+#define MT7615_ROM_PATCH		"mediatek/mt7615_rom_patch.bin"
 
 #define MT7615_EEPROM_SIZE		1024
 #define MT7615_TOKEN_SIZE		4096
-- 
2.20.1



