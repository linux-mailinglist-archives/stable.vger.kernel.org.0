Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D93244B766
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344286AbhKIWew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:34:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344329AbhKIWc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:32:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCD426137F;
        Tue,  9 Nov 2021 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496481;
        bh=rEvDH9e3e1/shQ8LDA401Gfc3RUsnKGokhs7qjYwDd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Av22EoRo0u8DkelP9vHS+nmfQ2PGhKiOKzaYg/rzMshUfM0WUp29UDF9uxAQAKwEt
         s7OiosbKtO3dgxWEzfJWVpaZLLLqjUvE0fnEvseONy4ioc4eImVOk0pBBicoAZoOBL
         rTCHkO6+cbRLMiD4YvBJM8Nmmmk1h1p34u26HF7ENVjAcFy5u6Xa+4/cCYDYSvE5yv
         M6CvoN6A6VcpKLHSMhkEEzmXf5XaxIDRus9cNJKxvih6trEU2tt6YKG1mk/qqNatkk
         VX4RfgHf2C5DyAhORKU+4jPs+KgK36WXnYzEp+fK94+KUcD4q3SOBEO9xlcqzR4cp/
         9uqEX8XkWlVQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthias Brugger <mbrugger@suse.com>,
        Guillaume Gardet <guillaume.gardet@arm.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 09/50] arm64: dts: rockchip: Disable CDN DP on Pinebook Pro
Date:   Tue,  9 Nov 2021 17:20:22 -0500
Message-Id: <20211109222103.1234885-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

[ Upstream commit 2513fa5c25d42f55ca5f0f0ab247af7c9fbfa3b1 ]

The CDN DP needs a PHY and a extcon to work correctly. But no extcon is
provided by the device-tree, which leads to an error:
cdn-dp fec00000.dp: [drm:cdn_dp_probe [rockchipdrm]] *ERROR* missing extcon or phy
cdn-dp: probe of fec00000.dp failed with error -22

Disable the CDN DP to make graphic work on the Pinebook Pro.

Reported-by: Guillaume Gardet <guillaume.gardet@arm.com>
Signed-off-by: Matthias Brugger <mbrugger@suse.com>
Link: https://lore.kernel.org/r/20210715164101.11486-1-matthias.bgg@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
index 219b7507a10fb..4297c1db5a413 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -379,10 +379,6 @@
 	};
 };
 
-&cdn_dp {
-	status = "okay";
-};
-
 &cpu_b0 {
 	cpu-supply = <&vdd_cpu_b>;
 };
-- 
2.33.0

