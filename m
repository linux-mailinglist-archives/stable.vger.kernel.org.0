Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F6DEA035
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbfJ3PyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbfJ3PyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:54:21 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D91720656;
        Wed, 30 Oct 2019 15:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450861;
        bh=Yryrw8btORmLzFL2hJEnT0zESURDGptQcMl5Pp9dUxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBGQeVDt9SqZwv3BrJ2A+NtHGMLo9KKESxPt7fgqnp1sEEvOBSSLZ3GXcZ3qTjtW8
         7m//bwQfBLTbzxNylkN8ikWmTpCPWwpcGZKLRiIrTgE5C9RMOHZvMs9Lteb1iiue63
         rTUZ3r3iVJ5+VfQEEFtTOcyYxAQf07yUCqYBRFj0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/38] arm64: dts: Fix gpio to pinmux mapping
Date:   Wed, 30 Oct 2019 11:53:33 -0400
Message-Id: <20191030155406.10109-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
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
index e283480bfc7e5..84101ea1fd2cb 100644
--- a/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi
+++ b/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi
@@ -463,8 +463,7 @@
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

