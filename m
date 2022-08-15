Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78E75942FD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244072AbiHOWTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348418AbiHOWQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:16:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BC71ED;
        Mon, 15 Aug 2022 12:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDDA0611E0;
        Mon, 15 Aug 2022 19:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAA8C433D6;
        Mon, 15 Aug 2022 19:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592400;
        bh=dnDxbrsHDl7j52sf7NppzBaeDhtDkuLyAP/XkSnlv1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iy7sLEYO9G7c104lMD//cT7+5CdOGH09/slfDqjMLJFokLyIobadWZp9flxPiGk6k
         3GynYQWqZVxms8KJ8tdxMkSzySIbBvfQBzgDA6jcK9xWlG8ZXpLoF2d60whEnaVnTI
         KT5w4sv0AimVZhfZt6f2V/V22/O7LXjQQFK9qQHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Fabio Estevam <festevam@denx.de>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0781/1095] dmaengine: imx-dma: Cast of_device_get_match_data() with (uintptr_t)
Date:   Mon, 15 Aug 2022 20:03:00 +0200
Message-Id: <20220815180501.569404789@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit c3266ee185b59e5aab3e0f982e5b7f95d31555a7 ]

Change the of_device_get_match_data() cast to (uintptr_t)
to silence the following clang warning:

drivers/dma/imx-dma.c:1048:20: warning: cast to smaller integer type 'enum imx_dma_type' from 'const void *' [-Wvoid-pointer-to-enum-cast]

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 0ab785c894e6 ("dmaengine: imx-dma: Remove unused .id_table")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Link: https://lore.kernel.org/r/20220706111327.940764-1-festevam@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/imx-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 2ddc31e64db0..da31e73d24d4 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -1047,7 +1047,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	imxdma->dev = &pdev->dev;
-	imxdma->devtype = (enum imx_dma_type)of_device_get_match_data(&pdev->dev);
+	imxdma->devtype = (uintptr_t)of_device_get_match_data(&pdev->dev);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	imxdma->base = devm_ioremap_resource(&pdev->dev, res);
-- 
2.35.1



