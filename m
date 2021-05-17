Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3839E3834E3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243215AbhEQPNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241488AbhEQPLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:11:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C3D616ED;
        Mon, 17 May 2021 14:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261853;
        bh=VWFWm5cUN1jSxsItT/U9HhoMnGvxh07KV69SrLyK5ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uq8yhQX+CmWgKgJz6DErVQbdEuSXu3FdRlaTrzE8zsYoOrmCoNUkd8Xuq4p36HWfJ
         cE44i0eE5PAXyUkgRDrCyVfQiDBExS5cEO2KtIDCW6Sky2IQjFrL/53pg3xlbf7HI0
         rzBZTsTS8w3idZZFsZrBwE2a/3dPhlxqCEpZ8BeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/289] mt76: mt7615: fix entering driver-own state on mt7663
Date:   Mon, 17 May 2021 16:00:01 +0200
Message-Id: <20210517140307.753984717@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5c7d374444afdeb9dd534a37c4f6c13af032da0c ]

Fixes hardware wakeup issues

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index c31036f57aef..62a971660da7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -341,12 +341,20 @@ static int mt7615_mcu_drv_pmctrl(struct mt7615_dev *dev)
 	u32 addr;
 	int err;
 
-	addr = is_mt7663(mdev) ? MT_PCIE_DOORBELL_PUSH : MT_CFG_LPCR_HOST;
+	if (is_mt7663(mdev)) {
+		/* Clear firmware own via N9 eint */
+		mt76_wr(dev, MT_PCIE_DOORBELL_PUSH, MT_CFG_LPCR_HOST_DRV_OWN);
+		mt76_poll(dev, MT_CONN_ON_MISC, MT_CFG_LPCR_HOST_FW_OWN, 0, 3000);
+
+		addr = MT_CONN_HIF_ON_LPCTL;
+	} else {
+		addr = MT_CFG_LPCR_HOST;
+	}
+
 	mt76_wr(dev, addr, MT_CFG_LPCR_HOST_DRV_OWN);
 
 	mt7622_trigger_hif_int(dev, true);
 
-	addr = is_mt7663(mdev) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
 	err = !mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN, 0, 3000);
 
 	mt7622_trigger_hif_int(dev, false);
-- 
2.30.2



