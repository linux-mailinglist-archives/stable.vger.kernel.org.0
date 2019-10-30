Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D38E9F91
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfJ3Ptt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727485AbfJ3Pts (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:49:48 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CECE20874;
        Wed, 30 Oct 2019 15:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450587;
        bh=Zi2pA8zM32y+SK/W1EncEJTDCZ+rY6LFsZ8hoPnHxuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQFUHp8cA1E9LijHuuuVrn3AG0+mtoPNuf6VaAT39g5OCzW7WrzQQABhQ1Hv41tyT
         0xwUesGgX/XdfIvZ/mNvEYoy3aGdCe7m8B7ywJG7L7ut/IuRWz/tWcPDiVl+xE+zO5
         OvYiQB5JXBq6BB6eQej8kg7KBEMEIdeXx6nIeB4Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 09/81] arm64: dts: Fix gpio to pinmux mapping
Date:   Wed, 30 Oct 2019 11:48:15 -0400
Message-Id: <20191030154928.9432-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>

[ Upstream commit 965f6603e3335a953f4f876792074cb36bf65f7f ]

There are total of 151 non-secure gpio (0-150) and four
pins of pinmux (91, 92, 93 and 94) are not mapped to any
gpio pin, hence update same in DT.

Fixes: 8aa428cc1e2e ("arm64: dts: Add pinctrl DT nodes for Stingray SOC")
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/stingray/stingray-pinctrl.dtsi | 5 +++--
 arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi         | 3 +--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/stingray/stingray-pinctrl.dtsi b/arch/arm64/boot/dts/broadcom/stingray/stingray-pinctrl.dtsi
index 8a3a770e8f2ce..56789ccf94545 100644
--- a/arch/arm64/boot/dts/broadcom/stingray/stingray-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/broadcom/stingray/stingray-pinctrl.dtsi
@@ -42,13 +42,14 @@
 
 		pinmux: pinmux@14029c {
 			compatible = "pinctrl-single";
-			reg = <0x0014029c 0x250>;
+			reg = <0x0014029c 0x26c>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			pinctrl-single,register-width = <32>;
 			pinctrl-single,function-mask = <0xf>;
 			pinctrl-single,gpio-range = <
-				&range 0 154 MODE_GPIO
+				&range 0  91 MODE_GPIO
+				&range 95 60 MODE_GPIO
 				>;
 			range: gpio-range {
 				#pinctrl-single,gpio-range-cells = <3>;
diff --git a/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi b/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi
index 71e2e34400d40..0098dfdef96c0 100644
--- a/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi
+++ b/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi
@@ -464,8 +464,7 @@
 					<&pinmux 108 16 27>,
 					<&pinmux 135 77 6>,
 					<&pinmux 141 67 4>,
-					<&pinmux 145 149 6>,
-					<&pinmux 151 91 4>;
+					<&pinmux 145 149 6>;
 		};
 
 		i2c1: i2c@e0000 {
-- 
2.20.1

