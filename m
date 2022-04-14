Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31D8500F69
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbiDNN1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244355AbiDNN0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:26:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E2A9E9E6;
        Thu, 14 Apr 2022 06:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91120618C4;
        Thu, 14 Apr 2022 13:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973C4C385A9;
        Thu, 14 Apr 2022 13:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942400;
        bh=GRVYjGN0oVU3bLQLZkS30dh2b8ueNqwEcosPDjmYZFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAQyWMJAC1KiSzB4b9wpFmgbNF0I9UjEjl369G8DqEvHsOJNFZRmUxCgCz7yjuZH2
         9NgMRE0gdzBGi2s8CC9jv3jqy9lySIi8i8WoGmhELc0kX/P4wloxspJZtXRi7YZlaY
         tcoGWi+UuMHiXpxXfTgswrq3IANf69v5X7HcygLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/338] power: reset: gemini-poweroff: Fix IRQ check in gemini_poweroff_probe
Date:   Thu, 14 Apr 2022 15:10:26 +0200
Message-Id: <20220414110842.404472626@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ba18dad0fb880cd29aa97b6b75560ef14d1061ba ]

platform_get_irq() returns negative error number instead 0 on failure.
And the doc of platform_get_irq() provides a usage example:

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0)
        return irq;

Fix the check of return value to catch errors correctly.

Fixes: f7a388d6cd1c ("power: reset: Add a driver for the Gemini poweroff")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/gemini-poweroff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/reset/gemini-poweroff.c b/drivers/power/reset/gemini-poweroff.c
index 90e35c07240a..b7f7a8225f22 100644
--- a/drivers/power/reset/gemini-poweroff.c
+++ b/drivers/power/reset/gemini-poweroff.c
@@ -107,8 +107,8 @@ static int gemini_poweroff_probe(struct platform_device *pdev)
 		return PTR_ERR(gpw->base);
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq)
-		return -EINVAL;
+	if (irq < 0)
+		return irq;
 
 	gpw->dev = dev;
 
-- 
2.34.1



