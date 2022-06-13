Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D15E5488E1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245154AbiFMKph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347898AbiFMKoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:44:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C42C20BD8;
        Mon, 13 Jun 2022 03:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 216ED60EFB;
        Mon, 13 Jun 2022 10:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5E9C34114;
        Mon, 13 Jun 2022 10:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115913;
        bh=xzGCfSZLzTsBiin7Dgz+G3EE85Jy2LOqbeb2Sx8S30o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KPLErRKufUCTyAX65hLfrl/Fm9tc4c9jiefe5FAOYas5AP/WJdX8nCN5mM6dK55q
         TOPgIEGn925wqnvO0nPAVGxVz++a4e+lGPm25/6obYxR2T+o1NRhnHcx6NGfHCMfyI
         Xg8Wt5DkIDXKNvA5FB5fGfMZcfGukpEN1YH0a5qE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 087/218] pinctrl: mvebu: Fix irq_of_parse_and_map() return value
Date:   Mon, 13 Jun 2022 12:09:05 +0200
Message-Id: <20220613094923.172492679@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 71bc7cf3be65bab441e03667cf215c557712976c ]

The irq_of_parse_and_map() returns 0 on failure, not a negative ERRNO.

Fixes: 2f227605394b ("pinctrl: armada-37xx: Add irqchip support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220422105339.78810-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 9f7d917458c7..d90aae2a5cfd 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -710,7 +710,7 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 	for (i = 0; i < nr_irq_parent; i++) {
 		int irq = irq_of_parse_and_map(np, i);
 
-		if (irq < 0)
+		if (!irq)
 			continue;
 
 		gpiochip_set_chained_irqchip(gc, irqchip, irq,
-- 
2.35.1



