Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6133C8C70
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhGNTmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233997AbhGNTlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28FBD613D3;
        Wed, 14 Jul 2021 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291536;
        bh=/LXC0pSLzFR6Suf13tw4eNPfaJ/VSEg952gbNu7tODY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u64DflQ3ofOTKBPLnn+IijjEsmkdR8aMU8c6I9aJuBhJJkgILoqoS8xCl4PQYGbNR
         vZmysKNy5aQj+QuluJs4jEg6/NObatIY15P+uF+QzOw3YHj3ajwcDHubzaSxtdMuXS
         ndI9legW9G6clbc4eujhmuatZoMJCffyDVRUgmJ/8mvYmG3QBsuIPKXPO6C0bCBr3p
         8OIfCZViPfxo+GHYNVtjM1Ez0QIHLZec9Be1uNfIyPwfO+Sty8gtyU5qw01HwEW5Kv
         Qh1j8NqSuoIABUPmp/njTAtS07QNLST/jmLUgd/TavFWHYLn7vY/kS6E0j7cHCrmsr
         ImYJDE9AyLmgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 038/108] arm64: dts: renesas: beacon: Fix USB ref clock references
Date:   Wed, 14 Jul 2021 15:36:50 -0400
Message-Id: <20210714193800.52097-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit ebc666f39ff67a01e748c34d670ddf05a9e45220 ]

The RZ/G2 boards expect there to be an external clock reference for
USB2 EHCI controllers.  For the Beacon boards, this reference clock
is controlled by a programmable versaclock.  Because the RZ/G2
family has a special clock driver when using an external clock,
the third clock reference in the EHCI node needs to point to this
special clock, called usb2_clksel.

Since the usb2_clksel does not keep the usb_extal clock enabled,
the 4th clock entry for the EHCI nodes needs to reference it to
keep the clock running and make USB functional.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20210513114617.30191-2-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index d8046fedf9c1..e3c8b2fe143e 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -271,12 +271,12 @@ &du_out_rgb {
 &ehci0 {
 	dr_mode = "otg";
 	status = "okay";
-	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>;
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>, <&usb2_clksel>, <&versaclock5 3>;
 };
 
 &ehci1 {
 	status = "okay";
-	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>;
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>, <&usb2_clksel>, <&versaclock5 3>;
 };
 
 &hdmi0 {
-- 
2.30.2

