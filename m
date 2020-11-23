Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA032C09EF
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733173AbgKWNOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:14:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733306AbgKWMp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02EC920732;
        Mon, 23 Nov 2020 12:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135528;
        bh=5XX9a1L7weueVzCfeLkm/jzxmWi7p/CpqRFGnnM56aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5TuMuTXjiAqJvZyEGn5Kg1SWtCuG9uHAHknpkQDGEz+lA31aZXy8nR+88CRGaRNZ
         iSUD3KU/Ikp0+pJ3S4NqtJjleSN+g2bUHgovtYRPanpE4WyA16HW2YmMGQxabX79cn
         0XdyEJl7yKzwBThl2+xrR8iNJ9DPke3pGiteje3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 100/252] ARM: dts: imx6q-prti6q: fix PHY address
Date:   Mon, 23 Nov 2020 13:20:50 +0100
Message-Id: <20201123121840.406995242@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit e402599e5e5e0b2758d7766fd9f6d7953d4ccd85 ]

Due to bug in the bootloader, the PHY has floating address and may
randomly change on each PHY reset. To avoid it, the updated bootloader
with the following patch[0] should be used:

| ARM: protonic: disable on-die termination to fix PHY bootstrapping
|
| If on-die termination is enabled, the RXC pin of iMX6 will be pulled
| high. Since we already have an 10K pull-down on board, the RXC level on
| PHY reset will be ~800mV, which is mostly interpreted as 1. On some
| reboots we get 0 instead and kernel can't detect the PHY properly.
|
| Since the default 0x020e07ac value is 0, it is sufficient to remove this
| entry from the affected imxcfg files.
|
| Since we get stable 0 on pin PHYADDR[2], the PHY address is changed from
| 4 to 0.

With latest bootloader update, the PHY address will be fixed to "0".

[0] https://git.pengutronix.de/cgit/barebox/commit/?id=93f7dcf631edfcda19e7757b28d66017ea274b81

Fixes: 0d446a505592 ("ARM: dts: add Protonic PRTI6Q board")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-prti6q.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-prti6q.dts b/arch/arm/boot/dts/imx6q-prti6q.dts
index de6cbaab8b499..671bb3a6665d8 100644
--- a/arch/arm/boot/dts/imx6q-prti6q.dts
+++ b/arch/arm/boot/dts/imx6q-prti6q.dts
@@ -213,8 +213,8 @@
 		#size-cells = <0>;
 
 		/* Microchip KSZ9031RNX PHY */
-		rgmii_phy: ethernet-phy@4 {
-			reg = <4>;
+		rgmii_phy: ethernet-phy@0 {
+			reg = <0>;
 			interrupts-extended = <&gpio1 28 IRQ_TYPE_LEVEL_LOW>;
 			reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <10000>;
-- 
2.27.0



