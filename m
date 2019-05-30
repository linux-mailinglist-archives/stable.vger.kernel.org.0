Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BEC2F1FF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfE3ERf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729460AbfE3DPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:39 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BF2024585;
        Thu, 30 May 2019 03:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186138;
        bh=JqatIXW8F2RINk5p6vnLD6MHuZb2+n6pr8nC3ExS3uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RR1f4la68YUEh6caxpOLoGLWduUMd4975sCYzAjsLIvQ1daGR9RZ7hK0zHxbxwSP/
         e8OkTYU8RZeA1Yq6tTeGkR5o1By18YL8SqvMBb4nQDxNR1L6irHOO48qub/NLGOqNK
         P8B1jPT+KvYBjp81lmfcHstjgKicYktqX2N09LU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 253/346] clk: renesas: rcar-gen3: Correct parent clock of Audio-DMAC
Date:   Wed, 29 May 2019 20:05:26 -0700
Message-Id: <20190530030553.821825089@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b9df2ea2b8d09ad850afe4d4a0403cb23d9e0c02 ]

The clock sources of the AXI-bus clock (266.66 MHz) used for Audio-DMAC
DMA transfers are:

    Channel        R-Car H3    R-Car M3-W    R-Car M3-N    R-Car E3
    ---------------------------------------------------------------
    Audio-DMAC0    S1D2        S1D2          S1D2          S1D2
    Audio-DMAC1    S1D2        S1D2          S1D2          -

As a result, change the parent clocks of the Audio-DMAC{0,1} module
clocks on R-Car H3, R-Car M3-W, and R-Car M3-N to S1D2, and change the
parent clock of the Audio-DMAC0 module on R-Car E3 to S1D2.

NOTE: This information will be reflected in a future revision of the
      R-Car Gen3 Hardware Manual.

Signed-off-by: Takeshi Kihara <takeshi.kihara.df@renesas.com>
[geert: Update R-Car D3, RZ/G2M, and RZ/G2E]
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a774a1-cpg-mssr.c | 4 ++--
 drivers/clk/renesas/r8a774c0-cpg-mssr.c | 2 +-
 drivers/clk/renesas/r8a7795-cpg-mssr.c  | 4 ++--
 drivers/clk/renesas/r8a7796-cpg-mssr.c  | 4 ++--
 drivers/clk/renesas/r8a77965-cpg-mssr.c | 4 ++--
 drivers/clk/renesas/r8a77990-cpg-mssr.c | 2 +-
 drivers/clk/renesas/r8a77995-cpg-mssr.c | 2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/renesas/r8a774a1-cpg-mssr.c b/drivers/clk/renesas/r8a774a1-cpg-mssr.c
