Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D268364353
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240029AbhDSNRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239963AbhDSNPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:15:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47C28613D0;
        Mon, 19 Apr 2021 13:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837995;
        bh=4Or+Yz6kO6pQb6f3i72UkcxlXMLm4CCQkvwij02cVAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5hLYp0MR8CdjVb6Dn0WaYD0yTPzrky9qXxLeU3mSHv7lLFWEX/KmFCaqnOdcS5Me
         bkNwebAhq44QYO4E8wZZE2bofLxRuLRmAVvbfKGR1RYTbMnGsGNao1rHF/VoHSWJy+
         rlaZfp3ntBLPV5pzMNzTdy6JagUp+yGJKdtGj1LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashley <contact@victorianfox.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 108/122] arm64: dts: allwinner: Fix SD card CD GPIO for SOPine systems
Date:   Mon, 19 Apr 2021 15:06:28 +0200
Message-Id: <20210419130533.828249431@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
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



