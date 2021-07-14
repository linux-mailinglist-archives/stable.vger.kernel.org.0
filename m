Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2864D3C8F41
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241340AbhGNTwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238767AbhGNTsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C378B613FE;
        Wed, 14 Jul 2021 19:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291831;
        bh=HqqOvqC15YrDxEeYulqHcBOQhJwP945aCtoFam1tPkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WG4ngpOLr0kA67qgjhNm/Uy2K/2m/ZlGdresAcIp5qDRgTuuIhyHiZXqawDiwhdVj
         le44IjA57jmGJtNrRc2xM0LEQqJnqelRYkAVerfpW47N5pEPJ/9hpPaze8VpdMT4Vz
         QuyB1F3jTUFqnHdixvdNmR+HlQGkfh/OrPn1RPHV4VPUEC/aDGzloqTNA30FARuH6K
         upwn+WY9Wi8eebegeXd5u3dPztJgnsUULjpqgWrCgj/BqlaE/JdmqDUQHIzESqBi6a
         I8bgaQlkpgFZvAFaDGleEW3D9lnKm4UBXw3kA5r6DVQEqjl1PxXNICN5DyjacEeS71
         WZn0rSjOjwDXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 30/88] arm64: dts: renesas: beacon: Fix USB extal reference
Date:   Wed, 14 Jul 2021 15:42:05 -0400
Message-Id: <20210714194303.54028-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 56bc54496f5d6bc638127bfc9df3742cbf0039e7 ]

The USB extal clock reference isn't associated to a crystal, it's
associated to a programmable clock, so remove the extal reference,
add the usb2_clksel.  Since usb_extal is referenced by the versaclock,
reference it here so the usb2_clksel can get the proper clock speed
of 50MHz.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20210513114617.30191-1-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 289cf711307d..e3773b05c403 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -295,8 +295,10 @@ &sdhi3 {
 	status = "okay";
 };
 
-&usb_extal_clk {
-	clock-frequency = <50000000>;
+&usb2_clksel {
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+		  <&versaclock5 3>, <&usb3s0_clk>;
+	status = "okay";
 };
 
 &usb3s0_clk {
-- 
2.30.2

