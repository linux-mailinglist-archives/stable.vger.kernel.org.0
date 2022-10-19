Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81ABE603E96
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiJSJQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiJSJPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:15:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7856B1C7;
        Wed, 19 Oct 2022 02:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C739C61851;
        Wed, 19 Oct 2022 09:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BDEC433C1;
        Wed, 19 Oct 2022 09:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170338;
        bh=3X88PMqkuFvbCL2Lx1FKmQEB2o2cLmNKVi0b2sFtjAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mLk2CPD40mjPK4qpr8ICu+0FlSn6/tvQtRA1RUHwQmFL8nC9LWmz3+CCOFra1IuT
         XnYKw0tMMGET/s2Q3VkqmeWsg+aj7DyFgdUFNDzRWAlf3lYEgI2FppGzhfKcC5p7zq
         Oh9C6ewKWuyfKioqBK+I/8kw+OBaZQudQn2E/Vd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 600/862] clk: ti: dra7-atl: Fix reference leak in of_dra7_atl_clk_probe
Date:   Wed, 19 Oct 2022 10:31:27 +0200
Message-Id: <20221019083316.457225483@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 9c59a01caba26ec06fefd6ca1f22d5fd1de57d63 ]

pm_runtime_get_sync() will increment pm usage counter.
Forgetting to putting operation will result in reference leak.
Add missing pm_runtime_put_sync in some error paths.

Fixes: 9ac33b0ce81f ("CLK: TI: Driver for DRA7 ATL (Audio Tracking Logic)")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220602030838.52057-1-linmq006@gmail.com
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-dra7-atl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index f0f5bf68b6d2..ff4d6a951681 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -245,14 +245,16 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		if (rc) {
 			pr_err("%s: failed to lookup atl clock %d\n", __func__,
 			       i);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto pm_put;
 		}
 
 		clk = of_clk_get_from_provider(&clkspec);
 		if (IS_ERR(clk)) {
 			pr_err("%s: failed to get atl clock %d from provider\n",
 			       __func__, i);
-			return PTR_ERR(clk);
+			ret = PTR_ERR(clk);
+			goto pm_put;
 		}
 
 		cdesc = to_atl_desc(__clk_get_hw(clk));
@@ -285,8 +287,9 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		if (cdesc->enabled)
 			atl_clk_enable(__clk_get_hw(clk));
 	}
-	pm_runtime_put_sync(cinfo->dev);
 
+pm_put:
+	pm_runtime_put_sync(cinfo->dev);
 	return ret;
 }
 
-- 
2.35.1



