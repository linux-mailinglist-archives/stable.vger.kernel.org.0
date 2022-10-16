Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E155FFEB1
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 12:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiJPKqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 06:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJPKqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 06:46:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417C913F51
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 03:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3CB2B80C82
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 10:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D29C433C1;
        Sun, 16 Oct 2022 10:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665917164;
        bh=LMkC1Tg88Ywolh4NmOdKx577ymRHr2N/4orqBNiKWME=;
        h=Subject:To:Cc:From:Date:From;
        b=WfITtGiGClTHpm26Z1p4YorYPUnBM/P6fsvGZUw64zOyczZmc13dla5Z6kD9DSGeK
         1YePS2zQDDUdWhlzpcb3KP1djDTcY9MeIk1Mdms0GySzlKt0TUgkUlZyV+5xCyESa1
         y973Y08H2+pt3DsXi2tP24PGPd1CZN0TmKIb75gU=
Subject: FAILED: patch "[PATCH] dmaengine: mxs: use platform_driver_register" failed to apply to 4.9-stable tree
To:     dario.binacchi@amarulasolutions.com, michael@amarulasolutions.com,
        s.hauer@pengutronix.de, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 12:46:37 +0200
Message-ID: <16659171979866@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

26696d465716 ("dmaengine: mxs: use platform_driver_register")
cc2afb0d4c7c ("dmaengine: mxs-dma: Remove the unused .id_table")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 26696d4657167112a1079f86cba1739765c1360e Mon Sep 17 00:00:00 2001
From: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date: Wed, 21 Sep 2022 19:05:56 +0200
Subject: [PATCH] dmaengine: mxs: use platform_driver_register

Driver registration fails on SOC imx8mn as its supplier, the clock
control module, is probed later than subsys initcall level. This driver
uses platform_driver_probe which is not compatible with deferred probing
and won't be probed again later if probe function fails due to clock not
being available at that time.

This patch replaces the use of platform_driver_probe with
platform_driver_register which will allow probing the driver later again
when the clock control module will be available.

The __init annotation has been dropped because it is not compatible with
deferred probing. The code is not executed once and its memory cannot be
freed.

Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: stable@vger.kernel.org

Link: https://lore.kernel.org/r/20220921170556.1055962-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 994fc4d2aca4..dc147cc2436e 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -670,7 +670,7 @@ static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
 	return mxs_chan->status;
 }
 
-static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
+static int mxs_dma_init(struct mxs_dma_engine *mxs_dma)
 {
 	int ret;
 
@@ -741,7 +741,7 @@ static struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
 				     ofdma->of_node);
 }
 
-static int __init mxs_dma_probe(struct platform_device *pdev)
+static int mxs_dma_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	const struct mxs_dma_type *dma_type;
@@ -839,10 +839,7 @@ static struct platform_driver mxs_dma_driver = {
 		.name	= "mxs-dma",
 		.of_match_table = mxs_dma_dt_ids,
 	},
+	.probe = mxs_dma_probe,
 };
 
-static int __init mxs_dma_module_init(void)
-{
-	return platform_driver_probe(&mxs_dma_driver, mxs_dma_probe);
-}
-subsys_initcall(mxs_dma_module_init);
+builtin_platform_driver(mxs_dma_driver);

