Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6DB26B5A9
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgIOXso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbgIOOcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17F6023731;
        Tue, 15 Sep 2020 14:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179856;
        bh=h1uH8Qkt3dvAqyDoC5+z/X5vEb4Cn5p7spXkszgoEbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDKqK8QnBS1oUhfud5bNpgM/1EJAqHMC8x32sgBZYubrPc8zhqkIrMCUd0Kkn2Rfx
         Rl3iqL1Vv2ifcLCpDKbm/fEa4SYw0zn86jSW16pIhp45RzB4aijve8t55TKpTIIJsx
         FBrZvj54OpFL6TaJ9DV03v3C84xoZuEMPoNDk+Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 013/177] ARM: dts: imx7d-zii-rmu2: fix rgmii phy-mode for ksz9031 phy
Date:   Tue, 15 Sep 2020 16:11:24 +0200
Message-Id: <20200915140654.275884239@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Healy <cphealy@gmail.com>

[ Upstream commit 5cbb80d5236b47b149da292b86d5fc99a680894b ]

Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the
KSZ9031 PHY") the networking is broken on the imx7d-zii-rmu2 board.

The end result is that network receive behaviour is marginal with lots of
RX CRC errors experienced and NFS frequently failing.

Quoting the explanation from Andrew Lunn in commit 0672d22a19244
("ARM: dts: imx: Fix the AR803X phy-mode"):

"The problem here is, all the DTs were broken since day 0. However,
because the PHY driver was also broken, nobody noticed and it
worked. Now that the PHY driver has been fixed, all the bugs in the
DTs now become an issue"

Fix it by switching to phy-mode = "rgmii-id".

Fixes: bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
Signed-off-by: Chris Healy <cphealy@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d-zii-rmu2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7d-zii-rmu2.dts b/arch/arm/boot/dts/imx7d-zii-rmu2.dts
index e5e20b07f184b..7cb6153fc650b 100644
--- a/arch/arm/boot/dts/imx7d-zii-rmu2.dts
+++ b/arch/arm/boot/dts/imx7d-zii-rmu2.dts
@@ -58,7 +58,7 @@
 			  <&clks IMX7D_ENET1_TIME_ROOT_CLK>;
 	assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_100M_CLK>;
 	assigned-clock-rates = <0>, <100000000>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&fec1_phy>;
 	status = "okay";
 
-- 
2.25.1



