Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEE4200E12
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390711AbgFSPEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391179AbgFSPEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:04:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AC1D21841;
        Fri, 19 Jun 2020 15:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579082;
        bh=X+fYMIqv9aW3zx9EKxEdSSMi/yaBPVv4khSCIkS3DbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uqbou9Dddl3JSCMDZGEQid9VI1kqp/2a4CFqS6EOB/zzFPBiCbxNuUVea2MiUBRj7
         oMdzrTGk28MiXmThvT/6OBEpE4gXQy18IcJ32xyz+ScwwdSbtVxun+Pn6sxqU537Q6
         qVBk5ZCK/MdbyK1cnTd8KSKW26vQkoq5V2HIdswg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.19 252/267] ARM: dts: exynos: Fix GPIO polarity for thr GalaxyS3 CM36651 sensors bus
Date:   Fri, 19 Jun 2020 16:33:57 +0200
Message-Id: <20200619141700.760834318@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
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
@@ -50,7 +50,7 @@
 
 	i2c_cm36651: i2c-gpio-2 {
 		compatible = "i2c-gpio";
-		gpios = <&gpf0 0 GPIO_ACTIVE_LOW>, <&gpf0 1 GPIO_ACTIVE_LOW>;
+		gpios = <&gpf0 0 GPIO_ACTIVE_HIGH>, <&gpf0 1 GPIO_ACTIVE_HIGH>;
 		i2c-gpio,delay-us = <2>;
 		#address-cells = <1>;
 		#size-cells = <0>;


