Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8C3101416
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfKSFaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:30:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729082AbfKSFaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:30:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81F2921939;
        Tue, 19 Nov 2019 05:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141407;
        bh=m5SAiEhmgoM419e11DWoaWJ3r5SwTf19vYa1RbB7u0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiRMRLXqUywlAHfG46JZxNU/CgIkwEghc/RaAisT17eRUZEADgpirQjRZrma4UpGG
         jAElKXrfisD2aKpNvi6YMpqeKdOwJRAzd923klOmz5Fo0AlSFoW+MmJQL4VvrJZUdD
         o+E/ilhBgs7JO+z8kdIiZCBtdWTkBhSGPUbStGcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/422] ARM: dts: exynos: Disable pull control for PMIC IRQ line on Artik5 board
Date:   Tue, 19 Nov 2019 06:15:48 +0100
Message-Id: <20191119051408.412047428@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 62623718fd31d08b26ebea6c8b40f24924153ab7 ]

S2MPS14 PMIC interrupt line on Exynos3250-based Artik5 evaluation board
has external pull-up resistors, so disable any pull control for it in
controller node. This fixes support for S2MPS14 PMIC interrupts and
enables operation of wakeup from S2MPS14 RTC alarm.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-artik5.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-artik5.dtsi b/arch/arm/boot/dts/exynos3250-artik5.dtsi
index 620b50c19ead9..7c22cbf6f3d41 100644
--- a/arch/arm/boot/dts/exynos3250-artik5.dtsi
+++ b/arch/arm/boot/dts/exynos3250-artik5.dtsi
@@ -69,6 +69,8 @@
 		compatible = "samsung,s2mps14-pmic";
 		interrupt-parent = <&gpx3>;
 		interrupts = <5 IRQ_TYPE_NONE>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&s2mps14_irq>;
 		reg = <0x66>;
 
 		s2mps14_osc: clocks {
@@ -350,6 +352,11 @@
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV3>;
 		samsung,pin-val = <1>;
 	};
+
+	s2mps14_irq: s2mps14-irq {
+		samsung,pins = "gpx3-5";
+		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
+	};
 };
 
 &rtc {
-- 
2.20.1



