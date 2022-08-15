Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503C65941E5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349274AbiHOVnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349702AbiHOVlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:41:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D085C9E8;
        Mon, 15 Aug 2022 12:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD27EB810C6;
        Mon, 15 Aug 2022 19:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18090C43147;
        Mon, 15 Aug 2022 19:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591765;
        bh=7rSatraBdchFZq9eWy7keGz7HdtwWZBRr7vyDaCiar4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sI1m33gwo8o0Mw0YvhKPNMWRUFvOF//N4LxZO6rTi569mlp/fN/L8BW7/3SzUIBCe
         nt7e2X0DV2McyHBFP8TxffApaT3ahkOWbsBVEXh6G/arTX4kZK77l0aeIlZeQQhYYO
         p4c2OMCW6WUBp0X4EhPuTJjaNr4CZSLFDyb1Z6vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>, Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0678/1095] clk: imx: clk-fracn-gppll: fix mfd value
Date:   Mon, 15 Aug 2022 20:01:17 +0200
Message-Id: <20220815180457.419164984@linuxfoundation.org>
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



