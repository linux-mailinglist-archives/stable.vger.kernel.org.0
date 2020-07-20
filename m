Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE51226955
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732484AbgGTQBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732480AbgGTQBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D43020672;
        Mon, 20 Jul 2020 16:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260868;
        bh=iXlLajt91w1bnQ2gPS9Ph5IJllN1yz7GZJYvqG5WeOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqFu7Sq6vpda5mcOeY6ffoIhsWmvPUk389hiXl9tTXQINMO2Qa4Xmx9xvZub1m10S
         LsvPTlq7BniErdUPdtZA4QBmDdHr6lK5DwGGIBVVg1YilleKe+tozAv6BsjEGAZrVg
         obgmUVp7TXGBoPdaEncTif6s0hHI6ugLTtMOFlHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/215] arm64: dts: meson-gxl-s805x: reduce initial Mali450 core frequency
Date:   Mon, 20 Jul 2020 17:36:20 +0200
Message-Id: <20200720152824.871021231@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit b2037dafcf082cd24b88ae9283af628235df36e1 ]

When starting at 744MHz, the Mali 450 core crashes on S805X based boards:
 lima d00c0000.gpu: IRQ ppmmu3 not found
 lima d00c0000.gpu: IRQ ppmmu4 not found
 lima d00c0000.gpu: IRQ ppmmu5 not found
 lima d00c0000.gpu: IRQ ppmmu6 not found
 lima d00c0000.gpu: IRQ ppmmu7 not found
 Internal error: synchronous external abort: 96000210 [#1] PREEMPT SMP
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.7.2+ #492
 Hardware name: Libre Computer AML-S805X-AC (DT)
 pstate: 40000005 (nZcv daif -PAN -UAO)
 pc : lima_gp_init+0x28/0x188
 ...
 Call trace:
  lima_gp_init+0x28/0x188
  lima_device_init+0x334/0x534
  lima_pdev_probe+0xa4/0xe4
 ...
 Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Reverting to a safer 666Mhz frequency on the S805X that doesn't use the
GP0 PLL makes it more stable.

Fixes: fd47716479f5 ("ARM64: dts: add S805X based P241 board")
Fixes: 0449b8e371ac ("arm64: dts: meson: add libretech aml-s805x-ac board")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20200618132737.14243-1-narmstrong@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amlogic/meson-gxl-s805x-libretech-ac.dts  |  2 +-
 .../boot/dts/amlogic/meson-gxl-s805x-p241.dts |  2 +-
 .../boot/dts/amlogic/meson-gxl-s805x.dtsi     | 24 +++++++++++++++++++
 3 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/boot/dts/amlogic/meson-gxl-s805x.dtsi

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dts
index 82b1c48511478..e034bbff8e66e 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dts
@@ -9,7 +9,7 @@
 
 #include <dt-bindings/input/input.h>
 
-#include "meson-gxl-s905x.dtsi"
+#include "meson-gxl-s805x.dtsi"
 
 / {
 	compatible = "libretech,aml-s805x-ac", "amlogic,s805x",
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dts
index 3a1484e5b8e1d..fbc687c9ff839 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dts
@@ -9,7 +9,7 @@
 
 #include <dt-bindings/input/input.h>
 
-#include "meson-gxl-s905x.dtsi"
+#include "meson-gxl-s805x.dtsi"
 
 / {
 	compatible = "amlogic,p241", "amlogic,s805x", "amlogic,meson-gxl";
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s805x.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl-s805x.dtsi
new file mode 100644
index 0000000000000..f9d705648426e
--- /dev/null
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s805x.dtsi
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+/*
+ * Copyright (c) 2020 BayLibre SAS
+ * Author: Neil Armstrong <narmstrong@baylibre.com>
+ */
+
+#include "meson-gxl-s905x.dtsi"
+
+/ {
+	compatible = "amlogic,s805x", "amlogic,meson-gxl";
+};
+
+/* The S805X Package doesn't seem to handle the 744MHz OPP correctly */
+&mali {
+	assigned-clocks = <&clkc CLKID_MALI_0_SEL>,
+			  <&clkc CLKID_MALI_0>,
+			  <&clkc CLKID_MALI>; /* Glitch free mux */
+	assigned-clock-parents = <&clkc CLKID_FCLK_DIV3>,
+				 <0>, /* Do Nothing */
+				 <&clkc CLKID_MALI_0>;
+	assigned-clock-rates = <0>, /* Do Nothing */
+			       <666666666>,
+			       <0>; /* Do Nothing */
+};
-- 
2.25.1



