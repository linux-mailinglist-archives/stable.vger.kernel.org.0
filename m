Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A42595050
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiHPEkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiHPEje (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:39:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9EECD7AC;
        Mon, 15 Aug 2022 13:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49E51B80EB1;
        Mon, 15 Aug 2022 20:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916C0C433C1;
        Mon, 15 Aug 2022 20:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595442;
        bh=SBzQteFzmwAx5cbaMvhguyziPkBKT50j+fZw3n8Q/0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srNAfklqgpV2MD9QPIE1SimZP69dUzCqlKpezliJRHD9zUdTOyjdjStiin49m3fIF
         GDXu/mSgab7TLUKHHx8C4UYcldZSzsM/Z+E0TfoZHP5kNyr6vr9lAmpQkNAosB5jQt
         2llMt8DOZgsLxUrQ6XaYvPvhzQF9BKBaw/OgxWj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0758/1157] clk: qcom: ipq8074: set BRANCH_HALT_DELAY flag for UBI clocks
Date:   Mon, 15 Aug 2022 20:01:54 +0200
Message-Id: <20220815180509.820749968@linuxfoundation.org>
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

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 2bd357e698207e2e65db03007e4be65bf9d6a7b3 ]

Currently, attempting to enable the UBI clocks will cause the stuck at
off warning to be printed and clk_enable will fail.

[   14.936694] gcc_ubi1_ahb_clk status stuck at 'off'

Downstream 5.4 QCA kernel has fixed this by seting the BRANCH_HALT_DELAY
flag on UBI clocks, so lets do the same.

Fixes: 5736294aef83 ("clk: qcom: ipq8074: add NSS clocks")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220515210048.483898-6-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq8074.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq8074.c b/drivers/clk/qcom/gcc-ipq8074.c
index f1017f2e61bd..2c2ecfc5e61f 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -3354,6 +3354,7 @@ static struct clk_branch gcc_nssnoc_ubi1_ahb_clk = {
 
 static struct clk_branch gcc_ubi0_ahb_clk = {
 	.halt_reg = 0x6820c,
+	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
 		.enable_reg = 0x6820c,
 		.enable_mask = BIT(0),
@@ -3371,6 +3372,7 @@ static struct clk_branch gcc_ubi0_ahb_clk = {
 
 static struct clk_branch gcc_ubi0_axi_clk = {
 	.halt_reg = 0x68200,
+	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
 		.enable_reg = 0x68200,
 		.enable_mask = BIT(0),
@@ -3388,6 +3390,7 @@ static struct clk_branch gcc_ubi0_axi_clk = {
 
 static struct clk_branch gcc_ubi0_nc_axi_clk = {
 	.halt_reg = 0x68204,
+	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
 		.enable_reg = 0x68204,
 		.enable_mask = BIT(0),
@@ -3405,6 +3408,7 @@ static struct clk_branch gcc_ubi0_nc_axi_clk = {
 
 static struct clk_branch gcc_ubi0_core_clk = {
 	.halt_reg = 0x68210,
+	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
 		.enable_reg = 0x68210,
 		.enable_mask = BIT(0),
@@ -3422,6 +3426,7 @@ static struct clk_branch gcc_ubi0_core_clk = {
 
 static struct clk_branch gcc_ubi0_mpt_clk = {
 	.halt_reg = 0x68208,
+	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
 		.enable_reg = 0x68208,
 		.enable_mask = BIT(0),
@@ -3439,6 +3444,7 @@ static struct clk_branch gcc_ubi0_mpt_clk = {
 
 static struct clk_branch gcc_ubi1_ahb_clk = {
 	.halt_reg = 0x6822c,
+	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
 		.enable_reg = 0x6822c,
 		.enable_mask = BIT(0),
@@ -3456,6 +3462,7 @@ static struct clk_branch gcc_ubi1_ahb_clk = {
 
 static struct clk_branch gcc_ubi1_axi_clk = {
 	.halt_reg = 0x68220,
+	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
 		.enable_reg = 0x68220,
 		.enable_mask = BIT(0),
@@ -3473,6 +3480,7 @@ static struct clk_branch gcc_ubi1_axi_clk = {
 
 static struct clk_branch gcc_ubi1_nc_axi_clk = {
 	.halt_reg = 0x68224,
+	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
 		.enable_reg = 0x68224,
 		.enable_mask = BIT(0),
@@ -3490,6 +3498,7 @@ static struct clk_branch gcc_ubi1_nc_axi_clk = {
 
 static struct clk_branch gcc_ubi1_core_clk = {
 	.halt_reg = 0x68230,
+	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
 		.enable_reg = 0x68230,
 		.enable_mask = BIT(0),
@@ -3507,6 +3516,7 @@ static struct clk_branch gcc_ubi1_core_clk = {
 
 static struct clk_branch gcc_ubi1_mpt_clk = {
 	.halt_reg = 0x68228,
+	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
 		.enable_reg = 0x68228,
 		.enable_mask = BIT(0),
-- 
2.35.1



