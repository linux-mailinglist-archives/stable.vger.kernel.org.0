Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC9B13F8AE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731498AbgAPTUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:20:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731467AbgAPQyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 617302176D;
        Thu, 16 Jan 2020 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193643;
        bh=IsIQlCAKLjxmjSdijTYiULQA7efHkUvHXQUo4paPNIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4rVYZsjwRcUVsCzlVBmg2/DDC53Mp8ey7KAPmjzsMk8GIGyQt9+K6zc034q2pFDv
         HHPTRefI/GFHs/7171zT2x74tL2iAzWUsAKSe1RxEDHuuVZk4nXY2nk8SsMun9FuDw
         YrL6ev8PBTkKtXCt4C4Yagk00t7+vfUh9fWDPQy8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 174/205] arm64: dts: juno: Fix UART frequency
Date:   Thu, 16 Jan 2020 11:42:29 -0500
Message-Id: <20200116164300.6705-174-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 39a1a8941b27c37f79508426e27a2ec29829d66c ]

Older versions of the Juno *SoC* TRM [1] recommended that the UART clock
source should be 7.2738 MHz, whereas the *system* TRM [2] stated a more
correct value of 7.3728 MHz. Somehow the wrong value managed to end up in
our DT.

Doing a prime factorisation, a modulo divide by 115200 and trying
to buy a 7.2738 MHz crystal at your favourite electronics dealer suggest
that the old value was actually a typo. The actual UART clock is driven
by a PLL, configured via a parameter in some board.txt file in the
firmware, which reads 7.37 MHz (sic!).

Fix this to correct the baud rate divisor calculation on the Juno board.

[1] http://infocenter.arm.com/help/topic/com.arm.doc.ddi0515b.b/DDI0515B_b_juno_arm_development_platform_soc_trm.pdf
[2] http://infocenter.arm.com/help/topic/com.arm.doc.100113_0000_07_en/arm_versatile_express_juno_development_platform_(v2m_juno)_technical_reference_manual_100113_0000_07_en.pdf

Fixes: 71f867ec130e ("arm64: Add Juno board device tree.")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/arm/juno-clocks.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/arm/juno-clocks.dtsi b/arch/arm64/boot/dts/arm/juno-clocks.dtsi
index e5e265dfa902..2870b5eeb198 100644
--- a/arch/arm64/boot/dts/arm/juno-clocks.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-clocks.dtsi
@@ -8,10 +8,10 @@
  */
 / {
 	/* SoC fixed clocks */
-	soc_uartclk: refclk7273800hz {
+	soc_uartclk: refclk7372800hz {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
-		clock-frequency = <7273800>;
+		clock-frequency = <7372800>;
 		clock-output-names = "juno:uartclk";
 	};
 
-- 
2.20.1

