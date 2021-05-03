Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2B7371C32
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhECQvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234252AbhECQt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A766A617ED;
        Mon,  3 May 2021 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060035;
        bh=VYfmhFt2W1DZcgIXrOOh7ooiC4aHcLCuxvOApxAU6hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR8VGTbrb3kicRkkfjoIzzzka9nPAEjjN73rnurnGIDBUKUsZwAslIO8COx6fcdFX
         85+lF+rArJ++boL/HujKBaZUl2RrsF4kUv08kOPOSECDmYi3mhpt1edATsc7qgHae/
         Rw886ZOwnpIP2FWZfVREEDAjSt72yOSDAbjjkdaghhv0YcQyEVueXUJ8iZ2/+DKvl8
         8nnHp1uyT0GoGcvn6l4oxHGkF+2VdaToKIzRKtFgiQR1OydW5X8Jn7F2QNedRYC16a
         uIQLVbk3pJ9ews52NL0/H/z1I8XG3OVPNpnGvn6/4dupPKfKrQqy2bKuq04I6R/BWq
         uFabe2oTJWScQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 35/57] clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return
Date:   Mon,  3 May 2021 12:39:19 -0400
Message-Id: <20210503163941.2853291-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 657d4d1934f75a2d978c3cf2086495eaa542e7a9 ]

There is an error return path that is not kfree'ing socfpga_clk leading
to a memory leak. Fix this by adding in the missing kfree call.

Addresses-Coverity: ("Resource leak")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210406170115.430990-1-colin.king@canonical.com
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-gate-a10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/socfpga/clk-gate-a10.c b/drivers/clk/socfpga/clk-gate-a10.c
index cd5df9103614..d62778884208 100644
--- a/drivers/clk/socfpga/clk-gate-a10.c
+++ b/drivers/clk/socfpga/clk-gate-a10.c
@@ -146,6 +146,7 @@ static void __init __socfpga_gate_init(struct device_node *node,
 		if (IS_ERR(socfpga_clk->sys_mgr_base_addr)) {
 			pr_err("%s: failed to find altr,sys-mgr regmap!\n",
 					__func__);
+			kfree(socfpga_clk);
 			return;
 		}
 	}
-- 
2.30.2

