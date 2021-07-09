Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F3C3C24E4
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhGINZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232085AbhGINZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7558A61377;
        Fri,  9 Jul 2021 13:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836957;
        bh=0KhZcQBYKpeF0Sg/PcoC1f2yhZzSci2u5qGRIt1skK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRXwZQKpE3MVJ4Pxx8dGSe2hIiCaCiUteQqew5fuPJKiNpFkLRKM+GAFf4OZbTY3p
         ujt/SRTHEudlssGpMh8yS/dEl3N7ic6CTUfqBWZt3PCnWG+xdz6IQ+HE5cIm/rUsHz
         +YqINR45JsWypT2i8RVo4PkRTqp33BukB/YEj0/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Deren Wu <Deren.Wu@mediatek.com>
Subject: [PATCH 5.12 04/11] mt76: mt7921: check mcu returned values in mt7921_start
Date:   Fri,  9 Jul 2021 15:21:41 +0200
Message-Id: <20210709131555.988089047@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit f92f81d35ac26f8a519866f1b561743fe70e33a5 upstream.

Properly check returned values from mcu utility routines in
mt7921_start.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Cc: Deren Wu <Deren.Wu@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -172,22 +172,31 @@ static int mt7921_start(struct ieee80211
 {
 	struct mt7921_dev *dev = mt7921_hw_dev(hw);
 	struct mt7921_phy *phy = mt7921_hw_phy(hw);
+	int err;
 
 	mt7921_mutex_acquire(dev);
 
-	mt76_connac_mcu_set_mac_enable(&dev->mt76, 0, true, false);
-	mt76_connac_mcu_set_channel_domain(phy->mt76);
+	err = mt76_connac_mcu_set_mac_enable(&dev->mt76, 0, true, false);
+	if (err)
+		goto out;
+
+	err = mt76_connac_mcu_set_channel_domain(phy->mt76);
+	if (err)
+		goto out;
+
+	err = mt7921_mcu_set_chan_info(phy, MCU_EXT_CMD_SET_RX_PATH);
+	if (err)
+		goto out;
 
-	mt7921_mcu_set_chan_info(phy, MCU_EXT_CMD_SET_RX_PATH);
 	mt7921_mac_reset_counters(phy);
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
 
 	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
 				     MT7921_WATCHDOG_TIME);
-
+out:
 	mt7921_mutex_release(dev);
 
-	return 0;
+	return err;
 }
 
 static void mt7921_stop(struct ieee80211_hw *hw)


