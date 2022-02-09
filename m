Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137964AFAF3
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240112AbiBISkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240174AbiBISjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:39:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF98C08ED09;
        Wed,  9 Feb 2022 10:39:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11CE5B82380;
        Wed,  9 Feb 2022 18:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBADEC340ED;
        Wed,  9 Feb 2022 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431958;
        bh=Pyle2Jv95r7tRGL+Wt4CcA9lvvZjHbaudDrcD8CL6tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTbY5p+eAlciV4yNP3o9Y63FiAXFQKWmU4IWuqUz3CQ4JBAksk12pm2MZ5rmG2HuP
         0rG/THBLv0XAnbpHTvv6M2uFcgdgceIUoJZl3HBDskQl12xXGumss8QK84R34D2Col
         k23RHZ70rMNjax70sXmpnu7QpE1fk7QbYclKsLcmrJwc2SA5rHTJSjf9M4RiroWFv5
         QN0kr9Xz3oi8p4FKwUrYzCJqrlH3gZ1DX09BaUzyCeD6pptqhq+1AbpCRAh9IM6NvO
         9EjGRnqPn+sVQi7nLDE7hyDi32JkyWA2GTQjkGjJ9MLHMVVcKkg4nfOVZ4F/6y9nYf
         a0s93AkOAq1PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, noltari@gmail.com,
        jonas.gorski@gmail.com, f.fainelli@gmail.com, rafal@milecki.pl,
        rdunlap@infradead.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/36] pinctrl: bcm63xx: fix unmet dependency on REGMAP for GPIO_REGMAP
Date:   Wed,  9 Feb 2022 13:37:39 -0500
Message-Id: <20220209183759.47134-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183759.47134-1-sashal@kernel.org>
References: <20220209183759.47134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 3a5286955bf5febc3d151bcb2c5e272e383b64aa ]

When PINCTRL_BCM63XX is selected,
and REGMAP is not selected,
Kbuild gives the following warning:

WARNING: unmet direct dependencies detected for GPIO_REGMAP
  Depends on [n]: GPIOLIB [=y] && REGMAP [=n]
  Selected by [y]:
  - PINCTRL_BCM63XX [=y] && PINCTRL [=y]

This is because PINCTRL_BCM63XX
selects GPIO_REGMAP without selecting or depending on
REGMAP, despite GPIO_REGMAP depending on REGMAP.

This unmet dependency bug was detected by Kismet,
a static analysis tool for Kconfig. Please advise
if this is not the appropriate solution.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
Link: https://lore.kernel.org/r/20220117062557.89568-1-julianbraha@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/bcm/Kconfig b/drivers/pinctrl/bcm/Kconfig
index c9c5efc927311..5973a279e6b8c 100644
--- a/drivers/pinctrl/bcm/Kconfig
+++ b/drivers/pinctrl/bcm/Kconfig
@@ -35,6 +35,7 @@ config PINCTRL_BCM63XX
 	select PINCONF
 	select GENERIC_PINCONF
 	select GPIOLIB
+	select REGMAP
 	select GPIO_REGMAP
 
 config PINCTRL_BCM6318
-- 
2.34.1

