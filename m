Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39118643434
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbiLETnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiLETmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:42:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA157275C5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88984B8118F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5243C433D6;
        Mon,  5 Dec 2022 19:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269215;
        bh=0UE29nwUynVKzO0dAM11rnMEA4+fasz6dd8cQikoU7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBo7R2Tip87DDKxz0MJFocNymA5JF62etCKnUDOuruQmlxhTL96B5uhCMBEceluQE
         +wfrr1rKAPSwBqpwC54jf4cL7itKj3XJKIWnX13d/HAMk473Qmdx7oFcheoVH60Pvr
         svMnt4oONpUjyEUft6Q705XTdnWrfYWaYX/mgG3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sam Protsenko <semen.protsenko@linaro.org>
Subject: [PATCH 5.4 045/153] usb: dwc3: exynos: Fix remove() function
Date:   Mon,  5 Dec 2022 20:09:29 +0100
Message-Id: <20221205190810.011218401@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit e0481e5b3cc12ea7ccf4552d41518c89d3509004 upstream.

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
---
 drivers/usb/dwc3/dwc3-exynos.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

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
@@ -142,7 +133,7 @@ static int dwc3_exynos_remove(struct pla
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 	int i;
 
-	device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
+	of_platform_depopulate(&pdev->dev);
 
 	for (i = exynos->num_clks - 1; i >= 0; i--)
 		clk_disable_unprepare(exynos->clks[i]);


