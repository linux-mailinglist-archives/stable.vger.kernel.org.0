Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388D247B700
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 02:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhLUB55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhLUB54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:57:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97F2C061574;
        Mon, 20 Dec 2021 17:57:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7008AB810D9;
        Tue, 21 Dec 2021 01:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24922C36AE5;
        Tue, 21 Dec 2021 01:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051874;
        bh=MF0eNFJRJARBRnTNa6hHpQ/Rs3ZB3qikLkkVFdKAfak=;
        h=From:To:Cc:Subject:Date:From;
        b=B53Q89pcH5PZFHm7enwkb9EzZXDqbDYfGLe1uU3Nn3MK0Q6+5c8J59ieOVZad+rwI
         TwWb9QtZ2IqHOo1TwPNpx0FB/O2yxKFY8sacoEG32jHb4iGb1+alt4UF6jCGWy+xNu
         DhQviNJzwSnrKiCoJhyx1StIhL7mOzXmjRUmZT+s1G6vkJZrY1MUqgOgJ6e0VD4F7W
         FHFo7NbtVegZP/9WUaPE7wpFC1e/9lKqvVkJFO2sfHwQRGY4Xf09qUj/wV8efNwNDH
         ygOqbercNyuhmLdwS3Sblc2Lx0+8Y11UK2iS3hnAnRAe3X6obbsow5lGLhVLKv5DTJ
         yIy+6wbf7pAMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 01/29] ARM: dts: imx6qp-prtwd3: update RGMII delays for sja1105 switch
Date:   Mon, 20 Dec 2021 20:57:22 -0500
Message-Id: <20211221015751.116328-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit f2c2e9ebb2cf476c09e59d073db031fbf7ef4914 ]

In the new behavior, the sja1105 driver expects there to be explicit
RGMII delays present on the fixed-link ports, otherwise it will complain
that it falls back to legacy behavior, which is to apply RGMII delays
incorrectly derived from the phy-mode string.

In this case, the legacy behavior of the driver is to apply both RX and
TX delays. To preserve that, add explicit 2 nanosecond delays, which are
identical with what the driver used to add (a 90 degree phase shift).
The delays from the phy-mode are ignored by new kernels (it's still
RGMII as long as it's "rgmii*" something), and the explicit
{rx,tx}-internal-delay-ps properties are ignored by old kernels, so the
change works both ways.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qp-prtwd3.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qp-prtwd3.dts b/arch/arm/boot/dts/imx6qp-prtwd3.dts
index b92e0f2748a51..29dd59bfa73dd 100644
--- a/arch/arm/boot/dts/imx6qp-prtwd3.dts
+++ b/arch/arm/boot/dts/imx6qp-prtwd3.dts
@@ -178,6 +178,8 @@ port@4 {
 				label = "cpu";
 				ethernet = <&fec>;
 				phy-mode = "rgmii-id";
+				rx-internal-delay-ps = <2000>;
+				tx-internal-delay-ps = <2000>;
 
 				fixed-link {
 					speed = <100>;
-- 
2.34.1

