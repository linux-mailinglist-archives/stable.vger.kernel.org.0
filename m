Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6808A450E48
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240879AbhKOSOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:14:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240229AbhKOSH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8CCE61361;
        Mon, 15 Nov 2021 17:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998228;
        bh=cjA5cE8OvcisCnN0GcVHFvKwsr7zcHdq7ZTaOItcYvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlAm+RzIhXNdyZi7hy8x4EvJg5FrxQQJHK+2opy8khMdbAV6zHYODvmd2Hn7BEcyi
         PnkHrL3+ZcCrEYGgl940PnZEUeyVaSj9m1heOIw2jfFS1rXZTFdCKldc4vuzxrvJ9I
         c3HyBj0acXmGj7EeVDi/qcXshBaNz0D+fetnH0Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 392/575] arm64: dts: rockchip: Fix GPU register width for RK3328
Date:   Mon, 15 Nov 2021 18:01:57 +0100
Message-Id: <20211115165357.327073951@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 932b4610f55b49f3a158b0db451137bab7ed0e1f ]

As can be seen in RK3328's TRM the register range for the GPU is
0xff300000 to 0xff330000.
It would (and does in vendor kernel) overlap with the registers of
the HEVC encoder (node/driver do not exist yet in upstream kernel).
See already existing h265e_mmu node.

Fixes: 752fbc0c8da7 ("arm64: dts: rockchip: add rk3328 mali gpu node")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20210623115926.164861-1-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index e546c9d1d6463..72112fe05a5c4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -603,7 +603,7 @@
 
 	gpu: gpu@ff300000 {
 		compatible = "rockchip,rk3328-mali", "arm,mali-450";
-		reg = <0x0 0xff300000 0x0 0x40000>;
+		reg = <0x0 0xff300000 0x0 0x30000>;
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.33.0



