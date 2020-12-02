Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620012CB818
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 10:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbgLBJH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 04:07:56 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:19365 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbgLBJHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 04:07:55 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2020 04:07:54 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1606899843;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=PjMKDyiY7+lF2RcIxd0I5lWhqlyFww3ysHgRV7W+Ptw=;
        b=i+/rc65tBrhk9cT2EgB42cy0M/uYA/jAs5zxkm620cgrM27p9otljY7LxK0b8O3lVH
        xHc4gkUxufm9F7dajedrPGZjMiw3oFSJdU/CvuFA+Lc77HAkTIjvbhWhEwdMwljAMbWH
        Na6n15Q/KuqEa97Vv36At6/Sc9A/w/blL8jLnj6Z9lZeXTn6FBnqYSY9KJbaipGjHP+A
        6NAxVmYU3k7NWEToX20XCM1evk73Fyw4HJTQlEgAtV2eMA6wir7UXX4MuOzmfzmNrtI5
        DoVQHuPPlsMT+snbtK490k6V4XrpNessp+ffEUU5Oft2mEszOGFugqetm86XpkwW2Ur/
        YGHA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o12DNOsPj0pDyBujo5I="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 47.3.4 DYNA|AUTH)
        with ESMTPSA id N02faawB28u4XiV
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 2 Dec 2020 09:56:04 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     letux-kernel@openphoenux.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [RFC 2/2] DTS: ARM: gta04: SPI panel chip select is active low
Date:   Wed,  2 Dec 2020 09:56:02 +0100
Message-Id: <5c979df0d9eb68c234686c85e6e22f84b143c7ed.1606899361.git.hns@goldelico.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1606899361.git.hns@goldelico.com>
References: <cover.1606899361.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Historically the panel driver did know the polarity and
the device tree introduced by

commit c2e138bc8ed8 ("ARM: dts: omap3-gta04: Add display support")

as

	cs-gpios = <&gpio1 19 0>;

The 0 was ignored because the spi-gpio driver did only
look at the presence of an spi-cs-high property. Since
it was not present, the CS was active low.

commit 3a637e008e54 ("ARM: dts: Use defined GPIO constants in flags cell for OMAP2+ boards")

replaced the constant 0 by the constant GPIO_ACTIVE_HIGH
which was no problem because it was still ignored.

Starting with

commit 6953c57ab172 ("gpio: of: Handle SPI chipselect legacy bindings")

the gpiolib and spi-gpio drivers tried to handle both properties
by making an inversion for GPIO_ACTIVE_HIGH definitions.

To keep the device tree compatible with older kernels which
ignored the GPIO_ACTIVE property we just added spi-cs-high;.

This tells the inversion logic that we want an active low
chip select as defined by the rule documented by the commit
message of

commit 6953c57ab172 ("gpio: of: Handle SPI chipselect legacy bindings")

	"If the line is tagged as active high in the device tree with
    the second cell flag and has no "spi-cs-high" property we
    enforce active low semantics (as this is the exception we can
    just tag on the flag)."

This went well until

commit 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")

arrived which effectively removes the inversion logic rule.

Removing spi-cs-high; in a separate patch already solves the
urgent problem, but to remove

[    3.629791] td028ttec1@0 enforce active low on chipselect handle

and to be safe against future changes of such rules we also define
the cs-gpio explicitly as GPIO_ACTIVE_LOW.

Note that this patch breaks all kernels between
commit 6953c57ab172 ("gpio: of: Handle SPI chipselect legacy bindings")
and
commit 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")

Fixes: 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
CC: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 7c4c0124e20d45..76344b9c294512 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -139,7 +139,7 @@ spi_lcd: spi_lcd {
 		gpio-sck = <&gpio1 12 GPIO_ACTIVE_HIGH>;
 		gpio-miso = <&gpio1 18 GPIO_ACTIVE_HIGH>;
 		gpio-mosi = <&gpio1 20 GPIO_ACTIVE_HIGH>;
-		cs-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>;
+		cs-gpios = <&gpio1 19 GPIO_ACTIVE_LOW>;
 		num-chipselects = <1>;
 
 		/* lcd panel */
-- 
2.26.2

