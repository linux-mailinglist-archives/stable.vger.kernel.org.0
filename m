Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA45331261
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 16:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCHPhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 10:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhCHPhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 10:37:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8CC36522D;
        Mon,  8 Mar 2021 15:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615217854;
        bh=A46gTqxo7AwHyKvIEVnYzBRWhGG50dROOHU9I3dE1aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BL48PRgFuU+5ddLyYRtlzjamdQFCv1UufBC/vewp6sa3deQpBDwcBeHJSrHzw1T8y
         eGL3y5mteIm5imB4cp38x8iKRA+Usr08YFv3HlC1DnsLrfshrkOBjYlh64KNTt2tNy
         SQEFNVTiyiE/V59tz6Lh4z9iH8tgbQXRTT2n8I3td/01cr528Ae9P1eD1f03OAdbce
         H4mH2H9B9ySHyscNj+g5GoEJQ4Aphf+dhYv+Lo9A3wxqEgedgjSl66Cn0nJ35EYO72
         F/5m4Zg59gqpOtMV3qvspsX7p2dg2i/NhGhJi8t/73vWDV69QcEBK14llyttEh/kgP
         hHW5Sok1U8P0A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     linux-arm-kernel@lists.infradead.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell: armada-37xx: move firmware node to generic dtsi file
Date:   Mon,  8 Mar 2021 16:37:03 +0100
Message-Id: <20210308153703.23097-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210308153703.23097-1-kabel@kernel.org>
References: <20210308153703.23097-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

Move the turris-mox-rwtm firmware node from Turris MOX' device tree into
the generic armada-37xx.dtsi file.

The Turris MOX rWTM firmware can be used on any Armada 37xx device,
giving them access to the rWTM hardware random number generator, which
is otherwise unavailable.

This change allows Linux to load the turris-mox-rwtm.ko module on these
boards.

Tested on ESPRESSObin v5 with both default Marvell WTMI firmware and
CZ.NIC's firmware. With default WTMI firmware the turris-mox-rwtm fails
to probe, while with CZ.NIC's firmware it registers the HW random number
generator.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4+: 46d2f6d0c99f ("arm64: dts: armada-3720-turris-mox: add firmware node")
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 8 --------
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi           | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index d239ab70ed99..8447f303a294 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -107,14 +107,6 @@ sfp: sfp {
 		/* enabled by U-Boot if SFP module is present */
 		status = "disabled";
 	};
-
-	firmware {
-		turris-mox-rwtm {
-			compatible = "cznic,turris-mox-rwtm";
-			mboxes = <&rwtm 0>;
-			status = "okay";
-		};
-	};
 };
 
 &i2c0 {
diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 7a2df148c6a3..31126f1ffe5b 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -503,4 +503,12 @@ pcie_intc: interrupt-controller {
 			};
 		};
 	};
+
+	firmware {
+		turris-mox-rwtm {
+			compatible = "cznic,turris-mox-rwtm";
+			mboxes = <&rwtm 0>;
+			status = "okay";
+		};
+	};
 };
-- 
2.26.2

