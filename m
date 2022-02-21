Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7007C4BDE86
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiBUJPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:15:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348240AbiBUJOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:14:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3936F9FDE;
        Mon, 21 Feb 2022 01:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE2761267;
        Mon, 21 Feb 2022 09:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06E3C340E9;
        Mon, 21 Feb 2022 09:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434398;
        bh=R4TuLef2DSgjZ3rFzWIyayhSS9Db1ZXijWzAtPi6lX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKtfZBygJuBUqMPv8MGD0Hb4oxwd1aHI80wsX18h7u7Oe/ujppT2rpNEJUfEjM20f
         hFYPT/9QAQ6AJ4xqF74+vmeaE/viwGJFMU7RH7Cnxi0aN9Gn+gw+GE306k2lgYV9E0
         fQHE6A+SWTCDKyw4Xybpm9zw3kN+bxS3yjS8OmOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 115/121] dmaengine: stm32-dmamux: Fix PM disable depth imbalance in stm32_dmamux_probe
Date:   Mon, 21 Feb 2022 09:50:07 +0100
Message-Id: <20220221084925.077466840@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Miaoqian Lin <linmq006@gmail.com>

commit e831c7aba950f3ae94002b10321279654525e5ec upstream.

The pm_runtime_enable will increase power disable depth.
If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable().

Fixes: 4f3ceca254e0 ("dmaengine: stm32-dmamux: Add PM Runtime support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20220108085336.11992-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32-dmamux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/stm32-dmamux.c
+++ b/drivers/dma/stm32-dmamux.c
@@ -292,10 +292,12 @@ static int stm32_dmamux_probe(struct pla
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
 


