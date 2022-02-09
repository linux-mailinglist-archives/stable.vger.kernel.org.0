Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BEB4AFA35
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbiBISfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239565AbiBISfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:35:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694F9C05CB88;
        Wed,  9 Feb 2022 10:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE61F61C31;
        Wed,  9 Feb 2022 18:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D71BC340EE;
        Wed,  9 Feb 2022 18:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431748;
        bh=5oevNkWltuZ5z9s8IhiJQ2Gtu7X4d4URKOU16CHikIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFwS4+PfIXvz/DsOutjqOAd+IjH/PLsMT2/t5xZpqCDPBVl8wwQBzwb+orGT3AVcJ
         B9LF67BNK59spcBWAXvIixb167WZHz0hNC97kerP7sQiJWB8Jb8uBNdcX4vorRrw3C
         mTAHs9xGaxhRZgWRDvra3aAfpo8r/rzy0X4NKiP/9lE6AEcST7eeeLcAllG/BnSUzM
         VgqSFD5TnHiOokmMR+ZBtTzUFhFLQ1Mp62hCda/IC8+QuaIYR3iEH1zs30XC7yyjeu
         o0E8a5d7mC6gBz6Vw9Ni1j/LVGpzdMY1QkyDCoRpPlf8262XQUTWA3fPmQLr3kRyfF
         CDkVRZahZCcDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, jonas.gorski@gmail.com,
        noltari@gmail.com, rdunlap@infradead.org, nsaenz@kernel.org,
        rafal@milecki.pl, f.fainelli@gmail.com, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 20/42] pinctrl: bcm63xx: fix unmet dependency on REGMAP for GPIO_REGMAP
Date:   Wed,  9 Feb 2022 13:32:52 -0500
Message-Id: <20220209183335.46545-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
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
index 8fc1feedd8617..5116b014e2a4f 100644
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

