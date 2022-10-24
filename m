Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE14160B03A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiJXQD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiJXQCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:02:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93138176BA9;
        Mon, 24 Oct 2022 07:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41E36B81188;
        Mon, 24 Oct 2022 12:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B513C433D6;
        Mon, 24 Oct 2022 12:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614408;
        bh=72IdrIRDfHiRyzadDUK1d/TKQj32QPvspPY4OjhOf2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y26FXCt6FMfQjgA9Sg+ZhIphX+7li+fn9ty1Kg3OaGl2+p0ZUIOqK/03aMBuhYuKn
         fgbL33MVFsYRwCPyOmtui+hzwkfJ/hWdOS104/w9nFpyjh6WH/0VhmJfw2rRD3A7hY
         kDEIVFE865zCDwjQn4G1IMWourlXKAuCKbIP6AUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/390] mfd: fsl-imx25: Fix an error handling path in mx25_tsadc_setup_irq()
Date:   Mon, 24 Oct 2022 13:30:45 +0200
Message-Id: <20221024113033.415359656@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3fa9e4cfb55da512ebfd57336fde468830719298 ]

If devm_of_platform_populate() fails, some resources need to be
released.

Introduce a mx25_tsadc_unset_irq() function that undoes
mx25_tsadc_setup_irq() and call it both from the new error handling path
of the probe and in the remove function.

Fixes: a55196eff6d6 ("mfd: fsl-imx25: Use devm_of_platform_populate()")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/d404e04828fc06bcfddf81f9f3e9b4babbe35415.1659269156.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/fsl-imx25-tsadc.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/fsl-imx25-tsadc.c b/drivers/mfd/fsl-imx25-tsadc.c
index a016b39fe9b0..95103b2cc471 100644
--- a/drivers/mfd/fsl-imx25-tsadc.c
+++ b/drivers/mfd/fsl-imx25-tsadc.c
@@ -84,6 +84,19 @@ static int mx25_tsadc_setup_irq(struct platform_device *pdev,
 	return 0;
 }
 
+static int mx25_tsadc_unset_irq(struct platform_device *pdev)
+{
+	struct mx25_tsadc *tsadc = platform_get_drvdata(pdev);
+	int irq = platform_get_irq(pdev, 0);
+
+	if (irq) {
+		irq_set_chained_handler_and_data(irq, NULL, NULL);
+		irq_domain_remove(tsadc->domain);
+	}
+
+	return 0;
+}
+
 static void mx25_tsadc_setup_clk(struct platform_device *pdev,
 				 struct mx25_tsadc *tsadc)
 {
@@ -171,18 +184,21 @@ static int mx25_tsadc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, tsadc);
 
-	return devm_of_platform_populate(dev);
+	ret = devm_of_platform_populate(dev);
+	if (ret)
+		goto err_irq;
+
+	return 0;
+
+err_irq:
+	mx25_tsadc_unset_irq(pdev);
+
+	return ret;
 }
 
 static int mx25_tsadc_remove(struct platform_device *pdev)
 {
-	struct mx25_tsadc *tsadc = platform_get_drvdata(pdev);
-	int irq = platform_get_irq(pdev, 0);
-
-	if (irq) {
-		irq_set_chained_handler_and_data(irq, NULL, NULL);
-		irq_domain_remove(tsadc->domain);
-	}
+	mx25_tsadc_unset_irq(pdev);
 
 	return 0;
 }
-- 
2.35.1



