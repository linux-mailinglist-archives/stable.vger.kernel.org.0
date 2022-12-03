Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F7F641653
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 12:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLCLSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 06:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLCLSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 06:18:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C030A252BB
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 03:18:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7241AB811C1
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 11:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B73C433D6;
        Sat,  3 Dec 2022 11:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670066282;
        bh=GhmLfzbPqeW9fFhN8/vMAg9/faTkVGjS1NK2n7gxdQU=;
        h=Subject:To:Cc:From:Date:From;
        b=CU290QdTxAUjdqGb2fF/Q6/8mqdrAY6iooRKSc0mqH4k2IbQK20OIG0t8xE/dLobV
         WU83Ajg5WrCvC7izfvjIl5yVEDnDtQlI7mnSB9unXsfMVcEU/SF8TdzSsKx7Nc7Xjt
         1nuX6CEvG1u1zh7bxNsgiortFcJlVdBorMSPhu2k=
Subject: FAILED: patch "[PATCH] mmc: mtk-sd: Fix missing clk_disable_unprepare in" failed to apply to 5.15-stable tree
To:     cuigaosheng1@huawei.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 12:17:58 +0100
Message-ID: <1670066278116141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c61bfb1cb63d ("mmc: mtk-sd: Fix missing clk_disable_unprepare in msdc_of_clock_parse()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c61bfb1cb63ddab52b31cf5f1924688917e61fad Mon Sep 17 00:00:00 2001
From: Gaosheng Cui <cuigaosheng1@huawei.com>
Date: Fri, 25 Nov 2022 17:01:41 +0800
Subject: [PATCH] mmc: mtk-sd: Fix missing clk_disable_unprepare in
 msdc_of_clock_parse()

The clk_disable_unprepare() should be called in the error handling
of devm_clk_bulk_get_optional, fix it by replacing devm_clk_get_optional
and clk_prepare_enable by devm_clk_get_optional_enabled.

Fixes: f5eccd94b63f ("mmc: mediatek: Add subsys clock control for MT8192 msdc")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221125090141.3626747-1-cuigaosheng1@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index df941438aef5..26bc59b5a7cc 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2588,13 +2588,11 @@ static int msdc_of_clock_parse(struct platform_device *pdev,
 			return PTR_ERR(host->src_clk_cg);
 	}
 
-	host->sys_clk_cg = devm_clk_get_optional(&pdev->dev, "sys_cg");
+	/* If present, always enable for this clock gate */
+	host->sys_clk_cg = devm_clk_get_optional_enabled(&pdev->dev, "sys_cg");
 	if (IS_ERR(host->sys_clk_cg))
 		host->sys_clk_cg = NULL;
 
-	/* If present, always enable for this clock gate */
-	clk_prepare_enable(host->sys_clk_cg);
-
 	host->bulk_clks[0].id = "pclk_cg";
 	host->bulk_clks[1].id = "axi_cg";
 	host->bulk_clks[2].id = "ahb_cg";

