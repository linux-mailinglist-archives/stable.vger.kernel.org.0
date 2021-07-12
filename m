Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF15B3C53E7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349085AbhGLH4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350774AbhGLHvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF0356124C;
        Mon, 12 Jul 2021 07:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076102;
        bh=bzxE9/+cq058Y0PN9Gucbc72yldyrfnd+Y2KsOhj9fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvrwVh/ED6Y94Qs5JTRS4AvtgAVUeEfk6zD5UaoYtRQqWtxNNAXplQh90RkXOYikU
         WdsQ5iUn85hVRw1Ny53uNfVznjeJuCRbdVqKcw5DeHo20fkroNMUjfpOOMCyR04+em
         D5JfvPc6QKu31gH8sO971OGZSexPhLErUtks3KY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 499/800] mt76: mt7921: avoid unnecessary consecutive WiFi resets
Date:   Mon, 12 Jul 2021 08:08:42 +0200
Message-Id: <20210712061020.283643223@linuxfoundation.org>
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

[ Upstream commit f07ac384b4579f294bb1e0380ed501156219ed71 ]

Avoid unnecessary consecutive WiFi resets by dropping reset
request when reset work is working.

Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    | 5 ++++-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 9bb88b2e28a9..4eac7c3206f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1272,6 +1272,7 @@ void mt7921_mac_reset_work(struct work_struct *work)
 	hw = mt76_hw(dev);
 
 	dev_err(dev->mt76.dev, "chip reset\n");
+	dev->hw_full_reset = true;
 	ieee80211_stop_queues(hw);
 
 	cancel_delayed_work_sync(&dev->mphy.mac_work);
@@ -1296,6 +1297,7 @@ void mt7921_mac_reset_work(struct work_struct *work)
 		ieee80211_scan_completed(dev->mphy.hw, &info);
 	}
 
+	dev->hw_full_reset = false;
 	ieee80211_wake_queues(hw);
 	ieee80211_iterate_active_interfaces(hw,
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
@@ -1306,7 +1308,8 @@ void mt7921_reset(struct mt76_dev *mdev)
 {
 	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
 
-	queue_work(dev->mt76.wq, &dev->reset_work);
+	if (!dev->hw_full_reset)
+		queue_work(dev->mt76.wq, &dev->reset_work);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 59862ea4951c..4cc8a372b277 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -156,6 +156,7 @@ struct mt7921_dev {
 	u16 chainmask;
 
 	struct work_struct reset_work;
+	bool hw_full_reset;
 
 	struct list_head sta_poll_list;
 	spinlock_t sta_poll_lock;
-- 
2.30.2



