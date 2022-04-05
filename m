Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBA34F2DEB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241028AbiDEJPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244930AbiDEIws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE20124970;
        Tue,  5 Apr 2022 01:46:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89BEA614F9;
        Tue,  5 Apr 2022 08:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C30C385A0;
        Tue,  5 Apr 2022 08:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148411;
        bh=6/cQjaXqq6vyOdwI/I7vG3d/NAXAZj9v3wIcWjLZh04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQq0jXcmDoBB4EuNXrGM+AqPOlZXyvQTIxlYiJvmvFqcbiDZmlJJvU7C/fQW+4NSS
         x4ph8iWcjp12/eKXn2pjamGOFuot3EGkrEzrk7/CFwQ2yzVEPKbZMDwlTDOrGo8z2v
         30DQHJZUutxuH2l4OMiBrKlLkchOdwI4cpSNeiTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Alejandro Tafalla <atafalla@dnyon.com>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0308/1017] ASoC: max98927: add missing header file
Date:   Tue,  5 Apr 2022 09:20:21 +0200
Message-Id: <20220405070403.419004572@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit bb45f689fa62110c263c86070bfcb9ecbb6e1e23 ]

Add a header file that provides the missing function prototypes
and macro to fix these build errors (seen on arch/alpha/):

../sound/soc/codecs/max98927.c: In function 'max98927_i2c_probe':
../sound/soc/codecs/max98927.c:902:19: error: implicit declaration of function 'devm_gpiod_get_optional'; did you mean 'devm_regulator_get_optional'? [-Werror=implicit-function-declaration]
  902 |                 = devm_gpiod_get_optional(&i2c->dev, "reset", GPIOD_OUT_HIGH);
      |                   ^~~~~~~~~~~~~~~~~~~~~~~
../sound/soc/codecs/max98927.c:902:63: error: 'GPIOD_OUT_HIGH' undeclared (first use in this function); did you mean 'GPIOF_INIT_HIGH'?
  902 |                 = devm_gpiod_get_optional(&i2c->dev, "reset", GPIOD_OUT_HIGH);
      |                                                               ^~~~~~~~~~~~~~
../sound/soc/codecs/max98927.c:909:17: error: implicit declaration of function 'gpiod_set_value_cansleep'; did you mean 'gpio_set_value_cansleep'? [-Werror=implicit-function-declaration]
  909 |                 gpiod_set_value_cansleep(max98927->reset_gpio, 0);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 4d67dc1998f1 ("ASoC: max98927: Handle reset gpio when probing i2c")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Alejandro Tafalla <atafalla@dnyon.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
Link: https://lore.kernel.org/r/20220129080259.19964-1-rdunlap@infradead.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98927.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/max98927.c b/sound/soc/codecs/max98927.c
index 5ba5f876eab8..fd84780bf689 100644
--- a/sound/soc/codecs/max98927.c
+++ b/sound/soc/codecs/max98927.c
@@ -16,6 +16,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of_gpio.h>
 #include <sound/tlv.h>
 #include "max98927.h"
-- 
2.34.1



