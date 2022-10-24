Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E4660AC54
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbiJXOFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbiJXODr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F627F120;
        Mon, 24 Oct 2022 05:48:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA59761336;
        Mon, 24 Oct 2022 12:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06560C433D6;
        Mon, 24 Oct 2022 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615676;
        bh=7rNgIZ8t7ZwPJgpss76pj0gV2+cw0OBlIpaZoHxPsnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MRLlvTacRTcHHx+TGVUcO/7LLO8TyN/fevyvUtDpu5+ru//EBrdfPSXxdRLQuQfO
         AFvVWIsrey9jtPIQPWrc8uzLhVjaAXMzJuBwcgLRBSlRbi9NXCsI0X88an/mlR+tZF
         OB4wiAN6m3fYQwHQFOcI3GwCkfxikCGao1/e3Le4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/530] mfd: fsl-imx25: Fix an error handling path in mx25_tsadc_setup_irq()
Date:   Mon, 24 Oct 2022 13:31:26 +0200
Message-Id: <20221024113100.494840816@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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
index 37e5e02a1d05..85f7982d26d2 100644
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



