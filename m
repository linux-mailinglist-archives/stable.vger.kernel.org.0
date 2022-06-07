Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2C6540E62
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353699AbiFGSyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354292AbiFGSqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A274562CD4;
        Tue,  7 Jun 2022 11:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E992617B4;
        Tue,  7 Jun 2022 18:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48676C341C0;
        Tue,  7 Jun 2022 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624836;
        bh=7C4cWSV1faZyhZGcY7GBV07+JeoEX0fJB6r7GfbLyME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHCqnsgoEP9QCUGivisE3C95wDcQGCyUGi1TfgUQXSley1PArQSIw2U7TJpEL6xaF
         l8i9LFdgVHOqeqUHtsgpzeXMJtxZlAWQyQL8WFEdyqYd/TO5LUpXtGaOaTOO+4ayD6
         J+Y5O9mhoHdQT/l3Ly9nPQM167G0937VTJRXUWFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 470/667] mfd: davinci_voicecodec: Fix possible null-ptr-deref davinci_vc_probe()
Date:   Tue,  7 Jun 2022 19:02:15 +0200
Message-Id: <20220607164948.801670142@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 311242c7703df0da14c206260b7e855f69cb0264 ]

It will cause null-ptr-deref when using 'res', if platform_get_resource()
returns NULL, so move using 'res' after devm_ioremap_resource() that
will check it to avoid null-ptr-deref.
And use devm_platform_get_and_ioremap_resource() to simplify code.

Fixes: b5e29aa880be ("mfd: davinci_voicecodec: Remove pointless #include")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20220426030857.3539336-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/davinci_voicecodec.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index e5c8bc998eb4..965820481f1e 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -46,14 +46,12 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 	}
 	clk_enable(davinci_vc->clk);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	fifo_base = (dma_addr_t)res->start;
-	davinci_vc->base = devm_ioremap_resource(&pdev->dev, res);
+	davinci_vc->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(davinci_vc->base)) {
 		ret = PTR_ERR(davinci_vc->base);
 		goto fail;
 	}
+	fifo_base = (dma_addr_t)res->start;
 
 	davinci_vc->regmap = devm_regmap_init_mmio(&pdev->dev,
 						   davinci_vc->base,
-- 
2.35.1



