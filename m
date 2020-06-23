Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DBD205DF5
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389673AbgFWUS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389667AbgFWUS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 928542080C;
        Tue, 23 Jun 2020 20:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943506;
        bh=NiNoKQsWrYuiM7i9TyVddiNvcbY15XcHo3EDEr0xVsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cI5tTV3/mkOGPy7mdwgpCO5XZwmpiNgO93EQCXCBIesTJU5s3f+9M3071OB8YasYu
         BVobSmulr79ftqJ3OzX5RRC8Q6ZyA3mQzCz/rRW93eck+RRTmL4eTR2DEZX8MgwPLm
         v+4sSY7b2AIiVq8UNE5o4bGV5RiQ43uYPBegHOLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        James Tai <james.tai@realtek.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Subject: [PATCH 5.7 419/477] arm64: dts: realtek: rtd129x: Carve out boot ROM from memory
Date:   Tue, 23 Jun 2020 21:56:56 +0200
Message-Id: <20200623195427.333741339@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Färber <afaerber@suse.de>

commit 3040e132beda2aee56e6ea9be8db69889bcb2e7a upstream.

Update DS418j, MeLE V9, PROBOX2 AVA, Zidoo X9S and DS418 /memory nodes
to exclude 0..0x1efff from reg entry and update unit address to match.
Add this region to /soc ranges and for now just update the /memreserve/s.

Suggested-by: Rob Herring <robh@kernel.org>
Fixes: 72a7786c0a0d ("ARM64: dts: Add Realtek RTD1295 and Zidoo X9S")
Fixes: d938a964a966 ("arm64: dts: realtek: Add ProBox2 Ava")
Fixes: a9ce6f854581 ("arm64: dts: realtek: Add MeLE V9")
Fixes: cf976f660ee8 ("arm64: dts: realtek: Add RTD1293 and Synology DS418j")
Fixes: 5133636e41a2 ("arm64: dts: realtek: Add RTD1296 and Synology DS418")
Cc: James Tai <james.tai@realtek.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/realtek/rtd1293-ds418j.dts      |    6 +++---
 arch/arm64/boot/dts/realtek/rtd1295-mele-v9.dts     |    6 +++---
 arch/arm64/boot/dts/realtek/rtd1295-probox2-ava.dts |    6 +++---
 arch/arm64/boot/dts/realtek/rtd1295-zidoo-x9s.dts   |    4 ++--
 arch/arm64/boot/dts/realtek/rtd1296-ds418.dts       |    4 ++--
 arch/arm64/boot/dts/realtek/rtd129x.dtsi            |    9 +++++----
 6 files changed, 18 insertions(+), 17 deletions(-)

--- a/arch/arm64/boot/dts/realtek/rtd1293-ds418j.dts
+++ b/arch/arm64/boot/dts/realtek/rtd1293-ds418j.dts
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-2-Clause)
 /*
- * Copyright (c) 2017 Andreas Färber
+ * Copyright (c) 2017-2019 Andreas Färber
  */
 
 /dts-v1/;
@@ -11,9 +11,9 @@
 	compatible = "synology,ds418j", "realtek,rtd1293";
 	model = "Synology DiskStation DS418j";
 
-	memory@0 {
+	memory@1f000 {
 		device_type = "memory";
-		reg = <0x0 0x40000000>;
+		reg = <0x1f000 0x3ffe1000>; /* boot ROM to 1 GiB */
 	};
 
 	aliases {
--- a/arch/arm64/boot/dts/realtek/rtd1295-mele-v9.dts
+++ b/arch/arm64/boot/dts/realtek/rtd1295-mele-v9.dts
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2017 Andreas Färber
+ * Copyright (c) 2017-2019 Andreas Färber
  *
  * SPDX-License-Identifier: (GPL-2.0+ OR MIT)
  */
@@ -12,9 +12,9 @@
 	compatible = "mele,v9", "realtek,rtd1295";
 	model = "MeLE V9";
 
-	memory@0 {
+	memory@1f000 {
 		device_type = "memory";
-		reg = <0x0 0x80000000>;
+		reg = <0x1f000 0x7ffe1000>; /* boot ROM to 2 GiB */
 	};
 
 	aliases {
--- a/arch/arm64/boot/dts/realtek/rtd1295-probox2-ava.dts
+++ b/arch/arm64/boot/dts/realtek/rtd1295-probox2-ava.dts
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2017 Andreas Färber
+ * Copyright (c) 2017-2019 Andreas Färber
  *
  * SPDX-License-Identifier: (GPL-2.0+ OR MIT)
  */
@@ -12,9 +12,9 @@
 	compatible = "probox2,ava", "realtek,rtd1295";
 	model = "PROBOX2 AVA";
 
-	memory@0 {
+	memory@1f000 {
 		device_type = "memory";
-		reg = <0x0 0x80000000>;
+		reg = <0x1f000 0x7ffe1000>; /* boot ROM to 2 GiB */
 	};
 
 	aliases {
--- a/arch/arm64/boot/dts/realtek/rtd1295-zidoo-x9s.dts
+++ b/arch/arm64/boot/dts/realtek/rtd1295-zidoo-x9s.dts
@@ -11,9 +11,9 @@
 	compatible = "zidoo,x9s", "realtek,rtd1295";
 	model = "Zidoo X9S";
 
-	memory@0 {
+	memory@1f000 {
 		device_type = "memory";
-		reg = <0x0 0x80000000>;
+		reg = <0x1f000 0x7ffe1000>; /* boot ROM to 2 GiB */
 	};
 
 	aliases {
--- a/arch/arm64/boot/dts/realtek/rtd1296-ds418.dts
+++ b/arch/arm64/boot/dts/realtek/rtd1296-ds418.dts
@@ -11,9 +11,9 @@
 	compatible = "synology,ds418", "realtek,rtd1296";
 	model = "Synology DiskStation DS418";
 
-	memory@0 {
+	memory@1f000 {
 		device_type = "memory";
-		reg = <0x0 0x80000000>;
+		reg = <0x1f000 0x7ffe1000>; /* boot ROM to 2 GiB */
 	};
 
 	aliases {
--- a/arch/arm64/boot/dts/realtek/rtd129x.dtsi
+++ b/arch/arm64/boot/dts/realtek/rtd129x.dtsi
@@ -5,8 +5,8 @@
  * Copyright (c) 2016-2019 Andreas Färber
  */
 
-/memreserve/	0x0000000000000000 0x0000000000030000;
-/memreserve/	0x0000000000030000 0x00000000000d0000;
+/memreserve/	0x0000000000000000 0x000000000001f000;
+/memreserve/	0x000000000001f000 0x00000000000e1000;
 /memreserve/	0x0000000001b00000 0x00000000004be000;
 
 #include <dt-bindings/interrupt-controller/arm-gic.h>
@@ -52,8 +52,9 @@
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		/* Exclude up to 2 GiB of RAM */
-		ranges = <0x80000000 0x80000000 0x80000000>;
+		ranges = <0x00000000 0x00000000 0x0001f000>, /* boot ROM */
+			 /* Exclude up to 2 GiB of RAM */
+			 <0x80000000 0x80000000 0x80000000>;
 
 		reset1: reset-controller@98000000 {
 			compatible = "snps,dw-low-reset";


