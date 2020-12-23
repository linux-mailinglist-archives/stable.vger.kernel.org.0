Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418CD2E164A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbgLWC7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbgLWCUE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9B0E2256F;
        Wed, 23 Dec 2020 02:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689986;
        bh=yJRRFSfrUWMNVGR1aJmIOLD3je5SKkACdB7S9UENrAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKhmnEyDOztZt/Rg7KiZFnGCfsrQbG6iVVa5f1bPJVHHCQa0vdRww6RP/gj8y/dg1
         SHlsTYOFg7z+AHXoYuK6qiAw241Fp5dVzhboctoB2iHI6N8GVNm6A+sBR9i3ZKKjOK
         EwkNfsmrYxpxMlX0gJ3sKDbxLEEh20BAF7dPA+mgUinWvebTphDrYuOLnjAZqaUQUz
         9f5u83+nPBc+//qmoCFmLj8GQ05JrLngrCOeQQaDhy2YWY3ebg6XAhRbLk6TLTz0lS
         Y1zybisAG4LTUlKdDGQULisaWnrQGHG2S8ZOAfcS/34ro23TqTVyuYSr74hy90BKC4
         kmOcW4DnNfsyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 072/130] arm64: tegra: Fix GIC400 missing GICH/GICV register regions
Date:   Tue, 22 Dec 2020 21:17:15 -0500
Message-Id: <20201223021813.2791612-72-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index 9abf0cb1dd67f..f72c97fe4afc8 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -569,7 +569,9 @@ gic: interrupt-controller@3881000 {
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

