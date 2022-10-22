Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD74C608651
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiJVHro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiJVHrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:47:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C640237EE;
        Sat, 22 Oct 2022 00:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF6C560B00;
        Sat, 22 Oct 2022 07:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E86C433B5;
        Sat, 22 Oct 2022 07:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424264;
        bh=BX8VTQIPLJW77cNwpmkb/Yr53Pz0B1c4Ovk/HIEfias=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdmnLe7oUh3DP8yaCBxrHQBTebUGzTTwhg0/Cfh9imjvchoqdiNTuiYF65x5KrPtp
         RtonvjJtA7A0MqcdXM+4Zs5gN6Ku77A2tXKJRDcfx5mxFMck+vz7Q+1r01DLe/9FQ0
         10vREhwLx1CCCW6jEGElIoRsB92PFcmMJswrNWQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.19 064/717] dmaengine: mxs: use platform_driver_register
Date:   Sat, 22 Oct 2022 09:19:03 +0200
Message-Id: <20221022072426.428089076@linuxfoundation.org>
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

commit 26696d4657167112a1079f86cba1739765c1360e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Link: https://lore.kernel.org/r/20220921170556.1055962-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 drivers/dma/mxs-dma.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -670,7 +670,7 @@ static enum dma_status mxs_dma_tx_status
 	return mxs_chan->status;
 }
 
-static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
+static int mxs_dma_init(struct mxs_dma_engine *mxs_dma)
 {
 	int ret;
 
@@ -741,7 +741,7 @@ static struct dma_chan *mxs_dma_xlate(st
 				     ofdma->of_node);
 }
 
-static int __init mxs_dma_probe(struct platform_device *pdev)
+static int mxs_dma_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	const struct mxs_dma_type *dma_type;
@@ -839,10 +839,7 @@ static struct platform_driver mxs_dma_dr
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


