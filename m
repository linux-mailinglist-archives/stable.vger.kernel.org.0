Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A74649F9D
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiLLNNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiLLNMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:12:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22419DF6D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:12:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3D2861059
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AC4C433EF;
        Mon, 12 Dec 2022 13:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850740;
        bh=I5mzg9fFy1bW72TyvTZKG/bnL367pM9JALW3VqNVQrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5Mqi+Ky0qh04m1SUc6qQMllvWhHs7bSDo53spxG9eq+mtH7LLTO8s8kJhHcvdJsj
         Xrg+QGnsdK7Xx6/3dxU9+Y4A2cMeVsxMVBJ0+iM0ZQLOEZv2O6LexQu35bcKK3nCnd
         m5atGNRfC5KFtGW5GNPch7EgbK55Qo/Cz3XHAaZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/106] regulator: slg51000: Wait after asserting CS pin
Date:   Mon, 12 Dec 2022 14:09:21 +0100
Message-Id: <20221212130925.662660590@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 0b24dfa587c6cc7484cfb170da5c7dd73451f670 ]

Sony's downstream driver [1], among some other changes, adds a
seemingly random 10ms usleep_range, which turned out to be necessary
for the hardware to function properly on at least Sony Xperia 1 IV.
Without this, I2C transactions with the SLG51000 straight up fail.

Relax (10-10ms -> 10-11ms) and add the aforementioned sleep to make
sure the hardware has some time to wake up.

(nagara-2.0.0-mlc/vendor/semc/hardware/camera-kernel-module/)
[1] https://developer.sony.com/file/download/open-source-archive-for-64-0-m-4-29/

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20221118131035.54874-1-konrad.dybcio@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/slg51000-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/slg51000-regulator.c b/drivers/regulator/slg51000-regulator.c
index 75a941fb3c2b..1b2eee95ad3f 100644
--- a/drivers/regulator/slg51000-regulator.c
+++ b/drivers/regulator/slg51000-regulator.c
@@ -457,6 +457,8 @@ static int slg51000_i2c_probe(struct i2c_client *client)
 		chip->cs_gpiod = cs_gpiod;
 	}
 
+	usleep_range(10000, 11000);
+
 	i2c_set_clientdata(client, chip);
 	chip->chip_irq = client->irq;
 	chip->dev = dev;
-- 
2.35.1



