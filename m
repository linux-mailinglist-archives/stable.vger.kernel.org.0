Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB7C4F38B6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377118AbiDEL1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349565AbiDEJuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DC09B;
        Tue,  5 Apr 2022 02:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9257F614FB;
        Tue,  5 Apr 2022 09:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E18C385A2;
        Tue,  5 Apr 2022 09:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152101;
        bh=HQpRMrAehDtWeCK0JY9A9/XHa20QiNq1aSYK6C2zu8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JH1ymJCiDnyR0Jn0V43TCiPWOnYj0G9gIRDQBTmq0c3O8ae3IMY7rvUj0/7O3tzUp
         T2eChDJTM0oN+qS4FSzS+2Z/XUKzsNcbZxF3v8llC9g3DtLLuX1f62Mt3r10YK6Zjt
         uq8FOnQqMDFHNh80wN2a2i6dWaAQZEcYqbxXzilU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Petr Vorel <petr.vorel@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 654/913] clk: qcom: gcc-msm8994: Fix gpll4 width
Date:   Tue,  5 Apr 2022 09:28:36 +0200
Message-Id: <20220405070359.442659167@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 71021db1c532c2545ae53b9ee85b37b7154f51d4 ]

The gpll4 postdiv is actually a div4, so make sure that Linux is aware of
this.

This fixes the following error messages:

 mmc1: Card appears overclocked; req 200000000 Hz, actual 343999999 Hz
 mmc1: Card appears overclocked; req 400000000 Hz, actual 687999999 Hz

Fixes: aec89f78cf01 ("clk: qcom: Add support for msm8994 global clock controller")
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20220319174940.341137-1-konrad.dybcio@somainline.org
Tested-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8994.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-msm8994.c b/drivers/clk/qcom/gcc-msm8994.c
index 144d2ba7a9be..463a444c8a7e 100644
--- a/drivers/clk/qcom/gcc-msm8994.c
+++ b/drivers/clk/qcom/gcc-msm8994.c
@@ -108,6 +108,7 @@ static struct clk_alpha_pll gpll4_early = {
 
 static struct clk_alpha_pll_postdiv gpll4 = {
 	.offset = 0x1dc0,
+	.width = 4,
 	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr.hw.init = &(struct clk_init_data)
 	{
-- 
2.34.1



