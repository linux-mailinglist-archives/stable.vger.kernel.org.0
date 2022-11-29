Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFB363C5E9
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 18:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiK2RAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 12:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbiK2Q7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 11:59:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A02C6DCD0
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 08:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D74AB816E6
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 16:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEC9C433D6;
        Tue, 29 Nov 2022 16:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669740924;
        bh=yo559cyVZpXgHkTkb6S+uHfG6laBMQJFpP4/LFpBCXo=;
        h=Subject:To:Cc:From:Date:From;
        b=M8lpq5BEUyFGW8RKyFFv+Q+Eatj8LDJGGTbp1lD7IeZvaVP/8KmYAM9BiFqaF7Gf5
         hnl2J6z5EO7G+yy4q1ky7qAT+6MmpjkxJKwUIYK81grSk3eB29o4SsfQLowo1gQ4ub
         gH3wnFkaCt1VQBzMD4k2xMv6m3y/xi8GM3ZSl31c=
Subject: FAILED: patch "[PATCH] usb: dwc3: exynos: Fix remove() function" failed to apply to 4.9-stable tree
To:     m.szyprowski@samsung.com, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, semen.protsenko@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 29 Nov 2022 17:55:10 +0100
Message-ID: <166974091058126@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

e0481e5b3cc1 ("usb: dwc3: exynos: Fix remove() function")
1e041b6f313a ("usb: dwc3: exynos: Remove dead code")
3a932b0f50f4 ("usb: dwc3: exynos: change goto labels to meaningful names")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e0481e5b3cc12ea7ccf4552d41518c89d3509004 Mon Sep 17 00:00:00 2001
From: Marek Szyprowski <m.szyprowski@samsung.com>
Date: Thu, 10 Nov 2022 16:41:31 +0100
Subject: [PATCH] usb: dwc3: exynos: Fix remove() function

The core DWC3 device node was not properly removed by the custom
dwc3_exynos_remove_child() function. Replace it with generic
of_platform_depopulate() which does that job right.

Fixes: adcf20dcd262 ("usb: dwc3: exynos: Use of_platform API to create dwc3 core pdev")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Link: https://lore.kernel.org/r/20221110154131.2577-1-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 0ecf20eeceee..4be6a873bd07 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -37,15 +37,6 @@ struct dwc3_exynos {
 	struct regulator	*vdd10;
 };
 
-static int dwc3_exynos_remove_child(struct device *dev, void *unused)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static int dwc3_exynos_probe(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos;
@@ -142,7 +133,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 	int i;
 
-	device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
+	of_platform_depopulate(&pdev->dev);
 
 	for (i = exynos->num_clks - 1; i >= 0; i--)
 		clk_disable_unprepare(exynos->clks[i]);

