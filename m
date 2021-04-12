Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6985035C07D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbhDLJN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240607AbhDLJKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96B7A61358;
        Mon, 12 Apr 2021 09:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218347;
        bh=UX5vgbquxPhFNHCzrM0fwKIp8gVSNQFsYpoKL47MNFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bspMnXiR8R999AFDzOYwlnvyJ7y5Y6cx3oC0Zj6axuhWksWRII/ixqb7Q+biLAcME
         g1Brc2dZGmLa+GsDhRxpWIWxLyFd5GS7YwuvKUWin2vKDR6/Rtefd6TA1zLZL3tzgg
         dSHpyO/lW4Wx1jO26vfditvqg1OUqvX1APTWrYLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 162/210] Revert "arm64: dts: marvell: armada-cp110: Switch to per-port SATA interrupts"
Date:   Mon, 12 Apr 2021 10:41:07 +0200
Message-Id: <20210412084021.428382884@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit 967ff33eb0efcd48e4df11ab9aee51c41e0f44d0 ]

The driver part of this support was not merged which leads to break
AHCI on all Marvell Armada 7k8k / CN913x platforms as it was reported
by Marcin Wojtas.

So for now let's remove it in order to fix the issue waiting for the
driver part really be merged.

This reverts commit 53e950d597e3578da84238b86424bfcc9e101d87.
Fixes: 53e950d597e3 ("arm64: dts: marvell: armada-cp110: Switch to per-port SATA interrupts")

Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
index 994a2fce449a..1e37ae181acf 100644
--- a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
@@ -300,9 +300,11 @@
 		};
 
 		CP11X_LABEL(sata0): sata@540000 {
-			compatible = "marvell,armada-8k-ahci";
+			compatible = "marvell,armada-8k-ahci",
+			"generic-ahci";
 			reg = <0x540000 0x30000>;
 			dma-coherent;
+			interrupts = <107 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&CP11X_LABEL(clk) 1 15>,
 				 <&CP11X_LABEL(clk) 1 16>;
 			#address-cells = <1>;
@@ -310,12 +312,10 @@
 			status = "disabled";
 
 			sata-port@0 {
-				interrupts = <109 IRQ_TYPE_LEVEL_HIGH>;
 				reg = <0>;
 			};
 
 			sata-port@1 {
-				interrupts = <107 IRQ_TYPE_LEVEL_HIGH>;
 				reg = <1>;
 			};
 		};
-- 
2.30.2



