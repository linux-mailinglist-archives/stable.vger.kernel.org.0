Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940E5680F71
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjA3Nxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbjA3Nxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:53:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39037A251
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:53:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E73D2B81145
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356BEC433D2;
        Mon, 30 Jan 2023 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086822;
        bh=HdwkosLvFl4Eg2pq4SB31AaUfIR9aVUGypswrbgFuUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcE7M1ouS4umQusHHdwc1KDEr7tlGK8xKV1KjLIYfj2MwlCoS/pgp6nZOoUaf4+jE
         iufrFeaEWnO031j2DLtDPTMNkuQp6PluTomJuYvUj09dX8KJE6pkvEbWiCFTQM2Qqq
         mDkMtZ4QUBm3dOzpviFUhUvYEDXaGASTEndPDugY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/313] memory: atmel-sdramc: Fix missing clk_disable_unprepare in atmel_ramc_probe()
Date:   Mon, 30 Jan 2023 14:47:17 +0100
Message-Id: <20230130134336.656436945@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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



