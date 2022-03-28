Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CDE4E9504
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241519AbiC1Ljt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241889AbiC1Ldz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:33:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8AC5938E;
        Mon, 28 Mar 2022 04:24:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06E6CB81058;
        Mon, 28 Mar 2022 11:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFA5C340EC;
        Mon, 28 Mar 2022 11:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466695;
        bh=87Dy8mAAeekj4Khq5ieyQ/YtECtV+i9VCgc9SA9o5EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWdhy8R3CoQRLuwo0qM4npUxSGczoEnNHQYf+t2Qa0rctdDhIo5oD/NAcM6uiVG0G
         geAPdutdYyC7VoLq2yy/cAIGvBkZUiMv9jl6zmPX7I3twE7Z4GcegwuZ0MQhil6drp
         q1SsboJAKLUaPJkTWbqeE3CnK1vcMAI6a5geY/DLljtX4CnWmbalLaqvavq0sMkBO1
         0T0x0BKKvXmlRUTTLvxm3oU3SQa88rt4Rh1hpx6aaKvzSTnhplULbg2diIMtI6uUjf
         VMHLgpAHd7lrs1qyEyhCGL1bv3GbtmDJkROqOIc8g5wNRg+XyA4aSB1EGmiYDgu8GW
         k0RfbVaLSyG4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ldewangan@nvidia.com,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        linux-spi@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 8/8] spi: tegra20: Use of_device_get_match_data()
Date:   Mon, 28 Mar 2022 07:24:39 -0400
Message-Id: <20220328112440.1557113-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112440.1557113-1-sashal@kernel.org>
References: <20220328112440.1557113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

[ Upstream commit c9839acfcbe20ce43d363c2a9d0772472d9921c0 ]

Use of_device_get_match_data() to simplify the code.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Link: https://lore.kernel.org/r/20220315023138.2118293-1-chi.minghao@zte.com.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-slink.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 1548f7b738c1..b520525df246 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1016,14 +1016,8 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	struct resource		*r;
 	int ret, spi_irq;
 	const struct tegra_slink_chip_data *cdata = NULL;
-	const struct of_device_id *match;
 
-	match = of_match_device(tegra_slink_of_match, &pdev->dev);
-	if (!match) {
-		dev_err(&pdev->dev, "Error: No device match found\n");
-		return -ENODEV;
-	}
-	cdata = match->data;
+	cdata = of_device_get_match_data(&pdev->dev);
 
 	master = spi_alloc_master(&pdev->dev, sizeof(*tspi));
 	if (!master) {
-- 
2.34.1

