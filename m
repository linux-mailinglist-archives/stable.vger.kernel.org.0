Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81EBA105FDF
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfKVF15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:27:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbfKVF1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:27:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BF3920708;
        Fri, 22 Nov 2019 05:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574400468;
        bh=qxxjYPnh4PQsTATEX/9F4QwWxNBeIk0vs4XPtZpHA2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVKAQQAFBkXOalOJqT53cdb0ZeA/GVnf/RjwvJJv8/4+9Xjkrpu9D/JMgmsNHNrNA
         xXqGIgZWd3iTxb4xsSYfCtMasN8zkKS10o6afskEHvYu5bY1CPpWXsJyUCKYnmjKCz
         tGG+5N6k6UW4Mzj2DTznV5kigInMMb3gzU4if0JY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 005/219] ARM: dts: Fix up SQ201 flash access
Date:   Fri, 22 Nov 2019 00:24:07 -0500
Message-Id: <20191122052741.32499-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122052741.32499-1-sashal@kernel.org>
References: <20191122052741.32499-1-sashal@kernel.org>
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
index 3787cf3763c41..e9e4a8a02600b 100644
--- a/arch/arm/boot/dts/gemini-sq201.dts
+++ b/arch/arm/boot/dts/gemini-sq201.dts
@@ -20,7 +20,7 @@
 	};
 
 	chosen {
-		bootargs = "console=ttyS0,115200n8";
+		bootargs = "console=ttyS0,115200n8 root=/dev/mtdblock2 rw rootfstype=squashfs,jffs2 rootwait";
 		stdout-path = &uart0;
 	};
 
@@ -138,37 +138,10 @@
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

