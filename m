Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4995629B54C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794214AbgJ0PKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794211AbgJ0PKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE3D206F4;
        Tue, 27 Oct 2020 15:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811433;
        bh=TQv5VhVBsW2PTEERVq0HWMxxf5mFqzr8iGBpG0i2QE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gH9tBBJL3+vPj8EEb9fWG/Uy2Uw0w380Sz/cpp84AsYBwi9+R7gzjxSHJV6Fl2R41
         5JaqtdeRmFlwD/EpUGnAgj4YKGdZjVijr++I46yR2PxLa5CfpIlUCck9uClZTgjYSY
         79tn5a5/eXf95hyvQl8k+sLIi+dMAgM2Ay+iZdLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 492/633] arm64: dts: imx8mq: Add missing interrupts to GPC
Date:   Tue, 27 Oct 2020 14:53:55 +0100
Message-Id: <20201027135545.816826039@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 791619f66843a213784efb2f171be98933bad991 ]

The i.MX General Power Controller v2 device node was missing interrupts
property necessary to route its interrupt to GIC.  This also fixes the
dbts_check warnings like:

  arch/arm64/boot/dts/freescale/imx8mq-evk.dt.yaml: gpc@303a0000:
    {'compatible': ... '$nodename': ['gpc@303a0000']} is not valid under any of the given schemas
  arch/arm64/boot/dts/freescale/imx8mq-evk.dt.yaml: gpc@303a0000: 'interrupts' is a required property

Fixes: fdbcc04da246 ("arm64: dts: imx8mq: add GPC power domains")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 66ac66856e7e8..077e12a0de3f9 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -614,6 +614,7 @@ src: reset-controller@30390000 {
 			gpc: gpc@303a0000 {
 				compatible = "fsl,imx8mq-gpc";
 				reg = <0x303a0000 0x10000>;
+				interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&gic>;
 				interrupt-controller;
 				#interrupt-cells = <3>;
-- 
2.25.1



