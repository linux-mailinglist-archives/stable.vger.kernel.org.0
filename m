Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E40D37CE48
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbhELREq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237774AbhELQnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55BD361D3E;
        Wed, 12 May 2021 16:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835999;
        bh=ifRPyNfqzc5LQ3LQ80/tN4+dO8LPlUuJlWFRw0VxkrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIclPtpowI0RGsME5zyXJl+LgyUuVKQrZFgF51XwiyjFj0Ub6Wx1gcsYuF5VmW3z5
         aO215ZrRegFpiwltyrHyZjLzgZH/iiWsjBEcmrN48wJB/J2PeWAe+0ImQN5MQcm6iY
         V/mkv9ExCmi93wjvlaK7wwlYf3tdZAU6GtKTARKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 524/677] mt76: mt7921: fix aggr length histogram
Date:   Wed, 12 May 2021 16:49:30 +0200
Message-Id: <20210512144854.793483252@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 461e3b7f45766f38eeb24ca7354ff01d993b5b47 ]

Fix register definitions for 802.11 aggr length histogram estimation.

Fixes: 474a9f21e2e2 ("mt76: mt7921: add debugfs support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c | 5 ++---
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h    | 6 +++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 0dc8e25e18e4..6aa11ca6fc81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -44,14 +44,13 @@ mt7921_ampdu_stat_read_phy(struct mt7921_phy *phy,
 		range[i] = mt76_rr(dev, MT_MIB_ARNG(0, i));
 
 	for (i = 0; i < ARRAY_SIZE(bound); i++)
-		bound[i] = MT_MIB_ARNCR_RANGE(range[i / 4], i) + 1;
+		bound[i] = MT_MIB_ARNCR_RANGE(range[i / 4], i % 4) + 1;
 
 	seq_printf(file, "\nPhy0\n");
 
 	seq_printf(file, "Length: %8d | ", bound[0]);
 	for (i = 0; i < ARRAY_SIZE(bound) - 1; i++)
-		seq_printf(file, "%3d -%3d | ",
-			   bound[i] + 1, bound[i + 1]);
+		seq_printf(file, "%3d  %3d | ", bound[i] + 1, bound[i + 1]);
 
 	seq_puts(file, "\nCount:  ");
 	for (i = 0; i < ARRAY_SIZE(bound); i++)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index 6dad7f6ab09d..11d5aa44ae7b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -128,9 +128,9 @@
 #define MT_MIB_MB_SDR2(_band, n)	MT_WF_MIB(_band, 0x108 + ((n) << 4))
 #define MT_MIB_FRAME_RETRIES_COUNT_MASK	GENMASK(15, 0)
 
-#define MT_TX_AGG_CNT(_band, n)		MT_WF_MIB(_band, 0x0a8 + ((n) << 2))
-#define MT_TX_AGG_CNT2(_band, n)	MT_WF_MIB(_band, 0x164 + ((n) << 2))
-#define MT_MIB_ARNG(_band, n)		MT_WF_MIB(_band, 0x4b8 + ((n) << 2))
+#define MT_TX_AGG_CNT(_band, n)		MT_WF_MIB(_band, 0x7dc + ((n) << 2))
+#define MT_TX_AGG_CNT2(_band, n)	MT_WF_MIB(_band, 0x7ec + ((n) << 2))
+#define MT_MIB_ARNG(_band, n)		MT_WF_MIB(_band, 0x0b0 + ((n) << 2))
 #define MT_MIB_ARNCR_RANGE(val, n)	(((val) >> ((n) << 3)) & GENMASK(7, 0))
 
 #define MT_WTBLON_TOP_BASE		0x34000
-- 
2.30.2



