Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD15740E08E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241626AbhIPQWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241768AbhIPQUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:20:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4801061268;
        Thu, 16 Sep 2021 16:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808860;
        bh=bXd0XILONge7uFoWc+BDvqYnrBLisRONyyx29I2aG64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYKS3NFYNeFO1LnhX6YRlDjJf+zi9Jj5Z/JEoiHeizZb+iZ0wULWb4bPBGuDEEjZp
         1/E8U1TGoFEIM0qNhc1jv2jhoaLsZaabFDRd0T2udG6ntjSY0HCJIiDpx55DD3tY9C
         8u+LENkMh/IFpO7bp0WTcpeBXl0JyKFpwEW1flNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raag Jadav <raagjadav@gmail.com>,
        Li Yang <leoyang.li@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/306] arm64: dts: ls1046a: fix eeprom entries
Date:   Thu, 16 Sep 2021 17:59:22 +0200
Message-Id: <20210916155801.445274806@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index db3d303093f6..6d22efbd645c 100644
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
index d53ccc56bb63..07139e35686d 100644
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



