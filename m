Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19142E3AB0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403889AbgL1NkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403846AbgL1NkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:40:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 329D9207B2;
        Mon, 28 Dec 2020 13:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162783;
        bh=BDMdtDImohmx+gtDsTvBpXzt4RsvTcqtfy7+Tkh0CXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxUSYKawf81GDvz7sP3TfriVmD7yYkiPvgZCKLJLTAvEI6XQAh5dM1NIsdGU1yETf
         KwYhaplHokRUN6vyWUK+gSnlLdlw0lqmk1lo7U0ipVyrCMmc4cYtKSzLrbAsBfweir
         dgNPs4eqiLjFl+jwlgCA8X1vDVNyaKsHMvYj0Jvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Gabriel Ribba Esteva <gabriel.ribbae@gmail.com>
Subject: [PATCH 5.4 060/453] ARM: dts: exynos: fix USB 3.0 pins supply being turned off on Odroid XU
Date:   Mon, 28 Dec 2020 13:44:56 +0100
Message-Id: <20201228124940.130634717@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit bd7e7ff56feea7810df900fb09c9741d259861d9 upstream.

On Odroid XU LDO12 and LDO15 supplies the power to USB 3.0 blocks but
the GPK GPIO pins are supplied by LDO7 (VDDQ_LCD).  LDO7 also supplies
GPJ GPIO pins.

The Exynos pinctrl driver does not take any supplies, so to have entire
GPIO block always available, make the regulator always on.

Fixes: 88644b4c750b ("ARM: dts: exynos: Configure PWM, usb3503, PMIC and thermal on Odroid XU board")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201015182044.480562-3-krzk@kernel.org
Tested-by: Gabriel Ribba Esteva <gabriel.ribbae@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5410-odroidxu.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -327,6 +327,8 @@
 				regulator-name = "vddq_lcd";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				/* Supplies also GPK and GPJ */
+				regulator-always-on;
 			};
 
 			ldo8_reg: LDO8 {


