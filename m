Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FABD408F8C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242255AbhIMNoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241258AbhIMNmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E61476128C;
        Mon, 13 Sep 2021 13:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539807;
        bh=+/009UgRmfeqVq8W2rEdino8D6ULVL59KC8jWrMLLw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yx26RyaGlAEQR5O53Q6v05jXOsUQXNciw1/zVcxxOcoTqX3tD2yi2vzZKfzSMjxXO
         0RvCyOQhQ7K9xoZTHjwzGVPd/AE47oeA5jk7JnUG+paj+MZVEyv+SgV9OeXzaIifgy
         6CNI8BkR4Ey2DS4ldHXQqBMihTXVd2lbCPJubk6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/236] arm64: dts: marvell: armada-37xx: Extend PCIe MEM space
Date:   Mon, 13 Sep 2021 15:14:32 +0200
Message-Id: <20210913131106.053056036@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 514ef1e62d6521c2199d192b1c71b79d2aa21d5a ]

Current PCIe MEM space of size 16 MB is not enough for some combination
of PCIe cards (e.g. NVMe disk together with ath11k wifi card). ARM Trusted
Firmware for Armada 3700 platform already assigns 128 MB for PCIe window,
so extend PCIe MEM space to the end of 128 MB PCIe window which allows to
allocate more PCIe BARs for more PCIe cards.

Without this change some combination of PCIe cards cannot be used and
kernel show error messages in dmesg during initialization:

    pci 0000:00:00.0: BAR 8: no space for [mem size 0x01800000]
    pci 0000:00:00.0: BAR 8: failed to assign [mem size 0x01800000]
    pci 0000:00:00.0: BAR 6: assigned [mem 0xe8000000-0xe80007ff pref]
    pci 0000:01:00.0: BAR 8: no space for [mem size 0x01800000]
    pci 0000:01:00.0: BAR 8: failed to assign [mem size 0x01800000]
    pci 0000:02:03.0: BAR 8: no space for [mem size 0x01000000]
    pci 0000:02:03.0: BAR 8: failed to assign [mem size 0x01000000]
    pci 0000:02:07.0: BAR 8: no space for [mem size 0x00100000]
    pci 0000:02:07.0: BAR 8: failed to assign [mem size 0x00100000]
    pci 0000:03:00.0: BAR 0: no space for [mem size 0x01000000 64bit]
    pci 0000:03:00.0: BAR 0: failed to assign [mem size 0x01000000 64bit]

Due to bugs in U-Boot port for Turris Mox, the second range in Turris Mox
kernel DTS file for PCIe must start at 16 MB offset. Otherwise U-Boot
crashes during loading of kernel DTB file. This bug is present only in
U-Boot code for Turris Mox and therefore other Armada 3700 devices are not
affected by this bug. Bug is fixed in U-Boot version 2021.07.

To not break booting new kernels on existing versions of U-Boot on Turris
Mox, use first 16 MB range for IO and second range with rest of PCIe window
for MEM.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 76f6386b25cc ("arm64: dts: marvell: Add Aardvark PCIe support for Armada 3700")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/marvell/armada-3720-turris-mox.dts | 17 +++++++++++++++++
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi    | 11 +++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index bbd34ae12a53..2e437f20da39 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -134,6 +134,23 @@
 	pinctrl-0 = <&pcie_reset_pins &pcie_clkreq_pins>;
 	status = "okay";
 	reset-gpios = <&gpiosb 3 GPIO_ACTIVE_LOW>;
+	/*
+	 * U-Boot port for Turris Mox has a bug which always expects that "ranges" DT property
+	 * contains exactly 2 ranges with 3 (child) address cells, 2 (parent) address cells and
+	 * 2 size cells and also expects that the second range starts at 16 MB offset. If these
+	 * conditions are not met then U-Boot crashes during loading kernel DTB file. PCIe address
+	 * space is 128 MB long, so the best split between MEM and IO is to use fixed 16 MB window
+	 * for IO and the rest 112 MB (64+32+16) for MEM, despite that maximal IO size is just 64 kB.
+	 * This bug is not present in U-Boot ports for other Armada 3700 devices and is fixed in
+	 * U-Boot version 2021.07. See relevant U-Boot commits (the last one contains fix):
+	 * https://source.denx.de/u-boot/u-boot/-/commit/cb2ddb291ee6fcbddd6d8f4ff49089dfe580f5d7
+	 * https://source.denx.de/u-boot/u-boot/-/commit/c64ac3b3185aeb3846297ad7391fc6df8ecd73bf
+	 * https://source.denx.de/u-boot/u-boot/-/commit/4a82fca8e330157081fc132a591ebd99ba02ee33
+	 */
+	#address-cells = <3>;
+	#size-cells = <2>;
+	ranges = <0x81000000 0 0xe8000000   0 0xe8000000   0 0x01000000   /* Port 0 IO */
+		  0x82000000 0 0xe9000000   0 0xe9000000   0 0x07000000>; /* Port 0 MEM */
 
 	/* enabled by U-Boot if PCIe module is present */
 	status = "disabled";
diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 83d2d83f7692..2a2015a15362 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -487,8 +487,15 @@
 			#interrupt-cells = <1>;
 			msi-parent = <&pcie0>;
 			msi-controller;
-			ranges = <0x82000000 0 0xe8000000   0 0xe8000000 0 0x1000000 /* Port 0 MEM */
-				  0x81000000 0 0xe9000000   0 0xe9000000 0 0x10000>; /* Port 0 IO*/
+			/*
+			 * The 128 MiB address range [0xe8000000-0xf0000000] is
+			 * dedicated for PCIe and can be assigned to 8 windows
+			 * with size a power of two. Use one 64 KiB window for
+			 * IO at the end and the remaining seven windows
+			 * (totaling 127 MiB) for MEM.
+			 */
+			ranges = <0x82000000 0 0xe8000000   0 0xe8000000   0 0x07f00000   /* Port 0 MEM */
+				  0x81000000 0 0xefff0000   0 0xefff0000   0 0x00010000>; /* Port 0 IO */
 			interrupt-map-mask = <0 0 0 7>;
 			interrupt-map = <0 0 0 1 &pcie_intc 0>,
 					<0 0 0 2 &pcie_intc 1>,
-- 
2.30.2



