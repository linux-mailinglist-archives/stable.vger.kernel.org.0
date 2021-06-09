Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B123A1D9A
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 21:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhFITUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 15:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhFITUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 15:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15C71613EE;
        Wed,  9 Jun 2021 19:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623266309;
        bh=H8gFgTRMSSNC7m2DDNBoJbrvV8evmOG7YKhFFReDtns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpgC0q8sHSquP8IN1dArySCw/goOxPacM7qiTrIurt+eDX5K8EKpZhEr87WQFhqdn
         NQskr8GN2/VllizXWNa9eIST92yUCOOkzwlNTsZcl1OTAjzx5AsnWBZF1NXO4wlgyP
         kv5xEs2n6NdHxwE/23Zv+mOM9+fdEJeYHZmbddEsWE6pXKhg265gC4FbL2PuEhUXWk
         dQbHElNF/R4/TguAnxlLvyHP2hIKhEDTCpOY46sKLPZeZDMuSvbaQujfIcyAmrx81T
         MOK3ovt72fq/B+Qw0fG5WxV4PWdjYKNJn8YMor9v4LqZvFYSyX+Jjlz1qpfEzQ0WHR
         xso8btK91RYiw==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-clk@vger.kernel.org
Cc:     dinguyen@kernel.org, sboyd@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org
Subject: [PATCHv2 4/4] clk: agilex/stratix10/n5x: fix how the bypass_reg is handled
Date:   Wed,  9 Jun 2021 14:17:36 -0500
Message-Id: <20210609191736.39668-4-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609191736.39668-1-dinguyen@kernel.org>
References: <20210609191736.39668-1-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the bypass_reg is set, then we can return the bypass parent, however,
if there is not a bypass_reg, we need to figure what the correct parent
mux is.

The previous code never handled the parent mux if there was a
bypass_reg.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 drivers/clk/socfpga/clk-periph-s10.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/socfpga/clk-periph-s10.c b/drivers/clk/socfpga/clk-periph-s10.c
index e5a5fef76df7..e2aad5d37611 100644
--- a/drivers/clk/socfpga/clk-periph-s10.c
+++ b/drivers/clk/socfpga/clk-periph-s10.c
@@ -66,14 +66,19 @@ static u8 clk_periclk_get_parent(struct clk_hw *hwclk)
 	u32 clk_src, mask;
 	u8 parent;
 
+	/* handle the bypass first */
 	if (socfpgaclk->bypass_reg) {
 		mask = (0x1 << socfpgaclk->bypass_shift);
 		parent = ((readl(socfpgaclk->bypass_reg) & mask) >>
 			   socfpgaclk->bypass_shift);
-	} else {
+		if (parent)
+			return parent;
+	}
+
+	if (socfpgaclk->hw.reg) {
 		clk_src = readl(socfpgaclk->hw.reg);
 		parent = (clk_src >> CLK_MGR_FREE_SHIFT) &
-			CLK_MGR_FREE_MASK;
+			  CLK_MGR_FREE_MASK;
 	}
 	return parent;
 }
-- 
2.25.1

