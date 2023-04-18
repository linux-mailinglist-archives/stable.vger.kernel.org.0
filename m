Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32426E6195
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjDRMZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbjDRMZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:25:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E32F83F7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:25:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFE086312F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EF1C433EF;
        Tue, 18 Apr 2023 12:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820728;
        bh=iSlH1YU6NyrpxL5h9pF5bYMmIuS5fZQQjseBFeXDF+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOXaFQpAv1wek+8BbqWzYL9uH2NgEUY5N+m/9WGX8ZZ9j2+FO5ESj+3VPROhCxd/V
         nNGM5LtdJ+zq4Wz/Rq4RSvTfm/tB+3Wm1zbcKcSbPC+E1oSY5NDpJMTlfqF0TJ1Axa
         WhC2ZnLHKCTjOUEia9u8x81xqp1fcW5TSiZoHzB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sandeep Singh <Sandeep.Singh@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Nehal Shah <Nehal-bakulchandra.Shah@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/57] pinctrl: Added IRQF_SHARED flag for amd-pinctrl driver
Date:   Tue, 18 Apr 2023 14:21:01 +0200
Message-Id: <20230418120258.773778655@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Singh <sandeep.singh@amd.com>

[ Upstream commit 279ffafaf39d60b3c37cb3f0f7de310d0dd834ad ]

Some of the AMD reference boards used single GPIO line for
multiple devices. So added IRQF_SHARED flag in amd pinctrl driver.

Signed-off-by: Sandeep Singh <Sandeep.Singh@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
cc: Nehal Shah <Nehal-bakulchandra.Shah@amd.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: b26cd9325be4 ("pinctrl: amd: Disable and mask interrupts on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 66b9c5826ec03..d76e50bc9d85c 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -943,8 +943,8 @@ static int amd_gpio_probe(struct platform_device *pdev)
 		goto out2;
 	}
 
-	ret = devm_request_irq(&pdev->dev, irq_base, amd_gpio_irq_handler, 0,
-			       KBUILD_MODNAME, gpio_dev);
+	ret = devm_request_irq(&pdev->dev, irq_base, amd_gpio_irq_handler,
+			       IRQF_SHARED, KBUILD_MODNAME, gpio_dev);
 	if (ret)
 		goto out2;
 
-- 
2.39.2



