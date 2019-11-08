Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D13EF476C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391188AbfKHLuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:50:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391671AbfKHLru (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21670222CE;
        Fri,  8 Nov 2019 11:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213669;
        bh=j7UqUvscSKQTKuABSb9Rd+j8p8e8+zIJM25RECCrkEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7/T6eHnUGveMJWcOmE3MmGc3FGoo7DbJ182VYunwSIpR14zFS2WC2tCxCpwhBtmr
         4eOSif7Bctx80QN4lcxXua8izIBPVBNx6nEYYkbM28Ach4sZ9DjNe/NbM//gfeUz/J
         pkAI2A6IRTsWBbkXVSV6wzFDhbAcUZV0vWg4cyoM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 22/44] ARM: dts: omap3-gta04: make NAND partitions compatible with recent U-Boot
Date:   Fri,  8 Nov 2019 06:46:58 -0500
Message-Id: <20191108114721.15944-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H. Nikolaus Schaller" <hns@goldelico.com>

[ Upstream commit fa99c21ecb3cd4021a60d0e8bf880e78b5bd0729 ]

Vendor defined U-Boot has changed the partition scheme a while ago:

* kernel partition 6MB
* file system partition uses the remainder up to end of the NAND
* increased size of the environment partition (to get an OneNAND compatible base address)
* shrink the U-Boot partition

Let's be compatible (e.g. Debian kernel built from upstream).

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 196b3f5158c90..0ea793e365e45 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -523,22 +523,22 @@
 
 		bootloaders@80000 {
 			label = "U-Boot";
-			reg = <0x80000 0x1e0000>;
+			reg = <0x80000 0x1c0000>;
 		};
 
-		bootloaders_env@260000 {
+		bootloaders_env@240000 {
 			label = "U-Boot Env";
-			reg = <0x260000 0x20000>;
+			reg = <0x240000 0x40000>;
 		};
 
 		kernel@280000 {
 			label = "Kernel";
-			reg = <0x280000 0x400000>;
+			reg = <0x280000 0x600000>;
 		};
 
-		filesystem@680000 {
+		filesystem@880000 {
 			label = "File System";
-			reg = <0x680000 0xf980000>;
+			reg = <0x880000 0>;	/* 0 = MTDPART_SIZ_FULL */
 		};
 	};
 };
-- 
2.20.1

