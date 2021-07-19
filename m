Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8953CE2A1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345967AbhGSPbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347873AbhGSPXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:23:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F16EC61376;
        Mon, 19 Jul 2021 15:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710393;
        bh=LDL4Bqi17LueZ8n7BQx1SbwuFjKuWJ/E8uFrCXGqHxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOUFcPV6Odtn75YLh3BQ5zCJ7Svf00gduqB+aYx7o5IVISjEGV6VVJGPraZacfJOH
         lcoYAc4Aqo0lImXGHPfq65DhZSI5k8IqOqoJ3cIpAFx6rlZu+ZwAXjiFHYi9Qwon/e
         GoQBeTEM2FVv+i5H0RONIkJKEqMe9ZcT8MkOThBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "B.R. Oake" <broake@mailfence.com>,
        Vagrant Cascadian <vagrant@reproducible-builds.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/243] ARM: dts: sun8i: h3: orangepi-plus: Fix ethernet phy-mode
Date:   Mon, 19 Jul 2021 16:53:47 +0200
Message-Id: <20210719144947.321830593@linuxfoundation.org>
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

From: Salvatore Bonaccorso <carnil@debian.org>

[ Upstream commit b19d3479f25e8a0ff24df0b46c82e50ef0f900dd ]

Commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay
config") sets the RX/TX delay according to the phy-mode property in the
device tree. For the Orange Pi Plus board this is "rgmii", which is the
wrong setting.

Following the example of a900cac3750b ("ARM: dts: sun7i: a20: bananapro:
Fix ethernet phy-mode") the phy-mode is changed to "rgmii-id" which gets
the Ethernet working again on this board.

Fixes: bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay config")
Reported-by: "B.R. Oake" <broake@mailfence.com>
Reported-by: Vagrant Cascadian <vagrant@reproducible-builds.org>
Link: https://bugs.debian.org/988574
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210524122111.416885-1-carnil@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts b/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts
index 97f497854e05..d05fa679dcd3 100644
--- a/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts
+++ b/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts
@@ -85,7 +85,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 
 	status = "okay";
 };
-- 
2.30.2



