Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DFE30CAAB
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239010AbhBBS4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:56:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233551AbhBBOBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:01:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A834A64FFE;
        Tue,  2 Feb 2021 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273640;
        bh=+sJ6+FE1dawmZ4XgYUZfhi4YFDDwlr9WNFJ+SMG0DKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8kVAHE02wcTZBeR1edF5t3jMoHbZKTz9J0NZ6K8+tdLNjkvjlndInuGeiZ9OR8mm
         SAZd8+gldd7ivsUEjvEVw3uK2d4ean3sX9emJuvXIoyrQ0i+Wj+Rwyj5bthoEcomNW
         PzfpYTHUvk1L8IsyuMraO7hsP7eQ9eu714D4yrRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/61] arm64: dts: ls1028a: fix the offset of the reset register
Date:   Tue,  2 Feb 2021 14:38:15 +0100
Message-Id: <20210202132948.034285820@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 1653e3d470629d25c64cd8a2f84adb20a9348b0c ]

The offset of the reset request register is 0, the absolute address is
0x1e60000. Boards without PSCI support will fail to perform a reset:

[   26.734700] reboot: Restarting system
[   27.743259] Unable to restart system
[   27.746845] Reboot failed -- System halted

Fixes: 8897f3255c9c ("arm64: dts: Add support for NXP LS1028A SoC")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 795d6ca4bbd1f..bd99fa68b7630 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -103,7 +103,7 @@
 	reboot {
 		compatible ="syscon-reboot";
 		regmap = <&rst>;
-		offset = <0xb0>;
+		offset = <0>;
 		mask = <0x02>;
 	};
 
-- 
2.27.0



