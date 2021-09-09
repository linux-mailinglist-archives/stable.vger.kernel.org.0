Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C22404F5E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351115AbhIIMSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347409AbhIIMP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CB5561263;
        Thu,  9 Sep 2021 11:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188174;
        bh=aqB/eixK9h34x4z7TYFN5+h1bz4ed0d3NHrCqDZ7MxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krUatQmaPhyx34uQ2PMUs+i7h9zo6jqplAxOzZWKmNIzKEnRr1I3bjBBMtVuLXfzC
         n78bLtW38KdPzyUf/sYKxDO9S0NIh9+AjCHN+oeNx/caq7GCLP4pWvuXB21mP17Yy8
         Z7ZiRo6vcQ7OJBBEMRNj/NbSyTmwroJPTFwQkBbD4OGzZAgsYo/gLhjWWF+BlQPdjB
         AYImgX+wMG07keivSGki1UVz64e4W5AiJR4P8XJLHJvUV+XXXaQ9VTq5JiAfokWl6m
         hHX8j5sioM7KW4Z+5Jq0IdEa4nUPq7ccn2V5zyiVIz3Icpbfk+YIuZwMi/nOL9BKVN
         LxvGS84uugtfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raag Jadav <raagjadav@gmail.com>, Li Yang <leoyang.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 138/219] arm64: dts: ls1046a: fix eeprom entries
Date:   Thu,  9 Sep 2021 07:45:14 -0400
Message-Id: <20210909114635.143983-138-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 60acdf0b689e..7025aad8ae89 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
@@ -59,14 +59,9 @@ temp-sensor@4c {
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

