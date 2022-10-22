Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD8860881C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiJVIKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiJVIJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:09:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A572D447E;
        Sat, 22 Oct 2022 00:53:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B67060B81;
        Sat, 22 Oct 2022 07:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4194C433C1;
        Sat, 22 Oct 2022 07:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425189;
        bh=0einq7fTqgMqNK76jwkzXls/v3g3vDEhp3UU2sIhUVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxjFhwCKN8NaJ9wXDeNsX2JztWkxxD8NyWib3qiGSE+qjmDbcJwAZld5MD9pOTdlj
         M0L1eUmJTPVPDTxE4jo6yjZecUe6QM421WFtw6ipN/Wjuj9alRsWuMwgkbMCOSBnvj
         KuhcqrYw4slasZlVnYXd84oeE6EtA0ZGif1At6A0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Alexey Minnekhanov <alexeymin@postmarketos.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 393/717] clk: qcom: gcc-sdm660: Use floor ops for SDCC1 clock
Date:   Sat, 22 Oct 2022 09:24:32 +0200
Message-Id: <20221022072515.071366224@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 6956c18f4ad9200aa945f7ea37d65a05afc49d51 ]

In commit 3f905469c8ce ("clk: qcom: gcc: Use floor ops for SDCC clocks")
floor ops were applied to SDCC2 only, but flooring is also required on
the SDCC1 apps clock which is used by the eMMC card on Sony's Nile
platform, and otherwise result in the typicial "Card appears
overclocked" warnings observed on many other platforms before:

    mmc0: Card appears overclocked; req 52000000 Hz, actual 100000000 Hz
    mmc0: Card appears overclocked; req 52000000 Hz, actual 100000000 Hz
    mmc0: Card appears overclocked; req 104000000 Hz, actual 192000000 Hz

Fixes: f2a76a2955c0 ("clk: qcom: Add Global Clock controller (GCC) driver for SDM660")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Tested-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220714203822.186448-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sdm660.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-sdm660.c b/drivers/clk/qcom/gcc-sdm660.c
index 9b97425008ce..db918c92a522 100644
--- a/drivers/clk/qcom/gcc-sdm660.c
+++ b/drivers/clk/qcom/gcc-sdm660.c
@@ -757,7 +757,7 @@ static struct clk_rcg2 sdcc1_apps_clk_src = {
 		.name = "sdcc1_apps_clk_src",
 		.parent_data = gcc_parent_data_xo_gpll0_gpll4_gpll0_early_div,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_xo_gpll0_gpll4_gpll0_early_div),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
-- 
2.35.1



