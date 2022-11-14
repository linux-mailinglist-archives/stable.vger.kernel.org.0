Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D47A62801E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiKNNDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237732AbiKNNDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CF42870E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ADDF6117F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0FCC433D7;
        Mon, 14 Nov 2022 13:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431001;
        bh=nn+U3izxFY6tY1K7v6bDa/UPz2VqRb8yFi+48NZoN1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOYoJpD0px+NkqsJrqjHs1V/elR9FFkRmsCWNrg5fO/Lt0z0I38NzPsO8LGEcn2Pe
         5IV39k8zp7ysg2jduXXnTFPFgI4oUzBXBfN+xydKCEPcwOKu2sDCi2hkKJWP8edH5T
         xN40+U+MFhfPBTSMIgmyd9xkpFLydx7zpzuyhHnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Doug Brown <doug@schmorgal.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 063/190] dmaengine: pxa_dma: use platform_get_irq_optional
Date:   Mon, 14 Nov 2022 13:44:47 +0100
Message-Id: <20221114124501.488684644@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Doug Brown <doug@schmorgal.com>

[ Upstream commit b3d726cb8497c6b12106fd617d46eef11763ea86 ]

The first IRQ is required, but IRQs 1 through (nb_phy_chans - 1) are
optional, because on some platforms (e.g. PXA168) there is a single IRQ
shared between all channels.

This change inhibits a flood of "IRQ index # not found" messages at
startup. Tested on a PXA168-based device.

Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Doug Brown <doug@schmorgal.com>
Link: https://lore.kernel.org/r/20220906000709.52705-1-doug@schmorgal.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pxa_dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pxa_dma.c b/drivers/dma/pxa_dma.c
index e7034f6f3994..22a392fe6d32 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -1247,14 +1247,14 @@ static int pxad_init_phys(struct platform_device *op,
 		return -ENOMEM;
 
 	for (i = 0; i < nb_phy_chans; i++)
-		if (platform_get_irq(op, i) > 0)
+		if (platform_get_irq_optional(op, i) > 0)
 			nr_irq++;
 
 	for (i = 0; i < nb_phy_chans; i++) {
 		phy = &pdev->phys[i];
 		phy->base = pdev->base;
 		phy->idx = i;
-		irq = platform_get_irq(op, i);
+		irq = platform_get_irq_optional(op, i);
 		if ((nr_irq > 1) && (irq > 0))
 			ret = devm_request_irq(&op->dev, irq,
 					       pxad_chan_handler,
-- 
2.35.1



