Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D7A16A86A
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 15:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgBXOew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 09:34:52 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6094 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbgBXOew (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 09:34:52 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e53debf0001>; Mon, 24 Feb 2020 06:33:35 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 24 Feb 2020 06:34:51 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 24 Feb 2020 06:34:51 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Feb
 2020 14:34:50 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Feb 2020 14:34:50 +0000
Received: from thunderball.nvidia.com (Not Verified[10.21.140.91]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5e53df090001>; Mon, 24 Feb 2020 06:34:50 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/4] ARM64: Tegra: Enable I2C controller for EEPROM
Date:   Mon, 24 Feb 2020 14:34:33 +0000
Message-ID: <20200224143436.5438-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582554815; bh=SKhUz0YkoB6pD4YoE/4KFxZbYw2qmSp519cZdmcBM3o=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=duOxTEf6wTpBnmdA4GzgtJ0CYXr5t34ZZNN48pc9hExmRqaCcppGHAY2wcXqnjNmL
         YwvDy0gfFikGS9gPJKICW2X6f4iOcgfnVhYOWdgnzSFD1bhtOoN+bEcXPC+LRDY89m
         uAwuuKQR4MMohz9C8MW8xyatlc13ZEU0jeW1+S3PYfX2GhwRUooeFCGnmLUso5s2DZ
         65p26CoCGdQNBARsw2TNevBzLshNSXvHBdlFiKSs4S0hB7yJJrCwZx2JsjOm+aRtb3
         dgVHvAZAd8GLLKC8NvPCAhbIRhDt0vkyWmqHnB5suduti7g4QA1Eb8HLAXB5ptvzeK
         jor+qP+NC8CVQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a5b6b67364cb ("arm64: tegra: Add ID EEPROM for Jetson TX1
module") populated the EEPROM on the Jetson TX1 module, but did not
enable the corresponding I2C controller. Enable the I2C controller so
that this EEPROM can be accessed.

Fixes: a5b6b67364cb ("arm64: tegra: Add ID EEPROM for Jetson TX1 module")

Cc: <stable@vger.kernel.org>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
index cb58f79deb48..95b1a6e76e6e 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
@@ -265,6 +265,8 @@
 	};
 
 	i2c@7000c500 {
+		status = "okay";
+
 		/* module ID EEPROM */
 		eeprom@50 {
 			compatible = "atmel,24c02";
-- 
2.17.1

