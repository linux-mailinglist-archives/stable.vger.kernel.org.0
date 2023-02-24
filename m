Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0AC6A1CBD
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 14:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjBXNJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 08:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjBXNJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 08:09:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA9014225;
        Fri, 24 Feb 2023 05:09:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE538617BD;
        Fri, 24 Feb 2023 13:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250C1C433EF;
        Fri, 24 Feb 2023 13:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677244142;
        bh=DfKPie46ReFTjEqKAjEGsOkois9sxNN565pWyn1gjA0=;
        h=From:To:Cc:Subject:Date:From;
        b=NdhT66enU/WN9qIxplXDOGrIkHaR1cQOlinSCM7P438D9UH1sULVuRNNrAiEUnmdw
         TxOHXnW6shXJo1N/JVlanoHk9qRY/7ZYDfdVl70nXT2S5AmsIXAPP25R0/q/RTaQr5
         LWHmUKJwT0pcBqwmstkQ5x/FaXQZLnGkuNUK+dOB2qNSWYHgBSLHWUmaBkbrRQ2A1R
         iut7SaxW6bhp0epE5wLUgEXw6HUZZ5GeRIMVHw2IBzT6svmhgSBMmlOZZbkMFWhm+J
         G4tfzzAUXzYwdMAtQoXEOgebjD0OtORud0HIoQTzLyO16zGbbE8IKmA0UfcQubyfUw
         cJUFAcFSq1Ypg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pVXp3-0007Hb-Fm; Fri, 24 Feb 2023 14:09:13 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Ludovic Desroches <ludovic.desroches@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] pinctrl: at91-pio4: fix domain name assignment
Date:   Fri, 24 Feb 2023 14:08:28 +0100
Message-Id: <20230224130828.27985-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit d59f6617eef0 ("genirq: Allow fwnode to carry name
information only") an IRQ domain is always given a name during
allocation (e.g. used for the debugfs entry).

Drop the no longer valid name assignment, which would lead to an attempt
to free a string constant when removing the domain on late probe
failures (e.g. probe deferral).

Fixes: d59f6617eef0 ("genirq: Allow fwnode to carry name information only")
Cc: stable@vger.kernel.org	# 4.13
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/pinctrl/pinctrl-at91-pio4.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index 39b233f73e13..d699588677a5 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1206,7 +1206,6 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 		dev_err(dev, "can't add the irq domain\n");
 		return -ENODEV;
 	}
-	atmel_pioctrl->irq_domain->name = "atmel gpio";
 
 	for (i = 0; i < atmel_pioctrl->npins; i++) {
 		int irq = irq_create_mapping(atmel_pioctrl->irq_domain, i);
-- 
2.39.2

