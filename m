Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5C7101875
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfKSFbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbfKSFbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0641A222A2;
        Tue, 19 Nov 2019 05:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141492;
        bh=K8e8NwW1s5RIKSL2iUMnsiJnnSWXjjMJUSVnzL1Zgl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbGFX2KAsK00/XQvwaWb5RF2toYHijzk0rA+ZPJ3HTqJOtSRdQS8VWfAoQ4SFCJm5
         rtP+aomZR+z3IPp1kihLlwGGQAlXxoxuX5ISXJB2rDjyXQCmKKI0gskZvNR4K/sy0a
         zCy1T7NL7KKT+6bOsoj4K/+WuL7KYuG3eQbG03Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 142/422] ARM: dts: omap3-gta04: make NAND partitions compatible with recent U-Boot
Date:   Tue, 19 Nov 2019 06:15:39 +0100
Message-Id: <20191119051407.950158598@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

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
index de873e395c05d..bb435684500fc 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -619,22 +619,22 @@
 
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



