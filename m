Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711944057C1
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354286AbhIINmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349635AbhIIMrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F75C630EA;
        Thu,  9 Sep 2021 11:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188593;
        bh=KLmTTQAd45LNcwwzP1tGD7nUWALbuyAXRThSa/Pr//0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZW5c7WUEAKvuy1wPefYRUcQD1aEVkobjh5JpRdUNER6PPwZZsm4dr9ZTgEIFBEZm
         BeFzSEVfJRLzBP0Xye/TJMCgqYHPjwmR6ubWJ+Rd0bTbO1M4KDdwE+u2Gn4R3L+vWR
         pmo7R3UNxQbqoN/fNgHatrcS3V9wBrrJGWqb1o43aOa41JKv3kqBrNj3SXxwfqiitP
         HpBpCupqSizz8cMSg3Qbpja6VFAE4hlHf6WcluExZq2yd2PXB0iSYdiaPYfXALAUG/
         0emP4O2CcFj9LvmoD5/I1epW205EGtcz6ZJsdduKMmDadP/F+DRyYu0U2YpzJ+mIgQ
         UdUF4IFVc9lag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raag Jadav <raagjadav@gmail.com>, Li Yang <leoyang.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 067/109] arm64: dts: ls1046a: fix eeprom entries
Date:   Thu,  9 Sep 2021 07:54:24 -0400
Message-Id: <20210909115507.147917-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raag Jadav <raagjadav@gmail.com>

[ Upstream commit c1a6018d1839c9cb8f807dc863a50102a1a5c412 ]

ls1046afrwy and ls1046ardb boards have CAT24C04[1] and CAT24C05[2]
eeproms respectively. Both are 4Kb (512 bytes) in size,
and compatible with AT24C04[3].
Remove multi-address entries, as both the boards have a single chip each.

[1] https://www.onsemi.com/pdf/datasheet/cat24c01-d.pdf
[2] https://www.onsemi.com/pdf/datasheet/cat24c03-d.pdf
[3] https://ww1.microchip.com/downloads/en/DeviceDoc/doc0180.pdf

Signed-off-by: Raag Jadav <raagjadav@gmail.com>
Acked-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts | 8 +-------
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts  | 7 +------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts
index 3595be0f2527..2d6c73d7d397 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts
@@ -83,15 +83,9 @@ rtc@51 {
 			};
 
 			eeprom@52 {
-				compatible = "atmel,24c512";
+				compatible = "onnn,cat24c04", "atmel,24c04";
 				reg = <0x52>;
 			};
-
-			eeprom@53 {
-				compatible = "atmel,24c512";
-				reg = <0x53>;
-			};
-
 		};
 	};
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
index 274339759114..8858c1e92f23 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
@@ -58,14 +58,9 @@ temp-sensor@4c {
 	};
 
 	eeprom@52 {
-		compatible = "atmel,24c512";
+		compatible = "onnn,cat24c05", "atmel,24c04";
 		reg = <0x52>;
 	};
-
-	eeprom@53 {
-		compatible = "atmel,24c512";
-		reg = <0x53>;
-	};
 };
 
 &i2c3 {
-- 
2.30.2

