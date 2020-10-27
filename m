Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD2229B76A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799657AbgJ0Pcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799650AbgJ0Pck (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7660A206D4;
        Tue, 27 Oct 2020 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812760;
        bh=mK0uWgdaqDDpW8rbcR9mDLIdPz/rQYsZW1kvduk8Ovs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alOiRNiqLXvMYMxMJ5wl0bOes/jMz7GhtPq8PjS+pUaVrZRPtGYgY4u/0f7axnUjq
         CVlRJh0Oa5QivbcjP+jozOWsugkxiafAoKjd1vNlD36xTQeDyiu5bYjAGIBaBUb7ML
         aUwsRRqwMeLmLMmaYJa9EmBItaPhjFHsTl7dkSaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 321/757] mt76: mt7663u: fix dma header initialization
Date:   Tue, 27 Oct 2020 14:49:31 +0100
Message-Id: <20201027135505.590461311@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 8da40d698111ad27b03afc40d67843e3073395e7 ]

Fix length field corruption in usb dma header introduced adding sdio
support

Fixes: 75b10f0cbd0b ("mt76: mt76u: add mt76_skb_adjust_pad utility routine")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c  | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c | 7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c
index 0b33df3e3bfec..adbed373798e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c
@@ -19,6 +19,7 @@ mt7663u_mcu_send_message(struct mt76_dev *mdev, struct sk_buff *skb,
 {
 	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
 	int ret, seq, ep;
+	u32 len;
 
 	mutex_lock(&mdev->mcu.mutex);
 
@@ -28,7 +29,8 @@ mt7663u_mcu_send_message(struct mt76_dev *mdev, struct sk_buff *skb,
 	else
 		ep = MT_EP_OUT_AC_BE;
 
-	put_unaligned_le32(skb->len, skb_push(skb, sizeof(skb->len)));
+	len = skb->len;
+	put_unaligned_le32(len, skb_push(skb, sizeof(len)));
 	ret = mt76_skb_adjust_pad(skb);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
index 6dffdaaa9ad53..294276e2280d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
@@ -259,8 +259,11 @@ int mt7663_usb_sdio_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	}
 
 	mt7663_usb_sdio_write_txwi(dev, wcid, qid, sta, skb);
-	if (mt76_is_usb(mdev))
-		put_unaligned_le32(skb->len, skb_push(skb, sizeof(skb->len)));
+	if (mt76_is_usb(mdev)) {
+		u32 len = skb->len;
+
+		put_unaligned_le32(len, skb_push(skb, sizeof(len)));
+	}
 
 	return mt76_skb_adjust_pad(skb);
 }
-- 
2.25.1



