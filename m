Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD41A2E3D81
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441195AbgL1OQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441065AbgL1OQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26782207B2;
        Mon, 28 Dec 2020 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164935;
        bh=wNl2biSASR/xt8leC0Ai5ISmCRW6q6Q7X4k1XGZ7NIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxFhZt+1lKKNsyjo8W3ROBtc04bssxUumvX+vJufcpGxZE5D2eV76x7PH4/IDkWE5
         dLc8OiOBC7l3L8E6R78H/NlsJg8boQ7hWBbVC1sp371dmEwfIsNG9kchgc6cvBoT73
         IisfoQWWUaNCp/henmVwnzGYrKQiiwHmVLZNwYcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Stefan Agner <stefan@agner.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 352/717] ARM: dts: meson: fix PHY deassert timing requirements
Date:   Mon, 28 Dec 2020 13:45:50 +0100
Message-Id: <20201228125037.890573394@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 0c26467de4d03..5963566dbcc9d 100644
--- a/arch/arm/boot/dts/meson8b-odroidc1.dts
+++ b/arch/arm/boot/dts/meson8b-odroidc1.dts
@@ -224,7 +224,7 @@
 			reg = <0>;
 
 			reset-assert-us = <10000>;
-			reset-deassert-us = <30000>;
+			reset-deassert-us = <80000>;
 			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
 
 			interrupt-parent = <&gpio_intc>;
diff --git a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
index cc498191ddd1d..8f4eb1ed45816 100644
--- a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
+++ b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
@@ -81,7 +81,7 @@
 			reg = <0>;
 
 			reset-assert-us = <10000>;
-			reset-deassert-us = <30000>;
+			reset-deassert-us = <80000>;
 			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
 		};
 	};
-- 
2.27.0



