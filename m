Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1CB47FF4A
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbhL0Pgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:36:40 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39592 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238312AbhL0Ped (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:34:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5EB77CE10D7;
        Mon, 27 Dec 2021 15:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7D1C36AE7;
        Mon, 27 Dec 2021 15:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619269;
        bh=5DcpuV1CCPdv1Ic6FykzKtMUG8fag1k5i7tb5csgOMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qvfm5BYZpeQzOU/pxI8SrTOymhMdf3xPTKDx/Q5gF0VDhnHVuecX0BPuo+ZRmhegB
         +212QzhwtnBjvOMfbt12TV/jTflSQxxRlxm9vU6kJiv5Y+GdE0bv2Xzotcvl3d7vtk
         bT+PjEgXpr4BhyOzvbv2kARJdmxApcILY0odWWWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Ron Goossens <rgoossens@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/47] arm64: dts: allwinner: orangepi-zero-plus: fix PHY mode
Date:   Mon, 27 Dec 2021 16:30:40 +0100
Message-Id: <20211227151320.940634183@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
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
index db6ea7b58999b..19f930f43936e 100644
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



