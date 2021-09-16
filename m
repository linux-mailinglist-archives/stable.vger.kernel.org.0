Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEA140E5A4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345384AbhIPRN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350535AbhIPRLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E87561407;
        Thu, 16 Sep 2021 16:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810276;
        bh=mB/oPdwl73KsxVExmbB8un8vw9SIZa/aoXml7Bf30Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdhMzW4cxrvb9Br5IcA5Vsv0RbReYuZqvP+t94iysM/6kNG0q2b8BkgwvUtfxC4t6
         ID05LfeqF46AQL3t1iVqvfN/l7o0o/tSEMxZrkC+lRsFXiZkAghClLXwlnV0LNkN4C
         pJH4j7CifTuEVeV9Mnx8dbBjy3CZh9M+qRvZ5J84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 081/432] clk: rockchip: drop GRF dependency for rk3328/rk3036 pll types
Date:   Thu, 16 Sep 2021 17:57:10 +0200
Message-Id: <20210916155813.534869850@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Geis <pgwipeout@gmail.com>

[ Upstream commit 6fffe52fb336ec2063270a7305652a93ea677ca1 ]

The rk3036/rk3328 pll types were converted to checking the lock status
via the internal register in january 2020, so don't need the grf
reference since then.

But it was forgotten to remove grf check when deciding between the
pll rate ops (read-only vs. read-write), so a clock driver without
the needed grf reference might've been put into the read-only mode
just because the grf reference was missing.

This affected the rk356x that needs to reclock certain plls at boot.

Fix this by removing the check for the grf for selecting the utilized
operations.

Suggested-by: Heiko Stuebner <heiko@sntech.de>
Fixes: 7f6ffbb885d1 ("clk: rockchip: convert rk3036 pll type to use internal lock status")
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
[adjusted the commit message, adjusted the fixes tag]
Link: https://lore.kernel.org/r/20210728180034.717953-3-pgwipeout@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index fe937bcdb487..f7827b3b7fc1 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -940,7 +940,7 @@ struct clk *rockchip_clk_register_pll(struct rockchip_clk_provider *ctx,
 	switch (pll_type) {
 	case pll_rk3036:
 	case pll_rk3328:
-		if (!pll->rate_table || IS_ERR(ctx->grf))
+		if (!pll->rate_table)
 			init.ops = &rockchip_rk3036_pll_clk_norate_ops;
 		else
 			init.ops = &rockchip_rk3036_pll_clk_ops;
-- 
2.30.2



