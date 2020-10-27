Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BB429B8D2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802029AbgJ0PpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799632AbgJ0Pce (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9662020727;
        Tue, 27 Oct 2020 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812753;
        bh=cpWzIkmuv6lv/M/2Jm87s+UFxxgkrL3zNQgaQO41ByI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmF8BaKcks/yL+KRylx13PJUfX/Wwf0FkL/EEQ++R4h0s4b/TM4jpPM/YzY2wCRzv
         pPPjFzLtJm8z/W37faBg3P8dCo3lf18FjXnZMQoHEg4KEcHpgmAVq1+T0GKhzhvaf2
         9G8vRCyWGzdjye97CW+VZJq3W4uSrc4gGgYglvkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 319/757] mt76: mt7615: fix a possible NULL pointer dereference in mt7615_pm_wake_work
Date:   Tue, 27 Oct 2020 14:49:29 +0100
Message-Id: <20201027135505.500460671@linuxfoundation.org>
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

[ Upstream commit a081de174d11b12db9a94eb748041c2732f14c10 ]

Initialize wcid to global_wcid if msta is NULL in mt7615_pm_wake_work
routine since wcid will be dereferenced running mt76_tx()

Fixes: 2b8cdfb28d340 ("mt76: mt7615: wake device before pushing frames in mt7615_tx")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 3dd8dd28690ed..2be127018df6a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1853,12 +1853,13 @@ void mt7615_pm_wake_work(struct work_struct *work)
 	spin_lock_bh(&dev->pm.txq_lock);
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		struct mt7615_sta *msta = dev->pm.tx_q[i].msta;
-		struct mt76_wcid *wcid = msta ? &msta->wcid : NULL;
 		struct ieee80211_sta *sta = NULL;
+		struct mt76_wcid *wcid;
 
 		if (!dev->pm.tx_q[i].skb)
 			continue;
 
+		wcid = msta ? &msta->wcid : &dev->mt76.global_wcid;
 		if (msta && wcid->sta)
 			sta = container_of((void *)msta, struct ieee80211_sta,
 					   drv_priv);
-- 
2.25.1



