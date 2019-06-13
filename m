Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE8E43FD7
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbfFMQAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731460AbfFMIsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:48:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EC2520851;
        Thu, 13 Jun 2019 08:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415732;
        bh=1VYTss3DUZnvcOvubZtWzUDzOLn+kn01EugPZXhZC5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOnAEHxzR/NdKlH3vTMGle9zD22xg0Hj+TwDd+NVdkRkT1TprhqL04yvgrluUeRBh
         TcDxQszBOjdbLTfBJcbBhyKunW2wqOhOfDwXmd5aZY+hQiJbpPv3WROEV3+n8P8YH1
         LNMkB3pzaud8naetUkYev8DNGPOqk801eVrjsApQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Smirnov <andrew.smirnov@gmail.com>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 107/155] ARM: dts: imx53: Specify IMX5_CLK_IPG as "ahb" clock to SDMA
Date:   Thu, 13 Jun 2019 10:33:39 +0200
Message-Id: <20190613075658.982430442@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 28c168018e0902c67eb9c60d0fc4c8aa166c4efe ]

Since 25aaa75df1e6 SDMA driver uses clock rates of "ipg" and "ahb"
clock to determine if it needs to configure the IP block as operating
at 1:1 or 1:2 clock ratio (ACR bit in SDMAARM_CONFIG). Specifying both
clocks as IMX5_CLK_SDMA results in driver incorrectly thinking that
ratio is 1:1 which results in broken SDMA funtionality. Fix the code
to specify IMX5_CLK_AHB as "ahb" clock for SDMA, to avoid detecting
incorrect clock ratio.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Angus Ainslie (Purism) <angus@akkea.ca>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Fabio Estevam <fabio.estevam@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index b3300300aabe..9b672ed2486d 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -702,7 +702,7 @@
 				reg = <0x63fb0000 0x4000>;
 				interrupts = <6>;
 				clocks = <&clks IMX5_CLK_SDMA_GATE>,
-					 <&clks IMX5_CLK_SDMA_GATE>;
+					 <&clks IMX5_CLK_AHB>;
 				clock-names = "ipg", "ahb";
 				#dma-cells = <3>;
 				fsl,sdma-ram-script-name = "imx/sdma/sdma-imx53.bin";
-- 
2.20.1



