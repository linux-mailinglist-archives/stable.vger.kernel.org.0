Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0372D2CB7EF
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 10:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387959AbgLBI75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 03:59:57 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:15962 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387960AbgLBI75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 03:59:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1606899364;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=jao+yK4Gfd4R/ItR2Be0QHxtKxFDrtfGP0ckn1qPjRM=;
        b=GnO2lYN8a4Rkp1XmHcIvWp5WlznjEOZMS432H8fAJ5rvaSgm4q5X52EFNsllSj3jTe
        0NuZnZcGt7deNSW1lVjND6l5oaPO04cn9vGUOMTP+5yIwMqNSBD8VW1/reYxF+hTHf9s
        8itLXmxye0NHBPT79nCAr8dgOgEFVNDAv8dedZ2R1iJupeuTXhwO2c71DX/NXZS9EqNN
        JEH7yFHnTsRJVJSJ/O4F1kTR8ATcoaZJ/433fdOmMQFu+SoffY7R+EvW7LOD6aJPdJJq
        Tk96Ttz4tQU4npUiY87txBeYHOEXz6OrfKXGw+EXVbYAuaNGqER7KX8PqqMkzwHJYR/F
        lcNw==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o12DNOsPj0pDyBujo5I="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 47.3.4 DYNA|AUTH)
        with ESMTPSA id N02faawB28u4XiT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 2 Dec 2020 09:56:04 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     letux-kernel@openphoenux.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [RFC 1/2] Revert "DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again"
Date:   Wed,  2 Dec 2020 09:56:01 +0100
Message-Id: <516de8aa2c0fd75a0ad5700d6c572171fbdfa664.1606899361.git.hns@goldelico.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1606899361.git.hns@goldelico.com>
References: <cover.1606899361.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit f1f028ff89cb.

commit 6953c57ab172 ("gpio: of: Handle SPI chipselect legacy bindings")

did introduce logic to centrally handle the legacy spi-cs-high property
in combination with cs-gpios. This assumes that the polarity
of the CS has to be inverted if spi-cs-high is missing, even
and especially if non-legacy GPIO_ACTIVE_HIGH is specified.

As a result we had to introduce spi-cs-high to the device tree by

commit f1f028ff89cb ("DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again")

Now,

commit 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")

removes this inversion logic again and the GTA04 display is broken again.

So we have to revert the device tree change again.

But we should revert it only if

commit 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")

is present in some kernel version. Hence this is the Fixes: reference
and not the original change.

Fixes: 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
CC: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 432bbb21ddd05a..7c4c0124e20d45 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -149,7 +149,6 @@ lcd: td028ttec1@0 {
 			spi-max-frequency = <100000>;
 			spi-cpol;
 			spi-cpha;
-			spi-cs-high;
 
 			backlight= <&backlight>;
 			label = "lcd";
-- 
2.26.2

