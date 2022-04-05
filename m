Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909004F375A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352818AbiDELMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348966AbiDEJsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FE2A66C4;
        Tue,  5 Apr 2022 02:38:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EDA46165C;
        Tue,  5 Apr 2022 09:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80610C385A2;
        Tue,  5 Apr 2022 09:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151493;
        bh=7oMBxw5Ep26R/6R297Y09+0/4ozMGQM2xnuGuzQcQu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFsJqQrqWgi6AZNdGNIQlFt/iykla6gkbx8LGHzaQeEdHUAJJSkq/wFEnZQvS23iX
         B8F7dTNQWD73v8VLvnlECKsrD9G99jtrID8LgHSPAGOPZtXcG7dpPTlwZr070dlZEO
         eTTTz813Hy/xAgh0kcxf3rDcRIj4xwHD7NTr1HPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/913] i2c: bcm2835: Use platform_get_irq() to get the interrupt
Date:   Tue,  5 Apr 2022 09:24:57 +0200
Message-Id: <20220405070352.885170055@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit c3b2f911ac11892b672df7829becf28d3a830073 ]

platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
allocation of IRQ resources in DT core code, this causes an issue
when using hierarchical interrupt domains using "interrupts" property
in the node as this bypasses the hierarchical setup and messes up the
irq chaining.

In preparation for removal of static setup of IRQ resource from DT core
code use platform_get_irq().

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-bcm2835.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
index ad3b124a2e37..5149454eef4a 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -407,7 +407,7 @@ static const struct i2c_adapter_quirks bcm2835_i2c_quirks = {
 static int bcm2835_i2c_probe(struct platform_device *pdev)
 {
 	struct bcm2835_i2c_dev *i2c_dev;
-	struct resource *mem, *irq;
+	struct resource *mem;
 	int ret;
 	struct i2c_adapter *adap;
 	struct clk *mclk;
@@ -457,12 +457,9 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!irq) {
-		dev_err(&pdev->dev, "No IRQ resource\n");
-		return -ENODEV;
-	}
-	i2c_dev->irq = irq->start;
+	i2c_dev->irq = platform_get_irq(pdev, 0);
+	if (i2c_dev->irq < 0)
+		return i2c_dev->irq;
 
 	ret = request_irq(i2c_dev->irq, bcm2835_i2c_isr, IRQF_SHARED,
 			  dev_name(&pdev->dev), i2c_dev);
-- 
2.34.1



