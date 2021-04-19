Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8751D3643E0
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241392AbhDSNWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241524AbhDSNUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBCB4613F4;
        Mon, 19 Apr 2021 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838229;
        bh=4Or+Yz6kO6pQb6f3i72UkcxlXMLm4CCQkvwij02cVAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtNrepaf8LtAe04MbdcsmadSiB2+DJcI1el+ujG2c0FlRNRfeMwsXigkVlhISBUgW
         AjmO8/KOnDvwl5Ory3AHPv0TMxAY5POv3uOJeCFWtDi2c8VII3VQ31pRxMjQ83wV+U
         ExFzmeCk/n5QgGMRjbnNbg9/R01T87ynkBwlsHOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashley <contact@victorianfox.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/103] arm64: dts: allwinner: Fix SD card CD GPIO for SOPine systems
Date:   Mon, 19 Apr 2021 15:06:41 +0200
Message-Id: <20210419130530.887006203@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 3dd4ce4185df6798dcdcc3669bddb35899d7d5e1 ]

Commit 941432d00768 ("arm64: dts: allwinner: Drop non-removable from
SoPine/LTS SD card") enabled the card detect GPIO for the SOPine module,
along the way with the Pine64-LTS, which share the same base .dtsi.

However while both boards indeed have a working CD GPIO on PF6, the
polarity is different: the SOPine modules uses a "push-pull" socket,
which has an active-high switch, while the Pine64-LTS use the more
traditional push-push socket and the common active-low switch.

Fix the polarity in the sopine.dtsi, and overwrite it in the LTS
board .dts, to make the SD card work again on systems using SOPine
modules.

Fixes: 941432d00768 ("arm64: dts: allwinner: Drop non-removable from SoPine/LTS SD card")
Reported-by: Ashley <contact@victorianfox.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210316144219.5973-1-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts | 4 ++++
 arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi    | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts
index 302e24be0a31..a1f621b388fe 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts
@@ -8,3 +8,7 @@
 	compatible = "pine64,pine64-lts", "allwinner,sun50i-r18",
 		     "allwinner,sun50i-a64";
 };
+
+&mmc0 {
+	cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>; /* PF6 push-push switch */
+};
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi
index 3402cec87035..df62044ff7a7 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi
@@ -34,7 +34,7 @@
 	vmmc-supply = <&reg_dcdc1>;
 	disable-wp;
 	bus-width = <4>;
-	cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>; /* PF6 */
+	cd-gpios = <&pio 5 6 GPIO_ACTIVE_HIGH>; /* PF6 push-pull switch */
 	status = "okay";
 };
 
-- 
2.30.2



