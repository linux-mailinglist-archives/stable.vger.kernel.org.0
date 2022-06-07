Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB3454136F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358069AbiFGUCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358652AbiFGUBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:01:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37971C0CB3;
        Tue,  7 Jun 2022 11:25:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82931B82384;
        Tue,  7 Jun 2022 18:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A10C385A2;
        Tue,  7 Jun 2022 18:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626312;
        bh=wKp8HDsungbWvC983amotRgL7FLHO8cc43t/Whwxl/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kmzHlstIQBxhcQC/1fn12l5Yrdm5okREo9ihoQEpOie7W91aKJCcoA3xlDLx4pff
         8eic0P42Hv3H3+gxFQHRBYKYp4R9g0AiGIBJCyFFRuK3NqR9abbAq/Ox/ZVW2C3kiU
         f7Hbi3xcoWISCqcjmFPCN2NYwUwLTdGk4LqrBfK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 332/772] irqchip/aspeed-i2c-ic: Fix irq_of_parse_and_map() return value
Date:   Tue,  7 Jun 2022 18:58:44 +0200
Message-Id: <20220607164958.806852664@linuxfoundation.org>
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

[ Upstream commit 50f0f26e7c8665763d0d7d3372dbcf191f94d077 ]

The irq_of_parse_and_map() returns 0 on failure, not a negative ERRNO.

Fixes: f48e699ddf70 ("irqchip/aspeed-i2c-ic: Add I2C IRQ controller for Aspeed")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220423094227.33148-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-aspeed-i2c-ic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-aspeed-i2c-ic.c b/drivers/irqchip/irq-aspeed-i2c-ic.c
index a47db16ff960..9c9fc3e2967e 100644
--- a/drivers/irqchip/irq-aspeed-i2c-ic.c
+++ b/drivers/irqchip/irq-aspeed-i2c-ic.c
@@ -77,8 +77,8 @@ static int __init aspeed_i2c_ic_of_init(struct device_node *node,
 	}
 
 	i2c_ic->parent_irq = irq_of_parse_and_map(node, 0);
-	if (i2c_ic->parent_irq < 0) {
-		ret = i2c_ic->parent_irq;
+	if (!i2c_ic->parent_irq) {
+		ret = -EINVAL;
 		goto err_iounmap;
 	}
 
-- 
2.35.1



