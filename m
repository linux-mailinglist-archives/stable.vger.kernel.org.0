Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB1A2E1AFD
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 11:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgLWKgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 05:36:22 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:12930 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgLWKgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 05:36:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1608719610;
        s=strato-dkim-0002; d=goldelico.com;
        h=Message-Id:Date:Subject:Cc:To:From:From:Subject:Sender;
        bh=bY0YzpEUeI+dY4ou93dboe/6Z74HesRpsnfqjYRk2Jk=;
        b=ULnRCvzGFpGwwalZO7iUgZhPAKbROVPYaipAvVFC0Aa++OcUow9wu/iRMb36qVtzAd
        i9U4c54FWWlD6s7y/KAXro8LfWOvd964r5cFNcx8mPvVOf0vpSHBuFyysm6Zw8Vy+lZU
        RMCxgkOBc0AM4vjX33+Nh2jP5vq8Xtx9pSL9sm2fcXH2wOQuv4y50tNkiTE3txxbOBVW
        Vuh1MOPz94mMlNId67nPxkgcbJuJAaomPMSeXIUzSx/yxtROkjN2P5J0rQSo7LR+7vQP
        DAwy7ipTy6x/BMftMi3bsYnxq3gEbrbDYKjeRQ60Zk2bxspmfya6MVAb3JrfeGyUzKop
        m5Mw==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH7FjJ5/fxd"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 47.10.7 DYNA|AUTH)
        with ESMTPSA id y052d6wBNAUM04l
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 23 Dec 2020 11:30:22 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        Andreas Kemnade <andreas@kemnade.info>,
        kernel@pyra-handheld.com,
        "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [PATCH] DTS: ARM: gta04: SPI panel chip select is active low
Date:   Wed, 23 Dec 2020 11:30:21 +0100
Message-Id: <a539758e798631b54a85df102a1c6635e1f70b37.1608719420.git.hns@goldelico.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 003202d129907b..7b8c18e6605e40 100644
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
2.26.2

