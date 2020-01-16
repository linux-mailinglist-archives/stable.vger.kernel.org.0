Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1414813F5CB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388963AbgAPRGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:06:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:37008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388959AbgAPRGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066F92192A;
        Thu, 16 Jan 2020 17:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194395;
        bh=bUvZZaUpegoWYmOjzCX2yPSP3NEroF18G9mlAtBlWUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=habCx89VjLI69vx5uWkpugiGmIe32HeQhepFWzyWwjVBg5tVv5V4kdio5fL2+IBg7
         rNFzJwb5jUT5O1kL/19JRDai7pTJRcAtg0sHQNQMR1BSGU5xZjQOimteUpv+fN1CHp
         x6RypGfx0aHwH0yIitQsVfFTAe4o++qBRFuxezF0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 322/671] ARM: dts: logicpd-som-lv: Fix MMC1 card detect
Date:   Thu, 16 Jan 2020 11:59:20 -0500
Message-Id: <20200116170509.12787-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 6a38df676a0a06bfc7ff8607ac62ccd6d95969ad ]

The card detect pin was incorrectly using IRQ_TYPE_LEVEL_LOW
instead of GPIO_ACTIVE_LOW when reading the state of the CD pin.

This was previosly fixed on Torpedo, but missed on the SOM-LV

Fixes: 5cb8b0fa55a9 ("ARM: dts: Move most of logicpd-som-lv-37xx-devkit.dts to logicpd-som-lv-baseboard.dtsi")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi b/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
index 4990ed90dcea..3e39b9a1f35d 100644
--- a/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
+++ b/arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi
@@ -153,7 +153,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc1_pins>;
 	wp-gpios = <&gpio4 30 GPIO_ACTIVE_HIGH>;		/* gpio_126 */
-	cd-gpios = <&gpio4 14 IRQ_TYPE_LEVEL_LOW>;		/* gpio_110 */
+	cd-gpios = <&gpio4 14 GPIO_ACTIVE_LOW>;			/* gpio_110 */
 	vmmc-supply = <&vmmc1>;
 	bus-width = <4>;
 	cap-power-off-card;
-- 
2.20.1

