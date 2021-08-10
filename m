Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDE63E5CFB
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242509AbhHJOQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242497AbhHJOQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2DC761075;
        Tue, 10 Aug 2021 14:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604945;
        bh=xC+BBKoZiCriGDF9X9QmzpHZ2z6ZAXuPMpw4yI+zFBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AN/XlpyZVn0aPBQ4o+HZbMA+KfE7nXGSf6uehK9fjtlg6bmf5+IaNcwOvoimdQ318
         6W1AeqA6/tLXesaSYUDwURROJOmN5lFcNr/08YDons4HDjveHCbXfopJMHtVD4Zra0
         2Vc7nyPYVbvnhY6UWph0cU/FYpjdoIBcosZCJG2MncziqeLldt2yomWuI63GW9u149
         amGzf8blwQPBzidZAbne1Xe9BMPRZs/HZ3g3a8XFISQW5v9aMKulrkJuFGrxGPwrmX
         WDonEzpNiET3BCtrD0pIVDYPFQaoXYhi2tzuxsoneRWfC1waN5ZY4KxDRelLbpGBnj
         h0QDRW0eSQaNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Gerlach <d-gerlach@ti.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/20] ARM: dts: am43x-epos-evm: Reduce i2c0 bus speed for tps65218
Date:   Tue, 10 Aug 2021 10:15:23 -0400
Message-Id: <20210810141538.3117707-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141538.3117707-1-sashal@kernel.org>
References: <20210810141538.3117707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Gerlach <d-gerlach@ti.com>

[ Upstream commit 20a6b3fd8e2e2c063b25fbf2ee74d86b898e5087 ]

Based on the latest timing specifications for the TPS65218 from the data
sheet, http://www.ti.com/lit/ds/symlink/tps65218.pdf, document SLDS206
from November 2014, we must change the i2c bus speed to better fit within
the minimum high SCL time required for proper i2c transfer.

When running at 400khz, measurements show that SCL spends
0.8125 uS/1.666 uS high/low which violates the requirement for minimum
high period of SCL provided in datasheet Table 7.6 which is 1 uS.
Switching to 100khz gives us 5 uS/5 uS high/low which both fall above
the minimum given values for 100 khz, 4.0 uS/4.7 uS high/low.

Without this patch occasionally a voltage set operation from the kernel
will appear to have worked but the actual voltage reflected on the PMIC
will not have updated, causing problems especially with cpufreq that may
update to a higher OPP without actually raising the voltage on DCDC2,
leading to a hang.

Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am43x-epos-evm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 8b696107eef8..d2aebdbc7e0f 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -582,7 +582,7 @@ &i2c0 {
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c0_pins>;
-	clock-frequency = <400000>;
+	clock-frequency = <100000>;
 
 	tps65218: tps65218@24 {
 		reg = <0x24>;
-- 
2.30.2

