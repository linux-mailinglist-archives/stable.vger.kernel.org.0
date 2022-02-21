Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA404BD733
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 08:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345834AbiBUHKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 02:10:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345851AbiBUHKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 02:10:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43692E05
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 23:09:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2E90CE0E39
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 07:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A0CC340E9;
        Mon, 21 Feb 2022 07:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645427385;
        bh=RYwQsGv8hGBjagv80Af7CZQOibKtSWJJxI07TqAvQFk=;
        h=Subject:To:Cc:From:Date:From;
        b=I0CtgYkxL/tXfWJuYICTQ9YB8qzSRbC3Dc9qjIawEnUxQQkvyG0sr6TXLiq9SwZCT
         n5PCElyO8EVyxLRnBZk+paHrt3dMyflLfAb2Mvl/1kuSMLTLhfaorNy8ioqRV17iHC
         1uwnuykD5U7pXxxAyKXHC9H5ElXvvHSwOhhg5ouU=
Subject: FAILED: patch "[PATCH] dmaengine: stm32-dmamux: Fix PM disable depth imbalance in" failed to apply to 5.4-stable tree
To:     linmq006@gmail.com, amelie.delaunay@foss.st.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 08:09:31 +0100
Message-ID: <164542737119579@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e831c7aba950f3ae94002b10321279654525e5ec Mon Sep 17 00:00:00 2001
From: Miaoqian Lin <linmq006@gmail.com>
Date: Sat, 8 Jan 2022 08:53:36 +0000
Subject: [PATCH] dmaengine: stm32-dmamux: Fix PM disable depth imbalance in
 stm32_dmamux_probe

The pm_runtime_enable will increase power disable depth.
If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable().

Fixes: 4f3ceca254e0 ("dmaengine: stm32-dmamux: Add PM Runtime support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20220108085336.11992-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/stm32-dmamux.c b/drivers/dma/stm32-dmamux.c
index a42164389ebc..d5d55732adba 100644
--- a/drivers/dma/stm32-dmamux.c
+++ b/drivers/dma/stm32-dmamux.c
@@ -292,10 +292,12 @@ static int stm32_dmamux_probe(struct platform_device *pdev)
 	ret = of_dma_router_register(node, stm32_dmamux_route_allocate,
 				     &stm32_dmamux->dmarouter);
 	if (ret)
-		goto err_clk;
+		goto pm_disable;
 
 	return 0;
 
+pm_disable:
+	pm_runtime_disable(&pdev->dev);
 err_clk:
 	clk_disable_unprepare(stm32_dmamux->clk);
 

