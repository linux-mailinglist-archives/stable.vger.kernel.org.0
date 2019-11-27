Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B29710BD8A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbfK0U4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731069AbfK0U4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CEE82068E;
        Wed, 27 Nov 2019 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888190;
        bh=30FkFKk0NxEOy+6Bj802DFapeTmG8/Wur0OjpwyjWbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dT3KZi/9xXtIdARZ281IkzMDU/SJFP43KC83ROS39Ys50KMV5LoE/RHSRUssuhN+p
         A4qDYWqvn9J63qN+e7tPv4mwfBzF09TpW02L9A2WNNnj/smkWPdJY3iiAg4+htK6vb
         L9j0N66wsT5KHVkzaG7f5aeOcu7IfjC8YLFl3ZKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/306] mt76x0: phy: fix restore phase in mt76x0_phy_recalibrate_after_assoc
Date:   Wed, 27 Nov 2019 21:28:08 +0100
Message-Id: <20191127203117.637392419@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit 4df942733fd26d9378a4a00619be348c771e0190 ]

Fix restore value configured in MT_BBP(IBI, 9) register in
mt76x0_phy_recalibrate_after_assoc routine.

Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 14e8c575f6c3e..924c761f34fd9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -793,9 +793,8 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev)
 	mt76_wr(dev, MT_TX_ALC_CFG_0, 0);
 	usleep_range(500, 700);
 
-	reg_val = mt76_rr(dev, 0x2124);
-	reg_val &= 0xffffff7e;
-	mt76_wr(dev, 0x2124, reg_val);
+	reg_val = mt76_rr(dev, MT_BBP(IBI, 9));
+	mt76_wr(dev, MT_BBP(IBI, 9), 0xffffff7e);
 
 	mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 0);
 
@@ -806,7 +805,7 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev)
 	mt76x0_mcu_calibrate(dev, MCU_CAL_RXIQ, is_5ghz);
 	mt76x0_mcu_calibrate(dev, MCU_CAL_RX_GROUP_DELAY, is_5ghz);
 
-	mt76_wr(dev, 0x2124, reg_val);
+	mt76_wr(dev, MT_BBP(IBI, 9), reg_val);
 	mt76_wr(dev, MT_TX_ALC_CFG_0, tx_alc);
 	msleep(100);
 
-- 
2.20.1



