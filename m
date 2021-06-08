Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D99A3A0303
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhFHTLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237459AbhFHTJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:09:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3306361420;
        Tue,  8 Jun 2021 18:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178088;
        bh=5zsrGqPiGGHX8N9zvnwKY4FLF7y4J3m1Ota+cUvpMks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+hQDc+/uS1vA3gxCsQ0kYuAcpdUOtpZ+WaiKlw3oRKCpD+ZXq1CBq9vFOPA4cJlN
         z+Ot+7Wc0zrHWqYuyfUw5p/EOeRuBVtCbZ0gQwpYkDx2h0JnljyZClIA8Y8YObTvKh
         6nJizQ0A2UXo8wu888E9mH6f1L87jm6zAZHOGpRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 072/161] arm64: dts: freescale: sl28: var4: fix RGMII clock and voltage
Date:   Tue,  8 Jun 2021 20:26:42 +0200
Message-Id: <20210608175947.886163872@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 25201269c6ec3e9398426962ccdd55428261f7d0 ]

During hardware validation it was noticed that the clock isn't
continuously enabled when there is no link. This is because the 125MHz
clock is derived from the internal PLL which seems to go into some kind
of power-down mode every once in a while. The LS1028A expects a contiuous
clock. Thus enable the PLL all the time.

Also, the RGMII pad voltage is wrong. It was configured to 2.5V (that is
the VDDH regulator). The correct voltage is 1.8V, i.e. the VDDIO
regulator.

This fix is for the freescale/fsl-ls1028a-kontron-sl28-var4.dts.

Fixes: 815364d0424e ("arm64: dts: freescale: add Kontron sl28 support")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts     | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts
index df212ed5bb94..e65d1c477e2c 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts
@@ -31,11 +31,10 @@
 			reg = <0x4>;
 			eee-broken-1000t;
 			eee-broken-100tx;
-
 			qca,clk-out-frequency = <125000000>;
 			qca,clk-out-strength = <AR803X_STRENGTH_FULL>;
-
-			vddio-supply = <&vddh>;
+			qca,keep-pll-enabled;
+			vddio-supply = <&vddio>;
 
 			vddio: vddio-regulator {
 				regulator-name = "VDDIO";
-- 
2.30.2



