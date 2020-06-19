Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B67020154E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393715AbgFSQUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390679AbgFSPBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:01:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6A4821841;
        Fri, 19 Jun 2020 15:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578866;
        bh=p6ZispYrWzk7yr0xIja5r9BTFfXDWbd/vCv6fYO7J7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcG5svNmg0C+czYkNzQoMdzMRIyTTfzZwtQm+fziwtgW1Vh9b3NeGd8rUTg6rTi2W
         1L2JtWeoKpGeaa8ApanZ8tnSn9wPtx8HeLnzx2GIyqzCUTWle15NfhwhvSYsyzULrZ
         O6xKF/cIVy3B5fAzWuyqeIdna7D7c1X0KN8mrdHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chih-Min Chen <chih-min.chen@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/267] mt76: avoid rx reorder buffer overflow
Date:   Fri, 19 Jun 2020 16:32:22 +0200
Message-Id: <20200619141656.344416983@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 7c4f744d6703757be959f521a7a441bf34745d99 ]

Enlarge slot to support 11ax 256 BA (256 MPDUs in an AMPDU)

Signed-off-by: Chih-Min Chen <chih-min.chen@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 8 ++++----
 drivers/net/wireless/mediatek/mt76/mt76.h   | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index 73c8b2805c97..d44d57e6eb27 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -154,8 +154,8 @@ void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames)
 	struct ieee80211_sta *sta;
 	struct mt76_rx_tid *tid;
 	bool sn_less;
-	u16 seqno, head, size;
-	u8 ackp, idx;
+	u16 seqno, head, size, idx;
+	u8 ackp;
 
 	__skb_queue_tail(frames, skb);
 
@@ -240,7 +240,7 @@ out:
 }
 
 int mt76_rx_aggr_start(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tidno,
-		       u16 ssn, u8 size)
+		       u16 ssn, u16 size)
 {
 	struct mt76_rx_tid *tid;
 
@@ -264,7 +264,7 @@ EXPORT_SYMBOL_GPL(mt76_rx_aggr_start);
 
 static void mt76_rx_aggr_shutdown(struct mt76_dev *dev, struct mt76_rx_tid *tid)
 {
-	u8 size = tid->size;
+	u16 size = tid->size;
 	int i;
 
 	cancel_delayed_work(&tid->reorder_work);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 2eab35879163..7b1667ec619e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -193,8 +193,8 @@ struct mt76_rx_tid {
 	struct delayed_work reorder_work;
 
 	u16 head;
-	u8 size;
-	u8 nframes;
+	u16 size;
+	u16 nframes;
 
 	u8 started:1, stopped:1, timer_pending:1;
 
@@ -537,7 +537,7 @@ int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 void mt76_set_stream_caps(struct mt76_dev *dev, bool vht);
 
 int mt76_rx_aggr_start(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid,
-		       u16 ssn, u8 size);
+		       u16 ssn, u16 size);
 void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid);
 
 void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
-- 
2.25.1



