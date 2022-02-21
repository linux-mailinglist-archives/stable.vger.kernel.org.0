Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC1F4BDEC3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245634AbiBUJtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352497AbiBUJrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EEE33E25;
        Mon, 21 Feb 2022 01:20:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DDB660EB3;
        Mon, 21 Feb 2022 09:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C32C340E9;
        Mon, 21 Feb 2022 09:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435201;
        bh=5oevNkWltuZ5z9s8IhiJQ2Gtu7X4d4URKOU16CHikIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6IFTIkFBXs+UXGUyV4L+NPdC3OikZeLtx78B6/fPVYxzDA75cLElT/hv896ig3vj
         HHui1GF6BuYb+yKwhLzLoQ9km3ZkD8pb3CmIo0JzbvBJu06MGt2W1L5mlPOq2/spgj
         K9POCU+ikTP7TfpRFgKlEt72v+1l8lv8OgtZtZLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Braha <julianbraha@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 049/227] pinctrl: bcm63xx: fix unmet dependency on REGMAP for GPIO_REGMAP
Date:   Mon, 21 Feb 2022 09:47:48 +0100
Message-Id: <20220221084936.506928008@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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



