Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2916013E329
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387724AbgAPRA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387828AbgAPRA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A41FE20730;
        Thu, 16 Jan 2020 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194027;
        bh=she8x1KBiCi7IWGzigQznZ9S9yBiAqWacrw7nedfE+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6WxVwnKsl1cfHpB8ES4tlUW9ZyGTV6IvV66qF6meuPktiJw9QzEvVsRJVffoS21M
         BdWVn1Hi3SzImzVMEkB3s6/Yt+SKSwdzmtAHX3ZCC/MEgfpchS6T2pXPJqcmbtzDzq
         SpicV9PKGB9QfSLVYbADKcNi6pisJY77coAO09k8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Zapolskiy <vz@mleia.com>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 147/671] ARM: dts: lpc32xx: add required clocks property to keypad device node
Date:   Thu, 16 Jan 2020 11:50:56 -0500
Message-Id: <20200116165940.10720-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit 3e88bc38b9f6fe4b69cecf81badd3c19fde97f97 ]

NXP LPC32xx keypad controller requires a clock property to be defined.

The change fixes the driver initialization problem:

  lpc32xx_keys 40050000.key: failed to get clock
  lpc32xx_keys: probe of 40050000.key failed with error -2

Fixes: 93898eb775e5 ("arm: dts: lpc32xx: add clock properties to device nodes")
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc32xx.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/lpc32xx.dtsi b/arch/arm/boot/dts/lpc32xx.dtsi
index ed0d6fb20122..d4368eeff1b9 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -462,6 +462,7 @@
 			key: key@40050000 {
 				compatible = "nxp,lpc3220-key";
 				reg = <0x40050000 0x1000>;
+				clocks = <&clk LPC32XX_CLK_KEY>;
 				interrupts = <54 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
-- 
2.20.1

