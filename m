Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CBE3CDC56
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbhGSOwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344153AbhGSOsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA2CF61244;
        Mon, 19 Jul 2021 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708419;
        bh=xHZWVjWjuS7dx1EBxb3BcjOQrdNHqcYC9lWORYUJgsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URbDeRc5XHupH6S8jdEejVvu7UvtPX1FYgUmXZw9mZfE6FJ2FjiFk1CBm2VOs2OBC
         I14/J9VCpQWMd1athO8yn20SSSgsd4pa4cABmxjB3/3oCOx5i+SjkWoVNpArXe/WaC
         gnkr8GkAYppHv6ALudLDkkpZCsBQlYi/VrS7LMhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 304/315] ARM: dts: r8a7779, marzen: Fix DU clock names
Date:   Mon, 19 Jul 2021 16:53:13 +0200
Message-Id: <20210719144953.464731083@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
index 9412a86f9b30..8cae7a656cec 100644
--- a/arch/arm/boot/dts/r8a7779-marzen.dts
+++ b/arch/arm/boot/dts/r8a7779-marzen.dts
@@ -136,7 +136,7 @@
 	status = "okay";
 
 	clocks = <&mstp1_clks R8A7779_CLK_DU>, <&x3_clk>;
-	clock-names = "du", "dclkin.0";
+	clock-names = "du.0", "dclkin.0";
 
 	ports {
 		port@0 {
diff --git a/arch/arm/boot/dts/r8a7779.dtsi b/arch/arm/boot/dts/r8a7779.dtsi
index 2face089d65b..138cc43911d6 100644
--- a/arch/arm/boot/dts/r8a7779.dtsi
+++ b/arch/arm/boot/dts/r8a7779.dtsi
@@ -432,6 +432,7 @@
 		reg = <0xfff80000 0x40000>;
 		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks R8A7779_CLK_DU>;
+		clock-names = "du.0";
 		power-domains = <&sysc R8A7779_PD_ALWAYS_ON>;
 		status = "disabled";
 
-- 
2.30.2



