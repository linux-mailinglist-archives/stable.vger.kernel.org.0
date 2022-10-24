Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B067A60B00F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiJXQAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiJXP7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:59:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A506E46225;
        Mon, 24 Oct 2022 07:54:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A85E2B819D6;
        Mon, 24 Oct 2022 12:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08969C433D6;
        Mon, 24 Oct 2022 12:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615721;
        bh=bt/7eh6FfydEePQtgDsOro6ZK50zNzKZYCGlPt6CeTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3qw8KkpiV2LOxQk1RoVVE4tl1/ytIXbdTrzE9brnXpsg4Ylpv0S5nQxKz0xqPoB9
         OqNpojA7ShhodkKACvwcDhUoiqFiw2UY28MPktrCFtxRlnaVzDZb7FUbxegaWttFpK
         obi3CvlaHV+/63xTo00FWgm4m2sWKVpnVjbBB9Bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 357/530] clk: ti: dra7-atl: Fix reference leak in of_dra7_atl_clk_probe
Date:   Mon, 24 Oct 2022 13:31:41 +0200
Message-Id: <20221024113101.192283753@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8d4c08b034bd..e2e59d78c173 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -251,14 +251,16 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
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
@@ -291,8 +293,9 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
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



