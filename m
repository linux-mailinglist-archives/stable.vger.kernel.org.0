Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8053E105F7C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfKVFTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:19:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbfKVFTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:19:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3D9F2070E;
        Fri, 22 Nov 2019 05:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574399950;
        bh=WszExPIIwxHba7R4ODtPaqd+zT5cyG2VdXTU71sfmK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgfB+JKlqxd8cuzwjFKQkc5EFUrZGh0nO9laUkh+K1eHgRw/6IVikelMWnfzItqnB
         BTINs6rACd+qXDccDKPz0c3FdFzPrrvVuZ8zxQs476UXDvirRRZm4q3P0Ynd1pBlTZ
         a2YlQEqcCzovnOYaGKNxAN3jrstpjLqU9jXD1uRc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ding Tao <miyatsu@qq.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 004/219] arm64: dts: marvell: armada-37xx: Enable emmc on espressobin
Date:   Fri, 22 Nov 2019 00:15:28 -0500
Message-Id: <20191122051903.31749-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122051903.31749-1-sashal@kernel.org>
References: <20191122051903.31749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Tao <miyatsu@qq.com>

[ Upstream commit 43ebc7c1b3ed8198b9acf3019eca16e722f7331c ]

The ESPRESSObin board has a emmc interface available on U11: declare it
and let the bootloader enable it if the emmc is present.

[gregory.clement@bootlin.com: disable the emmc by default]
Signed-off-by: Ding Tao <miyatsu@qq.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/marvell/armada-3720-espressobin.dts   | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
index 3ab25ad402b90..846003bb480cd 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
@@ -60,9 +60,31 @@
 	cd-gpios = <&gpionb 3 GPIO_ACTIVE_LOW>;
 	marvell,pad-type = "sd";
 	vqmmc-supply = <&vcc_sd_reg1>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdio_pins>;
 	status = "okay";
 };
 
+/* U11 */
+&sdhci0 {
+	non-removable;
+	bus-width = <8>;
+	mmc-ddr-1_8v;
+	mmc-hs400-1_8v;
+	marvell,xenon-emmc;
+	marvell,xenon-tun-count = <9>;
+	marvell,pad-type = "fixed-1-8v";
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc_pins>;
+/*
+ * This eMMC is not populated on all boards, so disable it by
+ * default and let the bootloader enable it, if it is present
+ */
+	status = "disabled";
+};
+
 &spi0 {
 	status = "okay";
 
-- 
2.20.1

