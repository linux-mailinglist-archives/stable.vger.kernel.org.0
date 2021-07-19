Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139CC3CE199
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349365AbhGSP0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348113AbhGSPYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8387661442;
        Mon, 19 Jul 2021 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710507;
        bh=+s9U411Vo2Vr93teTyFht/XZanhXISJmoFuwzSVMBns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxqEWZlBWWIRHM0O8U8VycidugD/XlSezQxDVvk7mSuPjePZIEcLsXp/Bl3svzLAI
         Y3Kta1wzr/EeTQMKfaOPmgvm94I2ETgNwtjLc06+HJl4iXxUOjQwNasSZfvx5DLVkD
         jCAv3mIvGawxeHpRcOk9aO5QOkbT09paunaCcoIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/243] arm64: dts: allwinner: a64-sopine-baseboard: change RGMII mode to TXID
Date:   Mon, 19 Jul 2021 16:54:09 +0200
Message-Id: <20210719144948.032060312@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

[ Upstream commit bd5431b2f9b30a70f6ed964dd5ee9a6d1c397c06 ]

Although the schematics of Pine A64-LTS and SoPine Baseboard shows both
the RX and TX internal delay are enabled, they're using the same broken
RTL8211E chip batch with Pine A64+, so they should use TXID instead, not
ID.

In addition, by checking the real components soldered on both a SoPine
Baseboard and a Pine A64-LTS, RX delay is not enabled (GR69 soldered and
GR70 NC) despite the schematics says it's enabled. It's a common
situation for Pine64 boards that the NC information on schematics is not
the same with the board.

So the RGMII delay mode should be TXID on these boards.

Fixes: c2b111e59a7b ("arm64: dts: allwinner: A64 Sopine: phy-mode rgmii-id")
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210609083843.463750-1-icenowy@aosc.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
index d4069749d721..068cbd955bfc 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
@@ -79,7 +79,7 @@
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&rgmii_pins>;
-	phy-mode = "rgmii-id";
+	phy-mode = "rgmii-txid";
 	phy-handle = <&ext_rgmii_phy>;
 	phy-supply = <&reg_dc1sw>;
 	status = "okay";
-- 
2.30.2



