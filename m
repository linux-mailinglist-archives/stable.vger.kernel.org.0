Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6EC1F2BAE
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgFIASG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729622AbgFHXSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E0082086A;
        Mon,  8 Jun 2020 23:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658322;
        bh=Y/PQsvmcP7ojJNDQ/LzfHMFXOeqcGVLKs741dczTlTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHnuhcwXPMaAVD6F19ef99kkKlo6ZR2PrYSn80TFtIzNiHuFdedahGDtBViPuyO8n
         V6Jh2XebFagKnbye70NlIOUab69VkRGpLd83Qv38BLpihj4152qXQA/DSWWTo+7t0Q
         Zy02KdjPmZ4zhV0HQ1+KhD0NwFnOi/k2SM4NqRNs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>, Jonathan Marek <jonathan@marek.ca>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 322/606] clk: qcom: gcc: Fix parent for gpll0_out_even
Date:   Mon,  8 Jun 2020 19:07:27 -0400
Message-Id: <20200608231211.3363633-322-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit a76f274182f054481182c81cd62bb8794a5450a6 ]

Documentation says that gpll0 is parent of gpll0_out_even, somehow
driver coded that as bi_tcxo, so fix it

Fixes: 2a1d7eb854bb ("clk: qcom: gcc: Add global clock controller driver for SM8150")
Reported-by: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lkml.kernel.org/r/20200521052728.2141377-1-vkoul@kernel.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8150.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8150.c b/drivers/clk/qcom/gcc-sm8150.c
index 20877214acff..e3959ff5cb55 100644
--- a/drivers/clk/qcom/gcc-sm8150.c
+++ b/drivers/clk/qcom/gcc-sm8150.c
@@ -75,8 +75,7 @@ static struct clk_alpha_pll_postdiv gpll0_out_even = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll0_out_even",
 		.parent_data = &(const struct clk_parent_data){
-			.fw_name = "bi_tcxo",
-			.name = "bi_tcxo",
+			.hw = &gpll0.clkr.hw,
 		},
 		.num_parents = 1,
 		.ops = &clk_trion_pll_postdiv_ops,
-- 
2.25.1

