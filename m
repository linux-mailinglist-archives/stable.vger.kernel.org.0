Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A16E3E5D97
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242908AbhHJOWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243267AbhHJOSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D1666115C;
        Tue, 10 Aug 2021 14:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628605018;
        bh=E20x5CMP7kwkHKrfbV2iPe9BJDP6pfJyxFJJgrbLu4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJSh6IHIczCypq7ML6TbcwckUcvpuY44W2w/7F7DWI47iZ/PULsu68YkFTl6+TEI3
         ABHVZhOrs55VDpD8m9JM0zBENHxOkff0rcmepjOCE6Kr4t7ZRcGvQfNlJv70kA3FMw
         zV5xEwalwTKEx0kP+DwFRvF7104qS5WX4YnfJgs0D182HYRU7v3AnT3TcNqO5qYK/Q
         +5/HgQSf2ETWKlhCFgyhXEqxX1o8t2ET+L/F8GQxKRU4d0kYpn0JL3DJnLGIbcsce8
         WYDQAFxSPys9JVbCzyhv5o32oFs+vAi2b6W3bSmIWZALSG/TKq62Tmhh/nv8ZlXPY9
         1V+WiPUUm1Lnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Gerlach <d-gerlach@ti.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/8] ARM: dts: am43x-epos-evm: Reduce i2c0 bus speed for tps65218
Date:   Tue, 10 Aug 2021 10:16:49 -0400
Message-Id: <20210810141655.3118498-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141655.3118498-1-sashal@kernel.org>
References: <20210810141655.3118498-1-sashal@kernel.org>
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
index 21918807c9f6..f42a92391289 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -411,7 +411,7 @@ &i2c0 {
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c0_pins>;
-	clock-frequency = <400000>;
+	clock-frequency = <100000>;
 
 	tps65218: tps65218@24 {
 		reg = <0x24>;
-- 
2.30.2

