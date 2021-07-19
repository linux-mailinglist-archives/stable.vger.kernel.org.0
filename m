Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7003CE3B6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbhGSPkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349079AbhGSPfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9832E600EF;
        Mon, 19 Jul 2021 16:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711370;
        bh=IBFI/NsLvnTDeENW4eAkcR1g8Z5XrQLd0HQjdND6skg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlgzuDPbum3QBiJeMNEp3Bel4k2VQCV5p6BZjVyCJSJUr+yDArFzVh2iXmCBjd9m1
         gYQg6KwJABpZtXDz7073kaiCG3h28afswntCm2441a5ukOfmm1jKwW0VkLoZGA9YiO
         YXFLvs2qapEZx4F6oqZx8xeKtQ02eJFe1QuBvLC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Pavel Hofman <pavel.hofman@ivitera.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 311/351] Revert "ARM: dts: bcm283x: increase dwc2s RX FIFO size"
Date:   Mon, 19 Jul 2021 16:54:17 +0200
Message-Id: <20210719144955.344076935@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 77daceabedb42482bb6200fa26047c5591716e45 ]

This reverts commit 278407a53c3b33fb820332c4d39eb39316c3879a.

The original change breaks USB config on Raspberry Pi Zero and Pi 4 B,
because it exceeds the total fifo size of 4080. A naive attempt to reduce
g-tx-fifo-size doesn't help on Raspberry Pi Zero. So better go back.

Fixes: 278407a53c3b ("ARM: dts: bcm283x: increase dwc2's RX FIFO size")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Pavel Hofman <pavel.hofman@ivitera.com>
Link: https://lore.kernel.org/r/1622293371-5997-1-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm283x-rpi-usb-otg.dtsi        | 2 +-
 arch/arm/boot/dts/bcm283x-rpi-usb-peripheral.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm283x-rpi-usb-otg.dtsi b/arch/arm/boot/dts/bcm283x-rpi-usb-otg.dtsi
index 20322de2f8bf..e2fd9610e125 100644
--- a/arch/arm/boot/dts/bcm283x-rpi-usb-otg.dtsi
+++ b/arch/arm/boot/dts/bcm283x-rpi-usb-otg.dtsi
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 &usb {
 	dr_mode = "otg";
-	g-rx-fifo-size = <558>;
+	g-rx-fifo-size = <256>;
 	g-np-tx-fifo-size = <32>;
 	/*
 	 * According to dwc2 the sum of all device EP
diff --git a/arch/arm/boot/dts/bcm283x-rpi-usb-peripheral.dtsi b/arch/arm/boot/dts/bcm283x-rpi-usb-peripheral.dtsi
index 1409d1b559c1..0ff0e9e25327 100644
--- a/arch/arm/boot/dts/bcm283x-rpi-usb-peripheral.dtsi
+++ b/arch/arm/boot/dts/bcm283x-rpi-usb-peripheral.dtsi
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 &usb {
 	dr_mode = "peripheral";
-	g-rx-fifo-size = <558>;
+	g-rx-fifo-size = <256>;
 	g-np-tx-fifo-size = <32>;
 	g-tx-fifo-size = <256 256 512 512 512 768 768>;
 };
-- 
2.30.2



