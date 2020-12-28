Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E47B2E4373
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392990AbgL1PiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:38:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406325AbgL1Nue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18CFA2064B;
        Mon, 28 Dec 2020 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163393;
        bh=/Ph6NisSeSE9OtDa9TmHsa/AjWs5KjLXJCpFh5R8m4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIePZfIneENA7UXQ+oZYFjLyI5woQelp7jlhxEPCM9CL22slNcbJyAVlGK3ifl29+
         Sy1pEqn6MQeN7QHtLgL0WgIGHG3eGwN7RhMU7fvEMcfM45BpZmzC1aKJ2p1k4soCZ0
         fI/3EdSF9F2XbHjQDRVjjMdbmkiICIwjYsLIA2QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Stefan Agner <stefan@agner.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 239/453] arm64: dts: meson: g12a: x96-max: fix PHY deassert timing requirements
Date:   Mon, 28 Dec 2020 13:47:55 +0100
Message-Id: <20201228124948.722663966@linuxfoundation.org>
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

[ Upstream commit 3d07c3b3a886fefd583c1b485b5e4e3c4e2da493 ]

According to the datasheet (Rev. 1.9) the RTL8211F requires at least
72ms "for internal circuits settling time" before accessing the PHY
registers. On similar boards with the same PHY this fixes an issue where
Ethernet link would not come up when using ip link set down/up.

Fixes: ed5e8f689154 ("arm64: dts: meson: g12a: x96-max: fix the Ethernet PHY reset line")
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/12506964ca5d5f936579a280ad0a7e7f9a0a2d4c.1607363522.git.stefan@agner.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
index 17155fb73fce9..c48125bf9d1e3 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
@@ -340,7 +340,7 @@
 		eee-broken-1000t;
 
 		reset-assert-us = <10000>;
-		reset-deassert-us = <30000>;
+		reset-deassert-us = <80000>;
 		reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
 
 		interrupt-parent = <&gpio_intc>;
-- 
2.27.0



