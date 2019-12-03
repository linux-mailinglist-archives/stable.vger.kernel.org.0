Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9238111F4E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfLCWrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729284AbfLCWrP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBA842084B;
        Tue,  3 Dec 2019 22:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413234;
        bh=qxxjYPnh4PQsTATEX/9F4QwWxNBeIk0vs4XPtZpHA2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jh5WenqYfk6PzSORCcFjFpHfMkxz++upRbcxiI3xBFXBjwOjVoBaLKdtA+2YpvMp8
         53E+8hr/our4Cho14CqC4tAP41JibMJutTx85aMx5ujjZWehMYsY7TSp3Nf9IQhmb0
         OwKgP42wk4YBQFCrYrwTXoxALa0K+jTgjxOeoDfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/321] ARM: dts: Fix up SQ201 flash access
Date:   Tue,  3 Dec 2019 23:31:57 +0100
Message-Id: <20191203223429.817549855@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



