Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D422437C9D9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbhELQWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240390AbhELQR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:17:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CAF261D72;
        Wed, 12 May 2021 15:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834241;
        bh=VR1Vh5FTLUXFjc6hclX8IOK/3afOrWa88bvvTzYc1gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSXtKwgLioOpLbtL2uIJsp+kTST4n+Dxf1RPkKIZql+m4sDCZ1utVe6gGr1vNni+9
         tZpUf48wb+GzCvURL7BhuJLGQyyHpNxN/UKmokZ8pCMMJIHpdDiTlob/PP+NCJc5tC
         BAV6xIJ6s4iEfD+LQVLdFRPTgSJu9dV6+/gCtYmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 465/601] mt76: mt7915: fix aggr len debugfs node
Date:   Wed, 12 May 2021 16:49:02 +0200
Message-Id: <20210512144843.150385730@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 9fb9d755fae20b5ad62ef8b4e9289e5baea2c6fc ]

Similar to mt7921, fix 802.11 aggr len debugfs reporting for mt7915 driver.

Fixes: e57b7901469fc ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 7d810fbf2862..a2d2b56a8eb9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -98,7 +98,7 @@ mt7915_ampdu_stat_read_phy(struct mt7915_phy *phy,
 		range[i] = mt76_rr(dev, MT_MIB_ARNG(ext_phy, i));
 
 	for (i = 0; i < ARRAY_SIZE(bound); i++)
-		bound[i] = MT_MIB_ARNCR_RANGE(range[i / 4], i) + 1;
+		bound[i] = MT_MIB_ARNCR_RANGE(range[i / 4], i % 4) + 1;
 
 	seq_printf(file, "\nPhy %d\n", ext_phy);
 
-- 
2.30.2



