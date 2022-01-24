Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2E849979A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353830AbiAXVN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60440 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447362AbiAXVKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:10:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 336E6B80FA3;
        Mon, 24 Jan 2022 21:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67582C340E5;
        Mon, 24 Jan 2022 21:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058631;
        bh=w2KZk+H0QJEvW7PC3K2aXvV3aUrFbePvjqUXTQZJgbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwDKjX1sLnaj+XEaA+euhACiwhKojaAKVMJMnQk09wenqmB3/1hpuC4ws25xNn2Wn
         tQHgx3YXK/jyrbglvBGhhQijLH/kHRLtJbx/RpxhOFSMsMkwsrQecjr9zb+7uBJZVT
         psjOorLahFUwFlYeEb8aqW+tcat7oYIllwjLUVZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deren Wu <deren.wu@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0352/1039] mt76: mt7921: fix a possible race enabling/disabling runtime-pm
Date:   Mon, 24 Jan 2022 19:35:41 +0100
Message-Id: <20220124184137.115148951@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d430dffbe9dd30759f3c64b65bf85b0245c8d8ab ]

Fix a possible race enabling/disabling runtime-pm between
mt7921_pm_set() and mt7921_poll_rx() since mt7921_pm_wake_work()
always schedules rx-napi callback and it will trigger
mt7921_pm_power_save_work routine putting chip to in low-power state
during mt7921_pm_set processing.

Suggested-by: Deren Wu <deren.wu@mediatek.com>
Tested-by: Deren Wu <deren.wu@mediatek.com>
Fixes: 1d8efc741df8 ("mt76: mt7921: introduce Runtime PM support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/0f3e075a2033dc05f09dab4059e5be8cbdccc239.1640094847.git.lorenzo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c |  3 ---
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c  | 12 +++++++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index af43bcb545781..306e9eaea9177 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -7,9 +7,6 @@ int mt76_connac_pm_wake(struct mt76_phy *phy, struct mt76_connac_pm *pm)
 {
 	struct mt76_dev *dev = phy->dev;
 
-	if (!pm->enable)
-		return 0;
-
 	if (mt76_is_usb(dev))
 		return 0;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 7cdfdf83529f6..86fd7292b229f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -276,7 +276,7 @@ mt7921_pm_set(void *data, u64 val)
 	struct mt7921_dev *dev = data;
 	struct mt76_connac_pm *pm = &dev->pm;
 
-	mt7921_mutex_acquire(dev);
+	mutex_lock(&dev->mt76.mutex);
 
 	if (val == pm->enable)
 		goto out;
@@ -285,7 +285,11 @@ mt7921_pm_set(void *data, u64 val)
 		pm->stats.last_wake_event = jiffies;
 		pm->stats.last_doze_event = jiffies;
 	}
-	pm->enable = val;
+	/* make sure the chip is awake here and ps_work is scheduled
+	 * just at end of the this routine.
+	 */
+	pm->enable = false;
+	mt76_connac_pm_wake(&dev->mphy, pm);
 
 	ieee80211_iterate_active_interfaces(mt76_hw(dev),
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
@@ -293,8 +297,10 @@ mt7921_pm_set(void *data, u64 val)
 
 	mt76_connac_mcu_set_deep_sleep(&dev->mt76, pm->ds_enable);
 
+	pm->enable = val;
+	mt76_connac_power_save_sched(&dev->mphy, pm);
 out:
-	mt7921_mutex_release(dev);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
-- 
2.34.1