index ddde2a7a24273..904d4d4ebcad5 100644
--- a/drivers/clk/renesas/r8a774a1-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a774a1-cpg-mssr.c
@@ -142,8 +142,8 @@ static const struct mssr_mod_clk r8a774a1_mod_clks[] __initconst = {
 	DEF_MOD("rwdt",			 402,	R8A774A1_CLK_R),
 	DEF_MOD("intc-ex",		 407,	R8A774A1_CLK_CP),
 	DEF_MOD("intc-ap",		 408,	R8A774A1_CLK_S0D3),
-	DEF_MOD("audmac1",		 501,	R8A774A1_CLK_S0D3),
-	DEF_MOD("audmac0",		 502,	R8A774A1_CLK_S0D3),
+	DEF_MOD("audmac1",		 501,	R8A774A1_CLK_S1D2),
+	DEF_MOD("audmac0",		 502,	R8A774A1_CLK_S1D2),
 	DEF_MOD("hscif4",		 516,	R8A774A1_CLK_S3D1),
 	DEF_MOD("hscif3",		 517,	R8A774A1_CLK_S3D1),
 	DEF_MOD("hscif2",		 518,	R8A774A1_CLK_S3D1),
diff --git a/drivers/clk/renesas/r8a774c0-cpg-mssr.c b/drivers/clk/renesas/r8a774c0-cpg-mssr.c
index 10b96895d4521..4a0525425c161 100644
--- a/drivers/clk/renesas/r8a774c0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a774c0-cpg-mssr.c
@@ -149,7 +149,7 @@ static const struct mssr_mod_clk r8a774c0_mod_clks[] __initconst = {
 	DEF_MOD("intc-ex",		 407,	R8A774C0_CLK_CP),
 	DEF_MOD("intc-ap",		 408,	R8A774C0_CLK_S0D3),
 
-	DEF_MOD("audmac0",		 502,	R8A774C0_CLK_S3D4),
+	DEF_MOD("audmac0",		 502,	R8A774C0_CLK_S1D2),
 	DEF_MOD("hscif4",		 516,	R8A774C0_CLK_S3D1C),
 	DEF_MOD("hscif3",		 517,	R8A774C0_CLK_S3D1C),
 	DEF_MOD("hscif2",		 518,	R8A774C0_CLK_S3D1C),
diff --git a/drivers/clk/renesas/r8a7795-cpg-mssr.c b/drivers/clk/renesas/r8a7795-cpg-mssr.c
index eade38e9ed36b..0825cd0ff2866 100644
--- a/drivers/clk/renesas/r8a7795-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a7795-cpg-mssr.c
@@ -153,8 +153,8 @@ static struct mssr_mod_clk r8a7795_mod_clks[] __initdata = {
 	DEF_MOD("rwdt",			 402,	R8A7795_CLK_R),
 	DEF_MOD("intc-ex",		 407,	R8A7795_CLK_CP),
 	DEF_MOD("intc-ap",		 408,	R8A7795_CLK_S0D3),
-	DEF_MOD("audmac1",		 501,	R8A7795_CLK_S0D3),
-	DEF_MOD("audmac0",		 502,	R8A7795_CLK_S0D3),
+	DEF_MOD("audmac1",		 501,	R8A7795_CLK_S1D2),
+	DEF_MOD("audmac0",		 502,	R8A7795_CLK_S1D2),
 	DEF_MOD("drif7",		 508,	R8A7795_CLK_S3D2),
 	DEF_MOD("drif6",		 509,	R8A7795_CLK_S3D2),
 	DEF_MOD("drif5",		 510,	R8A7795_CLK_S3D2),
diff --git a/drivers/clk/renesas/r8a7796-cpg-mssr.c b/drivers/clk/renesas/r8a7796-cpg-mssr.c
index 654f3ea88f335..997cd956f12bc 100644
--- a/drivers/clk/renesas/r8a7796-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a7796-cpg-mssr.c
@@ -146,8 +146,8 @@ static const struct mssr_mod_clk r8a7796_mod_clks[] __initconst = {
 	DEF_MOD("rwdt",			 402,	R8A7796_CLK_R),
 	DEF_MOD("intc-ex",		 407,	R8A7796_CLK_CP),
 	DEF_MOD("intc-ap",		 408,	R8A7796_CLK_S0D3),
-	DEF_MOD("audmac1",		 501,	R8A7796_CLK_S0D3),
-	DEF_MOD("audmac0",		 502,	R8A7796_CLK_S0D3),
+	DEF_MOD("audmac1",		 501,	R8A7796_CLK_S1D2),
+	DEF_MOD("audmac0",		 502,	R8A7796_CLK_S1D2),
 	DEF_MOD("drif7",		 508,	R8A7796_CLK_S3D2),
 	DEF_MOD("drif6",		 509,	R8A7796_CLK_S3D2),
 	DEF_MOD("drif5",		 510,	R8A7796_CLK_S3D2),
diff --git a/drivers/clk/renesas/r8a77965-cpg-mssr.c b/drivers/clk/renesas/r8a77965-cpg-mssr.c
index 13d1f88be04a5..afc9c72fa0940 100644
--- a/drivers/clk/renesas/r8a77965-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a77965-cpg-mssr.c
@@ -146,8 +146,8 @@ static const struct mssr_mod_clk r8a77965_mod_clks[] __initconst = {
 	DEF_MOD("intc-ex",		407,	R8A77965_CLK_CP),
 	DEF_MOD("intc-ap",		408,	R8A77965_CLK_S0D3),
 
-	DEF_MOD("audmac1",		501,	R8A77965_CLK_S0D3),
-	DEF_MOD("audmac0",		502,	R8A77965_CLK_S0D3),
+	DEF_MOD("audmac1",		501,	R8A77965_CLK_S1D2),
+	DEF_MOD("audmac0",		502,	R8A77965_CLK_S1D2),
 	DEF_MOD("drif7",		508,	R8A77965_CLK_S3D2),
 	DEF_MOD("drif6",		509,	R8A77965_CLK_S3D2),
 	DEF_MOD("drif5",		510,	R8A77965_CLK_S3D2),
diff --git a/drivers/clk/renesas/r8a77990-cpg-mssr.c b/drivers/clk/renesas/r8a77990-cpg-mssr.c
index 9a278c75c918c..03f445d47ef69 100644
--- a/drivers/clk/renesas/r8a77990-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a77990-cpg-mssr.c
@@ -152,7 +152,7 @@ static const struct mssr_mod_clk r8a77990_mod_clks[] __initconst = {
 	DEF_MOD("intc-ex",		 407,	R8A77990_CLK_CP),
 	DEF_MOD("intc-ap",		 408,	R8A77990_CLK_S0D3),
 
-	DEF_MOD("audmac0",		 502,	R8A77990_CLK_S3D4),
+	DEF_MOD("audmac0",		 502,	R8A77990_CLK_S1D2),
 	DEF_MOD("drif7",		 508,	R8A77990_CLK_S3D2),
 	DEF_MOD("drif6",		 509,	R8A77990_CLK_S3D2),
 	DEF_MOD("drif5",		 510,	R8A77990_CLK_S3D2),
diff --git a/drivers/clk/renesas/r8a77995-cpg-mssr.c b/drivers/clk/renesas/r8a77995-cpg-mssr.c
index eee3874865a95..68707277b17b4 100644
--- a/drivers/clk/renesas/r8a77995-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a77995-cpg-mssr.c
@@ -133,7 +133,7 @@ static const struct mssr_mod_clk r8a77995_mod_clks[] __initconst = {
 	DEF_MOD("rwdt",			 402,	R8A77995_CLK_R),
 	DEF_MOD("intc-ex",		 407,	R8A77995_CLK_CP),
 	DEF_MOD("intc-ap",		 408,	R8A77995_CLK_S1D2),
-	DEF_MOD("audmac0",		 502,	R8A77995_CLK_S3D1),
+	DEF_MOD("audmac0",		 502,	R8A77995_CLK_S1D2),
 	DEF_MOD("hscif3",		 517,	R8A77995_CLK_S3D1C),
 	DEF_MOD("hscif0",		 520,	R8A77995_CLK_S3D1C),
 	DEF_MOD("thermal",		 522,	R8A77995_CLK_CP),
-- 
2.20.1



