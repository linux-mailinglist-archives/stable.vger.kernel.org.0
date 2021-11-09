Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3616444B821
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345500AbhKIWkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345556AbhKIWiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:38:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD96861B04;
        Tue,  9 Nov 2021 22:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496594;
        bh=TA9Dl/ScuqngS+/mEndKBNYaVK/RfUMSBgmF4neBW/M=;
        h=From:To:Cc:Subject:Date:From;
        b=pCuKrJqSO3oDPDZMUbO/5hGywOY4xRhcPrX4txV7lf+nMYdYj8TWqlnmaD98padY6
         wPLMG9efB/GW/YsYlTeOC5Q3JW5bP1pnpMRAxvKwpa0SGVBojDLh5iyfoEfos6OslF
         xP43DAsstYkEZQbjXtU32ZocdD/2vaCi3XXFCCG5yaOoms9wLyMh3QLtREdI9z0/21
         j2K/XmoYyT+8ildf/oOSapgBHkqu1sr612unFjPwZpBzYtUMd5UVtFI8ObXSFJUZg6
         6RmWGJjRpNw59cT6opV8YCKRt9UJW4yJN2zauJxpOUzofJ9PqTVUyfoFezt0Mw+zfa
         ghUPNwzwnJgDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 01/21] arm64: zynqmp: Do not duplicate flash partition label property
Date:   Tue,  9 Nov 2021 17:22:50 -0500
Message-Id: <20211109222311.1235686-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>

[ Upstream commit 167721a5909f867f8c18c8e78ea58e705ad9bbd4 ]

In kernel 5.4, support has been added for reading MTD devices via the nvmem
API.
For this the mtd devices are registered as read-only NVMEM providers under
sysfs with the same name as the flash partition label property.

So if flash partition label property of multiple flash devices are
identical then the second mtd device fails to get registered as a NVMEM
provider.

This patch fixes the issue by having different label property for different
flashes.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/6c4b9b9232b93d9e316a63c086540fd5bf6b8687.1623684253.git.michal.simek@xilinx.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts
index 11cc67184fa9f..f1edd7fcef764 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts
@@ -130,7 +130,7 @@
 		reg = <0>;
 
 		partition@0 {
-			label = "data";
+			label = "spi0-data";
 			reg = <0x0 0x100000>;
 		};
 	};
@@ -148,7 +148,7 @@
 		reg = <0>;
 
 		partition@0 {
-			label = "data";
+			label = "spi1-data";
 			reg = <0x0 0x84000>;
 		};
 	};
-- 
2.33.0

