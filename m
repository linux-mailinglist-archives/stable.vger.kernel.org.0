Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930E22E408E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501908AbgL1OSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501901AbgL1OSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2163B22583;
        Mon, 28 Dec 2020 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165041;
        bh=R2kS0c/cPf48Einw0w4fo7O3z6wO6Wh2MOgQXaZBF/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oeSpJAtr6BJCPDgfZdzqwd/xLOa6Tn/CAIW6mE2OkSNNfpURV18tlH4O1c+5AQlP
         DNKcXylGNr8LazAB++dX//1CLQjMH8c2VcTXYm0lo7rHpv3+qpNpRaGltm4Xsic/me
         QitgehlYKv6gw73XVLI5glw53YSebgv+S1A81qAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 390/717] clk: renesas: r8a779a0: Fix R and OSC clocks
Date:   Mon, 28 Dec 2020 13:46:28 +0100
Message-Id: <20201228125039.690625700@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 14653942de7f63e21ece32e3901f09a248598a43 ]

The R-Car V3U clock driver defines the R and OSC clocks using R-Car Gen3
clock types.  However, The R-Car V3U clock driver does not use the R-Car
Gen3 clock driver core, hence registering the R and OSC clocks fails:

    renesas-cpg-mssr e6150000.clock-controller: Failed to register core clock osc: -22
    renesas-cpg-mssr e6150000.clock-controller: Failed to register core clock r: -22

Fix this by introducing clock definition macros specific to R-Car V3U.
Note that rcar_r8a779a0_cpg_clk_register() already handled the related
clock types.  Drop the now unneeded include of rcar-gen3-cpg.h.

Fixes: 17bcc8035d2d19fc ("clk: renesas: cpg-mssr: Add support for R-Car V3U")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20201109152614.2465483-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779a0-cpg-mssr.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/renesas/r8a779a0-cpg-mssr.c b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
index 17ebbac7ddfb4..046d79416b7d0 100644
--- a/drivers/clk/renesas/r8a779a0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
@@ -26,7 +26,6 @@
 #include <dt-bindings/clock/r8a779a0-cpg-mssr.h>
 
 #include "renesas-cpg-mssr.h"
-#include "rcar-gen3-cpg.h"
 
 enum rcar_r8a779a0_clk_types {
 	CLK_TYPE_R8A779A0_MAIN = CLK_TYPE_CUSTOM,
@@ -84,6 +83,14 @@ enum clk_ids {
 	DEF_BASE(_name, _id, CLK_TYPE_R8A779A0_PLL2X_3X, CLK_MAIN, \
 		 .offset = _offset)
 
+#define DEF_MDSEL(_name, _id, _md, _parent0, _div0, _parent1, _div1) \
+	DEF_BASE(_name, _id, CLK_TYPE_R8A779A0_MDSEL,	\
+		 (_parent0) << 16 | (_parent1),		\
+		 .div = (_div0) << 16 | (_div1), .offset = _md)
+
+#define DEF_OSC(_name, _id, _parent, _div)		\
+	DEF_BASE(_name, _id, CLK_TYPE_R8A779A0_OSC, _parent, .div = _div)
+
 static const struct cpg_core_clk r8a779a0_core_clks[] __initconst = {
 	/* External Clock Inputs */
 	DEF_INPUT("extal",  CLK_EXTAL),
@@ -136,8 +143,8 @@ static const struct cpg_core_clk r8a779a0_core_clks[] __initconst = {
 	DEF_DIV6P1("canfd",	R8A779A0_CLK_CANFD,	CLK_PLL5_DIV4,	0x878),
 	DEF_DIV6P1("csi0",	R8A779A0_CLK_CSI0,	CLK_PLL5_DIV4,	0x880),
 
-	DEF_GEN3_OSC("osc",	R8A779A0_CLK_OSC,	CLK_EXTAL,	8),
-	DEF_GEN3_MDSEL("r",	R8A779A0_CLK_R, 29, CLK_EXTALR, 1, CLK_OCO, 1),
+	DEF_OSC("osc",		R8A779A0_CLK_OSC,	CLK_EXTAL,	8),
+	DEF_MDSEL("r",		R8A779A0_CLK_R, 29, CLK_EXTALR, 1, CLK_OCO, 1),
 };
 
 static const struct mssr_mod_clk r8a779a0_mod_clks[] __initconst = {
-- 
2.27.0



