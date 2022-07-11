Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780EC56FC7B
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiGKJnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiGKJnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:43:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4C1550AA;
        Mon, 11 Jul 2022 02:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7133161227;
        Mon, 11 Jul 2022 09:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C81C34115;
        Mon, 11 Jul 2022 09:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531291;
        bh=CNgEGQnfprJQCxT+8dhucvFWX3tVxae3uRH/wYz4l+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ugG8VoqaQ+IhhRq1aHbqG9Uxsw8e+OFu5N3cdjUaOaNnKzny3vujKpECh4yKrUxF
         dIC8nuZfCXFFt3qgB0GlKHCcffyeZZESWLYDrXmjTz/lphQ8A7ICZMWxItfTo0/MJk
         1lffCPdD6kspFIq+KIZROnEmXmBhImNQFlk94LFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deren Wu <deren.wu@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/230] mt76: mt7921: fix a possible race enabling/disabling runtime-pm
Date:   Mon, 11 Jul 2022 11:05:01 +0200
Message-Id: <20220711090605.362189585@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index af43bcb54578..306e9eaea917 100644
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
index 82fb2585f413..b9f25599227d 100644
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
2.35.1



