Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039BB608709
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbiJVHzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiJVHyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBC7951C8;
        Sat, 22 Oct 2022 00:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4595F60AC3;
        Sat, 22 Oct 2022 07:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FE4C433C1;
        Sat, 22 Oct 2022 07:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424838;
        bh=GCQFGmmWCILSM7TeGWDzdxKnjq1UN8sj7bNfO38tuKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWnO3ImtqsEfxpmCYdqcOcelSKZpB5cc+yWq8uKUVnZXTfjny4j74CCYiZuaWeGLQ
         DovkKbCaiS+yzqhgwoFpK8FYYvYMrGs3l+za0IdWuoULqR3f0EO4xDK56amvyPavyy
         KJOu1wkSs2eWRcVLG3TCKuF9v4TLmADK+HC7+hU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 265/717] spi: cadence-quadspi: Fix PM disable depth imbalance in cqspi_probe
Date:   Sat, 22 Oct 2022 09:22:24 +0200
Message-Id: <20221022072501.398405631@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 4d0ef0a1c35189a6e8377d8ee8310ea5ef22c5f3 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Fixes:73d5fe0462702 ("spi: cadence-quadspi: Remove spi_master_put() in probe failure path")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220924121310.78331-2-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 72b1a5a2298c..106c09ffa425 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1619,7 +1619,7 @@ static int cqspi_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
-		return ret;
+		goto probe_pm_failed;
 
 	ret = clk_prepare_enable(cqspi->clk);
 	if (ret) {
@@ -1712,6 +1712,7 @@ static int cqspi_probe(struct platform_device *pdev)
 	clk_disable_unprepare(cqspi->clk);
 probe_clk_failed:
 	pm_runtime_put_sync(dev);
+probe_pm_failed:
 	pm_runtime_disable(dev);
 	return ret;
 }
-- 
2.35.1



