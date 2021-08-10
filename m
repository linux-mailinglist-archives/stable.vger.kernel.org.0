Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADBF3E7EB4
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhHJRe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232772AbhHJRe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45D1061076;
        Tue, 10 Aug 2021 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616843;
        bh=19XAj8CpkGRIQOjZXdON8Swuu6WXy9RgZW6TRI9rJrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctYzIa4Fm32B91XNZ8bJWu0RP+eilDmdP/hkYXZvGj+FF2iOZVDFauaRCrfcKgWTk
         kHHJ4RvC2xydeyuVUi9uZ3Lk3h+fI4XPkVKDD7nPB4voKfIPrwlJt2WDqfn5LZ84mm
         VmeqPoO7pJTQkoBcnzOlIpQ0Q8e2EjMHC2TDPluw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?q?Herv=C3=A9=20Codina?= <herve.codina@bootlin.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/85] ARM: dts: imx6qdl-sr-som: Increase the PHY reset duration to 10ms
Date:   Tue, 10 Aug 2021 19:29:39 +0200
Message-Id: <20210810172948.420988038@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit fd8e83884fdd7b5fc411f201a58d8d01890198a2 ]

The AR803x PHY used on this modules seems to require the reset line to
be asserted for around 10ms in order to avoid rare cases where the PHY
gets stuck in an incoherent state that prevents it to function
correctly.

The previous value of 2ms was found to be problematic on some setups,
causing intermittent issues where the PHY would be unresponsive
every once in a while on some sytems, with a low occurrence (it typically
took around 30 consecutive reboots to encounter the issue).

Bumping the delay to the 10ms makes the issue dissapear, with more than
2500 consecutive reboots performed without the issue showing-up.

Fixes: 208d7baf8085 ("ARM: imx: initial SolidRun HummingBoard support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Tested-by: Hervé Codina <herve.codina@bootlin.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
index 6d7f6b9035bc..f2649241167e 100644
--- a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
@@ -54,7 +54,13 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_microsom_enet_ar8035>;
 	phy-mode = "rgmii-id";
-	phy-reset-duration = <2>;
+
+	/*
+	 * The PHY seems to require a long-enough reset duration to avoid
+	 * some rare issues where the PHY gets stuck in an inconsistent and
+	 * non-functional state at boot-up. 10ms proved to be fine .
+	 */
+	phy-reset-duration = <10>;
 	phy-reset-gpios = <&gpio4 15 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
-- 
2.30.2



