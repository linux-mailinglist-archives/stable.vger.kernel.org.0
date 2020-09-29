Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86FD27C9F4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbgI2MPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730092AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 662E7208FE;
        Tue, 29 Sep 2020 11:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379212;
        bh=JABLUdjNq2imK1wjeCunrhCzek4I+Lgbd0ewlVoivLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMJFca/r44/SGlcGLi63z/n8WaSiyKj9a1Mc53hRb72ivJ+d/Fgezz9FX/9lR2V5Z
         4TBWKlidpZp7u/GDPm0WTKm0ugdj7eseQ77IbFmG2m0TS69lfPUcoW1SqVv7PT6PQX
         Iys5DF1vj9O03mgGwq9eUTvac3J3KB3unxrL/ao4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/388] mt76: do not use devm API for led classdev
Date:   Tue, 29 Sep 2020 12:56:26 +0200
Message-Id: <20200929110013.158835994@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 36f7e2b2bb1de86f0072cd49ca93d82b9e8fd894 ]

With the devm API, the unregister happens after the device cleanup is done,
after which the struct mt76_dev which contains the led_cdev has already been
freed. This leads to a use-after-free bug that can crash the system.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 1a2c143b34d01..7be5806a1c398 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -105,7 +105,15 @@ static int mt76_led_init(struct mt76_dev *dev)
 		dev->led_al = of_property_read_bool(np, "led-active-low");
 	}
 
-	return devm_led_classdev_register(dev->dev, &dev->led_cdev);
+	return led_classdev_register(dev->dev, &dev->led_cdev);
+}
+
+static void mt76_led_cleanup(struct mt76_dev *dev)
+{
+	if (!dev->led_cdev.brightness_set && !dev->led_cdev.blink_set)
+		return;
+
+	led_classdev_unregister(&dev->led_cdev);
 }
 
 static void mt76_init_stream_cap(struct mt76_dev *dev,
@@ -360,6 +368,7 @@ void mt76_unregister_device(struct mt76_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->hw;
 
+	mt76_led_cleanup(dev);
 	mt76_tx_status_check(dev, NULL, true);
 	ieee80211_unregister_hw(hw);
 }
-- 
2.25.1



