Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F55B51A75A
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354129AbiEDRCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355244AbiEDQ7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:59:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157E049686;
        Wed,  4 May 2022 09:51:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC300617C2;
        Wed,  4 May 2022 16:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457B7C385AF;
        Wed,  4 May 2022 16:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683083;
        bh=JSCa2iDFyLjNaathPK9LBYB8qEdrw+UHxwx06chyEuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hp+4w2BnX4CDB9qWJH1EQr2oXNJXq7T9zSUa2OOnUYFMvLlKQN5+TAUBqXhMtbDvu
         i/cUg/an+MABgzS1vJbdJTZpv9YmkaqmV04iCrXBwqp2IllCohGF3p6FHm8OtCn3cx
         BC21GPiyo90R/GfcBrTbGBC4pBk8lIYzoR00pJLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/129] pinctrl: pistachio: fix use of irq_of_parse_and_map()
Date:   Wed,  4 May 2022 18:44:26 +0200
Message-Id: <20220504153027.095704950@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 0c9843a74a85224a89daa81fa66891dae2f930e1 ]

The irq_of_parse_and_map() function returns 0 on failure, and does not
return an negative value.

Fixes: cefc03e5995e ("pinctrl: Add Pistachio SoC pin control driver")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Link: https://lore.kernel.org/r/20220424031430.3170759-1-lv.ruyi@zte.com.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-pistachio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-pistachio.c b/drivers/pinctrl/pinctrl-pistachio.c
index ec761ba2a2da..989a37fb402d 100644
--- a/drivers/pinctrl/pinctrl-pistachio.c
+++ b/drivers/pinctrl/pinctrl-pistachio.c
@@ -1374,10 +1374,10 @@ static int pistachio_gpio_register(struct pistachio_pinctrl *pctl)
 		}
 
 		irq = irq_of_parse_and_map(child, 0);
-		if (irq < 0) {
-			dev_err(pctl->dev, "No IRQ for bank %u: %d\n", i, irq);
+		if (!irq) {
+			dev_err(pctl->dev, "No IRQ for bank %u\n", i);
 			of_node_put(child);
-			ret = irq;
+			ret = -EINVAL;
 			goto err;
 		}
 
-- 
2.35.1



