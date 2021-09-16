Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2AA40E268
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242989AbhIPQhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:37:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236689AbhIPQfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 119A8619E7;
        Thu, 16 Sep 2021 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809290;
        bh=mB/oPdwl73KsxVExmbB8un8vw9SIZa/aoXml7Bf30Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWDJt1eM97VWvjPLKn1qxMwBk8qo1L59gXIpPEk9hMRJIla+VVTKufwkICrWLwjo0
         b2oVz6QuDsbT9MK0UorlyHfp0Ldr88yHwW4qfToJ+CAuUm/k6KnpFgqpfAcjXf6T6y
         8lQ2SwRcfDn1R03MgzKAxz1iI6U8mIUdtWht5Gr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 073/380] clk: rockchip: drop GRF dependency for rk3328/rk3036 pll types
Date:   Thu, 16 Sep 2021 17:57:10 +0200
Message-Id: <20210916155806.493863145@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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



