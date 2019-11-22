Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9875106D50
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbfKVK7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730387AbfKVK7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 678DB20721;
        Fri, 22 Nov 2019 10:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420344;
        bh=WatvhTlnTrUeKgE4vGEfMfvYTXMAw5MLRYU+EHcOmmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OBl3o81e3Mm8tOZX/W3tHcPHF89vZYyDUUx7l0WdESKXjVSW5FBJlm3I3MmYKQ27
         gZSwm0+fNGLrHxQXLdOBVe1flOmY6ZB/Ek8pWT/ggdjXK+GkfMK0LV2LF1y2r7FX2L
         kp1XTvqC7d8m1ur8wRiJunqqsWCeycpBTh5QZJI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/220] mt76x2: fix tx power configuration for VHT mcs 9
Date:   Fri, 22 Nov 2019 11:26:36 +0100
Message-Id: <20191122100914.627267228@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit 60b6645ef1a9239a02c70adeae136298395d145a ]

Fix tx power configuration for VHT 1SS/STBC mcs 9 since
in MT_TX_PWR_CFG_{8,9} mcs 8,9 bits are GENMASK(21,16) and
GENMASK(29,24) while GENMASK(15,6) are marked as reserved

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
index 9fd6ab4cbb949..ca68dd184489b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
@@ -232,9 +232,9 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 	mt76_wr(dev, MT_TX_PWR_CFG_7,
 		mt76x2_tx_power_mask(t.ofdm[6], t.vht[8], t.ht[6], t.vht[8]));
 	mt76_wr(dev, MT_TX_PWR_CFG_8,
-		mt76x2_tx_power_mask(t.ht[14], t.vht[8], t.vht[8], 0));
+		mt76x2_tx_power_mask(t.ht[14], 0, t.vht[8], t.vht[8]));
 	mt76_wr(dev, MT_TX_PWR_CFG_9,
-		mt76x2_tx_power_mask(t.ht[6], t.vht[8], t.vht[8], 0));
+		mt76x2_tx_power_mask(t.ht[6], 0, t.vht[8], t.vht[8]));
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_txpower);
 
-- 
2.20.1



