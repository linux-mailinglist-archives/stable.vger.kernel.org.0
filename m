Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A08206559
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbgFWUBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387544AbgFWUBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:01:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EAED20706;
        Tue, 23 Jun 2020 20:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942465;
        bh=Xmddb0PGgjMb8z3kGUQmrF98teyc8qCD/2QReoPrssc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqnI7KZugjcHW5mPR8aap2aDC9w0DEgtyphGYP3VBga5nNcOGhSoYPL2wWyGtDCw3
         ctHFIjdRQqz/OSC0K1dAZoW00rsgHn6LspemIChtWnGcZOYLaXsD61tW0gsmVVTULA
         +okqF5hdncWSQZBR2LFMQr/lKtM5TQfrkKEZv5NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Georgi Djakov <georgi.djakov@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 010/477] clk: qcom: msm8916: Fix the address location of pll->config_reg
Date:   Tue, 23 Jun 2020 21:50:07 +0200
Message-Id: <20200623195408.081672672@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit f47ab3c2f5338828a67e89d5f688d2cef9605245 ]

During the process of debugging a processor derived from the msm8916 which
we found the new processor was not starting one of its PLLs.

After tracing the addresses and writes that downstream was doing and
comparing to upstream it became obvious that we were writing to a different
register location than downstream when trying to configure the PLL.

This error is also present in upstream msm8916.

As an example clk-pll.c::clk_pll_recalc_rate wants to write to
pll->config_reg updating the bit-field POST_DIV_RATIO. That bit-field is
defined in PLL_USER_CTL not in PLL_CONFIG_CTL. Taking the BIMC PLL as an
example

lm80-p0436-13_c_qc_snapdragon_410_processor_hrd.pdf

0x01823010 GCC_BIMC_PLL_USER_CTL
0x01823014 GCC_BIMC_PLL_CONFIG_CTL

This pattern is repeated for gpll0, gpll1, gpll2 and bimc_pll.

This error is likely not apparent since the bootloader will already have
initialized these PLLs.

This patch corrects the location of config_reg from PLL_CONFIG_CTL to
PLL_USER_CTL for all relevant PLLs on msm8916.

Fixes commit 3966fab8b6ab ("clk: qcom: Add MSM8916 Global Clock Controller support")

Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lkml.kernel.org/r/20200329124116.4185447-1-bryan.odonoghue@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8916.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/gcc-msm8916.c b/drivers/clk/qcom/gcc-msm8916.c
index 4e329a7baf2ba..17e4a5a2a9fde 100644
--- a/drivers/clk/qcom/gcc-msm8916.c
+++ b/drivers/clk/qcom/gcc-msm8916.c
@@ -260,7 +260,7 @@ static struct clk_pll gpll0 = {
 	.l_reg = 0x21004,
 	.m_reg = 0x21008,
 	.n_reg = 0x2100c,
-	.config_reg = 0x21014,
+	.config_reg = 0x21010,
 	.mode_reg = 0x21000,
 	.status_reg = 0x2101c,
 	.status_bit = 17,
@@ -287,7 +287,7 @@ static struct clk_pll gpll1 = {
 	.l_reg = 0x20004,
 	.m_reg = 0x20008,
 	.n_reg = 0x2000c,
-	.config_reg = 0x20014,
+	.config_reg = 0x20010,
 	.mode_reg = 0x20000,
 	.status_reg = 0x2001c,
 	.status_bit = 17,
@@ -314,7 +314,7 @@ static struct clk_pll gpll2 = {
 	.l_reg = 0x4a004,
 	.m_reg = 0x4a008,
 	.n_reg = 0x4a00c,
-	.config_reg = 0x4a014,
+	.config_reg = 0x4a010,
 	.mode_reg = 0x4a000,
 	.status_reg = 0x4a01c,
 	.status_bit = 17,
@@ -341,7 +341,7 @@ static struct clk_pll bimc_pll = {
 	.l_reg = 0x23004,
 	.m_reg = 0x23008,
 	.n_reg = 0x2300c,
-	.config_reg = 0x23014,
+	.config_reg = 0x23010,
 	.mode_reg = 0x23000,
 	.status_reg = 0x2301c,
 	.status_bit = 17,
-- 
2.25.1



