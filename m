Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2400B6A09CB
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbjBWNJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbjBWNJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:09:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72463AB9
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:09:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7268616FE
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84416C433D2;
        Thu, 23 Feb 2023 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157789;
        bh=Znq77NldJrO5mrL9Y1tVbdJWOciLYeWwe9GclaI+pJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HV17t3EK9uiqCZgKBvoKHs3Db6++WseN48JaJDVpE70z+td+/uZ8QlP+rdKlDMfPB
         1sEtvw79pspj1R6279+7BuBWQbQXJUXGB4/mM26WozNeU+LrBxhB4bdlSN9qF2Kmxu
         tj2Tz8Mf27GjIzefg39b/fe1Wdqo1UP8NUTk5TS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/46] clk: mxl: syscon_node_to_regmap() returns error pointers
Date:   Thu, 23 Feb 2023 14:06:17 +0100
Message-Id: <20230223130432.017184720@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
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



