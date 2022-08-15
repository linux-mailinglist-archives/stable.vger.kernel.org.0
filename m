Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDB5594B0D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiHPAKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245700AbiHPAID (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:08:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E91CCD42;
        Mon, 15 Aug 2022 13:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4228660EE9;
        Mon, 15 Aug 2022 20:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E195C433C1;
        Mon, 15 Aug 2022 20:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595330;
        bh=7rSatraBdchFZq9eWy7keGz7HdtwWZBRr7vyDaCiar4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm2/Gr2rn3Q4NsoSCi/vN0ULvcyw2OyETUA8lP5Hz3+YssMh72a0LIMVjx/2xGFm0
         KFtqcr7t4rWRjgoFHBKC48zWlXcbodGC/3uCGliXr7c7Ld85/ELTWpLuaCOwWXM0wp
         L4LYfjAokU1OMBiDYNpEBBnDlo4EbSe20/4gaooo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>, Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0723/1157] clk: imx: clk-fracn-gppll: fix mfd value
Date:   Mon, 15 Aug 2022 20:01:19 +0200
Message-Id: <20220815180508.399522877@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 044034efbeea05f65c09d2ba15ceeab53b60e947 ]

According to spec:
A value of 0 is disallowed and should not be programmed in this register

Fix to 1.

Fixes: 1b26cb8a77a4 ("clk: imx: support fracn gppll")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20220609132902.3504651-5-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index 71c102d950ab..36a53c60e71f 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -64,10 +64,10 @@ struct clk_fracn_gppll {
  * Fout = Fvco / (rdiv * odiv)
  */
 static const struct imx_fracn_gppll_rate_table fracn_tbl[] = {
-	PLL_FRACN_GP(650000000U, 81, 0, 0, 0, 3),
-	PLL_FRACN_GP(594000000U, 198, 0, 0, 0, 8),
-	PLL_FRACN_GP(560000000U, 70, 0, 0, 0, 3),
-	PLL_FRACN_GP(400000000U, 50, 0, 0, 0, 3),
+	PLL_FRACN_GP(650000000U, 81, 0, 1, 0, 3),
+	PLL_FRACN_GP(594000000U, 198, 0, 1, 0, 8),
+	PLL_FRACN_GP(560000000U, 70, 0, 1, 0, 3),
+	PLL_FRACN_GP(400000000U, 50, 0, 1, 0, 3),
 	PLL_FRACN_GP(393216000U, 81, 92, 100, 0, 5)
 };
 
-- 
2.35.1



