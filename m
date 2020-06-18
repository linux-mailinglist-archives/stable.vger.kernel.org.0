Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537591FE81B
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgFRBKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728565AbgFRBKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B45B420CC7;
        Thu, 18 Jun 2020 01:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442638;
        bh=rhVADCPT/OCDnHYRLvpB5LjV+mc8Z/AZJUCSyHnY/oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7/eNye9SjigWGQs2wSi3u2fLu6zVPOJ9/NxnkYFHGKEm/bK8gelGPQBHDyRhUWDe
         QJk8p5kBrd2Aoz30WpbkHr+MgR+erehducWV0D7VJGoF3b60Sc/mfJvQFyCVC6RgCn
         25SFXm299F2/n6T5xgbGwACyLeNmc8ajsUmq0wLk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 114/388] ARM: dts: bcm283x: Use firmware PM driver for V3D
Date:   Wed, 17 Jun 2020 21:03:31 -0400
Message-Id: <20200618010805.600873-114-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit 3ac395a5b3f3b678663fbb58381fdae2b1b57588 ]

The register based driver turned out to be unstable, specially on RPi3a+
but not limited to it. While a fix is being worked on, we roll back to
using firmware based scheme.

Fixes: e1dc2b2e1bef ("ARM: bcm283x: Switch V3D over to using the PM driver instead of firmware")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20200303173217.3987-1-nsaenzjulienne@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2835-common.dtsi     |  1 -
 arch/arm/boot/dts/bcm2835-rpi-common.dtsi | 12 ++++++++++++
 arch/arm/boot/dts/bcm2835.dtsi            |  1 +
 arch/arm/boot/dts/bcm2836.dtsi            |  1 +
 arch/arm/boot/dts/bcm2837.dtsi            |  1 +
 5 files changed, 15 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/bcm2835-rpi-common.dtsi

diff --git a/arch/arm/boot/dts/bcm2835-common.dtsi b/arch/arm/boot/dts/bcm2835-common.dtsi
index 2b1d9d4c0cde..4119271c979d 100644
--- a/arch/arm/boot/dts/bcm2835-common.dtsi
+++ b/arch/arm/boot/dts/bcm2835-common.dtsi
@@ -130,7 +130,6 @@ v3d: v3d@7ec00000 {
 			compatible = "brcm,bcm2835-v3d";
 			reg = <0x7ec00000 0x1000>;
 			interrupts = <1 10>;
-			power-domains = <&pm BCM2835_POWER_DOMAIN_GRAFX_V3D>;
 		};
 
 		vc4: gpu {
diff --git a/arch/arm/boot/dts/bcm2835-rpi-common.dtsi b/arch/arm/boot/dts/bcm2835-rpi-common.dtsi
new file mode 100644
index 000000000000..8a55b6cded59
--- /dev/null
+++ b/arch/arm/boot/dts/bcm2835-rpi-common.dtsi
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This include file covers the common peripherals and configuration between
+ * bcm2835, bcm2836 and bcm2837 implementations that interact with RPi's
+ * firmware interface.
+ */
+
+#include <dt-bindings/power/raspberrypi-power.h>
+
+&v3d {
+	power-domains = <&power RPI_POWER_DOMAIN_V3D>;
+};
diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index 53bf4579cc22..0549686134ea 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "bcm283x.dtsi"
 #include "bcm2835-common.dtsi"
+#include "bcm2835-rpi-common.dtsi"
 
 / {
 	compatible = "brcm,bcm2835";
diff --git a/arch/arm/boot/dts/bcm2836.dtsi b/arch/arm/boot/dts/bcm2836.dtsi
index 82d6c4662ae4..b390006aef79 100644
--- a/arch/arm/boot/dts/bcm2836.dtsi
+++ b/arch/arm/boot/dts/bcm2836.dtsi
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "bcm283x.dtsi"
 #include "bcm2835-common.dtsi"
+#include "bcm2835-rpi-common.dtsi"
 
 / {
 	compatible = "brcm,bcm2836";
diff --git a/arch/arm/boot/dts/bcm2837.dtsi b/arch/arm/boot/dts/bcm2837.dtsi
index 9e95fee78e19..0199ec98cd61 100644
--- a/arch/arm/boot/dts/bcm2837.dtsi
+++ b/arch/arm/boot/dts/bcm2837.dtsi
@@ -1,5 +1,6 @@
 #include "bcm283x.dtsi"
 #include "bcm2835-common.dtsi"
+#include "bcm2835-rpi-common.dtsi"
 
 / {
 	compatible = "brcm,bcm2837";
-- 
2.25.1

