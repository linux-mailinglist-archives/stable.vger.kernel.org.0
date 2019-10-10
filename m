Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF78FD2593
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388429AbfJJIl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388411AbfJJIlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:41:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6802054F;
        Thu, 10 Oct 2019 08:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696912;
        bh=8Zflg7lZGju3znOPM11CWJ5ivnYcOP2oM1Gv3T3aW9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuoItyXtBDpl+MsVf+au2XXu+aTcSNuGVPGWf9uGYCJlQkEPAvBQB7Ad4VBr8KnWL
         nShsFiYIhXy+21pzzTDdoHqXAZHvnkMBdcRFOrFB9f7q/nw8icyKICfrwf7ZZHXwO/
         tienev9MqaoZ2iUoR+AIV0BTMWKqH0sQMl/6xHv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.3 081/148] DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again
Date:   Thu, 10 Oct 2019 10:35:42 +0200
Message-Id: <20191010083616.242624592@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit f1f028ff89cb0d37db299d48e7b2ce19be040d52 upstream.

commit 6953c57ab172 "gpio: of: Handle SPI chipselect legacy bindings"

did introduce logic to centrally handle the legacy spi-cs-high property
in combination with cs-gpios. This assumes that the polarity
of the CS has to be inverted if spi-cs-high is missing, even
and especially if non-legacy GPIO_ACTIVE_HIGH is specified.

The DTS for the GTA04 was orginally introduced under the assumption
that there is no need for spi-cs-high if the gpio is defined with
proper polarity GPIO_ACTIVE_HIGH.

This was not a problem until gpiolib changed the interpretation of
GPIO_ACTIVE_HIGH and missing spi-cs-high.

The effect is that the missing spi-cs-high is now interpreted as CS being
low (despite GPIO_ACTIVE_HIGH) which turns off the SPI interface when the
panel is to be programmed by the panel driver.

Therefore, we have to add the redundant and legacy spi-cs-high property
to properly activate CS.

Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap3-gta04.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -120,6 +120,7 @@
 			spi-max-frequency = <100000>;
 			spi-cpol;
 			spi-cpha;
+			spi-cs-high;
 
 			backlight= <&backlight>;
 			label = "lcd";


