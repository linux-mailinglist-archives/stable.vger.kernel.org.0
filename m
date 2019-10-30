Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1AE9FBD
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfJ3Pvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbfJ3Pvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:32 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E421D20874;
        Wed, 30 Oct 2019 15:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450691;
        bh=Du/6PTSuGoZ0Qf9UkdU/yHUEIgefC9EtDGfESH88STo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Nhr00SU9g5/5OehlzG6ky5i59mQSXgL3ph7dI/JwgDRToZgt1Muda3pXT1sqdoiZ
         KKtDm+OhXkoWJV9z62yhATfT4QTlnFd5J5m4neepOx13KIEj2mA1+krShk54rybakH
         d1+kfKIXGFgeiScc989HxFwICB3YUxjy2U/GKmpk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Soeren Moch <smoch@web.de>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.3 26/81] arm64: dts: rockchip: fix RockPro64 sdhci settings
Date:   Wed, 30 Oct 2019 11:48:32 -0400
Message-Id: <20191030154928.9432-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soeren Moch <smoch@web.de>

[ Upstream commit 2558b3b1b11a1b32b336be2dd0aabfa6d35ddcb5 ]

The RockPro64 schematics [1], [2] show that the rk3399 EMMC_STRB pin is
connected to the RESET pin instead of the DATA_STROBE pin of the eMMC module.
So the data strobe cannot be used for its intended purpose on this board,
and so the HS400 eMMC mode is not functional. Limit the controller to HS200.

[1] http://files.pine64.org/doc/rockpro64/rockpro64_v21-SCH.pdf
[2] http://files.pine64.org/doc/rock64/PINE64_eMMC_Module_20170719.pdf

Fixes: e4f3fb490967 ("arm64: dts: rockchip: add initial dts support for Rockpro64")
Signed-off-by: Soeren Moch <smoch@web.de>
Link: https://lore.kernel.org/r/20191003215036.15023-2-smoch@web.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
index cad314f708300..1ff617230f6c4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
@@ -625,8 +625,7 @@
 
 &sdhci {
 	bus-width = <8>;
-	mmc-hs400-1_8v;
-	mmc-hs400-enhanced-strobe;
+	mmc-hs200-1_8v;
 	non-removable;
 	status = "okay";
 };
-- 
2.20.1

