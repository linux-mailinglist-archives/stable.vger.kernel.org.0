Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6E6313830
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbhBHPhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:37:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhBHPdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:33:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50B0A64E8F;
        Mon,  8 Feb 2021 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797491;
        bh=ww7NgT3JJX+E58+NC7zyVcf1Gm6KRDyjpnPI1lnvecM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUXJEH32BZo4a1BsnT7GcJyLj2JPvXeYAAp3BJz8jK8mAxlDDs5pUezsrE+85ISiH
         W3/wwGPx9glKSHesmu9w70BPLIhxufa7zBXeDehM/3daV6eeBhn9FE5O7iPHSCwcfL
         hXfNsQbiuxgYttyxqjhmkXcuJ+Ts6qoHvs1yIP70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.10 095/120] ARM: dts; gta04: SPI panel chip select is active low
Date:   Mon,  8 Feb 2021 16:01:22 +0100
Message-Id: <20210208145822.177697429@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 181739822cf6f8f4e12b173913af2967a28906c0 upstream.

With the arrival of

commit 2fee9583198eb9 ("spi: dt-bindings: clarify CS behavior for spi-cs-high and gpio descriptors")

it was clarified what the proper state for cs-gpios should be, even if the
flag is ignored. The driver code is doing the right thing since

766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")

The chip-select of the td028ttec1 panel is active-low, so we must omit spi-cs-high;
attribute (already removed by separate patch) and should now use GPIO_ACTIVE_LOW for
the client device description to be fully consistent.

Fixes: 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
CC: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 003202d12990..7b8c18e6605e 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -114,7 +114,7 @@ spi_lcd: spi_lcd {
 		gpio-sck = <&gpio1 12 GPIO_ACTIVE_HIGH>;
 		gpio-miso = <&gpio1 18 GPIO_ACTIVE_HIGH>;
 		gpio-mosi = <&gpio1 20 GPIO_ACTIVE_HIGH>;
-		cs-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>;
+		cs-gpios = <&gpio1 19 GPIO_ACTIVE_LOW>;
 		num-chipselects = <1>;
 
 		/* lcd panel */
-- 
2.30.0



