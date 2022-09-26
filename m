Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128905EA2AB
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiIZLMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237507AbiIZLLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:11:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D6D6050B;
        Mon, 26 Sep 2022 03:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E86760C8E;
        Mon, 26 Sep 2022 10:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C977C433C1;
        Mon, 26 Sep 2022 10:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188531;
        bh=fVJx9bWZtuSE8qwIeRCZ+tV0nvTbXT/NX1tHwng38a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WL5sVgmTNIwglDM/efXbtYCekbbYhe1S0IIofFFOvW3XoCqNuBV5NqJrLGfOpgivV
         diICEHtbXnLw/j5QT/3kkzKJurRyB49xuCLkMcnlW6OXhRudybN0z/Eo3P6Wuegk0i
         VxkKfvTChSwVOiuChYBxFM37oz+tAqYY1t3A3fXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Sven Peter <sven@svenpeter.dev>,
        William Wu <william.wu@rock-chips.com>
Subject: [PATCH 5.15 038/148] usb: dwc3: core: leave default DMA if the controller does not support 64-bit DMA
Date:   Mon, 26 Sep 2022 12:11:12 +0200
Message-Id: <20220926100757.451004057@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Wu <william.wu@rock-chips.com>

commit 91062e663b261815573ce00967b1895a99e668df upstream.

On some DWC3 controllers (e.g. Rockchip SoCs), the DWC3 core
doesn't support 64-bit DMA address width. In this case, this
driver should use the default 32-bit mask. Otherwise, the DWC3
controller will break if it runs on above 4GB physical memory
environment.

This patch reads the DWC_USB3_AWIDTH bits of GHWPARAMS0 which
used for the DMA address width, and only configure 64-bit DMA
mask if the DWC_USB3_AWIDTH is 64.

Fixes: 45d39448b4d0 ("usb: dwc3: support 64 bit DMA in platform driver")
Cc: stable <stable@kernel.org>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: William Wu <william.wu@rock-chips.com>
Link: https://lore.kernel.org/r/20220901083446.3799754-1-william.wu@rock-chips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1570,12 +1570,6 @@ static int dwc3_probe(struct platform_de
 
 	dwc3_get_properties(dwc);
 
-	if (!dwc->sysdev_is_parent) {
-		ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
-		if (ret)
-			return ret;
-	}
-
 	dwc->reset = devm_reset_control_array_get_optional_shared(dev);
 	if (IS_ERR(dwc->reset))
 		return PTR_ERR(dwc->reset);
@@ -1612,6 +1606,13 @@ static int dwc3_probe(struct platform_de
 	platform_set_drvdata(pdev, dwc);
 	dwc3_cache_hwparams(dwc);
 
+	if (!dwc->sysdev_is_parent &&
+	    DWC3_GHWPARAMS0_AWIDTH(dwc->hwparams.hwparams0) == 64) {
+		ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
+		if (ret)
+			goto disable_clks;
+	}
+
 	spin_lock_init(&dwc->lock);
 	mutex_init(&dwc->mutex);
 


