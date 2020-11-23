Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC42C0823
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732037AbgKWMqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732268AbgKWMqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:46:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A1020857;
        Mon, 23 Nov 2020 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135558;
        bh=NS0+aJRhIytqEg4VHWmLaSaF8gUuzPFm1DxGh3/6YjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2kfZvXzi2SZA03+Q+Fc0FZNCtMZ/OPbK1LuV8Vr2Yk+TqRU+Br7hXT8XjstZp9Ri
         Mygqkssd3oaAykv7U56incZyy1tCZ2C5SKDk+Zx04iTw27RoNJ4eGsy+J6BtR0uQcv
         nTLy+MFCpFiulvx5p4VHimJVt1+TQ75xMgjnFhd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 081/252] Revert "arm: sun8i: orangepi-pc-plus: Set EMAC activity LEDs to active high"
Date:   Mon, 23 Nov 2020 13:20:31 +0100
Message-Id: <20201123121839.505928998@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 8d80e2f00a42ef10b54e1b2d9e97314f8fd046c0 ]

This reverts commit 75ee680cbd2e4d0156b94f9fec50076361ab12f2.

Turns out the activity and link LEDs on the RJ45 port are active low,
just like on the Orange Pi PC.

Revert the commit that says otherwise.

Fixes: 75ee680cbd2e ("arm: sun8i: orangepi-pc-plus: Set EMAC activity LEDs to active high")
Fixes: 4904337fe34f ("ARM: dts: sunxi: Restore EMAC changes (boards)")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Tested-by: Jernej Skrabec <jernej.skrabec@siol.net>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20201024162515.30032-1-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h3-orangepi-pc-plus.dts | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-h3-orangepi-pc-plus.dts b/arch/arm/boot/dts/sun8i-h3-orangepi-pc-plus.dts
index 71fb732089397..babf4cf1b2f68 100644
--- a/arch/arm/boot/dts/sun8i-h3-orangepi-pc-plus.dts
+++ b/arch/arm/boot/dts/sun8i-h3-orangepi-pc-plus.dts
@@ -53,11 +53,6 @@
 	};
 };
 
-&emac {
-	/* LEDs changed to active high on the plus */
-	/delete-property/ allwinner,leds-active-low;
-};
-
 &mmc1 {
 	vmmc-supply = <&reg_vcc3v3>;
 	bus-width = <4>;
-- 
2.27.0



