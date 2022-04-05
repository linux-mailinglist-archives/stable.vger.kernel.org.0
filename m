Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2974F2A7D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348864AbiDEKt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343994AbiDEJl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CFEBD7F8;
        Tue,  5 Apr 2022 02:27:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B7D6144D;
        Tue,  5 Apr 2022 09:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A1FC385A2;
        Tue,  5 Apr 2022 09:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150850;
        bh=t7zuJu+RdC6rv7No6foqPNPTASGSj0hg90vUn6Vk3p8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWE/Hu97h/mLiW71/kD8FJxs4MLGYnt89BjBKDfYnnPDGIQd4Y5B2ksldwsrDHM5K
         ahGp3DMhen+yyoaQ+mQ7i8aln+lelrC+TvJSnLJ39eoi5MbdFPj3QZ1ip1Zjm0sIo6
         kcT6ryja715NNkXBxkt9YbbqHqnDEbfTa7dqJSC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 202/913] spi: tegra210-quad: Fix missin IRQ check in tegra_qspi_probe
Date:   Tue,  5 Apr 2022 09:21:04 +0200
Message-Id: <20220405070345.913802108@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 2354ca1e3858..7967073c1354 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1249,6 +1249,8 @@ static int tegra_qspi_probe(struct platform_device *pdev)
 
 	tqspi->phys = r->start;
 	qspi_irq = platform_get_irq(pdev, 0);
+	if (qspi_irq < 0)
+		return qspi_irq;
 	tqspi->irq = qspi_irq;
 
 	tqspi->clk = devm_clk_get(&pdev->dev, "qspi");
-- 
2.34.1



