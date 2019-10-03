Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACD5CA4E2
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390477AbfJCQ3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391569AbfJCQ3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:29:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C871020700;
        Thu,  3 Oct 2019 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120141;
        bh=wKwjfWM+JCA0f7UO0uWQrgxnwNMKaVWWUO0lVQf5ynI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a76UlBZjg2nPOoBDw6Nj0Xip40gFPqEazOMpXwD6ukCJumhqYCCDx5OuN5QKUeCjY
         iGb8vI2MFUzXVPCa2GGx6XVLJvt2TachjVIxtj3g0FSxx6x45mqeUb3JT2Cfrnaa2v
         E6tDpyR6dQIii7Q9q4olJURI5LJMmf9m+YaTSEvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan.agner@toradex.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 111/313] ARM: dts: imx7-colibri: disable HS400
Date:   Thu,  3 Oct 2019 17:51:29 +0200
Message-Id: <20191003154543.769491448@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan.agner@toradex.com>

[ Upstream commit a95fbda08ee20cd063ce5826e0df95a2c22ea8c5 ]

Force HS200 by masking bit 63 of the SDHCI capability register.
The i.MX ESDHC driver uses SDHCI_QUIRK2_CAPS_BIT63_FOR_HS400. With
that the stack checks bit 63 to descide whether HS400 is available.
Using sdhci-caps-mask allows to mask bit 63. The stack then selects
HS200 as operating mode.

This prevents rare communication errors with minimal effect on
performance:
	sdhci-esdhc-imx 30b60000.usdhc: warning! HS400 strobe DLL
		status REF not lock!

Signed-off-by: Stefan Agner <stefan.agner@toradex.com>
Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
Reviewed-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7-colibri.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx7-colibri.dtsi b/arch/arm/boot/dts/imx7-colibri.dtsi
index 895fbde4d4333..c1ed83131b495 100644
--- a/arch/arm/boot/dts/imx7-colibri.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri.dtsi
@@ -323,6 +323,7 @@
 	vmmc-supply = <&reg_module_3v3>;
 	vqmmc-supply = <&reg_DCDC3>;
 	non-removable;
+	sdhci-caps-mask = <0x80000000 0x0>;
 };
 
 &iomuxc {
-- 
2.20.1



