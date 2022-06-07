Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45483540A58
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351476AbiFGSUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352415AbiFGSRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD082497A;
        Tue,  7 Jun 2022 10:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE42DB82354;
        Tue,  7 Jun 2022 17:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FB7C385A5;
        Tue,  7 Jun 2022 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624318;
        bh=9ngSOdPjjAPA6F7lCapsC6DrE+l8vaNY0CBrFpoeEAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVzh1iFJF5aSAZY+f8IjXTeJWUXRKikalk8kftTlWkGTd/0MRMjRjZ7B4i+01TimX
         AdEM54vgB0XZJ9n5IBr50SW5k193sNp4CFj6hhO1RqbK34gmDwqAiFCnaD3kSZApYI
         NLhfjwvdKtGcFPaQ3T13zlxo9OCGKSrFEhnFfuro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/667] irqchip/aspeed-scu-ic: Fix irq_of_parse_and_map() return value
Date:   Tue,  7 Jun 2022 18:59:09 +0200
Message-Id: <20220607164943.299922954@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

[ Upstream commit f03a9670d27d23fe734a456f16e2579b21ec02b4 ]

The irq_of_parse_and_map() returns 0 on failure, not a negative ERRNO.

Fixes: 04f605906ff0 ("irqchip: Add Aspeed SCU interrupt controller")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220423094227.33148-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-aspeed-scu-ic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-aspeed-scu-ic.c b/drivers/irqchip/irq-aspeed-scu-ic.c
index 18b77c3e6db4..279e92cf0b16 100644
--- a/drivers/irqchip/irq-aspeed-scu-ic.c
+++ b/drivers/irqchip/irq-aspeed-scu-ic.c
@@ -157,8 +157,8 @@ static int aspeed_scu_ic_of_init_common(struct aspeed_scu_ic *scu_ic,
 	}
 
 	irq = irq_of_parse_and_map(node, 0);
-	if (irq < 0) {
-		rc = irq;
+	if (!irq) {
+		rc = -EINVAL;
 		goto err;
 	}
 
-- 
2.35.1



