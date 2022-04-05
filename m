Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFB64F25F5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbiDEHxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiDEHwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:52:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ABD4DF61;
        Tue,  5 Apr 2022 00:48:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAE496172E;
        Tue,  5 Apr 2022 07:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE39C3410F;
        Tue,  5 Apr 2022 07:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144910;
        bh=1O3wARIgcJzEDaVnXAaUzeHiR7bXkP4f6h6UmUuJKfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U///q+SgieAdX3VrxAqlbmg4scI9NHfonze72O5g4BdyOYF/9CVhp/c61gfVBNdme
         knz09iiEser7AREm/WTBUYRDXkYB1q3e9Pj8o8XOkwifNe9MXVLGCeeOzwO3iyTkq7
         sn++YnuaVj2EHHcn19144ayhq1h3ur/1rNe1I7aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0214/1126] spi: tegra210-quad: Fix missin IRQ check in tegra_qspi_probe
Date:   Tue,  5 Apr 2022 09:16:01 +0200
Message-Id: <20220405070413.890879807@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 47c3e06ed95aa9b74932dbc6b23b544f644faf84 ]

This func misses checking for platform_get_irq()'s call and may passes the
negative error codes to request_threaded_irq(), which takes unsigned IRQ #,
causing it to fail with -EINVAL, overriding an original error code.
Stop calling request_threaded_irq() with invalid IRQ #s.

Fixes: 921fc1838fb0 ("spi: tegra210-quad: Add support for Tegra210 QSPI controller")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220128165956.27821-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index ce1bdb4767ea..cb00ac2fc7d8 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1240,6 +1240,8 @@ static int tegra_qspi_probe(struct platform_device *pdev)
 
 	tqspi->phys = r->start;
 	qspi_irq = platform_get_irq(pdev, 0);
+	if (qspi_irq < 0)
+		return qspi_irq;
 	tqspi->irq = qspi_irq;
 
 	tqspi->clk = devm_clk_get(&pdev->dev, "qspi");
-- 
2.34.1



