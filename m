Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE294290AB
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243428AbhJKOLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243067AbhJKOJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:09:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1CE761139;
        Mon, 11 Oct 2021 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960914;
        bh=HByJSIeXDIJ1Cu7sUGka5/gyd0gF0+2CKd/JvAcXB0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTi0zgp6tYFsjVMkWTvMckPx2jBRJcOvmHy/VnTuUrYmHjGnQHgrJ9V1BCyyTBDf0
         3ALYDPm4NqFAW4UTD4m1xlv1V7aUGCGfXC4JdErbGYe/8UfwWOFINBb5p53D3V1OzY
         fOsNv1hoCbwUAbcHLSR41yNiw9Hi+7PIMj4drBZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 079/151] arm64: dts: ls1028a: fix eSDHC2 node
Date:   Mon, 11 Oct 2021 15:45:51 +0200
Message-Id: <20211011134520.399866932@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 8b94aa318aa746fbbc668d6b9b3ad812c835230c ]

On the LS1028A this instance of the eSDHC controller is intended for
either an eMMC or eSDIO card. It doesn't provide a card detect pin and
its IO voltage is fixed at 1.8V.

Remove the bogus broken-cd property, instead add the non-removable
property. Fix the voltage-ranges property and set it to 1.8V only.

Fixes: 491d3a3fc113 ("arm64: dts: ls1028a: Add esdhc node in dts")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 343ecf0e8973..06b36cc65865 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -405,9 +405,9 @@
 			interrupts = <GIC_SPI 63 IRQ_TYPE_LEVEL_HIGH>;
 			clock-frequency = <0>; /* fixed up by bootloader */
 			clocks = <&clockgen QORIQ_CLK_HWACCEL 1>;
-			voltage-ranges = <1800 1800 3300 3300>;
+			voltage-ranges = <1800 1800>;
 			sdhci,auto-cmd12;
-			broken-cd;
+			non-removable;
 			little-endian;
 			bus-width = <4>;
 			status = "disabled";
-- 
2.33.0



