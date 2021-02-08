Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3FA313C0D
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhBHSAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235128AbhBHR7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:59:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC2B764EAA;
        Mon,  8 Feb 2021 17:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807100;
        bh=Kpx3RtEO4l3vAXpLy+dut0zIXM92dtPcyvGUkm1NyH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnGe43lAePA4GtmD+QGTM2X7Mhl7prg6/jsbcZfIZmLCaps4iP3m+XzRHJA88CpCi
         cBBBQiom/bubmg3KV99OwDsAl9rfEwgDe/2eTjQDViU2bI2UpbKY1Nw9DPOPgCQX5P
         wmyEpeJypirTt0yu+0+fDVVIwxq8oSOQ/qoTvrXgDYaOG9XLUDrzn4H8ajT6oN99x6
         mgyzPlmYkAxFHK4IjnBaOVIHlNGoDVMajMvRQLUSM73vSR3g31kenIvY/fbLvbeZkG
         9O8OWhPmEj1TaktAGgXfy0tu8mtobIiNjoIdI36wSdiJrwCtXZXiiBnx1MvUIgubjx
         BhqV3I9IEvJaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 10/36] arm64: dts: rockchip: Disable display for NanoPi R2S
Date:   Mon,  8 Feb 2021 12:57:40 -0500
Message-Id: <20210208175806.2091668-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 74532de460ec664e5a725507d1b59aa9e4d40776 ]

NanoPi R2S is headless, so rightly does not enable any of the display
interface hardware, which currently provokes an obnoxious error in the
boot log from the fake DRM device failing to find anything to bind to.
It probably isn't *too* hard to obviate the fake device shenanigans
entirely with a bit of driver reshuffling, but for now let's just
disable it here to shut up the spurious error.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/c4553dfad1ad6792c4f22454c135ff55de77e2d6.1611186099.git.robin.murphy@arm.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
index 2ee07d15a6e37..1eecad724f04c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
@@ -114,6 +114,10 @@ &cpu3 {
 	cpu-supply = <&vdd_arm>;
 };
 
+&display_subsystem {
+	status = "disabled";
+};
+
 &gmac2io {
 	assigned-clocks = <&cru SCLK_MAC2IO>, <&cru SCLK_MAC2IO_EXT>;
 	assigned-clock-parents = <&gmac_clk>, <&gmac_clk>;
-- 
2.27.0

