Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72292E4111
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439277AbgL1ONF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439149AbgL1OKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31EC2206C3;
        Mon, 28 Dec 2020 14:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164613;
        bh=xy8mMgT5jomiIV+pCLELbER+MjWSi5kozQLaf6xtihs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIhRT+qJtJC5K7GMcpmdsc7Os7I0AfBEorJH/JdID9s8mv2W7ktUIAE8sTO0XnDez
         0qy0sZxiwjBdwadr4OXqGwwstmVzamwP7riTfvo6S6Wm1dY1oTQ23g6b457lwTf+a7
         MBdb+bm8STq7Vm6c8vXk6zsDkEH6pgcZTrHEJETk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/717] arm64: dts: freescale: sl28: combine SPI MTD partitions
Date:   Mon, 28 Dec 2020 13:43:54 +0100
Message-Id: <20201228125032.300642938@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 91ab1c12285c9999afe56c09aa296d8b96862976 ]

The upstream port, doesn't really follow the vendor partitioning. The
bootloader partition has one U-Boot FIT image containing all needed
bits and pieces. Even today the bootloader is already larger than the
current "bootloader" partition. Thus, fold all the partitions into one
and keep the environment one. The latter is still valid.
We keep the failsafe partitions because the first half of the SPI flash
is preinstalled by the vendor and immutable.

Fixes: 815364d0424e ("arm64: dts: freescale: add Kontron sl28 support")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts  | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
index 8161dd2379712..b3fa4dbeebd52 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
@@ -155,20 +155,10 @@
 		};
 
 		partition@210000 {
-			reg = <0x210000 0x0f0000>;
+			reg = <0x210000 0x1d0000>;
 			label = "bootloader";
 		};
 
-		partition@300000 {
-			reg = <0x300000 0x040000>;
-			label = "DP firmware";
-		};
-
-		partition@340000 {
-			reg = <0x340000 0x0a0000>;
-			label = "trusted firmware";
-		};
-
 		partition@3e0000 {
 			reg = <0x3e0000 0x020000>;
 			label = "bootloader environment";
-- 
2.27.0



