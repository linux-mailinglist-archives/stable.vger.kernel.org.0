Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649AD658328
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbiL1Qod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiL1QoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981B21C135
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:39:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A4D61577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43877C433F0;
        Wed, 28 Dec 2022 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245553;
        bh=cjIJxS9k4HTen9XfVR+HlMZWIPloiFETeSCexC526SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rM5cRZMIfa68OS+7AozAxOtx1IhHHDbU9koqQtFEmpvSzIsPoMjxGp3qXlIEgPj81
         M9HpyJyuQTMy6QPEmfccoov3JkZDWWg7svjlwFN4QGgcRgeITak5OtobKSrBs/bDi/
         M03gDb0Bkrxy++JkBtbBCMjm2x1vKrqbfd388i90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0880/1146] mfd: qcom_rpm: Fix an error handling path in qcom_rpm_probe()
Date:   Wed, 28 Dec 2022 15:40:19 +0100
Message-Id: <20221228144354.065503612@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 36579aca877a62f67ecd77eb3edefc4c86292406 ]

If an error occurs after the clk_prepare_enable() call, a corresponding
clk_disable_unprepare() should be called.

Simplify code and switch to devm_clk_get_enabled() to fix it.

Fixes: 3526403353c2 ("mfd: qcom_rpm: Handle message RAM clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/e39752476d02605b2be46cab7115f71255ce13a8.1668949256.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/qcom_rpm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mfd/qcom_rpm.c b/drivers/mfd/qcom_rpm.c
index 71bc34b74bc9..ea5eb94427c4 100644
--- a/drivers/mfd/qcom_rpm.c
+++ b/drivers/mfd/qcom_rpm.c
@@ -547,7 +547,7 @@ static int qcom_rpm_probe(struct platform_device *pdev)
 	init_completion(&rpm->ack);
 
 	/* Enable message RAM clock */
-	rpm->ramclk = devm_clk_get(&pdev->dev, "ram");
+	rpm->ramclk = devm_clk_get_enabled(&pdev->dev, "ram");
 	if (IS_ERR(rpm->ramclk)) {
 		ret = PTR_ERR(rpm->ramclk);
 		if (ret == -EPROBE_DEFER)
@@ -558,7 +558,6 @@ static int qcom_rpm_probe(struct platform_device *pdev)
 		 */
 		rpm->ramclk = NULL;
 	}
-	clk_prepare_enable(rpm->ramclk); /* Accepts NULL */
 
 	irq_ack = platform_get_irq_byname(pdev, "ack");
 	if (irq_ack < 0)
@@ -681,7 +680,6 @@ static int qcom_rpm_remove(struct platform_device *pdev)
 	struct qcom_rpm *rpm = dev_get_drvdata(&pdev->dev);
 
 	of_platform_depopulate(&pdev->dev);
-	clk_disable_unprepare(rpm->ramclk);
 
 	return 0;
 }
-- 
2.35.1



