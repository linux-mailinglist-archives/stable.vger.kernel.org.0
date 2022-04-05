Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D92C4F3285
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241987AbiDEIgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239492AbiDEIUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F93B11;
        Tue,  5 Apr 2022 01:14:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F795609AD;
        Tue,  5 Apr 2022 08:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AE0C385A0;
        Tue,  5 Apr 2022 08:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146466;
        bh=TaiY8tH3629YPscA/b6pkTwtVd1V5SPfH9pAw+XpuJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3YLFPGZ2F7IKNTpuYNr2nGAKKrcgL7TUJqe4qTBhBC6xtlXDT3MfvIhFLjmDzvf5
         q2neQp4B4Yuh8qNDlU9PAJRnK44ZFpxTfGVOfBFzg8fcZPXO2IgjBRBN8zSwJcoIGn
         DBYUJYUwLv4j1r7vhIsn2FsgKYEWTRol8GKO30D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0774/1126] pinctrl: ocelot: Fix interrupt parsing
Date:   Tue,  5 Apr 2022 09:25:21 +0200
Message-Id: <20220405070430.299266803@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit d1f2c82f3b1f428bdc0933dde52fb93ae796d4ee ]

In the blamed commit, it removes the duplicate of_node assignment in the
driver. But the driver uses this before calling into of_gpio_dev_init to
determine if it needs to assign an IRQ chip to the GPIO. The fixes
consists in using the platform_get_irq_optional

Fixes: 8a8d6bbe1d3bc7 ("pinctrl: Get rid of duplicate of_node assignment in the drivers")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20220304144432.3397621-3-horatiu.vultur@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 9c13a7c90fc3..370459243007 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1750,8 +1750,8 @@ static int ocelot_gpiochip_register(struct platform_device *pdev,
 	gc->base = -1;
 	gc->label = "ocelot-gpio";
 
-	irq = irq_of_parse_and_map(gc->of_node, 0);
-	if (irq) {
+	irq = platform_get_irq_optional(pdev, 0);
+	if (irq > 0) {
 		girq = &gc->irq;
 		girq->chip = &ocelot_irqchip;
 		girq->parent_handler = ocelot_irq_handler;
-- 
2.34.1



