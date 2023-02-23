Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07C96A0A13
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbjBWNNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbjBWNM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:12:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA55B5709E
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:12:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D04F561700
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5FDC433EF;
        Thu, 23 Feb 2023 13:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157938;
        bh=Znq77NldJrO5mrL9Y1tVbdJWOciLYeWwe9GclaI+pJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8RUYphFKp0xtzVMqz0m63urHWHCITz8I02EY2ffYnQ3x5Ce9nj1WYPdLaP3gK9tR
         VtcBWzsmOemz1mji54Xiz5ThZwhrTNxS+rYLi+d1yipTYKlbiYP211HCGLbVUklg02
         WHpEg5W2HX4TkITYgZAncVK+68cichfE3YS433kA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/36] clk: mxl: syscon_node_to_regmap() returns error pointers
Date:   Thu, 23 Feb 2023 14:06:45 +0100
Message-Id: <20230223130429.506184427@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Tanwar <rtanwar@maxlinear.com>

[ Upstream commit 7256d1f4618b40792d1e9b9b6cb1406a13cad2dd ]

Commit 036177310bac ("clk: mxl: Switch from direct readl/writel based IO
to regmap based IO") introduced code resulting in below warning issued
by the smatch static checker.

  drivers/clk/x86/clk-lgm.c:441 lgm_cgu_probe() warn: passing zero to 'PTR_ERR'

Fix the warning by replacing incorrect IS_ERR_OR_NULL() with IS_ERR().

Fixes: 036177310bac ("clk: mxl: Switch from direct readl/writel based IO to regmap based IO")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rahul Tanwar <rtanwar@maxlinear.com>
Link: https://lore.kernel.org/r/49e339d4739e4ae4c92b00c1b2918af0755d4122.1666695221.git.rtanwar@maxlinear.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-lgm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/x86/clk-lgm.c b/drivers/clk/x86/clk-lgm.c
index 4de77b2c750d3..f69455dd1c980 100644
--- a/drivers/clk/x86/clk-lgm.c
+++ b/drivers/clk/x86/clk-lgm.c
@@ -436,7 +436,7 @@ static int lgm_cgu_probe(struct platform_device *pdev)
 	ctx->clk_data.num = CLK_NR_CLKS;
 
 	ctx->membase = syscon_node_to_regmap(np);
-	if (IS_ERR_OR_NULL(ctx->membase)) {
+	if (IS_ERR(ctx->membase)) {
 		dev_err(dev, "Failed to get clk CGU iomem\n");
 		return PTR_ERR(ctx->membase);
 	}
-- 
2.39.0



