Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49334CFA27
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiCGKNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242728AbiCGKLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3CC1166;
        Mon,  7 Mar 2022 01:55:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B4F660919;
        Mon,  7 Mar 2022 09:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F5DC340E9;
        Mon,  7 Mar 2022 09:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646916;
        bh=BXkF893AK//02PTnqTW+Wt3VCglY/7097F7ZAFnpV7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u24a4DrOzNy97kC81BL8RLc09e00fHLIEsgoTgCLvRjEbPjfk/5tmzQnzEfdxNyKS
         ACa09UySLAmuEnHTlCS1zT8mFd3Oa7m8UXvmTv8dwmgSS2QdLe83qlZLU1jkrpwI1s
         SJ/8CWljfsl4WIepkADsWF87L8xUZIXaxLTkADps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 133/186] soc: imx: gpcv2: Fix clock disabling imbalance in error path
Date:   Mon,  7 Mar 2022 10:19:31 +0100
Message-Id: <20220307091657.797628189@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit fa231bef3b34f1670b240409c11e59a3ce095e6d ]

The imx_pgc_power_down() starts by enabling the domain clocks, and thus
disables them in the error path. Commit 18c98573a4cf ("soc: imx: gpcv2:
add domain option to keep domain clocks enabled") made the clock enable
conditional, but forgot to add the same condition to the error path.
This can result in a clock enable/disable imbalance. Fix it.

Fixes: 18c98573a4cf ("soc: imx: gpcv2: add domain option to keep domain clocks enabled")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpcv2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/imx/gpcv2.c b/drivers/soc/imx/gpcv2.c
index 8176380b02e6..4415f07e1fa9 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -382,7 +382,8 @@ static int imx_pgc_power_down(struct generic_pm_domain *genpd)
 	return 0;
 
 out_clk_disable:
-	clk_bulk_disable_unprepare(domain->num_clks, domain->clks);
+	if (!domain->keep_clocks)
+		clk_bulk_disable_unprepare(domain->num_clks, domain->clks);
 
 	return ret;
 }
-- 
2.34.1



