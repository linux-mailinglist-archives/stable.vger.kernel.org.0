Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778CB505470
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241123AbiDRNGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241190AbiDRNFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:05:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5282913E2E;
        Mon, 18 Apr 2022 05:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FD10B80D9C;
        Mon, 18 Apr 2022 12:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5946CC385A7;
        Mon, 18 Apr 2022 12:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285932;
        bh=1e+kMqmuq0XgPzihm05kZ+rHyIgwe3Ceg9otdTGMBhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSl/SBRGfFBiSYuqgw53M7ttXamNgQpDeJfDx9Jk1BYeeyF3jmGCH8OEatbmxlsN9
         jc8lLxlmLDgbs68xNJqErhuYzk8WuIp8Fxdv/KdBP+R9LxKOvwR1S5tD8C+O51VGf2
         7BwBTAU6v+CU+ccitwB8MCpDSUftoNqSPbIhOkvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/32] memory: atmel-ebi: Fix missing of_node_put in atmel_ebi_probe
Date:   Mon, 18 Apr 2022 14:13:41 +0200
Message-Id: <20220418121127.172096762@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
References: <20220418121127.127656835@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 6f296a9665ba5ac68937bf11f96214eb9de81baa ]

The device_node pointer is returned by of_parse_phandle() with refcount
incremented. We should use of_node_put() on it when done.

Fixes: 87108dc78eb8 ("memory: atmel-ebi: Enable the SMC clock if specified")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220309110144.22412-1-linmq006@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/atmel-ebi.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/memory/atmel-ebi.c b/drivers/memory/atmel-ebi.c
index 2b9283d4fcb1..8e7b5a1d2983 100644
--- a/drivers/memory/atmel-ebi.c
+++ b/drivers/memory/atmel-ebi.c
@@ -524,20 +524,27 @@ static int atmel_ebi_probe(struct platform_device *pdev)
 	smc_np = of_parse_phandle(dev->of_node, "atmel,smc", 0);
 
 	ebi->smc.regmap = syscon_node_to_regmap(smc_np);
-	if (IS_ERR(ebi->smc.regmap))
-		return PTR_ERR(ebi->smc.regmap);
+	if (IS_ERR(ebi->smc.regmap)) {
+		ret = PTR_ERR(ebi->smc.regmap);
+		goto put_node;
+	}
 
 	ebi->smc.layout = atmel_hsmc_get_reg_layout(smc_np);
-	if (IS_ERR(ebi->smc.layout))
-		return PTR_ERR(ebi->smc.layout);
+	if (IS_ERR(ebi->smc.layout)) {
+		ret = PTR_ERR(ebi->smc.layout);
+		goto put_node;
+	}
 
 	ebi->smc.clk = of_clk_get(smc_np, 0);
 	if (IS_ERR(ebi->smc.clk)) {
-		if (PTR_ERR(ebi->smc.clk) != -ENOENT)
-			return PTR_ERR(ebi->smc.clk);
+		if (PTR_ERR(ebi->smc.clk) != -ENOENT) {
+			ret = PTR_ERR(ebi->smc.clk);
+			goto put_node;
+		}
 
 		ebi->smc.clk = NULL;
 	}
+	of_node_put(smc_np);
 	ret = clk_prepare_enable(ebi->smc.clk);
 	if (ret)
 		return ret;
@@ -587,6 +594,10 @@ static int atmel_ebi_probe(struct platform_device *pdev)
 	}
 
 	return of_platform_populate(np, NULL, NULL, dev);
+
+put_node:
+	of_node_put(smc_np);
+	return ret;
 }
 
 static __maybe_unused int atmel_ebi_resume(struct device *dev)
-- 
2.35.1



