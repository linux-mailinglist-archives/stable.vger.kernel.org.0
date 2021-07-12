Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32183C4E42
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244487AbhGLHRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240077AbhGLHQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:16:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 484F6613EE;
        Mon, 12 Jul 2021 07:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074025;
        bh=zpDaxQf98VqPDv6c/Fj7pPDmQNEEYxGEpe1S3mMl9ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwbfJlit/VV2J8gF34d67wRw4ZDH4Te7gaHBpuJYxOBh9z4tTpNXIImWsFJdXbxvZ
         FkTpFjMqnxkm40dxM7og6CH5jYwMltMN8Jwx4+STdSJ2Lsd/cKyVA/eFsN5BRylXLY
         j2crtNEfgI4Gcdf7IAh0x9OGkEsuPZ7Ye7o1O9rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 437/700] mt76: connac: alaways wake the device before scanning
Date:   Mon, 12 Jul 2021 08:08:40 +0200
Message-Id: <20210712061022.938945820@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit a61826203ba8806b4cdffd36bafdce3e9ad35c24 ]

move scanning check from mt76_connac_power_save_sched routine
to mt7921_pm_power_save_work/mt7615_pm_power_save_work ones

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c      | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 8 --------
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c      | 4 ++++
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 8dccb589b756..d06e61cadc41 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1890,6 +1890,10 @@ void mt7615_pm_power_save_work(struct work_struct *work)
 						pm.ps_work.work);
 
 	delta = dev->pm.idle_timeout;
+	if (test_bit(MT76_HW_SCANNING, &dev->mphy.state) ||
+	    test_bit(MT76_HW_SCHED_SCANNING, &dev->mphy.state))
+		goto out;
+
 	if (time_is_after_jiffies(dev->pm.last_activity + delta)) {
 		delta = dev->pm.last_activity + delta - jiffies;
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index c5f5037f5757..cff60b699e31 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -16,10 +16,6 @@ int mt76_connac_pm_wake(struct mt76_phy *phy, struct mt76_connac_pm *pm)
 	if (!test_bit(MT76_STATE_PM, &phy->state))
 		return 0;
 
-	if (test_bit(MT76_HW_SCANNING, &phy->state) ||
-	    test_bit(MT76_HW_SCHED_SCANNING, &phy->state))
-		return 0;
-
 	if (queue_work(dev->wq, &pm->wake_work))
 		reinit_completion(&pm->wake_cmpl);
 
@@ -45,10 +41,6 @@ void mt76_connac_power_save_sched(struct mt76_phy *phy,
 
 	pm->last_activity = jiffies;
 
-	if (test_bit(MT76_HW_SCANNING, &phy->state) ||
-	    test_bit(MT76_HW_SCHED_SCANNING, &phy->state))
-		return;
-
 	if (!test_bit(MT76_STATE_PM, &phy->state))
 		queue_delayed_work(dev->wq, &pm->ps_work, pm->idle_timeout);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 39be2e396269..c4b144391a8e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1524,6 +1524,10 @@ void mt7921_pm_power_save_work(struct work_struct *work)
 						pm.ps_work.work);
 
 	delta = dev->pm.idle_timeout;
+	if (test_bit(MT76_HW_SCANNING, &dev->mphy.state) ||
+	    test_bit(MT76_HW_SCHED_SCANNING, &dev->mphy.state))
+		goto out;
+
 	if (time_is_after_jiffies(dev->pm.last_activity + delta)) {
 		delta = dev->pm.last_activity + delta - jiffies;
 		goto out;
-- 
2.30.2



