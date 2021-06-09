Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF663A1D31
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFISwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230254AbhFISwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 14:52:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EBC1613E3;
        Wed,  9 Jun 2021 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623264622;
        bh=VjYzsxyX1IhYilHbdrY+02RW5CSdvT6q/weGyn2XyUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuFyzLGe4Zc2lGw31D32k/8cfbFcs/BMb2o0ENkkOOT2cjZOSg6M6IUc+Ac5NMbY0
         +3mhhY1kECKYoQQCqg94Yl4Yed1XN6m34/szuPUZnPOdNaP7Gbiw6iBxrfC+qnOkM3
         JGkyKilatolyeDzQQd/+M2fICK1xJjxz6wzDRhN7OorJGLTT80d2aoDvriQ06xt5P5
         oqJOganAEK2SXwcKL0k4QJE5YDw9GBhJa1kg/p00sp0wGArnqZ2qdeXxBgLvKbF/6Z
         R38rX0lbNOVlg5V//JsxnvdQ/A4XWSvfT9FpLyjmshKzmUfz/6PEO1H6zbFzYhpFaf
         1YI45IU91ApNg==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-clk@vger.kernel.org
Cc:     dinguyen@kernel.org, sboyd@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org
Subject: [PATCH 4/4] clk: agilex/stratix10/n5x: fix how the bypass_reg is handled
Date:   Wed,  9 Jun 2021 13:50:08 -0500
Message-Id: <20210609185008.36056-4-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609185008.36056-1-dinguyen@kernel.org>
References: <20210609185008.36056-1-dinguyen@kernel.org>
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

