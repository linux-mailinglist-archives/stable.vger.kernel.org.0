Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8AD3C53F6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348037AbhGLH4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351228AbhGLHve (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B25960241;
        Mon, 12 Jul 2021 07:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076125;
        bh=h6Di41b9GA4zFirPJoXGeizNZ7C6m27vN/RfcFp+FFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DaKuEuizTSnD1Gm+OyFqUUD2etc2CK09yapiT4L7Y0keKk2zf3jtxatks7cIwSdoD
         RI2BHYWJBSPDc3S9owAIHCM8qvxD+HmsHderqV13cQFfsgKGsh+hHE0zrVcSZfDGpm
         Ok5/HPxVNxf0AytCkFAoC4FZaDIFbWHPMc/dD7S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 508/800] mt76: mt7921: fix the coredump is being truncated
Date:   Mon, 12 Jul 2021 08:08:51 +0200
Message-Id: <20210712061021.247427276@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 723885a6750102e5d807429b3d06aa6b0d29cc66 ]

Fix the maximum size of the coredump generated with current mt7921
firmware. Otherwise, a truncated coredump would be reported to userland
via dev_coredumpv.

Also, there is an additional error handling enhanced in the patch to avoid
the possible invalid buffer access when the system failed to create the
buffer to hold the coredump.

Fixes: 0da3c795d07b ("mt76: mt7921: add coredump support")
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c  | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac.h b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
index 63c1d1a68a70..c26cfef425ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
@@ -12,7 +12,7 @@
 #define MT76_CONNAC_MAX_SCAN_MATCH		16
 
 #define MT76_CONNAC_COREDUMP_TIMEOUT		(HZ / 20)
-#define MT76_CONNAC_COREDUMP_SZ			(128 * 1024)
+#define MT76_CONNAC_COREDUMP_SZ			(1300 * 1024)
 
 enum {
 	CMD_CBW_20MHZ = IEEE80211_STA_RX_BW_20,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 853db0a52181..493c2aba2f79 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1504,7 +1504,7 @@ void mt7921_coredump_work(struct work_struct *work)
 			break;
 
 		skb_pull(skb, sizeof(struct mt7921_mcu_rxd));
-		if (data + skb->len - dump > MT76_CONNAC_COREDUMP_SZ) {
+		if (!dump || data + skb->len - dump > MT76_CONNAC_COREDUMP_SZ) {
 			dev_kfree_skb(skb);
 			continue;
 		}
@@ -1514,7 +1514,10 @@ void mt7921_coredump_work(struct work_struct *work)
 
 		dev_kfree_skb(skb);
 	}
-	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
-		      GFP_KERNEL);
+
+	if (dump)
+		dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
+			      GFP_KERNEL);
+
 	mt7921_reset(&dev->mt76);
 }
-- 
2.30.2



