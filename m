Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31522C0AE3
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730779AbgKWMax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730772AbgKWMav (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:30:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E4C920728;
        Mon, 23 Nov 2020 12:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134650;
        bh=/CuCIyqCGWl1pj0qaP1PVDXHdanIKYc2bl6650nmA0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXTGNhMF+tE0D7tP6XZpyMZNkQ5hMiHNNGAo0ssIFkcsHolwA5IFN9X2sTIe2jCPz
         KHAOPIuY0HnBdYIyb1OPJ6Y0dxbEWCqZDpBEqC5ncz1PXsPhzgJDbUsW2oF9ZLm8Pb
         XbREB5J2vR4RAghxpX28qKpqQjFsQOMUbz6M1wzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/91] arm64: dts: allwinner: a64: Pine64 Plus: Fix ethernet node
Date:   Mon, 23 Nov 2020 13:21:53 +0100
Message-Id: <20201123121810.927279546@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 927f42fcc1b4f7d04a2ac5cf02f25612aa8923a4 ]

According to board schematic, PHY provides both, RX and TX delays.
However, according to "fix" Realtek provided for this board, only TX
delay should be provided by PHY.
Tests show that both variants work but TX only PHY delay works
slightly better.

Update ethernet node to reflect the fact that PHY provides TX delay.

Fixes: 94f442886711 ("arm64: dts: allwinner: A64: Restore EMAC changes")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20201022211301.3548422-1-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts
index d5b6e8159a335..5d0905f0f1c1d 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts
@@ -52,7 +52,7 @@
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&rgmii_pins>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-txid";
 	phy-handle = <&ext_rgmii_phy>;
 	status = "okay";
 };
-- 
2.27.0



