Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8E91ACA74
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898031AbgDPNj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898029AbgDPNj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:39:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA5DF218AC;
        Thu, 16 Apr 2020 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044397;
        bh=IFWJtKO8b6hb9xBju8DtQHaiyO8+G0f/3xvR3wpJ/4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHYVQCth3xyMVRXxTodAtOKUhDqGFIqYC6ffgcvMUuBLPtlMHluRNvZE8gfw8Mq8w
         2WlEiWKIQ2L7uWzeUqAHaTEjtnRtQ7mp8V9LvckcodINJjADwXDsB9/glf4+Ll/HS6
         NWcS6pbf4sHP4YzVYQ9T2OL68jAsCiajSON1krHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.5 199/257] ARM: dts: exynos: Fix polarity of the LCD SPI bus on UniversalC210 board
Date:   Thu, 16 Apr 2020 15:24:10 +0200
Message-Id: <20200416131350.996178690@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 32a1671ff8e84f0dfff3a50d4b2091d25e91f5e2 upstream.

Recent changes in the SPI core and the SPI-GPIO driver revealed that the
GPIO lines for the LD9040 LCD controller on the UniversalC210 board are
defined incorrectly. Fix the polarity for those lines to match the old
behavior and hardware requirements to fix LCD panel operation with
recent kernels.

Cc: <stable@vger.kernel.org> # 5.0.x
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos4210-universal_c210.dts |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/arm/boot/dts/exynos4210-universal_c210.dts
+++ b/arch/arm/boot/dts/exynos4210-universal_c210.dts
@@ -115,7 +115,7 @@
 		gpio-sck = <&gpy3 1 GPIO_ACTIVE_HIGH>;
 		gpio-mosi = <&gpy3 3 GPIO_ACTIVE_HIGH>;
 		num-chipselects = <1>;
-		cs-gpios = <&gpy4 3 GPIO_ACTIVE_HIGH>;
+		cs-gpios = <&gpy4 3 GPIO_ACTIVE_LOW>;
 
 		lcd@0 {
 			compatible = "samsung,ld9040";
@@ -124,8 +124,6 @@
 			vci-supply = <&ldo17_reg>;
 			reset-gpios = <&gpy4 5 GPIO_ACTIVE_HIGH>;
 			spi-max-frequency = <1200000>;
-			spi-cpol;
-			spi-cpha;
 			power-on-delay = <10>;
 			reset-delay = <10>;
 			panel-width-mm = <90>;


