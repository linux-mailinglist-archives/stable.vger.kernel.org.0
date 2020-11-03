Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E6F2A51D0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbgKCUoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:44:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730866AbgKCUoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2A0F223FD;
        Tue,  3 Nov 2020 20:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436258;
        bh=9QAkHLo56SZmsaHq7ZAyJPLBo+X1+orX3v1u6Ea9nkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+TPyM7GyCDbOYCWF2fAUC1iVBasBsgaihB7t97G7aZLitu1u5kSi8py1kO2zy1Aa
         6kXYrAb+XyxsToYPXi8fvWz120nNbhZOXeHEzQM2VxskiFHX3+PcSVnZvmyLtN3MA3
         u3st90qa8w5L8wblgpAbZTey1sH084si6HqLP+A8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 170/391] ARM: dts: s5pv210: move PMU node out of clock controller
Date:   Tue,  3 Nov 2020 21:33:41 +0100
Message-Id: <20201103203358.347467276@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit bb98fff84ad1ea321823759edaba573a16fa02bd ]

The Power Management Unit (PMU) is a separate device which has little
common with clock controller.  Moving it to one level up (from clock
controller child to SoC) allows to remove fake simple-bus compatible and
dtbs_check warnings like:

  clock-controller@e0100000: $nodename:0:
    'clock-controller@e0100000' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/20200907161141.31034-8-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210.dtsi | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/s5pv210.dtsi b/arch/arm/boot/dts/s5pv210.dtsi
index 5c760a6d79557..46221a5c8ce59 100644
--- a/arch/arm/boot/dts/s5pv210.dtsi
+++ b/arch/arm/boot/dts/s5pv210.dtsi
@@ -92,19 +92,16 @@
 		};
 
 		clocks: clock-controller@e0100000 {
-			compatible = "samsung,s5pv210-clock", "simple-bus";
+			compatible = "samsung,s5pv210-clock";
 			reg = <0xe0100000 0x10000>;
 			clock-names = "xxti", "xusbxti";
 			clocks = <&xxti>, <&xusbxti>;
 			#clock-cells = <1>;
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges;
+		};
 
-			pmu_syscon: syscon@e0108000 {
-				compatible = "samsung-s5pv210-pmu", "syscon";
-				reg = <0xe0108000 0x8000>;
-			};
+		pmu_syscon: syscon@e0108000 {
+			compatible = "samsung-s5pv210-pmu", "syscon";
+			reg = <0xe0108000 0x8000>;
 		};
 
 		pinctrl0: pinctrl@e0200000 {
-- 
2.27.0



