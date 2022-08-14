Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2335921C3
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241114AbiHNPj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240745AbiHNPh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:37:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C57420F4D;
        Sun, 14 Aug 2022 08:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A83D8B80B4D;
        Sun, 14 Aug 2022 15:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DB3C43141;
        Sun, 14 Aug 2022 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491142;
        bh=3Ju9VbGV6I1/r0QTNy2axkLR0oPolV6Y+H6HWcrkt4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sF5GBF00uzwQUEZmevW1jwuhFc5ooOVFuoJY/9CrFYQWmW0VJ3U0ZRi5+fTwZ6pXb
         SlkJnGcMQ7yC6tkPLUmtcFAJSXT6nkPQYuOoj78q1Rgyb4RvBvt4/sdJB5yFODxiI7
         csB9PJ1MVwvRlZQ9GiYh31sVszWlVreJVYlZoBdcvMPtaDeTsMG+u2JSODkAam7O9e
         S5zbYtYJTVBfHEkI2uBV+35qUAneHMzUR2ZhzbEv2RiwKDxICwFdY9JvDciIaVbgiS
         yM+alo9kYtyb++u6acjRUMKvncJBmQCcSLMWPiZEQ3Nv1ppV5qEZ3zmuM4pHGUo0JV
         I6QULbeThgdeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        orsonzhai@gmail.com, zhang.lyra@gmail.com,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 45/56] dmaengine: sprd: Cleanup in .remove() after pm_runtime_get_sync() failed
Date:   Sun, 14 Aug 2022 11:30:15 -0400
Message-Id: <20220814153026.2377377-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 7f158ef5672d..e5c8b274c76a 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -1233,11 +1233,8 @@ static int sprd_dma_remove(struct platform_device *pdev)
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

