Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C362C2EB54
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfE3DLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbfE3DLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:47 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 299EF2446F;
        Thu, 30 May 2019 03:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185906;
        bh=mOTHQkA9xhzrx9IqUyYSupDYM6744LKs6Vi2Qm5MEVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LexhCAaCym2L+a3bUX/G+Ja5fj3Oknzo1QQMN0XiRezueZtTzebEA4LY75ENf46hR
         c7j8lDjXSfSA7wmRbToT+Fn037TaEr/6vRBK4ZIsZO4otEnFao5TaXayDgz8uxuaIn
         CZ5zOu4gil/GoALm9f3czbINy4la9cqhbLIvAZLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 278/405] clk: renesas: rcar-gen3: Correct parent clock of SYS-DMAC
Date:   Wed, 29 May 2019 20:04:36 -0700
Message-Id: <20190530030554.955734994@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3c772f71a552d343a96868ed9a809f9047be94f5 ]

The clock sources of the AXI BUS clock (266.66 MHz) used for SYS-DMAC
DMA transfers are:

    Channel      R-Car H3    R-Car M3-W    R-Car M3-N
    -------------------------------------------------
    SYS-DMAC0    S0D3        S0D3          S0D3
    SYS-DMAC1    S3D1        S3D1          S3D1
    SYS-DMAC2    S3D1        S3D1          S3D1

As a result, change the parent clocks of the SYS-DMAC{1,2} module clocks
on R-Car H3, R-Car M3-W, and R-Car M3-N to S3D1.

NOTE: This information will be reflected in a future revision of the
      R-Car Gen3 Hardware Manual.

Signed-off-by: Takeshi Kihara <takeshi.kihara.df@renesas.com>
[geert: Update RZ/G2M]
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a774a1-cpg-mssr.c | 4 ++--
 drivers/clk/renesas/r8a7795-cpg-mssr.c  | 4 ++--
 drivers/clk/renesas/r8a7796-cpg-mssr.c  | 4 ++--
 drivers/clk/renesas/r8a77965-cpg-mssr.c | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/renesas/r8a774a1-cpg-mssr.c b/drivers/clk/renesas/r8a774a1-cpg-mssr.c
index 4d92b27a61538..047599579c651 100644
--- a/drivers/clk/renesas/r8a774a1-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a774a1-cpg-mssr.c
@@ -123,8 +123,8 @@ static const struct mssr_mod_clk r8a774a1_mod_clks[] __initconst = {
 	DEF_MOD("msiof2",		 209,	R8A774A1_CLK_MSO),
 	DEF_MOD("msiof1",		 210,	R8A774A1_CLK_MSO),
 	DEF_MOD("msiof0",		 211,	R8A774A1_CLK_MSO),
-	DEF_MOD("sys-dmac2",		 217,	R8A774A1_CLK_S0D3),
-	DEF_MOD("sys-dmac1",		 218,	R8A774A1_CLK_S0D3),
+	DEF_MOD("sys-dmac2",		 217,	R8A774A1_CLK_S3D1),
+	DEF_MOD("sys-dmac1",		 218,	R8A774A1_CLK_S3D1),
 	DEF_MOD("sys-dmac0",		 219,	R8A774A1_CLK_S0D3),
 	DEF_MOD("cmt3",			 300,	R8A774A1_CLK_R),
 	DEF_MOD("cmt2",			 301,	R8A774A1_CLK_R),
diff --git a/drivers/clk/renesas/r8a7795-cpg-mssr.c b/drivers/clk/renesas/r8a7795-cpg-mssr.c
index 86842c9fd314e..eade38e9ed36b 100644
--- a/drivers/clk/renesas/r8a7795-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a7795-cpg-mssr.c
@@ -129,8 +129,8 @@ static struct mssr_mod_clk r8a7795_mod_clks[] __initdata = {
 	DEF_MOD("msiof2",		 209,	R8A7795_CLK_MSO),
 	DEF_MOD("msiof1",		 210,	R8A7795_CLK_MSO),
 	DEF_MOD("msiof0",		 211,	R8A7795_CLK_MSO),
-	DEF_MOD("sys-dmac2",		 217,	R8A7795_CLK_S0D3),
-	DEF_MOD("sys-dmac1",		 218,	R8A7795_CLK_S0D3),
+	DEF_MOD("sys-dmac2",		 217,	R8A7795_CLK_S3D1),
+	DEF_MOD("sys-dmac1",		 218,	R8A7795_CLK_S3D1),
 	DEF_MOD("sys-dmac0",		 219,	R8A7795_CLK_S0D3),
 	DEF_MOD("sceg-pub",		 229,	R8A7795_CLK_CR),
 	DEF_MOD("cmt3",			 300,	R8A7795_CLK_R),
diff --git a/drivers/clk/renesas/r8a7796-cpg-mssr.c b/drivers/clk/renesas/r8a7796-cpg-mssr.c
index 12c455859f2c2..654f3ea88f335 100644
--- a/drivers/clk/renesas/r8a7796-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a7796-cpg-mssr.c
@@ -126,8 +126,8 @@ static const struct mssr_mod_clk r8a7796_mod_clks[] __initconst = {
 	DEF_MOD("msiof2",		 209,	R8A7796_CLK_MSO),
 	DEF_MOD("msiof1",		 210,	R8A7796_CLK_MSO),
 	DEF_MOD("msiof0",		 211,	R8A7796_CLK_MSO),
-	DEF_MOD("sys-dmac2",		 217,	R8A7796_CLK_S0D3),
-	DEF_MOD("sys-dmac1",		 218,	R8A7796_CLK_S0D3),
+	DEF_MOD("sys-dmac2",		 217,	R8A7796_CLK_S3D1),
+	DEF_MOD("sys-dmac1",		 218,	R8A7796_CLK_S3D1),
 	DEF_MOD("sys-dmac0",		 219,	R8A7796_CLK_S0D3),
 	DEF_MOD("cmt3",			 300,	R8A7796_CLK_R),
 	DEF_MOD("cmt2",			 301,	R8A7796_CLK_R),
diff --git a/drivers/clk/renesas/r8a77965-cpg-mssr.c b/drivers/clk/renesas/r8a77965-cpg-mssr.c
index eb1cca58a1e1f..13d1f88be04a5 100644
--- a/drivers/clk/renesas/r8a77965-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a77965-cpg-mssr.c
@@ -123,8 +123,8 @@ static const struct mssr_mod_clk r8a77965_mod_clks[] __initconst = {
 	DEF_MOD("msiof2",		209,	R8A77965_CLK_MSO),
 	DEF_MOD("msiof1",		210,	R8A77965_CLK_MSO),
 	DEF_MOD("msiof0",		211,	R8A77965_CLK_MSO),
-	DEF_MOD("sys-dmac2",		217,	R8A77965_CLK_S0D3),
-	DEF_MOD("sys-dmac1",		218,	R8A77965_CLK_S0D3),
+	DEF_MOD("sys-dmac2",		217,	R8A77965_CLK_S3D1),
+	DEF_MOD("sys-dmac1",		218,	R8A77965_CLK_S3D1),
 	DEF_MOD("sys-dmac0",		219,	R8A77965_CLK_S0D3),
 
 	DEF_MOD("cmt3",			300,	R8A77965_CLK_R),
-- 
2.20.1



