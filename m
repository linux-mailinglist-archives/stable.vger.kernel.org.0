Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B48E541526
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbiFGU3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376766AbiFGU2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:28:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264E71D80A7;
        Tue,  7 Jun 2022 11:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C148B8237C;
        Tue,  7 Jun 2022 18:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F2CC385A5;
        Tue,  7 Jun 2022 18:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626788;
        bh=conex0sFGgB/DV350k7ij59++tfMZbwt9/zyaSY9Pe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANm4+MV++tW8/oFp+QcZfR7UEZlTy1GX1EuLpuv4cFDwKJrk4w8Qdc+GbX/1duQv4
         0SwFHXGc/kBVEAGcYG/P1kH8Qr0LuO+Bb70yelD+rOMlEl50VNgQglvTPUFpy9J/rE
         YGsXfA1o7aTpGRXtnRya6a9jNmgW7nOddPhZP9Yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 503/772] pinctrl: mvebu: Fix irq_of_parse_and_map() return value
Date:   Tue,  7 Jun 2022 19:01:35 +0200
Message-Id: <20220607165003.801604637@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 08cad14042e2..adccf03b3e5a 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -773,7 +773,7 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 	for (i = 0; i < nr_irq_parent; i++) {
 		int irq = irq_of_parse_and_map(np, i);
 
-		if (irq < 0)
+		if (!irq)
 			continue;
 		girq->parents[i] = irq;
 	}
-- 
2.35.1



