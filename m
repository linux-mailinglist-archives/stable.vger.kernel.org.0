Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FE9452451
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356667AbhKPBhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242945AbhKOSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:50:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C26061507;
        Mon, 15 Nov 2021 18:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999750;
        bh=Gl4Xe7uU/xTaf++Ml296d66z5wC/FE2VWrA/FHOlJP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPujTLLZEa795cRMqFFoJ2lVQ/y9cj44MOeWycIyFyZZ1Mq3cpnAR/XBbOtznmXQ+
         TNhB4jNJT+74TeO4x4HFTiXlj03621QT3U7uW+SaDFuORLtMmR7s52d2I8u5VTLAhC
         j8/0TT4Xf4y/J3TsF46zbLk7S5Pm5Nf8G/etl2fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Kirill Shilimanov <kirill.shilimanov@huawei.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 410/849] media: dvb-frontends: mn88443x: Handle errors of clk_prepare_enable()
Date:   Mon, 15 Nov 2021 17:58:13 +0100
Message-Id: <20211115165434.134542624@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index e4528784f8477..fff212c0bf3b5 100644
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



