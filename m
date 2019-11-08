Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B8DF5639
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389019AbfKHTHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:07:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:38202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390878AbfKHTHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:07:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A39EE206A3;
        Fri,  8 Nov 2019 19:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240049;
        bh=4m9W6+lCWhClJDg8hqJlF4rraD1V7K6uCv5L3Br1eR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSJCuUvzWiwilXh/YnSe949I61tj5wv4CQ6pgxkX05qXGOwLcO157maA8IlMdL8I8
         cFktGx4UV+7zEXGb3HF5KhFp4FBBxqnG/f0wNr7/R96wGxFaXCKK8DT67AYooGAEv0
         bGz4h3Alo1K2DciqxPF9DYwiZO7X4bGjoURdhhtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 029/140] arm64: dts: zii-ultra: fix ARM regulator states
Date:   Fri,  8 Nov 2019 19:49:17 +0100
Message-Id: <20191108174905.506865955@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 21094ba5c1f4b15df096e8f6247a50b6ab57c869 ]

The GPIO controlled regulator for the ARM power supply is supplying
the higher voltage when the GPIO is driven high. This is opposite to
the similar regulator setup on the EVK board and is impacting stability
of the board as the ARM domain has been supplied with a too low voltage
when to faster OPPs are in use.

Fixes: 4a13b3bec3b4 (arm64: dts: imx: add Zii Ultra board support)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi b/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
index 7a1706f969f09..3faa652fdf20d 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
@@ -101,8 +101,8 @@
 		regulator-min-microvolt = <900000>;
 		regulator-max-microvolt = <1000000>;
 		gpios = <&gpio3 19 GPIO_ACTIVE_HIGH>;
-		states = <1000000 0x0
-		           900000 0x1>;
+		states = <1000000 0x1
+		           900000 0x0>;
 		regulator-always-on;
 	};
 };
-- 
2.20.1



