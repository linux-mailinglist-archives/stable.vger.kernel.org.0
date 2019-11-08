Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C984F5749
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388327AbfKHTT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389454AbfKHTAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E7F22067B;
        Fri,  8 Nov 2019 18:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239449;
        bh=edyaPEsSFDSaiIed7hgWIzOEDLJ9eNGK6LfhNHk5TbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSCSx9ZEqxbJXn8aGeGkUydPWAJWijRZSGg+3KrsunmlYG5Sw498/fyt6GHpoKKYA
         ILjj0Klu6hYw/cdGoC76ua8nsLhfIgpLp1jzlt1eYfb5yZOvm99iXUTLAIi8/W6zua
         YeEa9VjKksQ7piRwzj+SO2dmdWsy19AiaLAL9438=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/62] arm64: dts: Fix gpio to pinmux mapping
Date:   Fri,  8 Nov 2019 19:49:49 +0100
Message-Id: <20191108174721.289735410@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 15214d05fec1c..8c20d4a0cb4ed 100644
--- a/arch/arm64/boot/dts/broadcom/stingray/stingray-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/broadcom/stingray/stingray-pinctrl.dtsi
@@ -42,13 +42,14 @@
 
 		pinmux: pinmux@0014029c {
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
index 2b76293b51c83..3d2921ef29351 100644
--- a/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi
+++ b/arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi
@@ -444,8 +444,7 @@
 					<&pinmux 108 16 27>,
 					<&pinmux 135 77 6>,
 					<&pinmux 141 67 4>,
-					<&pinmux 145 149 6>,
-					<&pinmux 151 91 4>;
+					<&pinmux 145 149 6>;
 		};
 
 		i2c1: i2c@000e0000 {
-- 
2.20.1



