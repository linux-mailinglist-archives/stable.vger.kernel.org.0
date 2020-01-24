Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA0C1488EF
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392599AbgAXObu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:31:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404643AbgAXOUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2B7B2087E;
        Fri, 24 Jan 2020 14:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875615;
        bh=P4zl6VgXUyjKwIgpzBo1I+kQ4xYgQbJdKQlwOSGS0mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mg1XbiSwms/Kc/RZR0it9tpRZSc8qrp9V0u1o7pXwQJxlr8rA2x0h1hkVEPSKapYI
         RaKbun9e2/N4RUDTf7Q0pzeYssgpxSBTzmzQkbdGAr7mxxU0ef/r7h6p/3Sf4E9zDi
         vsqLdLvuAZsnsYj80QRd/OQ4eX8/bb0VzE5xetSM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 02/56] ARM: dts: meson8: fix the size of the PMU registers
Date:   Fri, 24 Jan 2020 09:19:18 -0500
Message-Id: <20200124142012.29752-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 46c9585ed4af688ff1be6d4e76d7ed2f04de4fba ]

The PMU registers are at least 0x18 bytes wide. Meson8b already uses a
size of 0x18. The structure of the PMU registers on Meson8 and Meson8b
is similar but not identical.

Meson8 and Meson8b have the following registers in common (starting at
AOBUS + 0xe0):
  #define AO_RTI_PWR_A9_CNTL0 0xe0 (0x38 << 2)
  #define AO_RTI_PWR_A9_CNTL1 0xe4 (0x39 << 2)
  #define AO_RTI_GEN_PWR_SLEEP0 0xe8 (0x3a << 2)
  #define AO_RTI_GEN_PWR_ISO0 0x4c (0x3b << 2)

Meson8b additionally has these three registers:
  #define AO_RTI_GEN_PWR_ACK0 0xf0 (0x3c << 2)
  #define AO_RTI_PWR_A9_MEM_PD0 0xf4 (0x3d << 2)
  #define AO_RTI_PWR_A9_MEM_PD1 0xf8 (0x3e << 2)

Thus we can assume that the register size of the PMU IP blocks is
identical on both SoCs (and Meson8 just contains some reserved registers
in that area) because the CEC registers start right after the PMU
(AO_RTI_*) registers at AOBUS + 0x100 (0x40 << 2).

The upcoming power domain driver will need to read and write the
AO_RTI_GEN_PWR_SLEEP0 and AO_RTI_GEN_PWR_ISO0 registers, so the updated
size is needed for that driver to work.

Fixes: 4a5a27116b447d ("ARM: dts: meson8: add support for booting the secondary CPU cores")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
index 7162e0ca05b0a..ba78170e70274 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -139,7 +139,7 @@
 &aobus {
 	pmu: pmu@e0 {
 		compatible = "amlogic,meson8-pmu", "syscon";
-		reg = <0xe0 0x8>;
+		reg = <0xe0 0x18>;
 	};
 
 	pinctrl_aobus: pinctrl@84 {
-- 
2.20.1

