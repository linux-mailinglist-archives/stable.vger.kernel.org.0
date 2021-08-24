Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D783F638B
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhHXQ5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233396AbhHXQ5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97829613BD;
        Tue, 24 Aug 2021 16:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824178;
        bh=hmiAuGvDMEHw/MPDXtTgBIuj2w4uBIlK6gNECyNFkcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0PeIQqO8XEf0oMxbyMiKbTbqokTk/WryDWVzGOegjwcgyB6zW8AJOOfEW6KaWEF7
         GPllcwmNC93hAByFl7Wwvj0sd2dK7wzdkBvXY8ZSEhyXjA6Harl1hwAGM0Hfbw1Sky
         CBMljq97GbexZU3KvrS5aifwDcikcEnkdwytYCeDQYpBrTlXxF50j6oO2L87ba6vZA
         JKibJlsHoE2CnIoxpcPdm98u775qw+1XMqFL0isinpMTBgTrNd2bPzFK892I+fiEfF
         CCSGyYApj6o67wqVfjZaNTZtSt2f3ujveLKzO/G9bAxLfcbLgYRcTcoTVhwoHRHIWm
         Vpuwnkcd09cbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Gerlach <d-gerlach@ti.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 009/127] ARM: dts: am43x-epos-evm: Reduce i2c0 bus speed for tps65218
Date:   Tue, 24 Aug 2021 12:54:09 -0400
Message-Id: <20210824165607.709387-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
@@ -582,7 +582,7 @@
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c0_pins>;
-	clock-frequency = <400000>;
+	clock-frequency = <100000>;
 
 	tps65218: tps65218@24 {
 		reg = <0x24>;
-- 
2.30.2

