Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1A72E13FD
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgLWChC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:37:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730212AbgLWCY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 731AE2222D;
        Wed, 23 Dec 2020 02:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690226;
        bh=A73uzdkqQ1ZPQma2CAjuUN93t+I6+FrfDFX5rU73yyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AODv9Yr11hyUgRvzjtSwvQacxRGCHUdCx+4M+dCjYC6Un2iFRMrSd/i9EDmYw2QBs
         Kt3BCnVev5U2glooMIo+tKlu3Gz9CD9Tj6bfJ9JnkWr0G0XYKuHHx4Nq8tMoiypqYz
         TZUucWvN7MEsw8vjXi+Goub7+aOQiHFj0TfhpPd2tFI8Lbkv7oCoQh+N1LCsulpncO
         UxcYUNR4Jj4ytewZZWzMDBVXaCfGt8oyMGBSuu/34eFD4v8ZxniTAyXkrZmGzF8UAP
         h3Kj2Vl2+FNjxsh3FW+9dBVRNyWqtwSR+6nhbQqfBz8+4jN3YeDITyXFyG29X8sx0G
         63LoztxceeGdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 42/66] arm64: tegra: Fix GIC400 missing GICH/GICV register regions
Date:   Tue, 22 Dec 2020 21:22:28 -0500
Message-Id: <20201223022253.2793452-42-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 776a3c04da9fa144241476f4a0d263899d6cad26 ]

GIC400 has full support for virtualization, and yet the tegra186
DT doesn't expose the GICH/GICV regions (despite exposing the
maintenance interrupt that only makes sense for virtualization).

Add the missing regions, based on the hunch that the HW doesn't
use the CPU build-in interfaces, but instead the external ones
provided by the GIC. KVM's virtual GIC now works with this change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra186.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra186.dtsi b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
index a9c3eef6c4e09..5738b02973074 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -263,7 +263,9 @@ gic: interrupt-controller@3881000 {
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x0 0x03881000 0x0 0x1000>,
-		      <0x0 0x03882000 0x0 0x2000>;
+		      <0x0 0x03882000 0x0 0x2000>,
+		      <0x0 0x03884000 0x0 0x2000>,
+		      <0x0 0x03886000 0x0 0x2000>;
 		interrupts = <GIC_PPI 9
 			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 		interrupt-parent = <&gic>;
-- 
2.27.0

