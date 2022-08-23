Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C27959D8BD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242161AbiHWJvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351841AbiHWJu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:50:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B8E61728;
        Tue, 23 Aug 2022 01:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D07EB81C6C;
        Tue, 23 Aug 2022 08:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC41DC433D6;
        Tue, 23 Aug 2022 08:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244320;
        bh=EjuNj/W6yvY3QRPw/sASGRs/Haf5FAtW1SwjLFbn8ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7uOU+xhTlDzZmi6sIsZ1a1qhCRfratKmUHXgCSrbgnOn7ZsWAn/MU0dKFmT0uZWb
         pR6p0DnTBmwfqqV0UXOEPZP4xpO0Hpcea5LuLuNeq8yk/EzMabo9tGqGPeOC4NCy7U
         7Yzwd5zDmRo0zWzD1BI2iRcy1istRL+p4eXunFmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 119/229] ASoC: codecs: da7210: add check for i2c_add_driver
Date:   Tue, 23 Aug 2022 10:24:40 +0200
Message-Id: <20220823080057.953286886@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 82fa8f581a954ddeec1602bed9f8b4a09d100e6e ]

As i2c_add_driver could return error if fails, it should be
better to check the return value.
However, if the CONFIG_I2C and CONFIG_SPI_MASTER are both true,
the return value of i2c_add_driver will be covered by
spi_register_driver.
Therefore, it is necessary to add check and return error if fails.

Fixes: aa0e25caafb7 ("ASoC: da7210: Add support for spi regmap")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220531094712.2376759-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da7210.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 1af443ccbc51..ba38ea99b1da 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -1351,6 +1351,8 @@ static int __init da7210_modinit(void)
 	int ret = 0;
 #if IS_ENABLED(CONFIG_I2C)
 	ret = i2c_add_driver(&da7210_i2c_driver);
+	if (ret)
+		return ret;
 #endif
 #if defined(CONFIG_SPI_MASTER)
 	ret = spi_register_driver(&da7210_spi_driver);
-- 
2.35.1



