Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9948314B991
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgA1OZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732896AbgA1OZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:25:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4952A24688;
        Tue, 28 Jan 2020 14:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221517;
        bh=t5GZ5N/LopTk45JDVCHyBPgByYjTUsskcBljJRjATUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMjIQBcAxOS1ifX4WLUIv9afxsYMuRxcCEJxL6I+lPl7ZGH6JSYoXM17mKHB9AXDX
         QAEoUR/GwEr3WU7eAJxKpFRyip7cb/ZgMPlKy3PSzgF2stZZ+9KGFcjZdnm21gJjWi
         5/nxZdAEOA55M9Nk1PebcGVxIHhAiIHD88F3k46c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 229/271] arm64: dts: juno: Fix UART frequency
Date:   Tue, 28 Jan 2020 15:06:18 +0100
Message-Id: <20200128135909.624406632@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 25352ed943e6e..00bcbf7688c77 100644
--- a/arch/arm64/boot/dts/arm/juno-clocks.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-clocks.dtsi
@@ -8,10 +8,10 @@
  */
 
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



