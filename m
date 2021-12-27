Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0187E47FEDB
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237667AbhL0PdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:33:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38792 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237471AbhL0Pc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:32:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8700ACE10B3;
        Mon, 27 Dec 2021 15:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ED9C36AEA;
        Mon, 27 Dec 2021 15:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619174;
        bh=bQMhoAvE14uPqBPyziNe9PzFFzAQ7OXWGKcdDIJ6EQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6D5fJcjydSu69r9xQO3EVeTGGqIDBexCOnssTwGuN1m+Za42XCIlQH63HEBQNxxg
         SUN3ETdI34RI3PmaccIRhFocC+eIJkmSL0MphFNa2c0mvaYPHQiIQRakIPsnNzaF93
         R2zSYxcTBkU8Yyoud9jOY/RR+UgZeY8QSSl7nGsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Ron Goossens <rgoossens@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/38] arm64: dts: allwinner: orangepi-zero-plus: fix PHY mode
Date:   Mon, 27 Dec 2021 16:30:45 +0100
Message-Id: <20211227151319.654658383@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit 08d2061ff9c5319a07bf9ca6bbf11fdec68f704a ]

Orange Pi Zero Plus uses a Realtek RTL8211E RGMII Gigabit PHY, but its
currently set to plain RGMII mode meaning that it doesn't introduce
delays.

With this setup, TX packets are completely lost and changing the mode to
RGMII-ID so the PHY will add delays internally fixes the issue.

Fixes: a7affb13b271 ("arm64: allwinner: H5: Add Xunlong Orange Pi Zero Plus")
Acked-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Ron Goossens <rgoossens@gmail.com>
Tested-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20211117140222.43692-1-robert.marko@sartura.hr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts
index 1238de25a9691..9b1789504f7a0 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts
@@ -72,7 +72,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 
-- 
2.34.1



