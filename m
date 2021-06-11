Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E04D3A39F7
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 04:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFKC4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 22:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230407AbhFKCyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 22:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83A4E613B3;
        Fri, 11 Jun 2021 02:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623379936;
        bh=maCRj5DlrA+NbqU4+WBNdsYG1i6FhfkxEPU1kIXNVJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/OwC++Gjmm+1ZdY2IgKsDuBYx/nsmcnQEJQFAab6JS6fvjhvKr6lonrbxrvURq9c
         +EsAItpU+onT8k7e6aqCQxVM1vk10wEG4u1b1G3+pZqYbkYMJNcjBZZvhrSbFEZ8I0
         FVsFvnqzId7nxmKNLUVQF3+zV32rk/hdAIlSMt+FnfarG7KBFieFEdlkNo+5Oa8gvp
         +/j4hKyisQlo+oCYr1LJCEyK0emDCKsgnYKcOPMOoH8+zCjK7TbEc/99Bz10H2Jp9m
         uAi96bSk9Fvif/uXDLbngTl17FkE7OKf9EQz/L5w7sBNs8Ryl+C9b/yqGxCqLQdjcl
         v+EeaSKLfGZGg==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-clk@vger.kernel.org
Cc:     dinguyen@kernel.org, sboyd@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org
Subject: [PATCHv3 4/4] clk: agilex/stratix10/n5x: fix how the bypass_reg is handled
Date:   Thu, 10 Jun 2021 21:52:01 -0500
Message-Id: <20210611025201.118799-4-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611025201.118799-1-dinguyen@kernel.org>
References: <20210611025201.118799-1-dinguyen@kernel.org>
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
v3: fix smatch warning by initializing parent to 0
v2: add linux-stable to cc
---
 drivers/clk/socfpga/clk-periph-s10.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/socfpga/clk-periph-s10.c b/drivers/clk/socfpga/clk-periph-s10.c
index e5a5fef76df7..cbabde2b476b 100644
--- a/drivers/clk/socfpga/clk-periph-s10.c
+++ b/drivers/clk/socfpga/clk-periph-s10.c
@@ -64,16 +64,21 @@ static u8 clk_periclk_get_parent(struct clk_hw *hwclk)
 {
 	struct socfpga_periph_clk *socfpgaclk = to_periph_clk(hwclk);
 	u32 clk_src, mask;
-	u8 parent;
+	u8 parent = 0;
 
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

