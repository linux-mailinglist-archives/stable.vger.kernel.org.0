Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65CE3CDF12
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344600AbhGSPHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345913AbhGSPFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:05:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B9F7601FD;
        Mon, 19 Jul 2021 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709546;
        bh=zx6m9DHmVwvAQ9CYl++kvdn2CmsORRRK4bS2uQh4voI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIJKPcw3pTDXaUPU9/lDjTd5nljdppyBzoqzuhiyA64YcSNI5YEksMQ+EsJCUEEP9
         gFmjtT11hOE0QAYZcj3FCkVZd7iUrowksV7qLe2jgu2HcmEyRsok9JOOeYsJVpVSLe
         iOEpf6Z6MWOp0fQ5O5eqoYIAkVaysKWwS5/taQnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 404/421] ARM: dts: r8a7779, marzen: Fix DU clock names
Date:   Mon, 19 Jul 2021 16:53:35 +0200
Message-Id: <20210719145000.343633885@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 6ab8c23096a29b69044209a5925758a6f88bd450 ]

"make dtbs_check" complains:

    arch/arm/boot/dts/r8a7779-marzen.dt.yaml: display@fff80000: clock-names:0: 'du.0' was expected

Change the first clock name to match the DT bindings.
This has no effect on actual operation, as the Display Unit driver in
Linux does not use the first clock name on R-Car H1, but just grabs the
first clock.

Fixes: 665d79aa47cb3983 ("ARM: shmobile: marzen: Add DU external pixel clock to DT")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/9d5e1b371121883b3b3e10a3df43802a29c6a9da.1619699965.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/r8a7779-marzen.dts | 2 +-
 arch/arm/boot/dts/r8a7779.dtsi       | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/r8a7779-marzen.dts b/arch/arm/boot/dts/r8a7779-marzen.dts
index a4d0038363f0..84e30ed235b5 100644
--- a/arch/arm/boot/dts/r8a7779-marzen.dts
+++ b/arch/arm/boot/dts/r8a7779-marzen.dts
@@ -146,7 +146,7 @@
 	status = "okay";
 
 	clocks = <&mstp1_clks R8A7779_CLK_DU>, <&x3_clk>;
-	clock-names = "du", "dclkin.0";
+	clock-names = "du.0", "dclkin.0";
 
 	ports {
 		port@0 {
diff --git a/arch/arm/boot/dts/r8a7779.dtsi b/arch/arm/boot/dts/r8a7779.dtsi
index f1c9b2bc542c..c9695f31002a 100644
--- a/arch/arm/boot/dts/r8a7779.dtsi
+++ b/arch/arm/boot/dts/r8a7779.dtsi
@@ -437,6 +437,7 @@
 		reg = <0xfff80000 0x40000>;
 		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks R8A7779_CLK_DU>;
+		clock-names = "du.0";
 		power-domains = <&sysc R8A7779_PD_ALWAYS_ON>;
 		status = "disabled";
 
-- 
2.30.2



