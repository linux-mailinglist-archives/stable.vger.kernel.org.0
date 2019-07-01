Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6B55BAA3
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 13:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfGAL1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 07:27:37 -0400
Received: from nbd.name ([46.4.11.11]:40242 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbfGAL1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 07:27:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8xeQ8Ouu97Qg8BegnrjEEygtfPvTpW6Qo6/jKRbo+sM=; b=LVfpJzyovRUV1R30IH63mbqg0u
        65d/MuBzKcsiMYJl6PQ73a3Hyteg+afEV9mv2aN1gSfPdlE+1nnv6UaCYtvyCM2bM15eRuASdCs5s
        vHdwdlITFs+Unu/69ww9wGwzZ2uOEPoCdTe37pJ4jJQJUVS7VQYzAKRERlXP28TANUVA=;
Received: from p54ae9425.dip0.t-ipconnect.de ([84.174.148.37] helo=maeck-3.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1hhuT9-00044o-Uu; Mon, 01 Jul 2019 13:27:36 +0200
Received: by maeck-3.local (Postfix, from userid 501)
        id 3D91260D3CE5; Mon,  1 Jul 2019 13:27:34 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] mt76: round up length on mt76_wr_copy
Date:   Mon,  1 Jul 2019 13:27:34 +0200
Message-Id: <20190701112734.86552-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When beacon length is not a multiple of 4, the beacon could be sent with
the last 1-3 bytes corrupted. The skb data is guaranteed to have enough
room for reading beyond the end, because it is always followed by
skb_shared_info, so rounding up is safe.
All other callers of mt76_wr_copy have multiple-of-4 length already.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mmio.c | 2 +-
 drivers/net/wireless/mediatek/mt76/usb.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 38368d19aa6f..83c96a47914f 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -43,7 +43,7 @@ static u32 mt76_mmio_rmw(struct mt76_dev *dev, u32 offset, u32 mask, u32 val)
 static void mt76_mmio_copy(struct mt76_dev *dev, u32 offset, const void *data,
 			   int len)
 {
-	__iowrite32_copy(dev->mmio.regs + offset, data, len >> 2);
+	__iowrite32_copy(dev->mmio.regs + offset, data, DIV_ROUND_UP(len, 4));
 }
 
 static int mt76_mmio_wr_rp(struct mt76_dev *dev, u32 base,
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 61b27f3ec6e4..87ecbe290f99 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -164,7 +164,7 @@ static void mt76u_copy(struct mt76_dev *dev, u32 offset,
 	int i, ret;
 
 	mutex_lock(&usb->usb_ctrl_mtx);
-	for (i = 0; i < (len / 4); i++) {
+	for (i = 0; i < DIV_ROUND_UP(len, 4); i++) {
 		put_unaligned_le32(val[i], usb->data);
 		ret = __mt76u_vendor_request(dev, MT_VEND_MULTI_WRITE,
 					     USB_DIR_OUT | USB_TYPE_VENDOR,
-- 
2.17.0

