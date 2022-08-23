Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15E859D749
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347622AbiHWJRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347922AbiHWJPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:15:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F986DADC;
        Tue, 23 Aug 2022 01:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F285B61257;
        Tue, 23 Aug 2022 08:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD87C433C1;
        Tue, 23 Aug 2022 08:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243533;
        bh=CGcBH5rQ3CR51QKmCPkYsyRGCuTCXCRNzB1PPUJkLT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxIlpNJpuP1fxKNsFobfTKfaOKkKRtFQdlFSpmHVeEqnPtdJPPXhJw4ghXlABbKkc
         cTdnDWG8Q/dMha6aL7XakjnJXmGscNBHZr8Rj3N/DpHahFeiXCZAMRBxM2omgrWfqD
         zAB4Fd0ZCni5jtR7oPsNbzQc20hKxSNKKEuQS1go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 307/365] dmaengine: sprd: Cleanup in .remove() after pm_runtime_get_sync() failed
Date:   Tue, 23 Aug 2022 10:03:28 +0200
Message-Id: <20220823080131.028457465@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 1e42f82cbec7b2cc4873751e7791e6611901c5fc ]

It's not allowed to quit remove early without cleaning up completely.
Otherwise this results in resource leaks that probably yield graver
problems later. Here for example some tasklets might survive the lifetime
of the sprd-dma device and access sdev which is freed after .remove()
returns.

As none of the device freeing requires an active device, just ignore the
return value of pm_runtime_get_sync().

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Link: https://lore.kernel.org/r/20220721204054.323602-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 2138b80435ab..474d3ba8ec9f 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -1237,11 +1237,8 @@ static int sprd_dma_remove(struct platform_device *pdev)
 {
 	struct sprd_dma_dev *sdev = platform_get_drvdata(pdev);
 	struct sprd_dma_chn *c, *cn;
-	int ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
-		return ret;
+	pm_runtime_get_sync(&pdev->dev);
 
 	/* explicitly free the irq */
 	if (sdev->irq > 0)
-- 
2.35.1



