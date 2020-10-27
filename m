Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064EC29B8D3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802031AbgJ0PpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799625AbgJ0Pcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E360206D4;
        Tue, 27 Oct 2020 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812750;
        bh=XFkd8pRlSYA3qzesuUdg+ewHdG2R6wP+uT3eYXI5GNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEM3E0A0J1zb1uKJ511oZ6qIkolSIScpuaUpd4chFPCASXvV7plz6FMmYcmqbUkR1
         EcaRl/c9f25VJaqBMFdgWSi019Gis61lTTuSY/8xPSJqdyc87B4wZ31mH5u6skia11
         ke8dSIhPOT5U8G/JsR3vPIRhBCJIFKIolVm8Y3ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 318/757] mt76: mt7615: fix possible memory leak in mt7615_tm_set_tx_power
Date:   Tue, 27 Oct 2020 14:49:28 +0100
Message-Id: <20201027135505.455364635@linuxfoundation.org>
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

[ Upstream commit e862825dcf74203c5ab60335c341766808f47507 ]

Fix a memory leak in mt7615_tm_set_tx_power routine if
mt7615_eeprom_get_target_power_index fails.
Moreover do not account req_header twice in mcu skb allocation.

Fixes: 4f0bce1c88882 ("mt76: mt7615: implement testmode support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/testmode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c
index 1730751133aa2..2cfa58d49832f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/testmode.c
@@ -70,7 +70,7 @@ mt7615_tm_set_tx_power(struct mt7615_phy *phy)
 	if (dev->mt76.test.state != MT76_TM_STATE_OFF)
 		tx_power = dev->mt76.test.tx_power;
 
-	len = sizeof(req_hdr) + MT7615_EE_MAX - MT_EE_NIC_CONF_0;
+	len = MT7615_EE_MAX - MT_EE_NIC_CONF_0;
 	skb = mt76_mcu_msg_alloc(&dev->mt76, NULL, sizeof(req_hdr) + len);
 	if (!skb)
 		return -ENOMEM;
@@ -83,8 +83,10 @@ mt7615_tm_set_tx_power(struct mt7615_phy *phy)
 		int index;
 
 		ret = mt7615_eeprom_get_target_power_index(dev, chandef->chan, i);
-		if (ret < 0)
+		if (ret < 0) {
+			dev_kfree_skb(skb);
 			return -EINVAL;
+		}
 
 		index = ret - MT_EE_NIC_CONF_0;
 		if (tx_power && tx_power[i])
-- 
2.25.1



