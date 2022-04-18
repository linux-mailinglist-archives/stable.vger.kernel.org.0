Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA99505261
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbiDRMkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240815AbiDRMjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94929BD6;
        Mon, 18 Apr 2022 05:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AEC8B80EC0;
        Mon, 18 Apr 2022 12:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9364DC385A9;
        Mon, 18 Apr 2022 12:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285049;
        bh=tv4zKBl+I3vxx2xHCn4Ct8zhqbx9Pth5UP2RUme5oVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZUI+x/hZgh57M/lkPD4bcbxT1+EI9rVmUCAhcZtXI5u5y3HOKhTKY+q3C3Rg26Gx
         ayNrPridAIObJD4bmKsFCKpitSnCRxQ4RZXe4L43RhNkfDQzYIpiN1EVHFT2NUPP22
         QVzBbtPTZbySoNfw8Aww86qnbijqT+EhG3hgBFyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/189] memory: atmel-ebi: Fix missing of_node_put in atmel_ebi_probe
Date:   Mon, 18 Apr 2022 14:11:18 +0200
Message-Id: <20220418121202.156879229@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
index c267283b01fd..e749dcb3ddea 100644
--- a/drivers/memory/atmel-ebi.c
+++ b/drivers/memory/atmel-ebi.c
@@ -544,20 +544,27 @@ static int atmel_ebi_probe(struct platform_device *pdev)
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
@@ -608,6 +615,10 @@ static int atmel_ebi_probe(struct platform_device *pdev)
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



