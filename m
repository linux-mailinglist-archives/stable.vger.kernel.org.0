Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB162A58F6
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgKCWDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:03:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730855AbgKCUoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A255223BF;
        Tue,  3 Nov 2020 20:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436262;
        bh=tapfU2YlJK1XJjHdexWPTAQxeqjwNRj3jVHNY1rFOp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBn9umBJ7wE5Gr6fWPZo5nYdUDp/0zNu513b95+u/MzDq5dvNwDNuzzuRqUbZnjrO
         FLqm9/Yd7b2MyB/oR7rCnXK++FdoDiRZtWpJJYJLtVY/xKTO4ZMmVC3f/pS4YJBut2
         h7dD9QMFFRastdfMhyxPYiF603yHoDGOVmQ6WuVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 172/391] ARM: dts: s5pv210: add RTC 32 KHz clock in Aries family
Date:   Tue,  3 Nov 2020 21:33:43 +0100
Message-Id: <20201103203358.478826938@linuxfoundation.org>
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

[ Upstream commit 086c4498b0cc87fdb09188f3da7056e898814948 ]

The S3C RTC requires 32768 Hz clock as input which is provided by PMIC.
However there is no such clock provider but rather a regulator driver
which registers the clock as a regulator.  This is an old driver which
will not be updated so add a workaround - a fixed-clock to fill missing
clock phandle reference in S3C RTC.

This fixes dtbs_check warnings:

  rtc@e2800000: clocks: [[2, 145]] is too short
  rtc@e2800000: clock-names: ['rtc'] is too short

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/20200907161141.31034-12-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-aries.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/s5pv210-aries.dtsi b/arch/arm/boot/dts/s5pv210-aries.dtsi
index a3f83f668ce14..8a98b35b9b0de 100644
--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -47,6 +47,13 @@
 		};
 	};
 
+	pmic_ap_clk: clock-0 {
+		/* Workaround for missing clock on PMIC */
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <32768>;
+	};
+
 	bt_codec: bt_sco {
 		compatible = "linux,bt-sco";
 		#sound-dai-cells = <0>;
@@ -825,6 +832,11 @@
 	samsung,pwm-outputs = <1>;
 };
 
+&rtc {
+	clocks = <&clocks CLK_RTC>, <&pmic_ap_clk>;
+	clock-names = "rtc", "rtc_src";
+};
+
 &sdhci1 {
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
2.27.0



