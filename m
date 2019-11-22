Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B19105F8C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfKVFUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:20:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfKVFU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:20:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 658552070B;
        Fri, 22 Nov 2019 05:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574400026;
        bh=JpUGC9nWCZCTQes37a4qys2DDjrsol2d6dZ4/1Ex844=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUOMAxeS8tx10N4MT8XMlqnIAmo78PHTr7KUR2I5QrK5t1967Qe9NUhzzK7tka+Pc
         jPk8+WEPfEhEP4RnhtNAApszml02SYLtYcabGj/1XCYOHkDtTkNewCIOz8PFen3+0H
         f0/RKHpNgJ1JQc6GF2r63eQokdEqnt0yeWosdQD4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 003/127] ARM: dts: Fix up SQ201 flash access
Date:   Fri, 22 Nov 2019 00:18:17 -0500
Message-Id: <20191122052021.32062-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122052021.32062-1-sashal@kernel.org>
References: <20191122052021.32062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit d88b11ef91b15d0af9c0676cbf4f441a0dff0c56 ]

This sets the partition information on the SQ201 to be read
out from the RedBoot partition table, removes the static
partition table and sets our boot options to mount root from
/dev/mtdblock2 where the squashfs+JFFS2 resides.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini-sq201.dts | 37 ++++--------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

diff --git a/arch/arm/boot/dts/gemini-sq201.dts b/arch/arm/boot/dts/gemini-sq201.dts
index 63c02ca9513c4..e9e2f6ff0c583 100644
--- a/arch/arm/boot/dts/gemini-sq201.dts
+++ b/arch/arm/boot/dts/gemini-sq201.dts
@@ -20,7 +20,7 @@
 	};
 
 	chosen {
-		bootargs = "console=ttyS0,115200n8";
+		bootargs = "console=ttyS0,115200n8 root=/dev/mtdblock2 rw rootfstype=squashfs,jffs2 rootwait";
 		stdout-path = &uart0;
 	};
 
@@ -71,37 +71,10 @@
 			/* 16MB of flash */
 			reg = <0x30000000 0x01000000>;
 
-			partition@0 {
-				label = "RedBoot";
-				reg = <0x00000000 0x00120000>;
-				read-only;
-			};
-			partition@120000 {
-				label = "Kernel";
-				reg = <0x00120000 0x00200000>;
-			};
-			partition@320000 {
-				label = "Ramdisk";
-				reg = <0x00320000 0x00600000>;
-			};
-			partition@920000 {
-				label = "Application";
-				reg = <0x00920000 0x00600000>;
-			};
-			partition@f20000 {
-				label = "VCTL";
-				reg = <0x00f20000 0x00020000>;
-				read-only;
-			};
-			partition@f40000 {
-				label = "CurConf";
-				reg = <0x00f40000 0x000a0000>;
-				read-only;
-			};
-			partition@fe0000 {
-				label = "FIS directory";
-				reg = <0x00fe0000 0x00020000>;
-				read-only;
+			partitions {
+				compatible = "redboot-fis";
+				/* Eraseblock at 0xfe0000 */
+				fis-index-block = <0x1fc>;
 			};
 		};
 
-- 
2.20.1

