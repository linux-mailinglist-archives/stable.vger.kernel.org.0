Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EEB68964B
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbjBCKZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbjBCKZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:25:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B721D945F4
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:25:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EF7E61E5D
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475EBC4339B;
        Fri,  3 Feb 2023 10:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419928;
        bh=HdwkosLvFl4Eg2pq4SB31AaUfIR9aVUGypswrbgFuUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ut4oD5gOeTvpYHtWfExMPXWKF6BzxSCI5GL+EFXS4apHMN52x6B5sj1ElcvzmrYjY
         31HxuneHo27PzSxwN9mXVaQnIwzrJvKMcPbSsGWglIoveiLvmMYK9xIrkht5POtkUy
         2oQCNWWiutkhnsByq7JrXLyCGptJb8desRNIYF4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/134] memory: atmel-sdramc: Fix missing clk_disable_unprepare in atmel_ramc_probe()
Date:   Fri,  3 Feb 2023 11:11:48 +0100
Message-Id: <20230203101024.006243325@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 340cb392a038cf70540a4cdf2e98a247c66b6df4 ]

The clk_disable_unprepare() should be called in the error handling
of caps->has_mpddr_clk, fix it by replacing devm_clk_get and
clk_prepare_enable by devm_clk_get_enabled.

Fixes: e81b6abebc87 ("memory: add a driver for atmel ram controllers")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221125073757.3535219-1-cuigaosheng1@huawei.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/atmel-sdramc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/memory/atmel-sdramc.c b/drivers/memory/atmel-sdramc.c
index 9c49d00c2a96..ea6e9e1eaf04 100644
--- a/drivers/memory/atmel-sdramc.c
+++ b/drivers/memory/atmel-sdramc.c
@@ -47,19 +47,17 @@ static int atmel_ramc_probe(struct platform_device *pdev)
 	caps = of_device_get_match_data(&pdev->dev);
 
 	if (caps->has_ddrck) {
-		clk = devm_clk_get(&pdev->dev, "ddrck");
+		clk = devm_clk_get_enabled(&pdev->dev, "ddrck");
 		if (IS_ERR(clk))
 			return PTR_ERR(clk);
-		clk_prepare_enable(clk);
 	}
 
 	if (caps->has_mpddr_clk) {
-		clk = devm_clk_get(&pdev->dev, "mpddr");
+		clk = devm_clk_get_enabled(&pdev->dev, "mpddr");
 		if (IS_ERR(clk)) {
 			pr_err("AT91 RAMC: couldn't get mpddr clock\n");
 			return PTR_ERR(clk);
 		}
-		clk_prepare_enable(clk);
 	}
 
 	return 0;
-- 
2.39.0



