Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB97D11B57A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732369AbfLKPyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:54:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732101AbfLKPSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04D332073D;
        Wed, 11 Dec 2019 15:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077489;
        bh=YENSJB8KW4L7MlKMsQeYRD5sdXJJ44x2fE4JG3/ST58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUTuK/oVUJjv4mbPaQngr7Vd1ciBkLO78dw4wX4iz3SC21CXdwv39ewGX5ciswgYL
         l+kM/72BbIXrCw/1nLkbgaIGQKUhOcLP7iqntCwZdc4CxM3/LuWRUYI3ywikDFBlxW
         MvqZlHJmPUu/8oktKu3oDWG8uVSiBaIXCxILKdsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/243] ARM: dts: imx6: RDU2: fix eGalax touchscreen node
Date:   Wed, 11 Dec 2019 16:03:39 +0100
Message-Id: <20191211150342.953226712@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 749a5068f2e2453a38777b1d5fc322d503cabf1d ]

Use the correct compatible for the new protocol used by the firmware
on the touch controller, the GPIO wakeup isn't used in that case.
Also eGalax touch needs axis swapping, just as with the RMI4 touch.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi b/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
index 7fff3717cf7c0..315d0e7615f33 100644
--- a/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
@@ -609,13 +609,14 @@
 	};
 
 	touchscreen@2a {
-		compatible = "eeti,egalax_ts";
+		compatible = "eeti,exc3000";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_ts>;
 		reg = <0x2a>;
 		interrupt-parent = <&gpio1>;
 		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
-		wakeup-gpios = <&gpio1 8 GPIO_ACTIVE_LOW>;
+		touchscreen-inverted-x;
+		touchscreen-swapped-x-y;
 		status = "disabled";
 	};
 
-- 
2.20.1



