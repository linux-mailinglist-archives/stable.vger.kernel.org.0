Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E567148A05
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390486AbgAXOSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:18:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388527AbgAXOSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D15F42087E;
        Fri, 24 Jan 2020 14:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875501;
        bh=dUHXIG6MtZiAEHdpM8ABRLLmWi1FRJw9J1lJsLzRkpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Lxw9QeM1KY0qjR6LqFUXoAzhApDXwVR86iE/ZYtP5535dz+jJ5MQcmmWqiz1lMmN
         dVV/QQuxKh8c9PjlEqcjY7WjCPW972bQAHEeJmyfGO3J/34GTovE1RZQses8k673j+
         2Qqm9qoylzU+lW1sPT2/jQ8ZLyYT1gvXpZw+mKCs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 003/107] ARM: dts: meson8: fix the size of the PMU registers
Date:   Fri, 24 Jan 2020 09:16:33 -0500
Message-Id: <20200124141817.28793-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
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
index 5a7e3e5caebe2..3c534cd50ee3b 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -253,7 +253,7 @@
 &aobus {
 	pmu: pmu@e0 {
 		compatible = "amlogic,meson8-pmu", "syscon";
-		reg = <0xe0 0x8>;
+		reg = <0xe0 0x18>;
 	};
 
 	pinctrl_aobus: pinctrl@84 {
-- 
2.20.1

