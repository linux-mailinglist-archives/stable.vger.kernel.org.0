Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCFF60B987
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiJXUOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiJXUNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:13:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727EC96214;
        Mon, 24 Oct 2022 11:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51715CE13CB;
        Mon, 24 Oct 2022 12:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E6DC433D6;
        Mon, 24 Oct 2022 12:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614431;
        bh=hc8c3MQUf/iJKjMeBQ8BrGrAjXnopkSr+laGHJAs9m0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrRsqRA2f4kONVl2DAcyrtL6RioxgYHYzjHckchlO0jHD57P5Wkg3U1mj4Qrjg2Fi
         do3O52aOV+5kWMopnYs/Mwpx8aIPAUuWo1mg4pZPrZWOxmRqA85xw0Ww3EwGowV6p5
         H8LeUI//mWEuDPfCh0vhG0IL0SMpU9qiui4Y/mC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Martin Kaiser <martin@kaiser.cx>, Lee Jones <lee@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/390] mfd: fsl-imx25: Fix check for platform_get_irq() errors
Date:   Mon, 24 Oct 2022 13:30:48 +0200
Message-Id: <20221024113033.556644401@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 75db7907355ca5e2ff606e9dd3e86b6c3a455fe2 ]

The mx25_tsadc_remove() function assumes all non-zero returns are success
but the platform_get_irq() function returns negative on error and
positive non-zero values on success.  It never returns zero, but if it
did then treat that as a success.

Fixes: 18f773937968 ("mfd: fsl-imx25: Clean up irq settings during removal")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/YvTfkbVQWYKMKS/t@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/fsl-imx25-tsadc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/fsl-imx25-tsadc.c b/drivers/mfd/fsl-imx25-tsadc.c
index 95103b2cc471..5f1f6f3a0696 100644
--- a/drivers/mfd/fsl-imx25-tsadc.c
+++ b/drivers/mfd/fsl-imx25-tsadc.c
@@ -69,7 +69,7 @@ static int mx25_tsadc_setup_irq(struct platform_device *pdev,
 	int irq;
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
+	if (irq < 0)
 		return irq;
 
 	tsadc->domain = irq_domain_add_simple(np, 2, 0, &mx25_tsadc_domain_ops,
@@ -89,7 +89,7 @@ static int mx25_tsadc_unset_irq(struct platform_device *pdev)
 	struct mx25_tsadc *tsadc = platform_get_drvdata(pdev);
 	int irq = platform_get_irq(pdev, 0);
 
-	if (irq) {
+	if (irq >= 0) {
 		irq_set_chained_handler_and_data(irq, NULL, NULL);
 		irq_domain_remove(tsadc->domain);
 	}
-- 
2.35.1



