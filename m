Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7F7200F2A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392462AbgFSPQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392456AbgFSPQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C422080C;
        Fri, 19 Jun 2020 15:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579764;
        bh=efE9qh+gRAoqSgGMofKgX7fsB1wxtB4Sw4lVk2loedU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDd9UBnui2EIV3Ni9Y/0wdvg8YKWK3frcc7DTokGjm4T3EhM+KXQ+Zbu4KB24pGXs
         E6fxBszNaBDSyqJBjwGX3pofklpQMKtN869mhVcKuPc9V4r7vogTz97B/J7p8Rbk6u
         pUKMT8aLZhOu117KZv4i1PQtIXWCgN+ErgC3uRoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.4 227/261] ARM: dts: exynos: Fix GPIO polarity for thr GalaxyS3 CM36651 sensors bus
Date:   Fri, 19 Jun 2020 16:33:58 +0200
Message-Id: <20200619141700.738834102@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 8807d356bfea92b0a8f04ce421800ed83400cd22 upstream.

GPIO lines for the CM36651 sensor I2C bus use the normal not the inverted
polarity. This bug has been there since adding the CM36651 sensor by
commit 85cb4e0bd229 ("ARM: dts: add cm36651 light/proximity sensor node
for exynos4412-trats2"), but went unnoticed because the "i2c-gpio"
driver ignored the GPIO polarity specified in the device-tree.

The recent conversion of "i2c-gpio" driver to the new, descriptor based
GPIO API, automatically made it the DT-specified polarity aware, what
broke the CM36651 sensor operation.

Fixes: 85cb4e0bd229 ("ARM: dts: add cm36651 light/proximity sensor node for exynos4412-trats2")
CC: stable@vger.kernel.org # 4.16+
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi
+++ b/arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi
@@ -68,7 +68,7 @@
 
 	i2c_cm36651: i2c-gpio-2 {
 		compatible = "i2c-gpio";
-		gpios = <&gpf0 0 GPIO_ACTIVE_LOW>, <&gpf0 1 GPIO_ACTIVE_LOW>;
+		gpios = <&gpf0 0 GPIO_ACTIVE_HIGH>, <&gpf0 1 GPIO_ACTIVE_HIGH>;
 		i2c-gpio,delay-us = <2>;
 		#address-cells = <1>;
 		#size-cells = <0>;


