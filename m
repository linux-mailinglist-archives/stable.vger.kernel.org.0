Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A17E20662B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388845AbgFWViU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387890AbgFWUIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:08:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42AA12064B;
        Tue, 23 Jun 2020 20:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942892;
        bh=VcSOQ2qH2sWUKv+iNrqztCThkyL2PjPjllnVeVeguF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+U3E3W+wgmOzYVDr3fgLaW9V1IKqCw2rkdyeYkpQWT+eEHLANEtxP25HZ1jKSmIW
         ZcI8IKRougRJ5C2sXWqrOl6SKKsxkHOi66DL0l3s51Fx8NxwCfsbEelxpg/tD1adfq
         ikdqRhxb5e+9PF4u6j3H8bfJMiiPDvG/DfdjX2Os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 177/477] power: supply: lp8788: Fix an error handling path in lp8788_charger_probe()
Date:   Tue, 23 Jun 2020 21:52:54 +0200
Message-Id: <20200623195415.946734574@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 934ed3847a4ebc75b655659c4d2349ba4337941c ]

In the probe function, in case of error, resources allocated in
'lp8788_setup_adc_channel()' must be released.

This can be achieved easily by using the devm_ variant of
'iio_channel_get()'.
This has the extra benefit to simplify the remove function and to axe the
'lp8788_release_adc_channel()' function which is now useless.

Fixes: 98a276649358 ("power_supply: Add new lp8788 charger driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/lp8788-charger.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/power/supply/lp8788-charger.c b/drivers/power/supply/lp8788-charger.c
index 84a206f42a8e9..e7931ffb7151d 100644
--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -572,27 +572,14 @@ static void lp8788_setup_adc_channel(struct device *dev,
 		return;
 
 	/* ADC channel for battery voltage */
-	chan = iio_channel_get(dev, pdata->adc_vbatt);
+	chan = devm_iio_channel_get(dev, pdata->adc_vbatt);
 	pchg->chan[LP8788_VBATT] = IS_ERR(chan) ? NULL : chan;
 
 	/* ADC channel for battery temperature */
-	chan = iio_channel_get(dev, pdata->adc_batt_temp);
+	chan = devm_iio_channel_get(dev, pdata->adc_batt_temp);
 	pchg->chan[LP8788_BATT_TEMP] = IS_ERR(chan) ? NULL : chan;
 }
 
-static void lp8788_release_adc_channel(struct lp8788_charger *pchg)
-{
-	int i;
-
-	for (i = 0; i < LP8788_NUM_CHG_ADC; i++) {
-		if (!pchg->chan[i])
-			continue;
-
-		iio_channel_release(pchg->chan[i]);
-		pchg->chan[i] = NULL;
-	}
-}
-
 static ssize_t lp8788_show_charger_status(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -735,7 +722,6 @@ static int lp8788_charger_remove(struct platform_device *pdev)
 	flush_work(&pchg->charger_work);
 	lp8788_irq_unregister(pdev, pchg);
 	lp8788_psy_unregister(pchg);
-	lp8788_release_adc_channel(pchg);
 
 	return 0;
 }
-- 
2.25.1



