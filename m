Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225F659DC2C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355305AbiHWKkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355308AbiHWKiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:38:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FA0A6C7D;
        Tue, 23 Aug 2022 02:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37852B81C85;
        Tue, 23 Aug 2022 09:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8313BC433D6;
        Tue, 23 Aug 2022 09:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245657;
        bh=gAP38tcAj7LlaKrsijqfJ1GSUGU8jMf8tiBpQP4uIZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0uWNVLBLjlAAzwZ1tXynTuWQv0ih2b3HQPEzpY9jX75pT6d+cSeoYu9ns8sLngL1
         NuK+B+TXs5fJjJ81BF5ftM0l24hKjR9FvFD53G3lq4JOwfdk/vOwO5OlEQNtEpbQ4C
         Swng1G3HwUoB2MXtNgv3v9hSl5lQhtns5ob0aiPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/287] ASoC: codecs: da7210: add check for i2c_add_driver
Date:   Tue, 23 Aug 2022 10:25:17 +0200
Message-Id: <20220823080105.554865945@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index e172913d04a4..efc5049c0796 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -1333,6 +1333,8 @@ static int __init da7210_modinit(void)
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



