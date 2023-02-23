Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B625F6A0998
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbjBWNIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbjBWNIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:08:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB543A80
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:08:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AED6616E2
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E03CC4339B;
        Thu, 23 Feb 2023 13:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157688;
        bh=Znq77NldJrO5mrL9Y1tVbdJWOciLYeWwe9GclaI+pJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVAcq2hEeWUlBH/Ez6U5lcsMsLpbpugzstxaV9K90w1F6Z//krF1Y1uWK/7RdsbU8
         yeK9QCzg+S8gFmvCF619BLAOcL4Z3APtC0BR2r8rCEvWJ2/DfDrpjJIsH/ygTBan7d
         A8ldZzq/pt87HVMgLwqsgbiR9li9KlBIbCxmwAg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/25] clk: mxl: syscon_node_to_regmap() returns error pointers
Date:   Thu, 23 Feb 2023 14:06:25 +0100
Message-Id: <20230223130427.172374955@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
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



