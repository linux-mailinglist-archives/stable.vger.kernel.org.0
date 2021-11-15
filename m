Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC961451139
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbhKOTCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:02:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243139AbhKOS5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B63C663488;
        Mon, 15 Nov 2021 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999938;
        bh=wAEORlIloIhquPQmQylodOIuiUktgC2qMMWzZ4isTm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLSy3OQ09zcR8ixRA++XRHN+A2iJxstqwz7wm6NNRxZtA3zYcQ+fLGXnHtJeQqVsq
         0Trmp5BwWA9KP1J8IxeZoVg/Yn4Ku1nxKGrP7kX7OAEJG180YJVmMUrbB9rvG+pZWX
         K+/ERmionBTEtg3IsV3QGckx5lO1KGN6np20/dG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deren Wu <deren.wu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 461/849] mt76: mt7921: fix dma hang in rmmod
Date:   Mon, 15 Nov 2021 17:59:04 +0100
Message-Id: <20211115165435.887080950@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit a23f80aa9c5e6ad4ec8df88037b7ffd4162b1ec4 ]

The dma would be broken after rmmod flow. There are two different
cases causing this issue.
1. dma access without privilege.
2. hw access sequence borken by another context.

This patch handle both cases to avoid hw crash.

Fixes: 2b9ea5a8cf1bd ("mt76: mt7921: add mt7921_dma_cleanup in mt7921_unregister_device")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 52d40385fab6c..78a00028137bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -251,8 +251,17 @@ int mt7921_register_device(struct mt7921_dev *dev)
 
 void mt7921_unregister_device(struct mt7921_dev *dev)
 {
+	int i;
+	struct mt76_connac_pm *pm = &dev->pm;
+
 	mt76_unregister_device(&dev->mt76);
+	mt76_for_each_q_rx(&dev->mt76, i)
+		napi_disable(&dev->mt76.napi[i]);
+	cancel_delayed_work_sync(&pm->ps_work);
+	cancel_work_sync(&pm->wake_work);
+
 	mt7921_tx_token_put(dev);
+	mt7921_mcu_drv_pmctrl(dev);
 	mt7921_dma_cleanup(dev);
 	mt7921_mcu_exit(dev);
 
-- 
2.33.0



