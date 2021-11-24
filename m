Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895AE45C002
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343980AbhKXNED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:04:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346697AbhKXNCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:02:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 881E6619F5;
        Wed, 24 Nov 2021 12:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757352;
        bh=ZTw2M3FXJciBHBvNDjbZApPxJw9LWsiKfN9fqg6GrvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbcEYL9vgsqoAqSyIPGYItRfxrZgcbADhqY9yA/+I1Nk4ne38Wf/5hbsoblGR58Mv
         X4aC5evFqvL+pWhNd1lJLBDWF6oyUhlMfO+FsZl4GMFTUYfgX8Oz2i/POpVCD+OpEP
         YJJsFChN2HfjK6CbOZq1EWZFUW4JxwVr1Aov55QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Kirill Shilimanov <kirill.shilimanov@huawei.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/323] media: dvb-frontends: mn88443x: Handle errors of clk_prepare_enable()
Date:   Wed, 24 Nov 2021 12:55:29 +0100
Message-Id: <20211124115723.616836693@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 69a10678e2fba3d182e78ea041f2d1b1a6058764 ]

mn88443x_cmn_power_on() did not handle possible errors of
clk_prepare_enable() and always finished successfully so that its caller
mn88443x_probe() did not care about failed preparing/enabling of clocks
as well.

Add missed error handling in both mn88443x_cmn_power_on() and
mn88443x_probe(). This required to change the return value of the former
from "void" to "int".

Found by Linux Driver Verification project (linuxtesting.org).

Fixes: 0f408ce8941f ("media: dvb-frontends: add Socionext MN88443x ISDB-S/T demodulator driver")
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Co-developed-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
Signed-off-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/mn88443x.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88443x.c b/drivers/media/dvb-frontends/mn88443x.c
index 9ec1aeef03d5a..53981ff9422e0 100644
--- a/drivers/media/dvb-frontends/mn88443x.c
+++ b/drivers/media/dvb-frontends/mn88443x.c
@@ -204,11 +204,18 @@ struct mn88443x_priv {
 	struct regmap *regmap_t;
 };
 
-static void mn88443x_cmn_power_on(struct mn88443x_priv *chip)
+static int mn88443x_cmn_power_on(struct mn88443x_priv *chip)
 {
+	struct device *dev = &chip->client_s->dev;
 	struct regmap *r_t = chip->regmap_t;
+	int ret;
 
-	clk_prepare_enable(chip->mclk);
+	ret = clk_prepare_enable(chip->mclk);
+	if (ret) {
+		dev_err(dev, "Failed to prepare and enable mclk: %d\n",
+			ret);
+		return ret;
+	}
 
 	gpiod_set_value_cansleep(chip->reset_gpio, 1);
 	usleep_range(100, 1000);
@@ -222,6 +229,8 @@ static void mn88443x_cmn_power_on(struct mn88443x_priv *chip)
 	} else {
 		regmap_write(r_t, HIZSET3, 0x8f);
 	}
+
+	return 0;
 }
 
 static void mn88443x_cmn_power_off(struct mn88443x_priv *chip)
@@ -738,7 +747,10 @@ static int mn88443x_probe(struct i2c_client *client,
 	chip->fe.demodulator_priv = chip;
 	i2c_set_clientdata(client, chip);
 
-	mn88443x_cmn_power_on(chip);
+	ret = mn88443x_cmn_power_on(chip);
+	if (ret)
+		goto err_i2c_t;
+
 	mn88443x_s_sleep(chip);
 	mn88443x_t_sleep(chip);
 
-- 
2.33.0



