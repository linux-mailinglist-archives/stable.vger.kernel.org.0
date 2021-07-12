Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557473C53E2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348936AbhGLH4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350758AbhGLHvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED2C860241;
        Mon, 12 Jul 2021 07:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076088;
        bh=xyChzT686xZFrqCIPhwW9+x74p4335XOxHNqlbETT/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3qDXfG/8g99QmvUd+ch45fC1BPL5xwS+V7kbQfy01OFFV9Y2GjjDYZLrJaYyv9Zf
         PdINv8GRErVol7EYjO+aSf+SIxKxLkmkdvu5Zj+fpe/5nO3xZuXTycGmztOiDfiSGg
         1QMSGfjQPySpBUE4hDooPsE/gLWevZT9pPFqbB7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 493/800] mt76: connac: fw_own rely on all packet memory all being free
Date:   Mon, 12 Jul 2021 08:08:36 +0200
Message-Id: <20210712061019.613459943@linuxfoundation.org>
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

[ Upstream commit 4bfa291251623486711693a69d9eaa539478d340 ]

If the device is MMIO-based, we must ensure all TxD/TxP on the host
memory all being consumed by the device prior to safely switching to
fw_own state.

Fixes: ec7bd7b4a9c0 ("mt76: connac: check wake refcount in mcu_fw_pmctrl")
Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac.h b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
index 6c889b90fd12..337c5ece7ec3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
@@ -127,8 +127,12 @@ mt76_connac_pm_unref(struct mt76_connac_pm *pm)
 static inline bool
 mt76_connac_skip_fw_pmctrl(struct mt76_phy *phy, struct mt76_connac_pm *pm)
 {
+	struct mt76_dev *dev = phy->dev;
 	bool ret;
 
+	if (dev->token_count)
+		return true;
+
 	spin_lock_bh(&pm->wake.lock);
 	ret = pm->wake.count || test_and_set_bit(MT76_STATE_PM, &phy->state);
 	spin_unlock_bh(&pm->wake.lock);
-- 
2.30.2



