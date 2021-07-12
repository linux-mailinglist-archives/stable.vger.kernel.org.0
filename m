Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368AE3C5129
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344968AbhGLHiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243610AbhGLHgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:36:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 004A6613E0;
        Mon, 12 Jul 2021 07:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075139;
        bh=RrEZ3nvMz/eRzmsim55IcWFIrNUkgGhypRTju5JW/SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2n2FgMfWLVx59vec2+FSD68m5tVh2ElyloW4XGLqnfEAWS/kmXzMGEkrRHo9Ibxrz
         2iD9ys3853xgwuuLzwxV4dw6quHNZJHwCer02tnCOFG5bA9G3akFdskrQaRi4zoBqE
         F8Q5rHyPa439DFogcy9WVy0dpUrx3c/bGZD2SX3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.13 086/800] clk: agilex/stratix10/n5x: fix how the bypass_reg is handled
Date:   Mon, 12 Jul 2021 08:01:49 +0200
Message-Id: <20210712060925.165914040@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit dfd1427c3769ba51297777dbb296f1802d72dbf6 upstream.

If the bypass_reg is set, then we can return the bypass parent, however,
if there is not a bypass_reg, we need to figure what the correct parent
mux is.

The previous code never handled the parent mux if there was a
bypass_reg.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20210611025201.118799-4-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/socfpga/clk-periph-s10.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/clk/socfpga/clk-periph-s10.c
+++ b/drivers/clk/socfpga/clk-periph-s10.c
@@ -64,16 +64,21 @@ static u8 clk_periclk_get_parent(struct
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


