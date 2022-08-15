Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED58594D97
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244908AbiHPAgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350640AbiHPAgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:36:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8841894DC;
        Mon, 15 Aug 2022 13:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A724BB8114A;
        Mon, 15 Aug 2022 20:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57A8C433C1;
        Mon, 15 Aug 2022 20:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595852;
        bh=I2Uxh4EvJCSOE07CYqNhIoCNwu9Uw3Ub0lGO2+m236M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSb5nlUVSs7UeIz8797dC0ymrYnSL+xFQsLEacYeukABo0MXHJ4J7Pg6dFAyvUaF5
         +bUZa8I1QUibV/lfyiG3xKd8prt/jE6VBf8WP6SB3/0YF4w08BkHzTfN0i0It05yxd
         tUxJE2orGOTVvjDOj17dxzodFRfkPILPR/HY1kW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Steve Lee <steve.lee.analog@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0894/1157] ASoC: max98390: use linux/gpio/consumer.h to fix build
Date:   Mon, 15 Aug 2022 20:04:10 +0200
Message-Id: <20220815180515.194039678@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit aa7407f807b250eca7697e5fe9a699bc6c2fab71 ]

Change the header file to fix build errors in max98390.c:

../sound/soc/codecs/max98390.c: In function 'max98390_i2c_probe':
../sound/soc/codecs/max98390.c:1076:22: error: implicit declaration of function 'devm_gpiod_get_optional'; did you mean 'devm_regulator_get_optional'? [-Werror=implicit-function-declaration]
 1076 |         reset_gpio = devm_gpiod_get_optional(&i2c->dev,
../sound/soc/codecs/max98390.c:1077:55: error: 'GPIOD_OUT_HIGH' undeclared (first use in this function); did you mean 'GPIOF_INIT_HIGH'?
 1077 |                                              "reset", GPIOD_OUT_HIGH);
../sound/soc/codecs/max98390.c:1077:55: note: each undeclared identifier is reported only once for each function it appears in
../sound/soc/codecs/max98390.c:1083:17: error: implicit declaration of function 'gpiod_set_value_cansleep'; did you mean 'gpio_set_value_cansleep'? [-Werror=implicit-function-declaration]
 1083 |                 gpiod_set_value_cansleep(reset_gpio, 0);

Fixes: 397ff0249606 ("ASoC: max98390: Add reset gpio control")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Steve Lee <steve.lee.analog@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
Link: https://lore.kernel.org/r/20220605163123.23537-1-rdunlap@infradead.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98390.c b/sound/soc/codecs/max98390.c
index 2a6b1648c884..d83f81d9ff4e 100644
--- a/sound/soc/codecs/max98390.c
+++ b/sound/soc/codecs/max98390.c
@@ -10,7 +10,7 @@
 #include <linux/cdev.h>
 #include <linux/dmi.h>
 #include <linux/firmware.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/of_gpio.h>
-- 
2.35.1



