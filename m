Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A801E9FDC
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfJ3Pvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfJ3Pvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:47 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CC5620656;
        Wed, 30 Oct 2019 15:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450706;
        bh=4m9W6+lCWhClJDg8hqJlF4rraD1V7K6uCv5L3Br1eR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4Cz9i/xYPftaiEaiRBj0itIfgUjOylBdZZ0sgpBNODks06Sx8KZcTlVQzTu90lSY
         dHf/BR9v3ii9EeAFQ7WYj63hwg6YqjixquHS+1H+rsp8THH2kXWFhvicz8UrYrMzsI
         tATE0tS4/A3WPflUiUvodLaeRYFae24dJpEUS768=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 29/81] arm64: dts: zii-ultra: fix ARM regulator states
Date:   Wed, 30 Oct 2019 11:48:35 -0400
Message-Id: <20191030154928.9432-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

