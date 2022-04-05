Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55384F304C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348873AbiDEKtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343962AbiDEJlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E5ABD7F1;
        Tue,  5 Apr 2022 02:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7EAC61693;
        Tue,  5 Apr 2022 09:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90AAC385A2;
        Tue,  5 Apr 2022 09:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150847;
        bh=ChCoChCJ+bm2s/23Tdv+MYjgZvCiKzNdR0c3alOGOmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+08oAqrWFaBmFJzNiWtp/451PDe5ZcAKLGCSbDVihC/wlTowpiNKn7CfwnLqRYAJ
         sA+vLpu+gJ/IMFALwUINYoBodtHpYANZ8VfiHdpxVYkDg9Pn91/Jo/UCLaCTJ0rZpK
         7kkbamYOHn34kOzs94cwJRep9DVn5XSvGZUklAmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 201/913] spi: tegra114: Add missing IRQ check in tegra_spi_probe
Date:   Tue,  5 Apr 2022 09:21:03 +0200
Message-Id: <20220405070345.884270021@linuxfoundation.org>
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

[ Upstream commit 4f92724d4b92c024e721063f520d66e11ca4b54b ]

This func misses checking for platform_get_irq()'s call and may passes the
negative error codes to request_threaded_irq(), which takes unsigned IRQ #,
causing it to fail with -EINVAL, overriding an original error code.
Stop calling request_threaded_irq() with invalid IRQ #s.

Fixes: f333a331adfa ("spi/tegra114: add spi driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220128165238.25615-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index e9de1d958bbd..8f345247a8c3 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1352,6 +1352,10 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	tspi->phys = r->start;
 
 	spi_irq = platform_get_irq(pdev, 0);
+	if (spi_irq < 0) {
+		ret = spi_irq;
+		goto exit_free_master;
+	}
 	tspi->irq = spi_irq;
 
 	tspi->clk = devm_clk_get(&pdev->dev, "spi");
-- 
2.34.1



