Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D2D418907
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 15:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhIZN0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 09:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231723AbhIZN0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 09:26:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B01261038
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632662719;
        bh=ElexqrPpYGbeH7tN5hn4/D4TlgAeUZutCFNJAO2dG+o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fGwRSQBDajL8RRZYjUhxuew00DCJmvFXEs7wVM5Q478iNkuu3AFYl1LlFRmk1fZRI
         Bx/BLlxdcDT05aX6j4kuvHsha/NziUGHGpdbYLBwYGQL8bE0KeSD3P0famuzum41dF
         Gjq+FnpIqmpBqGSTF/nEBFFi+XS66aYcrlpwD23C4pEG615aX0wHTps62OVUWc+p4g
         lca9XJouf2Y55PNP5oqrDriT+MBkNsTvrk9RhaakMvTSt8XpkJUfY/sIGI/QF18y+j
         3+47OSLwK90NYVIsauP4Yk2H0+qvnVhmkiLX6y/nM3O3rvi9jNJuCFhflkB1/jQoJ2
         5ODJU4WiSGoDA==
Received: by pali.im (Postfix)
        id 8E66560D; Sun, 26 Sep 2021 15:25:17 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Subject: [PATCH stable-4.19 and older] arm64: dts: marvell: armada-37xx: Extend PCIe MEM space
Date:   Sun, 26 Sep 2021 15:24:58 +0200
Message-Id: <20210926132458.27422-2-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210926132458.27422-1-pali@kernel.org>
References: <20210926132458.27422-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 514ef1e62d6521c2199d192b1c71b79d2aa21d5a upstream.

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
[pali: Backported to 4.19 and older versions]
---
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 1844fb8605f0..fca78eb334b1 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -376,8 +376,15 @@
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
2.20.1

