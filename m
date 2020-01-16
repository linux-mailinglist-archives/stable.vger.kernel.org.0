Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0440413E85D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404429AbgAPRbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:31:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390807AbgAPRbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:31:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 839C4246C0;
        Thu, 16 Jan 2020 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195872;
        bh=pMzsxZqL7mnzlJsR54Z8Dv3VsMGRuTgcj/xJQ/YELWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sj2PiqCUnFAnaunOeAvrjdGOv/aNSN6N9Uy6Y0FHf542k3fAKAZKf+DQ8nAzTsyFl
         XlG3yf8s0v1D6VgWTPu/yd633jhCL7C9rUbQ2Gu4TShSDnS5OGkc/9fJNNH2WEOZbN
         p6s85df7rCTlmkMIefgC66SP5ayItDHrE9ckpQtI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 367/371] Revert "arm64: dts: juno: add dma-ranges property"
Date:   Thu, 16 Jan 2020 12:23:59 -0500
Message-Id: <20200116172403.18149-310-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 54fb3fe0f211d4729a2551cf9497bd612189af9d ]

This reverts commit 193d00a2b35ee3353813b4006a18131122087205.

Commit 951d48855d86 ("of: Make of_dma_get_range() work on bus nodes")
reworked the logic such that of_dma_get_range() works correctly
starting from a bus node containing "dma-ranges".

Since on Juno we don't have a SoC level bus node and "dma-ranges" is
present only in the root node, we get the following error:

OF: translation of DMA address(0) to CPU address failed node(/sram@2e000000)
OF: translation of DMA address(0) to CPU address failed node(/uart@7ff80000)
...
OF: translation of DMA address(0) to CPU address failed node(/mhu@2b1f0000)
OF: translation of DMA address(0) to CPU address failed node(/iommu@2b600000)
OF: translation of DMA address(0) to CPU address failed node(/iommu@2b600000)
OF: translation of DMA address(0) to CPU address failed node(/iommu@2b600000)

So let's fix it by dropping the "dma-ranges" property for now. This
should be fine since it doesn't represent any kind of device-visible
restriction; it was only there for completeness, and we've since given
in to the assumption that missing "dma-ranges" implies a 1:1 mapping
anyway.

We can add it later with a proper SoC bus node and moving all the
devices that belong there along with the "dma-ranges" if required.

Fixes: 193d00a2b35e ("arm64: dts: juno: add dma-ranges property")
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/arm/juno-base.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index f165f04db0c9..13ee8ffa9bbf 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -5,7 +5,6 @@
 	/*
 	 *  Devices shared by all Juno boards
 	 */
-	dma-ranges = <0 0 0 0 0x100 0>;
 
 	memtimer: timer@2a810000 {
 		compatible = "arm,armv7-timer-mem";
-- 
2.20.1

