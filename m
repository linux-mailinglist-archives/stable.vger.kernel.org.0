Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8218660410E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiJSKgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiJSKge (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:36:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E123BAE876;
        Wed, 19 Oct 2022 03:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B4E2B823B3;
        Wed, 19 Oct 2022 08:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA1BC433D6;
        Wed, 19 Oct 2022 08:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169538;
        bh=ts0uQ0ZHszs3Hfyb7b4wNuPKsVvQ1XetjCglba3KlkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKYl3loowQwA1nGQvvLASzZIhaBa/HfA5+fYyrDopOf1o6RxAb+lXixzzztlKA3VE
         ZRzMFvwYovkDxaCaPUz4t7lCM1NaBSCkv5UGU8yxucsyivHDbEkZXFaYQh6frIGrIl
         ELPdvpt0d1sRH7YPgI+K2ZIgPnmojYA8a3tayQyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 315/862] spi: dw: Fix PM disable depth imbalance in dw_spi_bt1_probe
Date:   Wed, 19 Oct 2022 10:26:42 +0200
Message-Id: <20221019083303.943891998@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 618d815fc93477b1675878f3c04ff32657cc18b4 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Fixes:abf00907538e2 ("spi: dw: Add Baikal-T1 SPI Controller glue driver")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220924121310.78331-3-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-bt1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-bt1.c b/drivers/spi/spi-dw-bt1.c
index c06553416123..3fb89dee595e 100644
--- a/drivers/spi/spi-dw-bt1.c
+++ b/drivers/spi/spi-dw-bt1.c
@@ -293,8 +293,10 @@ static int dw_spi_bt1_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	ret = dw_spi_add_host(&pdev->dev, dws);
-	if (ret)
+	if (ret) {
+		pm_runtime_disable(&pdev->dev);
 		goto err_disable_clk;
+	}
 
 	platform_set_drvdata(pdev, dwsbt1);
 
-- 
2.35.1



