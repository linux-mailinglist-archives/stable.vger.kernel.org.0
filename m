Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F42711ED4
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfEBPlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbfEBP2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:28:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74A8F2177B;
        Thu,  2 May 2019 15:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810935;
        bh=vaKOv5VLQ0ocqDN2T1ujpP65YlTvzlsEjWaiC3OLZbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8sOuOU68u3XmOwDvUhlwhb19/JuKumtAjqN/fFDdihqXElYWauQMM18R0anj/OzN
         dFNdXKwZm1YXbnktKV5bGCLmk83llBCexX9CJGRzoQ2PFr2zcu3cHXFi1gRbbU6mPB
         Jvs/dNypNCqMv0F387L5QzMeuHcdF6AexGlJ2r/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 013/101] mt76: mt76x2: fix 2.4 GHz channel gain settings
Date:   Thu,  2 May 2019 17:20:15 +0200
Message-Id: <20190502143341.052632347@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b8cfd87ac24273e36fbd3ecda631f3ba6566d493 ]

AGC register 35, 37 override for the low gain setting should only be done
on 5 GHz. Also, 2.4 GHz needs a different value for register 35

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index 11167b7af668..2f618536ef2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -285,6 +285,7 @@ void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 {
 	u8 *gain = dev->cal.agc_gain_init;
 	u8 low_gain_delta, gain_delta;
+	u32 agc_35, agc_37;
 	bool gain_change;
 	int low_gain;
 	u32 val;
@@ -321,6 +322,16 @@ void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 	else
 		low_gain_delta = 14;
 
+	agc_37 = 0x2121262c;
+	if (dev->mt76.chandef.chan->band == NL80211_BAND_2GHZ)
+		agc_35 = 0x11111516;
+	else if (low_gain == 2)
+		agc_35 = agc_37 = 0x08080808;
+	else if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80)
+		agc_35 = 0x10101014;
+	else
+		agc_35 = 0x11111116;
+
 	if (low_gain == 2) {
 		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a990);
 		mt76_wr(dev, MT_BBP(AGC, 35), 0x08080808);
@@ -329,15 +340,13 @@ void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 		dev->cal.agc_gain_adjust = 0;
 	} else {
 		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a991);
-		if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80)
-			mt76_wr(dev, MT_BBP(AGC, 35), 0x10101014);
-		else
-			mt76_wr(dev, MT_BBP(AGC, 35), 0x11111116);
-		mt76_wr(dev, MT_BBP(AGC, 37), 0x2121262C);
 		gain_delta = 0;
 		dev->cal.agc_gain_adjust = low_gain_delta;
 	}
 
+	mt76_wr(dev, MT_BBP(AGC, 35), agc_35);
+	mt76_wr(dev, MT_BBP(AGC, 37), agc_37);
+
 	dev->cal.agc_gain_cur[0] = gain[0] - gain_delta;
 	dev->cal.agc_gain_cur[1] = gain[1] - gain_delta;
 	mt76x2_phy_set_gain_val(dev);
-- 
2.19.1



