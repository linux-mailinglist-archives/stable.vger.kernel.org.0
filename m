Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EB81F2320
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgFHXMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgFHXMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6FE5214F1;
        Mon,  8 Jun 2020 23:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657970;
        bh=eCdWYHv8EcvxTFVDZa4tARPB5ii607RoSfNA5U3lK6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKLy+PXM+4ek5uyjAcDeQJH4L8kdhc1+hxQ8tSvuqqUpApJXfUAwyjBry/r6BtzcJ
         eEKdeUIwnguAT0aXyXOrWNPS2YF71UE4z102R2VT2Re//dS+xgTp+YqdCj/G2yt57o
         bK4CcCqiC2sGT3ifsXSe0d57Xi5Zi2lMj4oUADqs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 033/606] ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries
Date:   Mon,  8 Jun 2020 19:02:38 -0400
Message-Id: <20200608231211.3363633-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 0caf34350a25907515d929a9c77b9b206aac6d1e upstream.

The I2C2 pins are already used and the following errors are seen:

imx27-pinctrl 10015000.iomuxc: pin MX27_PAD_I2C2_SDA already requested by 10012000.i2c; cannot claim for 1001d000.i2c
imx27-pinctrl 10015000.iomuxc: pin-69 (1001d000.i2c) status -22
imx27-pinctrl 10015000.iomuxc: could not request pin 69 (MX27_PAD_I2C2_SDA) from group i2c2grp  on device 10015000.iomuxc
imx-i2c 1001d000.i2c: Error applying setting, reverse things back
imx-i2c: probe of 1001d000.i2c failed with error -22

Fix it by adding the correct I2C1 IOMUX entries for the pinctrl_i2c1 group.

Cc: <stable@vger.kernel.org>
Fixes: 61664d0b432a ("ARM: dts: imx27 phyCARD-S pinctrl")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Stefan Riedmueller <s.riedmueller@phytec.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts b/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
index 0cd75dadf292..188639738dc3 100644
--- a/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
+++ b/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
@@ -75,8 +75,8 @@ &iomuxc {
 	imx27-phycard-s-rdk {
 		pinctrl_i2c1: i2c1grp {
 			fsl,pins = <
-				MX27_PAD_I2C2_SDA__I2C2_SDA 0x0
-				MX27_PAD_I2C2_SCL__I2C2_SCL 0x0
+				MX27_PAD_I2C_DATA__I2C_DATA 0x0
+				MX27_PAD_I2C_CLK__I2C_CLK 0x0
 			>;
 		};
 
-- 
2.25.1

