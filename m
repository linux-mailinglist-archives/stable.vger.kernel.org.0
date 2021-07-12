Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529F53C4C11
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241323AbhGLHBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239878AbhGLHBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:01:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C12246142B;
        Mon, 12 Jul 2021 06:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073092;
        bh=RrEZ3nvMz/eRzmsim55IcWFIrNUkgGhypRTju5JW/SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LANnnMD9r/BQr/ppBgTkh35g5Lz66dSjiUPTFFuEyydFmq7gs2WgEmF1/SgqdREX5
         m2Ue0OXA5UakHEFklEdyG7kFdXQFbPQjFswscb9N2Vzp3Cfqk44kv1tCs0MMr2NTLA
         esZvCmsFIpbB16Hl4uhQPNbkPcq5lkRvaaFc5a3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.12 081/700] clk: agilex/stratix10/n5x: fix how the bypass_reg is handled
Date:   Mon, 12 Jul 2021 08:02:44 +0200
Message-Id: <20210712060936.138706154@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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


