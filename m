Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E492E3A83D
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbfFIQ6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387427AbfFIQ6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:58:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 160D8206C3;
        Sun,  9 Jun 2019 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099496;
        bh=S8bpiVtb9z6UdZz6cxSZ/8tAMh48FXDlCzAw1CCRdVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGF+8Z+DJui0PcfZCR6XEZdZ/kQ42ZOx8aAhvCGxUfAdCvLTEEzi3n61PzB6d43hA
         nNUJDdK5kFAmNcEqyVWA45tzhyiKQCY8Ms3xf+UmtbRuDzdCOJVpyPSuj9vIU1I8P1
         n6RupTi1SaQeYZB9kPSvqh2/dwaenLrQZHly7P+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steev Klimaszewski <steev@kali.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.4 044/241] clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divider
Date:   Sun,  9 Jun 2019 18:39:46 +0200
Message-Id: <20190609164149.046238718@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 40db569d6769ffa3864fd1b89616b1a7323568a8 upstream.

There are wrongly set parenthesis in the code that are resulting in a
wrong configuration being programmed for PLLM. The original fix was made
by Danny Huang in the downstream kernel. The patch was tested on Nyan Big
Tegra124 chromebook, PLLM rate changing works correctly now and system
doesn't lock up after changing the PLLM rate due to EMC scaling.

Cc: <stable@vger.kernel.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-By: Peter De Schrijver <pdeschrijver@nvidia.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/tegra/clk-pll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -492,8 +492,8 @@ static void _update_pll_mnp(struct tegra
 		pll_override_writel(val, params->pmc_divp_reg, pll);
 
 		val = pll_override_readl(params->pmc_divnm_reg, pll);
-		val &= ~(divm_mask(pll) << div_nmp->override_divm_shift) |
-			~(divn_mask(pll) << div_nmp->override_divn_shift);
+		val &= ~((divm_mask(pll) << div_nmp->override_divm_shift) |
+			(divn_mask(pll) << div_nmp->override_divn_shift));
 		val |= (cfg->m << div_nmp->override_divm_shift) |
 			(cfg->n << div_nmp->override_divn_shift);
 		pll_override_writel(val, params->pmc_divnm_reg, pll);


