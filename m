Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C02B59E15C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbiHWL1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241690AbiHWLYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:24:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAA97330C;
        Tue, 23 Aug 2022 02:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E910DB81B1F;
        Tue, 23 Aug 2022 09:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAAEC433C1;
        Tue, 23 Aug 2022 09:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246630;
        bh=pUgHQ3k3twW5S4+8bfc2BELCE52yZejB212T7oG7Et4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wy0U4AH5NRsiH1utdphrwRAY2Moey4KRgBpAsjkGtJ458eu+VONw1NJyD20ZpjW4q
         hy9+Aun+XtKrsBEFap2rXySn+iRDVzsNjhkFyl+nDVixmL+moX2oiBhvZ6WhCaA9Of
         vrOyVuKBimBkUn81zc/Z8UPs3laqiNpFA/4gsS0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/389] clk: qcom: ipq8074: set BRANCH_HALT_DELAY flag for UBI clocks
Date:   Tue, 23 Aug 2022 10:24:09 +0200
Message-Id: <20220823080122.764408396@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index 735a1cb59ffa..68fe80a0a92f 100644
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



