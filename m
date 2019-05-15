Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C5C1ED22
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfEOLFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbfEOLFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:05:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EED6A216FD;
        Wed, 15 May 2019 11:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918337;
        bh=sgZSSDMED22/aKLOlCAcmow8+TnAKPF7apieVi8FTq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SH9xqn5a4fWMxoEKSx07HWa76L6g6cWmUAVKRhgsXnknOyQecNhx0j2P1kr0rxcRk
         kvKpulyzMoTben2i0QNAhDf1kvEbbyZ5SDk7/krXFM6a0saU8Y9rDalFLPbe+ftkvB
         QqYGFU8ymiHBADJbCP+GTF0PstHaxCg0pYNYc6bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Christ <s.christ@phytec.de>,
        Christian Hemp <c.hemp@phytec.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.4 095/266] ARM: dts: pfla02: increase phy reset duration
Date:   Wed, 15 May 2019 12:53:22 +0200
Message-Id: <20190515090725.662678460@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 032f85c9360fb1a08385c584c2c4ed114b33c260 ]

Increase the reset duration to ensure correct phy functionality. The
reset duration is taken from barebox commit 52fdd510de ("ARM: dts:
pfla02: use long enough reset for ethernet phy"):

  Use a longer reset time for ethernet phy Micrel KSZ9031RNX. Otherwise a
  small percentage of modules have 'transmission timeouts' errors like

  barebox@Phytec phyFLEX-i.MX6 Quad Carrier-Board:/ ifup eth0
  warning: No MAC address set. Using random address 7e:94:4d:02:f8:f3
  eth0: 1000Mbps full duplex link detected
  eth0: transmission timeout
  T eth0: transmission timeout
  T eth0: transmission timeout
  T eth0: transmission timeout
  T eth0: transmission timeout

Cc: Stefan Christ <s.christ@phytec.de>
Cc: Christian Hemp <c.hemp@phytec.de>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Fixes: 3180f956668e ("ARM: dts: Phytec imx6q pfla02 and pbab01 support")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
index d6d98d426384..cae04e806036 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
@@ -90,6 +90,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
+	phy-reset-duration = <10>; /* in msecs */
 	phy-reset-gpios = <&gpio3 23 GPIO_ACTIVE_LOW>;
 	phy-supply = <&vdd_eth_io_reg>;
 	status = "disabled";
-- 
2.19.1



