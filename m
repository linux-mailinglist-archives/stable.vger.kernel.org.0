Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CF64F2C3C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242023AbiDEIg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239622AbiDEIUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E388B129;
        Tue,  5 Apr 2022 01:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99065B81B92;
        Tue,  5 Apr 2022 08:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C08C385A0;
        Tue,  5 Apr 2022 08:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146651;
        bh=ICPnzx6vA/X57pONJWjP2kR6lefOSYh2BJuEirZaUv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNGhXMWgKX8Ps2IyoVs7x3FB7tY7BY16oZRE+VTdFMTwuJ6G/dO4uLlwC4oJ3P0bX
         pHWtuJwPi92e0YczmzljraSRC8NVqdQ0Q1yrBG+5RfeWPmXpH8OxVF601S4dOgWyR4
         KbpUjOAcNO7KCkPZRg7VSzfy1ymTRXPvjrxbYtLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Petr Vorel <petr.vorel@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0800/1126] clk: qcom: gcc-msm8994: Fix gpll4 width
Date:   Tue,  5 Apr 2022 09:25:47 +0200
Message-Id: <20220405070431.052818778@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index f09499999eb3..6b702cdacbf2 100644
--- a/drivers/clk/qcom/gcc-msm8994.c
+++ b/drivers/clk/qcom/gcc-msm8994.c
@@ -77,6 +77,7 @@ static struct clk_alpha_pll gpll4_early = {
 
 static struct clk_alpha_pll_postdiv gpll4 = {
 	.offset = 0x1dc0,
+	.width = 4,
 	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll4",
-- 
2.34.1



