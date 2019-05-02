Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FDC11E70
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfEBP3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbfEBP3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:29:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6268220675;
        Thu,  2 May 2019 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810990;
        bh=XzRTI5aGM9/tHJgzdTCENxcAbCuSO0YLsJy5A1hSxk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yu8wLXexh8CaP6z/wqkhzBzH++sSLQJSyx+Ja8tvJHIdYG1qQvLpRdg7kt4iAbvyo
         sRnzOgDnyZwIkjdnxF6ihPLrhrAiJKQ6CO86gDGzwku/kR12R06IW5KB8CNB0cTi1D
         fi1b5e2Tbp95rirgfsGIogMF9bAl43Q09Jbh8KgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 008/101] arm64: dts: renesas: r8a77990: Fix SCIF5 DMA channels
Date:   Thu,  2 May 2019 17:20:10 +0200
Message-Id: <20190502143340.421866995@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e20119f7eaaaf6aad5b44f35155ce500429e17f6 ]

According to the R-Car Gen3 Hardware Manual Errata for Rev 1.50 of Feb
12, 2019, the DMA channels for SCIF5 are corrected from 16..47 to 0..15
on R-Car E3.

Signed-off-by: Takeshi Kihara <takeshi.kihara.df@renesas.com>
Fixes: a5ebe5e49a862e21 ("arm64: dts: renesas: r8a77990: Add SCIF-{0,1,3,4,5} device nodes")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77990.dtsi | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77990.dtsi b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
index b2f606e286ce..327d12097643 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
@@ -2,7 +2,7 @@
 /*
  * Device Tree Source for the R-Car E3 (R8A77990) SoC
  *
- * Copyright (C) 2018 Renesas Electronics Corp.
+ * Copyright (C) 2018-2019 Renesas Electronics Corp.
  */
 
 #include <dt-bindings/clock/r8a77990-cpg-mssr.h>
@@ -1040,9 +1040,8 @@
 				 <&cpg CPG_CORE R8A77990_CLK_S3D1C>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
-			dmas = <&dmac1 0x5b>, <&dmac1 0x5a>,
-			       <&dmac2 0x5b>, <&dmac2 0x5a>;
-			dma-names = "tx", "rx", "tx", "rx";
+			dmas = <&dmac0 0x5b>, <&dmac0 0x5a>;
+			dma-names = "tx", "rx";
 			power-domains = <&sysc R8A77990_PD_ALWAYS_ON>;
 			resets = <&cpg 202>;
 			status = "disabled";
-- 
2.19.1



