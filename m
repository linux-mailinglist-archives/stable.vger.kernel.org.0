Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2E22E62FA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406330AbgL1Nu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:50:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406325AbgL1NuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 742A622583;
        Mon, 28 Dec 2020 13:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163379;
        bh=18AS3DecSQIXpjv2KC6bhvdWK076uLGJkHeyUsmK5cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcOFTneVIsXbIaY7REwMTc6jV1jEKu0poyi4rl8w2HqZrdSRgG9w3ZdgdDZ1VaKTP
         3O3khdhsUcvPDCI6OwgRzV1uHRB1pEWQx1Tx0VdO7wt1gHlxhK2G/uvxSk+/QBLW/K
         wBTftBbJZTtzpMjZOl0vEX91l8i9Gwh38gAdm/KI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Stefan Agner <stefan@agner.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 238/453] ARM: dts: meson: fix PHY deassert timing requirements
Date:   Mon, 28 Dec 2020 13:47:54 +0100
Message-Id: <20201228124948.671091226@linuxfoundation.org>
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

From: Stefan Agner <stefan@agner.ch>

[ Upstream commit 656ab1bdcd2b755dc161a9774201100d5bf74b8d ]

According to the datasheet (Rev. 1.9) the RTL8211F requires at least
72ms "for internal circuits settling time" before accessing the PHY
registers. On similar boards with the same PHY this fixes an issue where
Ethernet link would not come up when using ip link set down/up.

Fixes: a2c6e82e5341 ("ARM: dts: meson: switch to the generic Ethernet PHY reset bindings")
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com> # on Odroid-C1+
Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/ff78772b306411e145769c46d4090554344db41e.1607363522.git.stefan@agner.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8b-odroidc1.dts    | 2 +-
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/meson8b-odroidc1.dts b/arch/arm/boot/dts/meson8b-odroidc1.dts
index a24eccc354b95..0f9c71137bed5 100644
--- a/arch/arm/boot/dts/meson8b-odroidc1.dts
+++ b/arch/arm/boot/dts/meson8b-odroidc1.dts
@@ -219,7 +219,7 @@
 			reg = <0>;
 
 			reset-assert-us = <10000>;
-			reset-deassert-us = <30000>;
+			reset-deassert-us = <80000>;
 			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
 
 			interrupt-parent = <&gpio_intc>;
diff --git a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
index d54477b1001ca..84b6ed51099db 100644
--- a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
+++ b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
@@ -83,7 +83,7 @@
 			reg = <0>;
 
 			reset-assert-us = <10000>;
-			reset-deassert-us = <30000>;
+			reset-deassert-us = <80000>;
 			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
 		};
 	};
-- 
2.27.0



