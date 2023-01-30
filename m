Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6F268110F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbjA3OJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237178AbjA3OJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354C03B670
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7913561086
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B0BC4339E;
        Mon, 30 Jan 2023 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087785;
        bh=HdwkosLvFl4Eg2pq4SB31AaUfIR9aVUGypswrbgFuUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpRGOob9Ia+q9/a3ZY3V5hIeUko9/dcp2yD4jb9Nf7r/FNFFk8FTYodUDBU+1zwGR
         z9mjwoYLWxQGX0uQBEAeOHAtIhAeoiXF1HpqBCsxmf6jY6noSh/m9bTXbKg/TV3KFO
         mSyu9Shq0h2/YOhOZCPbvULmNxXERdziKvRNoIvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/204] memory: atmel-sdramc: Fix missing clk_disable_unprepare in atmel_ramc_probe()
Date:   Mon, 30 Jan 2023 14:49:27 +0100
Message-Id: <20230130134316.430794788@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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



