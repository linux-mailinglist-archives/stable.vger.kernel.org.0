Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812E01EAB46
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731317AbgFASPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731620AbgFASPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:15:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7DFE2068D;
        Mon,  1 Jun 2020 18:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035348;
        bh=Y/PQsvmcP7ojJNDQ/LzfHMFXOeqcGVLKs741dczTlTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZafApawlVige2nNUZ68cA08ooMXSp7zXtPTRnD07TK8MFuUu9cxWoOZo/fRnYo4lh
         ZiN0w+jp10si1Jwghl2YFh5dvBR2+EafegYORT02YKbcaCh0Dd/qdWjt8IUD7fcUSx
         qIU+Z7eX8O2+jvQSy2RGe4CqNICOiZpjd6iXDNlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 118/177] clk: qcom: gcc: Fix parent for gpll0_out_even
Date:   Mon,  1 Jun 2020 19:54:16 +0200
Message-Id: <20200601174058.442236897@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



