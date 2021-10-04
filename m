Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11026420CFD
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhJDNKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235288AbhJDNJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C597561B55;
        Mon,  4 Oct 2021 13:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352599;
        bh=gtHvc0HZonQuMqEPsdc0C0bkVaBd1dO2c49JDHCP3Xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzMAxHgjT89apewuZAExE8HJ74ujoSYI6TLtjkp2aJgsxturwaFqVAsTKzH0e/XAU
         ckk4/SlU8ejKWUl3EAcNrsZ7/dyxK4FbzN/0YW0+nN31wc22+jOr9HCbA/rr+xebzU
         cH+TViZigglmwel4d5Ag8TBypJsMnHXtm4z+gblo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 4.19 48/95] arm64: dts: marvell: armada-37xx: Extend PCIe MEM space
Date:   Mon,  4 Oct 2021 14:52:18 +0200
Message-Id: <20211004125035.148973261@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

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


